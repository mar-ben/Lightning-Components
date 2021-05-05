global  class SObjectListController extends VisualEditor.DynamicPickList {
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Account', 'Account');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {

        VisualEditor.DynamicPickListRows rowList=new VisualEditor.DynamicPickListRows();
        for ( Schema.SObjectType o : Schema.getGlobalDescribe().values() )
        {
            Schema.DescribeSObjectResult objResult = o.getDescribe();
            VisualEditor.DataRow dataRow = new VisualEditor.DataRow(objResult.getLabel(),
                                                                 objResult.getName());
            rowList.addRow(dataRow);

        }
        
        return rowList;
    }
    
}