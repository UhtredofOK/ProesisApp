// This ignores DML limits and looks for All... when we get to >10K records to update, this will need refactoring

List<Task> taskUpdates = new List<Task>();
Set<Id> contactsToQuery = new Set<Id>();
Map<Id, Task> tasksInScope = new Map<Id, Task>();

for (Task tsk : [
    SELECT Id,
        WhoId,
        Subject,
        Description
    FROM Task
    WHERE Subject = 'First Visit Code'
]) {
    contactsToQuery.add(tsk.WhoId); // Assuming this is always a Contact for these based on current logic of how these are created
    tasksInScope.put(tsk.Id, tsk);
}

if (!contactsToQuery.isEmpty()) {
    Map<Id, Contact> contactDataMap = new Map<Id, Contact>();
    for (Contact ct : [
        SELECT Id,
            Account.First_Visit_Code__c
        FROM Contact
        WHERE Id IN :contactsToQuery
    ]) {
        contactDataMap.put(ct.Id, ct);
    }

    for (Task tsk : tasksInScope.values()) {
        if (contactDataMap.get(tsk.WhoId).Account.First_Visit_Code__c != null) {
            if (tsk.Description != contactDataMap.get(tsk.WhoId).Account.First_Visit_Code__c) {
                Task tskUpdate = new Task(
                    Id = tsk.Id
                );
                tskUpdate.Description = contactDataMap.get(tsk.WhoId).Account.First_Visit_Code__c;
                taskUpdates.add(tskUpdate);
            }
        }
    }
    if (!taskUpdates.isEmpty()) {
        update taskUpdates;
    }
}

System.debug(taskUpdates);