({
	
    showOtherIssue : function(component,event){ 
        var action = component.get("c.otherIssue");
        action.setParams({ caseId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var oRes = response.getReturnValue();
               
                if(oRes !== null && oRes !== undefined && Array.isArray(oRes)){
                    var ol = [];
                    for(let i=0; i < oRes.length; i += 1) {
                        let obj ={'sObjectType':'Case','CaseNumber':'','Name':''};
                        obj.CaseNumber = oRes[i].CaseNumber;
                        obj.Name = oRes[i].Contact.Name;
                        //alert('PaginationList2 here'+JSON.stringify(obj));
                        ol.push(obj);
                        
                    }
                    component.set("v.PaginationList2",ol);
                }
                //alert(JSON.stringify(component.get("v.PaginationList2"))+'here');


            }
            else{
                console.log("Error");
                //alert('Error...');
            }
        });
        $A.enqueueAction(action);  
    },
})