public without sharing class DonorEventHelper {
    public static List<List<SObject>> validateDonorAndVisitReferences(List<List<SObject>> inputRecords) {
        Map<String, SObject> runningDonorNumberList = getDonorNumberToDonorEvent(inputRecords);
        Map<String, Object> getRelatedObjectMappingsResult = mapDonorNumberToDonorRelatedRecords(runningDonorNumberList);
        Map<String, SObject> validDonorNumbersToDonorEvent = (Map<String, SObject>)getRelatedObjectMappingsResult.get('validDonorNumbersToDonorEvent');
        Map<String, Contact> validDonorNumbersToDonor = (Map<String, Contact>)getRelatedObjectMappingsResult.get('validDonorNumbersToDonor');

        // Create Tasks for missing donors
        Group customerSupportQueue, proesisOperationsQueue;
        for(Group foundBaseQueue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN ('Customer_Support', 'Proesis_Operations')]) {
            if (foundBaseQueue.DeveloperName == 'Customer_Support') {
                customerSupportQueue = foundBaseQueue;
            } else if (foundBaseQueue.DeveloperName == 'Proesis_Operations') {
                proesisOperationsQueue = foundBaseQueue;
            }
        }

        // Find all donorNumbers that don't have a corresponding Account.DonorId__c reference
        // Create a Task record for each donorNumber with a missing contact
        List<Task> tasksToInsert = new List<Task>();

        if (runningDonorNumberList.size() > 0) {
            for (String donorNumber : runningDonorNumberList.keySet()) {
                Task task = new Task();
                task.Subject = 'Missing Donor from BECS';
                task.Description = 'No matching donor for DonorId of ' + donorNumber;
                task.ActivityDate = Date.today();
                task.OwnerId = proesisOperationsQueue != null ? proesisOperationsQueue.Id : customerSupportQueue.Id;
                tasksToInsert.add(task);
            }
        }

        // Searching for valid visits on the varlid donors given the BECS Timestamp (Donor_Comp__e.Timestamp__c)
        Map<Datetime, List<Id>> targetAppointmentTimeToRescheduleVisitId = new Map<Datetime, List<Id>>();
        Map<Datetime, List<SObject>> targetAppointmentTimeToDonorEvent = new Map<Datetime, List<SObject>>();
        Set<String> becsDeviceNumbers = new Set<String>();
        Set<Id> lastUsedCenterIds = new Set<Id>();
        
        for (Contact validDonor : [
            SELECT Id, Account.DonorId__c, Last_Used_Center__c, (
                SELECT Id, Appointment_Datetime__c
                FROM Visits__r 
                WHERE Status__c IN ('New', 'Scheduled', 'Checked-In') 
                ORDER BY Appointment_Datetime__c ASC
            ) FROM Contact 
            WHERE Id IN :validDonorNumbersToDonor.values()
        ]) {
            SObject relatedEvent = validDonorNumbersToDonorEvent.get(validDonor.Account.DonorId__c);
            Datetime donorCompTimestamp = (Datetime)relatedEvent.get('Timestamp__c');

            // Check to see if there is a visit on the day of or next day of the Timestamp__c
            Boolean foundVisit = false;
            for (Visit__c visit : validDonor.Visits__r) {
                // If we find a visit on the day of then we exit happy!
                if (visit.Appointment_Datetime__c.date() == donorCompTimestamp.date()) {
                    foundVisit = true;
                    continue;
                } else if (visit.Appointment_Datetime__c.date() == donorCompTimestamp.date().addDays(1)) {
                    // If we find it the next day of, then we reschedule the visit to the target date using CenterScheduleController.changeVisit(visitId, newAppointmentId)
                    List<Id> visitIds = targetAppointmentTimeToRescheduleVisitId.get(donorCompTimestamp);
                    if (visitIds == null) {
                        visitIds = new List<Id>();
                    }
                    
                    visitIds.add(visit.Id);
                    targetAppointmentTimeToRescheduleVisitId.put(donorCompTimestamp, visitIds);

                    foundVisit = true;
                }
            }

            // If we don't find a visit on the day of or next day of, we need to find the next available appointment slot using Datetime__c and create a Visit for that slot
            // The Center for the visit (Visit__c.Center_Donation_Type__c.Center__c) can be queried using the BECS_Device_Id__c to find a related BECS_Device__c child record, the center would be the parent of that record
            if (!foundVisit) {
                List<SObject> donorComps = targetAppointmentTimeToDonorEvent.get(donorCompTimestamp);
                if (donorComps == null) {
                    donorComps = new List<SObject>();
                }

                // If there is a BECS_Device__c on the Event record, then we use that to find the center
                // Otherwise, use the Last_Used_Center__c as a backup
                String becsNumber = (relatedEvent instanceof Donor_Comp__e) ? (String)relatedEvent.get('BECS_Device__c') : '';
                if (!String.isEmpty(becsNumber)) {
                    becsDeviceNumbers.add(becsNumber);
                } else if (validDonor.Last_Used_Center__c != null) {
                    lastUsedCenterIds.add(validDonor.Last_Used_Center__c);
                }

                donorComps.add(relatedEvent);
                targetAppointmentTimeToDonorEvent.put(donorCompTimestamp, donorComps);
            }
        }

        // Reschedule visits that need to be rescheduled
        if (targetAppointmentTimeToRescheduleVisitId.size() > 0) {
            List<CoreSchedulerHandler.RescheduleRequest> rescheduleRequests = new List<CoreSchedulerHandler.RescheduleRequest>();

            for(Appointment__c rescheduleAppointmentSlot : [SELECT Id, Datetime__c FROM Appointment__c WHERE Datetime__c IN :targetAppointmentTimeToRescheduleVisitId.keySet() ORDER BY Datetime__c ASC]) {
                for (Id visitId : targetAppointmentTimeToRescheduleVisitId.get(rescheduleAppointmentSlot.Datetime__c)) {
                    rescheduleRequests.add(new CoreSchedulerHandler.RescheduleRequest(visitId, rescheduleAppointmentSlot.Id));
                }
            }

            CoreSchedulerHandler.rescheduleVisits(new CoreSchedulerHandler.RescheduleBatchRequest(rescheduleRequests));
        }
        
        if (targetAppointmentTimeToDonorEvent.size() > 0) {
            // Get the Center_Donation_Type__c records for the BECS Devices
            Map<String, Device__c> becsCenterToDevice = new Map<String, Device__c>();
            Map<Id, String> centerIdToTargetQueueName = new Map<Id, String>();

            if (becsDeviceNumbers.size() > 0) {
                for(Device__c becsDevice : [SELECT Id, Center__c, Center__r.Name, Device_Id__c FROM Device__c WHERE Device_Id__c IN :becsDeviceNumbers AND Type__c = 'BECS']) {
                    becsCenterToDevice.put(becsDevice.Center__c, becsDevice);
                    centerIdToTargetQueueName.put(becsDevice.Center__c, 'Center_Manager_-_' + becsDevice.Center__r.Name.replaceAll(' ', '_'));
                }
            }

            Map<String, Center_Donation_Type__c> becsDeviceIdToCenterDonationType = new Map<String, Center_Donation_Type__c>();
            Map<Id, Center_Donation_Type__c> centerIdToCenterDonationType = new Map<Id, Center_Donation_Type__c>();

            for(Center_Donation_Type__c centerDonationType : [
                SELECT Id, Center__c 
                FROM Center_Donation_Type__c 
                WHERE (Center__c IN :becsCenterToDevice.keySet() OR Center__c IN :lastUsedCenterIds) AND 
                    Donation_Type__r.Name = 'Normal Source Plasma'
            ]) {
                if (becsCenterToDevice.get(centerDonationType.Center__c) != null) {
                    becsDeviceIdToCenterDonationType.put(becsCenterToDevice.get(centerDonationType.Center__c).Device_Id__c, centerDonationType);
                } else {
                    centerIdToCenterDonationType.put(centerDonationType.Center__c, centerDonationType);
                }
            }

            Map<String, Id> centerQueueNameToId = new Map<String, Id>();
            for(Group centerQueue : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN :centerIdToTargetQueueName.values()]) {
                centerQueueNameToId.put(centerQueue.DeveloperName, centerQueue.Id);
            }

            // Create visits for donors that need to be scheduled
            List<Visit__c> visitsToInsert = new List<Visit__c>();
            Map<Id, List<Task>> donorIdToTasksToParent = new Map<Id, List<Task>>();

            for(Appointment__c newAppointmentSlot : [SELECT Id, Datetime__c FROM Appointment__c WHERE Datetime__c IN :targetAppointmentTimeToDonorEvent.keySet() ORDER BY Datetime__c ASC]) {
                for(SObject donorEvent : targetAppointmentTimeToDonorEvent.get(newAppointmentSlot.Datetime__c)) {
                    Contact relatedDonor = validDonorNumbersToDonor.get((String)donorEvent.get('Donor_Number__c'));
                    
                    Visit__c missingVisit = new Visit__c(
                        Appointment__c = newAppointmentSlot.Id,
                        Donor__c = relatedDonor.Id
                    );

                    String becsNumber = (donorEvent instanceof Donor_Comp__e) ? (String)donorEvent.get('BECS_Device__c') : '';
                    if (becsDeviceIdToCenterDonationType.containsKey(becsNumber)) {
                        missingVisit.Center_Donation_Type__c = becsDeviceIdToCenterDonationType.get(becsNumber).Id;
                    } else {
                        missingVisit.Center_Donation_Type__c = centerIdToCenterDonationType.get(relatedDonor.Last_Used_Center__c).Id;
                    }

                    visitsToInsert.add(missingVisit);

                    // Create a task to notify the center manager
                    Id targetQueueId;
                    if (donorEvent instanceof Donor_Comp__e) {
                        targetQueueId = centerQueueNameToId.get(centerIdToTargetQueueName.get(becsCenterToDevice.get(becsDeviceIdToCenterDonationType.get(becsNumber).Center__c).Center__c));
                    } else {
                        targetQueueId = centerQueueNameToId.get(centerIdToTargetQueueName.get(relatedDonor.Last_Used_Center__c));
                    }

                    if (targetQueueId == null) {
                        targetQueueId = (proesisOperationsQueue != null) ? proesisOperationsQueue.Id : customerSupportQueue.Id;
                    }

                    String donorEventType = (donorEvent instanceof Donor_Comp__e) ? 'Donor Complete' : 'Donor Check In';

                    List<Task> tasksToParent = donorIdToTasksToParent.get(relatedDonor.Id);
                    if (tasksToParent == null) {
                        tasksToParent = new List<Task>();
                    }

                    tasksToParent.add(new Task(
                        Subject = 'Missing Visit Created upon ' + donorEventType + ' Event',
                        ActivityDate = Date.today(),
                        WhoId = relatedDonor.Id,
                        OwnerId = targetQueueId
                    ));

                    donorIdToTasksToParent.put(relatedDonor.Id, tasksToParent);
                }
            }

            if (visitsToInsert.size() > 0) {
                CoreSchedulerHandler.createVisits(visitsToInsert);
            }

            // Parent Tasks to Visit after inserting
            for(Visit__c createdVisit : visitsToInsert) {
                List<Task> tasksToParent = donorIdToTasksToParent.get(createdVisit.Donor__c);
                if (tasksToParent != null) {
                    for(Task taskToParent : tasksToParent) {
                        taskToParent.WhatId = createdVisit.Id;
                    }
                }

                tasksToInsert.addAll(tasksToParent);
            }
        }

        if (tasksToInsert.size() > 0) {
            insert tasksToInsert;
        }

        List<List<SObject>> validDonorEvents = new List<List<SObject>>();
        for(SObject validDonorEvent : validDonorNumbersToDonorEvent.values()) {
            validDonorEvents.add(new List<SObject>{validDonorEvent});
        }

        return validDonorEvents;
    }

    private static Map<String, SObject> getDonorNumberToDonorEvent(List<List<SObject>> donorEvents) {
        Map<String, SObject> donorNumberToDonorEvent = new Map<String, SObject>();

        for (List<SObject> donorEventList : donorEvents) {
            for (SObject donorEvent : donorEventList) {
                donorNumberToDonorEvent.put((String)donorEvent.get('Donor_Number__c'), donorEvent);
            }
        }

        return donorNumberToDonorEvent;
    }

    private static Map<String, Object> mapDonorNumberToDonorRelatedRecords(Map<String, SObject> runningDonorNumberList) {
        Map<String, SObject> validDonorNumbersToDonorEvent = new Map<String, SObject>();
        Map<String, Contact> validDonorNumbersToDonor = new Map<String, Contact>();

        for(Contact donor : [SELECT Id, Account.DonorId__c, Last_Used_Center__c FROM Contact WHERE Account.DonorId__c IN :runningDonorNumberList.keySet()]) {
            validDonorNumbersToDonorEvent.put(donor.Account.DonorId__c, runningDonorNumberList.get(donor.Account.DonorId__c));
            validDonorNumbersToDonor.put(donor.Account.DonorId__c, donor);

            runningDonorNumberList.remove(donor.Account.DonorId__c);
        }

        return new Map<String, Object> {
            'validDonorNumbersToDonorEvent' => validDonorNumbersToDonorEvent,
            'validDonorNumbersToDonor' => validDonorNumbersToDonor
        };
    }
}