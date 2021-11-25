public class RecordFormController {
    
    class Column{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled 
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public List<Object> pickList {get;set;}
        @AuraEnabled
        public Integer maxlength {get;set;}
    }
    
    public class Response{
        @AuraEnabled 
        public List<Column> columns{get;set;}
        @AuraEnabled
        public sObject record{get;set;}
        @AuraEnabled
        public String objectLabel{get;set;}
    }
    
    
    public static String getObjectLabel(String objectApiName){
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
            .get(objectApiName).getDescribe();
        return objResult.getLabel();
    }
    @AuraEnabled
    public static Response getRecordData(String objectApiName,String attributes,String recordId){
        
        Response res=new Response();
        res.columns=getColumns(objectApiName,attributes);
        String soql='select id,Name,';
        for (column aColumn : res.columns){
            if(aColumn.type=='picklist'){
                soql=soql+' toLabel('+aColumn.fieldName +'), '; 
            }else{
                soql=soql+aColumn.fieldName +', ';
            }
        }
        soql=soql.removeEnd(', ');
        soql=soql+' from '+objectApiName;
        soql=soql+ ' where id=\''+recordId+'\' ';
        System.debug('soql='+soql);
        sObject record= Database.query(soql);
        res.record=record;
        res.objectLabel=getObjectLabel(objectApiName);
        return res;
    }
    @AuraEnabled
    public static  String updateRecord(String objectApiName,
                                       Map<String,Object> attributes,
                                       String recordId ){
                                           try{
                                               Map<String, Schema.SObjectType> allObjects = Schema.getGlobalDescribe();
                                               Schema.SObjectType objType=allObjects.get(objectApiName);
                                               Sobject obj=objType.newSObject();
                                               System.debug(obj);
                                               obj.put('id',recordId);
                                               for (String key : attributes.keySet()) {
                                                   obj.put(key, attributes.get(key));
                                               }
                                               update obj;
                                               
                                           }catch(Exception ex){
                                               System.debug(ex);
                                               return ex.getMessage()+ex.getLineNumber();
                                               
                                           }
                                           return 'true';
                                       }
    
    public static List<Column> getColumns(String objectApiName, String attributes){
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
            .get(objectApiName).getDescribe();
        List<Column> cols=new List<Column>();
        List<String> attributeList=attributes.split(',');
        for(string attribute : attributeList){
            System.debug('col='+attribute);
            if(attribute.trim()!=null){
                Column aColumn= new Column();
                DescribeFieldResult fieldResult = objResult.fields.getMap().get(attribute.trim()).getDescribe();
                System.debug(fieldResult);
                aColumn.fieldName=fieldResult.getName();       
                aColumn.type=String.valueOf(fieldResult.getType()).toLowerCase();  
                if(aColumn.type=='picklist'){
                    List<Object> pickListValues=new List<Object>();
                    List<Schema.PicklistEntry> pickList=fieldResult.getPicklistValues();   
                    for( Schema.PicklistEntry pickListItem : pickList){
                        Map<String,String> pickListMap=new Map<String,String>();
                        pickListMap.put('label',pickListItem.getLabel());
                        pickListMap.put('value',pickListItem.getValue());
                        pickListValues.add(pickListMap);
                    }
                    aColumn.pickList=pickListValues;  
                }
                aColumn.label=fieldResult.getLabel();
                aColumn.maxlength=fieldResult.getLength();
                cols.add(aColumn);
            }
        }
        
        return cols;
    }
    
    
    
}