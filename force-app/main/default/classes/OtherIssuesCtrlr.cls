public class OtherIssuesCtrlr {
    @AuraEnabled
    public Static List<Case> otherIssue(Id caseId){
       Id conId = OpenissuesCtrlr.getConId(caseId);
       if(conId!=null)
       	 return [SELECT Id,CaseNumber,Contact.Name FROM Case WHERE Contact.Id = :conId And Id != :caseid];
       return null;
    }

}