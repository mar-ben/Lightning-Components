public with sharing class RelatedListComponentController {

class Column{
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled 
        public String fieldName {get;set;}
        @AuraEnabled
        public String type {get;set;}
        @AuraEnabled
        public Boolean sortable {get;set;}
        @AuraEnabled
        public Boolean wrapText {get;set;}
    }

public class Response{
    @AuraEnabled 
    public List<Column> columns{get;set;}
    @AuraEnabled
    public List<sObject> records{get;set;}
    @AuraEnabled
    public String objectLabel{get;set;}
}

    public RelatedListComponentController() {

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
                if(fieldResult.getType()==Schema.DisplayType.REFERENCE){
                 String relationshipName=fieldResult.getRelationshipName();
                 aColumn.fieldName=relationshipName+'.Name';   
                 aColumn.type='STRING';
                }else{
                aColumn.fieldName=fieldResult.getName();       
            //    aColumn.sortable=true;    
                aColumn.type=String.valueOf(fieldResult.getType()).toLowerCase();  
                }
                aColumn.label=fieldResult.getLabel();
                aColumn.wrapText=true;
                
                cols.add(aColumn);
            }
        }
    
        return cols;
    }


    public static String getObjectLabel(String objectName){
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
            .get(objectName).getDescribe();
        return objResult.getLabel();
    }

    @AuraEnabled
    public static Response getRelatedRecords(String recordId,
                                           String objectName,
                                           String attributes,
                                           String sortBy,
                                           String referenceAttribute
                                           ){
      //  try {
        System.debug('objectName='+objectName);
        String objectLabel=getObjectLabel(objectName.trim());
        List<Column> columns=getColumns(objectName,attributes);
        String soql='select id,Name,';
        for (column aColumn : columns){
            soql=soql+aColumn.fieldName +', ';
        }
        soql=soql.removeEnd(', ');
        soql=soql+' from '+objectName;
        soql=soql+ ' where '+referenceAttribute+ '=\''+recordId+'\' ';
        soql=soql+ ' order by '+ sortBy;
        System.debug('soql='+soql);
        List<sObject> dataResult= Database.query(soql);
        Response response=new Response();
        response.columns=columns;
        response.records=dataResult;
        response.objectLabel=objectLabel;
        
        return response;

    /*    } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }*/
    }

    public static String getColumns(String attributes){
    List<String> attributeList=attributes.split(',');
    System.debug(attributeList);
    return '';
    }
   
}