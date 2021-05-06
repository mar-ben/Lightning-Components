({
	fetchRecords : function(component) {
		var action=component.get('c.getRelatedRecords');
		var params={
			recordId : component.get("v.recordId"),
			objectName: component.get('v.object'),
			attributes: component.get('v.attributes'),
			sortBy: component.get('v.sort'),
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
				var columns=result.columns;
				var columnsWithRecordLink=this.addRecordLink(columns);
				console.log('columnsWithRecordLink='+ JSON.stringify(columnsWithRecordLink));
				console.log('columns='+JSON.stringify(result.columns));
				component.set('v.columns',columnsWithRecordLink);
				var data=this.formatRelationShipAttributes(result.records);
				component.set("v.recordCount",data.length);
				component.set('v.records',data);
				//result=response.returnValue;
				//component.set("v.columns",result.)
			}catch(e){console.log(e)}
		}else if(response.getState()=='ERROR'){
			console.log(response.getError());
		}
			console.log(JSON.stringify(response));
		});
		$A.enqueueAction(action);
		
		},
		formatRelationShipAttributes: function(records){
			var formatedRecords = [];
		  console.log(records);
			//todo check if data exists
		   // console.log("related=" + JSON.stringify(returnVal));
			for (var i = 0; i < records.length; i++) {
			  var recordObject = records[i];
			  for (var key of Object.keys(recordObject)) {
			    console.log("key=" + key);
 				//if (key.includes("__r")) {
				if (typeof recordObject[key]==='object'){
				  recordObject[key + "." + "Name"] = recordObject[key].Name;
				  delete recordObject[key];
				}
			  }
			  recordObject["linkName"] = "/" + recordObject.Id;
			  formatedRecords.push(recordObject);
			}
			console.log('formated records'+JSON.stringify(formatedRecords));
		 return formatedRecords;
		},
		addRecordLink :function  (columns){
			 columns.unshift({
				label: "Name",
				fieldName: "linkName",
				type: "url",
				typeAttributes: { label: { fieldName: "Name" }, target: "_self" }
			  });
			  return columns;
		}
})