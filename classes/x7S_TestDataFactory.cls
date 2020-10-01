@isTest
public class x7S_TestDataFactory {

	/*
	new changes 3.1 addeded here
	*/
	
    public static final string PROFILE_DX_ADMIN = 'Dx System Admin';
    public static final string PROFILE_DX_SALES_REP = 'Dx Enterprise Direct Sales Rep';
    public static final string SOURCE_ORG_Name_SB = 'deluxesb';
    public static final string SOURCE_ORG_Name_FS = 'deluxefs';
    public static final string PRIMARY_LEGACY_ID = '0011400001cz9c4BBB';
    public static final string SECONDARY_LEGACY_ID = '0011400001cz9c4BBC';
    
    public static final string ACCOUNT_TYPE_CUST = 'Customer';
    public static final string ACCOUNT_CUST_TYPE_COMM_BANK = 'Commercial Bank';
    public static final string ACCOUNT_STATUS_ACTIVE = 'Active';
    public static final string ACCOUNT_LEGACY_REC_TYPE_MAJOR = 'Major Accounts';
    
    public static final string CONTACT_EMAIL = 'test@test.com';
    public static final string CONTACT_SECOND_EMAIL = 'test1@test.com';
    public static final string CONTACT_THIRD_EMAIL = 'test2@test.com';
    
    public static final string PRODUCT_FAMILY_CLOUD = 'Cloud';
    public static final string PRODUCT_GROUP_BUS_MARKETING_SERVICES = 'Business Marketing Services';
    public static final string PRODUCT_GROUP_DEL_MARKETING_SERVICES = 'Deluxe Marketing Services';
    public static final string PRODUCT_COMPONENT_SEFLSERACQUISITION = 'Self Service Acquisition';
    public static final string PRODUCT_OPP_REC_TYPE_Major_COD = 'Major Accounts Opportunity/COD Opportunity';
    
    public static final string OPP_SEGMENT_MOS = 'MOS';
    public static final string OPP_STAGE_NAME_VALUE_FIT = 'Plan';
    public static final string OPP_TYPE_NEW_BUSINESS = 'New Business';
    
    public static final string OPP_CONTACT_ROLE_BU = 'Business User';
    public static final string OPP_CONTACT_ROLE_DM = 'Decision Maker';
    
    public static final string USER_EMAIL = 'standarduser@testorg.com';
    
    public static final string ACCOUNT_TEAM_ROLE_SALES_MANAGER = 'Sales Manager';
    
    public static List<Account> createTestAccount(Integer numberofRecord , account sampleAccount) {
        List<Account> accountList = New List<Account>();
        for(Integer numIndex=0; numIndex<numberofRecord; numIndex++){
            account newAccount = sampleAccount.clone();
            if(numindex>0) {
                string valuePostFix = string.valueOf(numIndex);
                newAccount.Legacy_Id__c = sampleAccount.Legacy_Id__c.substring(0,sampleAccount.Legacy_Id__c.length()
                                            - valuePostFix.length()) + valuePostFix;
            }
            newAccount.Name = 'TestAccount' + numIndex;
            accountList.add(newAccount);
        }
        insert accountList;
        return accountList;
    }
    public static List<contact> createTestcontact(Integer numberofRecord , 
                                   Id AccountId, String testEmail) {
        List<Contact> contactList = New List<Contact>();
        for(Integer numIndex=0; numIndex<numberofRecord; numIndex++){
            contactList.add(new Contact(
                    lastname = 'Testcontact' + numIndex ,
                    Firstname = AccountId,
                    accountId = AccountId,
            		Email = numIndex + testEmail));
        }
        insert contactList;
        return contactList;
    }
    public static List<Opportunity> createTestOpportunity(Integer numberofRecord, 
                                Id AccountId, string StageName, date CloseDate, 
                                string legacySourceOrgName, string Type, string Legacy_ID) {
        List<Opportunity> opportunityList = New List<Opportunity>();
        string newLegacyId = Legacy_ID;
        for(Integer numIndex=0; numIndex<numberofRecord; numIndex++){
            if(numindex>0) {
                string valuePostFix = string.valueOf(numIndex);
                newLegacyId = Legacy_ID.substring(0,Legacy_ID.length()
                                            - valuePostFix.length()) + valuePostFix;
            }
            opportunityList.add(new Opportunity(
                    Name = 'Test Opportunity' + numIndex ,
                    AccountId = AccountId,
                    StageName = StageName,
                	probability = 20,
                    CloseDate = CloseDate,
                    Legacy_Source_Org_Name__c = legacySourceOrgName,
                    Type = Type,
                    Legacy_ID__c = newLegacyId));
        }

        insert opportunityList;
        return opportunityList;
    }
    public static List<PricebookEntry> createTestProductsPriceBook(Integer numberofRecord, string legacySourceOrgName,
                                                                  String productGroup, Boolean enrollmentRequired) {
        List<Product2> ProductList = New List<Product2>();
        List<PricebookEntry> PricebookEntryList = new List<PricebookEntry>();
        for(Integer numIndex=0; numIndex<numberofRecord; numIndex++){
            product2 newProduct = new Product2(
                    Name = 'Test Product' + numIndex ,
                    isActive = true,
                    Family = PRODUCT_FAMILY_CLOUD,
                    Product_Group__c = productGroup,
                    Product_Component__c = PRODUCT_COMPONENT_SEFLSERACQUISITION,
                    Legacy_Source_Org_Name__c = legacySourceOrgName,
                    Enrollment_Required__c = enrollmentRequired,
                 	Revenue_Schedules_Required__c = true,
                	Legacy_Opportunity_Record_Type__c = PRODUCT_OPP_REC_TYPE_Major_COD
                    );
            ProductList.add(newProduct);
        }
        insert ProductList;
        
        for(product2 prod: ProductList){
            PricebookEntryList.add( new PricebookEntry(
                    UnitPrice = 4000,
                    product2Id = prod.Id,
                    Pricebook2Id=Test.getStandardPricebookId(),
                    isActive=true,
                    UseStandardPrice = false));            
        }
        
        
        insert PricebookEntryList;
        return PricebookEntryList;
    }
    
    public static List<accountTeamMember> CreateAccountTeam(List<account> accountList, Id memberUserId){
        List<accountTeamMember> teamList = new List<accountTeamMember>();
        for(Account acc: accountList){
            AccountTeamMember acctmem = new AccountTeamMember();
            acctmem.AccountId = acc.Id;
            acctmem.UserId = memberUserId;
            acctmem.TeamMemberRole = ACCOUNT_TEAM_ROLE_SALES_MANAGER;
            teamList.add(acctmem);
        }
        insert teamList;
        return teamList;
    }
    
    public static User creatTestUser(string profileName){
        Profile ProfileObj = [SELECT Id FROM Profile WHERE Name=: profileName];
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        User newUser = new User(Alias = 'standt', Email=USER_EMAIL,
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = ProfileObj.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);      
       
        return newUser;
    }
    
    public static void createMulesoftIntegrationSetting(Id muleUserId){
        List<x7S_Mulesoft_Integration_Setting__c> settings = new List<x7S_Mulesoft_Integration_Setting__c>();
        x7S_Mulesoft_Integration_Setting__c custSettingMuleSoft; 
        custSettingMuleSoft=  new x7S_Mulesoft_Integration_Setting__c(
                SetupOwnerId=UserInfo.getOrganizationId(),
                Disabled_Account_Trigger__c = false,
                Disabled_Contact_Trigger__c = false,
                Disabled_Opportunity_Trigger__c = false,
                Disabled_Opportunity_Product_Trigger__c = false,
                Disabled_Opportunity_ContactRole_Trigger__c = false);
        settings.add(custSettingMuleSoft);
        
        custSettingMuleSoft=  new x7S_Mulesoft_Integration_Setting__c(
                SetupOwnerId= muleUserId,
                Disabled_Account_Trigger__c = True,
                Disabled_Contact_Trigger__c = True,
                Disabled_Opportunity_Trigger__c = True,
                Disabled_Opportunity_Product_Trigger__c = True,
                Disabled_Opportunity_ContactRole_Trigger__c = True);
        settings.add(custSettingMuleSoft);
        Insert settings;
        system.debug('#####settings=' + settings);
    }
}