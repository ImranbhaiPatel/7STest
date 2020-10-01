/**************************************************************************************************************
* 7Summits
* Name: x7S_Utils
* Description: Utility class
* Created Date: [12/9/2019]
* Created By: [Lucas Soderstrom] (7Summits)
***************************************************************************************************************/
public class x7S_Utils {
    private static String DX_QA_ADMIN_PROFILE = 'Dx QA Admin';
    private static String DX_SYSTEM_ADMIN_PROFILE = 'Dx System Admin';
    private static String SYSTEM_ADMIN_PROFILE = 'System Administrator';
    
    /*
	 *  Take a list of objects, returns a set of the Id field specified in fieldName parameter. 
	 */
    public static set<Id> toSetIds(List<SObject> records, final String fieldName) {
        Set<Id> ids = new Set<Id>();
        for (SObject record : records) {
            Id idVal = (Id) record.get(fieldName);
            ids.add(idVal);
        }
        return ids;
    }
    
    /*
	 *  Take a new and old recored of objects, check with provided field (API) set if any field change return true. 
	 */
    public static boolean isAnyFieldUpdated(sObject newObject,sObject oldObject, set<string> objectFieldsSet ){
        for(string fieldAPIName : objectFieldsSet){
            if(newObject.get(fieldAPIName) != oldObject.get(fieldAPIName)){
                return true;
            }
        }
        return false;
    }
    
    /*
	 *  Generates and sends a chatter message to specified user notifying them of apex error. 
	 */
    public static void generateApexErrorChatterMessage(exception apexException){
        Id recipientUserId = [SELECT Id FROM User WHERE email = :Label.x7S_Apex_Error_User_Email].Id;
        FeedItem post = new FeedItem();
        post.ParentId = recipientUserId;
        post.CreatedById = recipientUserId;
        post.Body = 'An apex error has occured.\r\n Type: ' + apexException.getTypeName() + 
            '\r\n Message: ' + apexException.getMessage() + '\r\n Trace: ' + apexException.getStackTraceString() +
            '\r\n User: ' + UserInfo.getUserName();
        insert post;
        system.debug('post: ' + post);
    }
    
    /*
	 *  Generates set of profile Ids that are considered 'Admin' by the business 
	 */
    public static set <Id> getAdminIds(){
        set <Id> adminIds = new set <Id>(); 
        for (Profile prof : [SELECT Id FROM Profile WHERE Name = :DX_QA_ADMIN_PROFILE OR Name = :DX_SYSTEM_ADMIN_PROFILE OR Name = :SYSTEM_ADMIN_PROFILE]){
            adminIds.add(prof.Id);
        }
        return adminIds; 
    }
    
    /*
	 *  Returns boolean based on whether passed in list has values 
	 */
    public Static Boolean isNullOrEmpty(List<Object> objectList) {
        if (objectList == null || objectList.size() == 0) {
            return true;
        }
		//will return false
        return false;
    }
}