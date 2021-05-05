({
	fetchRecords : function(component) {
		var action=component.get('c.getRelatedRecords');
		var params={
			recordId : component.get("v.recordId"),
			objectName: component.get('v.Object'),
			attributes: component.get('v.Attributes'),
			sortBy: component.get('v.Sort'),
			referenceAttribute:component.get('v.referenceAttribute')
			 };
		debugger;
		action.setParams(params);
		action.setCallback(this,function(response){
			debugger;
			if(response.getState()=='SUCCESS'){
				debugger;
				try{
				var result=response.getReturnValue();
				component.set('v.columns',result.columns);
				component.set('v.records',result.records);
				//result=response.returnValue;
				//component.set("v.columns",result.)
			}catch(e){console.log(e)}

			}
			console.log(JSON.stringify(response));
		});
		$A.enqueueAction(action);
		
		}
})