//Generated by wsdl2apex

public class OnbeDomainPrepaid {

    // Constant
    private static final String uriAccountManagementPrepaidDomain = 'http://domain.accountmanagementapi.prepaid.citi.com';
    
    public class Load {
        public Long amount;
        public String comment;
        public OnbeWsPrepaid.ArrayOf_tns2_keyValue keyValue;
        public String claimable;
        public String notificationIndicator;
        public String templateId;
        private String[] amount_type_info = new String[]{'amount', uriAccountManagementPrepaidDomain, null,'1','1','false'};
        private String[] comment_type_info = new String[]{'comment', uriAccountManagementPrepaidDomain, null,'1','1','false'};
        private String[] keyValue_type_info = new String[]{'keyValue',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] claimable_type_info = new String[]{'claimable',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] notificationIndicator_type_info = new String[]{'notificationIndicator',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] templateId_type_info = new String[]{'templateId',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'amount','comment','keyValue','claimable','notificationIndicator','templateId'};
    }

    public class Address {
        public String address;
        public String city;
        public String state;
        public String postal;
        public String country;
        private String[] address_type_info = new String[]{'address',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] city_type_info = new String[]{'city',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] state_type_info = new String[]{'state',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] postal_type_info = new String[]{'postal',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] country_type_info = new String[]{'country',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'address','city','state','postal','country'};
    }

    public class WithdrawCheck {
        public String primary_payee_name;
        public String secondary_payee_name;
        private String[] primary_payee_name_type_info = new String[]{'primary_payee_name',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] secondary_payee_name_type_info = new String[]{'secondary_payee_name',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'primary_payee_name','secondary_payee_name'};
    }

    public class VoidACH {
        public String original_partner_withdraw_id;
        private String[] original_partner_withdraw_id_type_info = new String[]{'original_partner_withdraw_id',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'original_partner_withdraw_id'};
    }

    public class Registration {
        public OnbeDomainPrepaid.Addenda addenda;
        public String address1;
        public String address2;
        public String address3;
        public String address4;
        public String businessEmail;
        public String businessPhone;
        public String city;
        public String country;
        public String county;
        public String date_of_birth;
        public String emailAddress;
        public String firstName;
        public String homeEmail;
        public String homePhone;
        public OnbeWsPrepaid.ArrayOf_tns2_keyValue keyValue;
        public String lastName;
        public String middleName;
        public String mobileEmail;
        public String mobilePhone;
        public String phone;
        public String postal;
        public String ssn;
        public String state;
        public String suffixName;
        public String notificationIndicator;
        private String[] addenda_type_info = new String[]{'addenda',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] address1_type_info = new String[]{'address1',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] address2_type_info = new String[]{'address2',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] address3_type_info = new String[]{'address3',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] address4_type_info = new String[]{'address4',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] businessEmail_type_info = new String[]{'businessEmail',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] businessPhone_type_info = new String[]{'businessPhone',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] city_type_info = new String[]{'city',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] country_type_info = new String[]{'country',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] county_type_info = new String[]{'county',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] date_of_birth_type_info = new String[]{'date_of_birth',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] emailAddress_type_info = new String[]{'emailAddress',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] firstName_type_info = new String[]{'firstName',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] homeEmail_type_info = new String[]{'homeEmail',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] homePhone_type_info = new String[]{'homePhone',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] keyValue_type_info = new String[]{'keyValue',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] lastName_type_info = new String[]{'lastName',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] middleName_type_info = new String[]{'middleName',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] mobileEmail_type_info = new String[]{'mobileEmail',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] mobilePhone_type_info = new String[]{'mobilePhone',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] phone_type_info = new String[]{'phone',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] postal_type_info = new String[]{'postal',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] ssn_type_info = new String[]{'ssn',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] state_type_info = new String[]{'state',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] suffixName_type_info = new String[]{'suffixName',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] notificationIndicator_type_info = new String[]{'notificationIndicator',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'addenda','address1','address2','address3','address4','businessEmail','businessPhone','city','country','county','date_of_birth','emailAddress','firstName','homeEmail','homePhone','keyValue','lastName','middleName','mobileEmail','mobilePhone','phone','postal','ssn','state','suffixName','notificationIndicator'};
    }

    public class WithdrawACH {
        public String account_holder_name;
        public String account_number;
        public String routing_number;
        public String account_type;
        public String bank_name;
        private String[] account_holder_name_type_info = new String[]{'account_holder_name',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] account_number_type_info = new String[]{'account_number',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] routing_number_type_info = new String[]{'routing_number',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] account_type_type_info = new String[]{'account_type',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] bank_name_type_info = new String[]{'bank_name',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'account_holder_name','account_number','routing_number','account_type','bank_name'};
    }

    public class VoidCheck {
        public String original_partner_withdraw_id;
        public String check_number;
        private String[] original_partner_withdraw_id_type_info = new String[]{'original_partner_withdraw_id',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] check_number_type_info = new String[]{'check_number',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'original_partner_withdraw_id','check_number'};
    }

    public class Addenda {
        public String reference_1;
        public String reference_2;
        public String reference_3;
        public String reference_4;
        private String[] reference_1_type_info = new String[]{'reference_1',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] reference_2_type_info = new String[]{'reference_2',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] reference_3_type_info = new String[]{'reference_3',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] reference_4_type_info = new String[]{'reference_4',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'reference_1','reference_2','reference_3','reference_4'};
    }

    public class Link {
        public String cardPackageId;
        public String block;
        public OnbeWsPrepaid.ArrayOf_tns2_keyValue keyValue;
        private String[] cardPackageId_type_info = new String[]{'cardPackageId',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] block_type_info = new String[]{'block',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] keyValue_type_info = new String[]{'keyValue',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'cardPackageId','block','keyValue'};
    }
    
    public class Card {
        public String cardAccessLevel;
        public OnbeWsPrepaid.ArrayOf_tns2_keyValue keyValue;
        private String[] cardAccessLevel_type_info = new String[]{'cardAccessLevel',uriAccountManagementPrepaidDomain,null,'1','1','false'};
        private String[] keyValue_type_info = new String[]{'keyValue',uriAccountManagementPrepaidDomain,null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{uriAccountManagementPrepaidDomain,'true','false'};
        private String[] field_order_type_info = new String[]{'cardAccessLevel','keyValue'};
    }
}