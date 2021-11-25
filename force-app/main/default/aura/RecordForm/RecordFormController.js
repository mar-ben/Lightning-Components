({
  onInit: function(component, event, helper) {
    console.log("on Init");
    helper.fetchRecords(component);
    //component.set()
  },
    onClickEditHandler: function (component, event, helper) {
    
        debugger;
    //capture the current state.
    let rows = component.get("v.rows");
    component.set("v.prevState", helper.cloneObject(rows));
    component.set("v.isEditMode", true);
  },
    handleClickCancel: function (component, event, helper) {
    //Rollback the change to prev State.
    let prevState = component.get("v.prevState");
    component.set("v.rows", helper.cloneObject(prevState));
    component.set("v.isEditMode", false);
  },
  handleClickSave: function(component, event, helper) {
    try {
      let items = [];
      console.log(component.get("v.rows"));
      let rows = component.get("v.rows");
      for (let index in rows) {
        let rowItems = rows[index];
        for (let itemIndex in rowItems) {
          let item = rowItems[itemIndex];
          items.push(item);
        }
      } 
      console.log(items);
      let itemsWithOutReadonlyFields = items.filter(item => !item.readOnly);
        var payload={};
        for(let index in itemsWithOutReadonlyFields){
            let key=itemsWithOutReadonlyFields[index].fieldName;
            let value=itemsWithOutReadonlyFields[index].value;
            payload[key]=value;
        }
        console.log('payload='+JSON.stringify(payload));
      var action = component.get("c.updateRecord");
      //action.setParams({ recId: component.get("v.recordId") });
        action.setParams({ objectApiName:'lead',attributes:payload,recordId:component.get("v.recordId")});
      action.setCallback(
        this,
        $A.getCallback(function(response1) {
          component.set("v.spinner", false);
          var state = response1.getState();
            console.log(response1);
          if (state === "SUCCESS") {
            var res = response1.getReturnValue();
             console.log(res);
             component.set("v.isEditMode", false);
          } else {
              console.log(response1.getError());
          }
            
        })
      );
      $A.enqueueAction(action);

     
    } catch (e) {
      console.log(e);
    }
  }
});