({
	 /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event){ 
        var action = component.get("c.getContactDetails");
        action.setParams({ caseId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var oRes = response.getReturnValue();
                component.set("v.PaginationList",oRes)


            }
            else{
                console.log("Error");
                //alert('Error...');
            }
        });
        $A.enqueueAction(action);  
    }
})