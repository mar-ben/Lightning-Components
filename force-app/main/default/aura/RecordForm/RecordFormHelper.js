({
  fetchRecords: function(component) {
      component.set("v.isLoading",true);
    var action = component.get("c.getRecordData");
        //let attributes='FirstName,LastName,WL_Promo_Code_RAC__c,MobilePhone,WL_Renter_Inventory_Reservation_Flag_RAC__c';
		
    var params = {
      //recordId : component.get("v.recordId"),
      recordId: component.get("v.recordId"),
      objectApiName: component.get("v.objectApiName"),
      attributes: component.get("v.attributes")
      //objectName: component.get('v.object'),
      //attributes: component.get('v.attributes')
    };

    action.setParams(params);
    action.setCallback(this, function(response) {
      if (response.getState() == "SUCCESS") {
        try {
          var result = response.getReturnValue();
          console.log(result);
          let formattedRecord = this.mergeColumnAndRecord(
            result.columns,
            result.record
          );
          let updatedRecord=this.updateReadOnlyAttributes(component,formattedRecord);
          let rows = this.groupAttributesInRows(formattedRecord);
          console.log("formattedRecord");
          console.log(formattedRecord);
          console.log(rows);
          component.set("v.rows",rows);
        } catch (e) {
          console.log(e);
        }
      } else if (response.getState() == "ERROR") {
        console.log(response.getError());
      }
      console.log(JSON.stringify(response));
        component.set("v.isLoading",false);
    });
    $A.enqueueAction(action);
  },
  mergeColumnAndRecord: function(columns, data) {
    for (let column in columns) {
      console.log(column);
      let key = columns[column].fieldName;
      columns[column].value = data[key];
    }
    return columns;
  },
  groupAttributesInRows: function(attributes) {
    let rows = [];
    let rowItems = [];
    let cnt = 1;
    for (let index in attributes) {
      rowItems.push(attributes[index]);
      if (cnt === 2) {
        rows.push(rowItems);
        rowItems = [];
        cnt = 0;
      }
      cnt++;
    }
      if(rowItems.length>0){
         rows.push(rowItems); 
      }
    return rows;
  },
    updateReadOnlyAttributes: function (component, data) {
        debugger;
      let readonlyAttributes=component.get("v.readOnlyAttributes");
      let map={}
		var items=readonlyAttributes.split(",")
        for (let index in items) {
           map[items[index].toLowerCase()]=true;
			}
			console.log(map);
        for(let index in data){
            let fieldName=data[index].fieldName;
            if(map[fieldName.toLowerCase()]){
                data[index].readOnly=true;
            }else{
                data[index].readOnly=false;
            }
        }
        //TODO
        return data;
    },
    cloneObject:function (obj) {
        return JSON.parse(JSON.stringify(obj));
    }
});