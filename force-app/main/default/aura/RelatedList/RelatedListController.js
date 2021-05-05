({
	onInit : function(component, event, helper) {
		console.log("on Init");
		helper.fetchRecords(component);
		//component.set()
	}
})