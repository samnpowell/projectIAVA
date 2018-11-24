@isTest
private class test_dc_ctrl_reconfirm {

    static testMethod void testController() {       
        Give__c give = test_Utilities.createSimpleGive();
        give.Collect_Guest_Name__c = 'at re-confirm';
        give.Collect_Guest_DL_Num__c = 'at re-confirm';
        give.Collect_Guest_DOB__c = 'at re-confirm';
        give.Collect_Guest_Shirt_Size__c = 'at re-confirm';
        give.Collect_Member_DL_Num__c = 'at re-confirm';
        give.Collect_Member_DOB__c = 'at re-confirm';
        give.Collect_Member_Shirt_Size__c = 'at re-confirm';
        
        give.Must_be_21__c = true;
        give.Must_be_21_for_guest__c = true;
        
        update give;
        
        Give_Instance__c instance = test_Utilities.createSimpleGiveInstance(give);
                
        Contact con = test_Utilities.createSimpleContact('last', 'test@test.com', '12345');
        
        Give_Request__c request = test_Utilities.createSimpleGiveRequest(give, instance, con);
        
        test_Utilities.createSimpleGuest(request, con);
        
        PageReference pageRef = Page.dc_ReConfirm;

        Test.setCurrentPage(pageRef);
        
        
        //rucksack/dc_ReConfirm?GiveRequestID=a0JS0000001WlGY&ContactID=003S000000OyQ57&PageAction=confirmation
        
        
        System.debug(System.LoggingLevel.INFO, 'GiveRequest: ' + request.Id);
        System.debug(System.LoggingLevel.INFO, 'ContactId: ' + con.Id);
        
        ApexPages.currentPage().getParameters().put('GiveRequestId', request.Id);
        ApexPages.currentPage().getParameters().put('ContactID', con.Id);
        ApexPages.currentPage().getParameters().put('PageAction', 'confirmation');
        ApexPages.currentPage().getParameters().put('instanceid', instance.id);
        ApexPages.currentPage().getParameters().put('mem-id', '12345');
        ApexPages.currentPage().getParameters().put('email', 'test@test.com');
        ApexPages.currentPage().getParameters().put('giveid', give.Id);
        
        
        Test.startTest();
        dc_Request_Page_Handler t = new dc_Request_Page_Handler();
        
        dc_ctrl_reconfirm controller = new dc_ctrl_reconfirm();
        controller.loadContact(con.Id);
        controller.confirm = 'yes';
        
        controller.submitrequest();
        controller.joinContactMailingAddress();
        
        controller.age_y = true;
        controller.guest_age_y = true;
        
        PageReference pr = controller.redirectOnSave();
        Boolean s = controller.getShouldShowReConfirmedMessage();
        s = controller.getShouldShowCancelledMessage();
        String s1 = controller.getdc_reconfirmed_confirmation_message();
        s1 = controller.getdc_cancelled_confirmation_message();
        List<SelectOption> options = controller.getAge();
        controller.age_y();
        controller.age_n();
        s = controller.getHasPersonalDetails();
        s = controller.getHasSpecialQuestions();
        s = controller.getPromptForGuests();
        s = controller.getShouldShowReConfirmBody();
        s = controller.getShouldShowReadonlyFields();
        s = controller.getShouldShowHeader();
        s = controller.getShouldShowConfirmationQuestion();
        s = controller.getShouldShowAlreadyConfirmed();
        s = controller.getShouldShowCancelled();
        s = controller.getShouldShowGuestsDivider();
        
        options = controller.getStateOptions();
        options = controller.getYesNoOptions();
        s1 = controller.getLogo();
        s1 = controller.getDefaultLogo();
        s1 = controller.getWhen();
        s1 = controller.getWhere();
        s1 = controller.getQuantity();
        s1 = controller.getDeadline();
        s1 = controller.getAgeLimit();
        options = controller.getTicketOptions();
        options = controller.getShirtSizeOptions();
        options = controller.getStateOptions();
        controller.refreshGuests();
        
        pr = controller.its();
        pr = controller.its_conf();
        
        options = controller.getInstanceOptions();
        s = controller.getMultipleInstances();
        
        s1 = controller.getSpecialInstructions2();
        s1 = controller.getSpecialInstructions3();
        s1 = controller.getSpecialInstructions4();
        s1 = controller.getSpecialInstructions5();
        
        s = controller.getPromptForGuestAge21();
        s = controller.getCollectMemberAgeVerification();
        
        s = controller.getCollectSpecialResponse();
        s = controller.getCollectSpecialResponse2();
        s = controller.getCollectSpecialResponse3();
        s = controller.getCollectSpecialResponse4();
        s = controller.getCollectSpecialResponse5();
        
        s = controller.getCollectGuestDLNum();
        s = controller.getCollectGuestDOB();
        s = controller.getCollectGuestName();
        s = controller.getCollectGuestShirtSize();
        s = controller.getCollectMemberAgeVerification();
        s = controller.getCollectMemberDLNum();
        s = controller.getCollectMemberDOB();
        s = controller.getCollectMemberShirtSize();
        s = controller.getCollectQuantity();

		controller.ticketValue = 10;
        controller.selectedNumberOfGuests = 10;
        controller.refreshGuests();
        controller.ticketValue = 5;
        controller.selectedNumberOfGuests = 5;
        controller.refreshGuests();
        
        s = controller.commitGuests();
        
        
        controller.give.Maximum_Units_per_Member__c = null;
        s1 = controller.getQuantity();
        
        Test.stopTest();
    }
    
    private static testMethod void testCtrlTemplate() {
    	dc_ctrl_template tmp = new dc_ctrl_template();
    	String s = tmp.gettitle();
    	s = tmp.getoldieversion();
    	s = tmp.getMacos();
    }
}