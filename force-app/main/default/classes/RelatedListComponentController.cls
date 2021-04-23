public with sharing class RelatedListComponentController {
    public RelatedListComponentController() {

    }
    @AuraEnabled
    public static string getRelatedRecords(String recordId){
        try {
        
            return '';

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
