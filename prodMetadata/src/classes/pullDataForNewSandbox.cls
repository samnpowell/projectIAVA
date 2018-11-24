public class pullDataForNewSandbox
{
    public static void getDataForReferrals()
    {
        // pull a subset of referral records from production for testing
        // use the records related to the referrals to build up a sandbox database
        
        // each referral record is related to a case, a contact, a focus area, and a program
        // each case record is related to a contact, a program and a stat
        // stats are a dead end related to no other records
        // each program record is related to an account, a contact, and a focus area
        // focus areas are a dead end related to no other records
        // each contact is related to an account
        // each account can be related to a contact, will need to add these contacts to a set as well then re-query accounts
        
        // set all the variables
        string csv = null; // this will be used to build all csvs, set to null to start, reset after each file is generated
        set<id> referralIds = new set<id>(); // set to hold all referral record ids
        set<id> caseIds = new set<id>(); // set to hold all case record ids
        set<id> statIds = new set<id>(); // set to hold all stat record ids
        set<id> programIds = new set<id>(); // set to hold all program record ids
        set<id> focusAreaIds = new set<id>(); // set to hold all focus area ids
        set<id> contactIds = new set<id>(); // set to hold all contact record ids
        set<id> accountIds = new set<id>(); // set to hold all account record ids
        blob b = null; // variable for blob since execute anonymous is being an asshole
        
        // this block creates and inserts the referral csv (also starts building out sets of ids for other objects to be inserted)
        // set the csv header row
        csv = 'Benefit_Received__c,Can_We_Contact_You_About_Your_Responses__c,Case_Manager_Customer_Service__c,Case_Manager_Quality__c,Case_Manager_Timeliness__c,Case_Manager__c,Case__c,Client_Notes_on_Case_Manager__c,Client_Notes_on_Program__c,Comments__c,Contact__c,Customer_Service__c,Date_of_Referral__c,Effectiveness__c,Focus_Area_for_Referral__c,Id,Master_Rating__c,Name,Note_to_Client__c,Overall_Rating__c,Program__c,Quality__c,Status__c,Timeliness__c,Type__c\n';
        
        // loop through query of 100 referrals, add each to new row in csv file (build the csv)
        for(Referral__c ref: [SELECT Benefit_Received__c,Can_We_Contact_You_About_Your_Responses__c,Case_Manager_Customer_Service__c,Case_Manager_Quality__c,Case_Manager_Timeliness__c,Case_Manager__c,Case__c,Client_Notes_on_Case_Manager__c,Client_Notes_on_Program__c,Comments__c,Contact__c,Customer_Service__c,Date_of_Referral__c,Effectiveness__c,Focus_Area_for_Referral__c,Id,Master_Rating__c,Name,Note_to_Client__c,Overall_Rating__c,Program__c,Quality__c,Status__c,Timeliness__c,Type__c FROM Referral__c LIMIT 100])
        {
            csv += ref.Benefit_Received__c + ',' + ref.Can_We_Contact_You_About_Your_Responses__c + ',' + ref.Case_Manager_Customer_Service__c + ',' + ref.Case_Manager_Quality__c + ',' + ref.Case_Manager_Timeliness__c + ',' + ref.Case_Manager__c + ',' + ref.Case__c + ',' + ref.Client_Notes_on_Case_Manager__c + ',' + ref.Client_Notes_on_Program__c + ',' + ref.Comments__c + ',' + ref.Contact__c + ',' + ref.Customer_Service__c + ',' + ref.Date_of_Referral__c + ',' + ref.Effectiveness__c + ',' + ref.Focus_Area_for_Referral__c + ',' + ref.Id + ',' + ref.Master_Rating__c + ',' + ref.Name + ',' + ref.Note_to_Client__c + ',' + ref.Overall_Rating__c + ',' + ref.Program__c + ',' + ref.Quality__c + ',' + ref.Status__c + ',' + ref.Timeliness__c + ',' + ref.Type__c + '\n';
            referralIds.add(ref.Id);
            caseIds.add(ref.Case__c);
            programIds.add(ref.Program__c);
            focusAreaIds.add(ref.Focus_Area_for_Referral__c);
            contactIds.add(ref.Contact__c);
        }
        
        // set the blob value before inserting the file
        b = blob.valueOf(csv);
        
        // if the query produced results, insert the csv file
        if(!referralIds.isEmpty())
        {
            ContentVersion referralFile = new ContentVersion(title='referralsToImport.csv',versionData=b,pathOnClient='/referralsToImport.csv');
            insert referralFile;
        }
        
        // reset the csv string and the blob
        csv = null;
        b = null;
        
        // this block creates and inserts the case csv (also continues building out sets of ids for other objects to be inserted)
        // set the csv header row
        csv = 'accountid,actual_hours__c,annual_family_income__c,at_risk_for_homelessness__c,cancelled_by_client__c,casenumber,combat_related_special_compensation__c,contactid,contact_lost__c,contact_preference__c,current_housing_living_status__c,date_time_of_completed_intake__c,date_time_of_first_referral__c,date_time_of_initial_request__c,date_time_of_permanent_vtm_outreach__c,description,discharge_status__c,emergency_contact__c,employment__c,estimated_hours__c,ethnicity__c,family_income__c,gender__c,healthcare__c,highest_level_of_education__c,how_did_you_hear_about_us__c,id,intake_completed__c,intake_form_completed_date__c,intake_never_completed__c,intake_step_completed__c,intervention_treatment_plan__c,in_household__c,last_case_comment_date__c,locality__c,marital_status__c,mental_health__c,military_retirement_compensation__c,monthly_compensation__c,most_recently_used_education_benefit__c,most_recent_stress_level__c,number_of_children__c,origin,ownerid,position_job_title__c,priority,problem_assessment__c,receiving_public_benefits__c,receiving_va_educational_benefits__c,recordtypeid,referred_from_program__c,related_stat__c,re_opened__c,rrrp_customer_service__c,rrrp_effectiveness__c,rrrp_quality__c,rrrp_timeliness__c,salary__c,service_era__c,source_of_client_referral__c,status,stress_level_at_intake__c,subject,type,va_disability__c,veteran_family_member__c\n'; //va_disability_rating__c,
        
        // loop through query of cases related to the 100 referrals, add each to new row in csv file (build the csv)
        if(!caseIds.isEmpty())
        {
            for(Case rrrp: [SELECT accountid,actual_hours__c,annual_family_income__c,at_risk_for_homelessness__c,cancelled_by_client__c,casenumber,combat_related_special_compensation__c,contactid,contact_lost__c,contact_preference__c,current_housing_living_status__c,date_time_of_completed_intake__c,date_time_of_first_referral__c,date_time_of_initial_request__c,date_time_of_permanent_vtm_outreach__c,description,discharge_status__c,emergency_contact__c,employment__c,estimated_hours__c,ethnicity__c,family_income__c,gender__c,healthcare__c,highest_level_of_education__c,how_did_you_hear_about_us__c,id,intake_completed__c,intake_form_completed_date__c,intake_never_completed__c,intake_step_completed__c,intervention_treatment_plan__c,in_household__c,last_case_comment_date__c,locality__c,marital_status__c,mental_health__c,military_retirement_compensation__c,monthly_compensation__c,most_recently_used_education_benefit__c,most_recent_stress_level__c,number_of_children__c,origin,ownerid,position_job_title__c,priority,problem_assessment__c,receiving_public_benefits__c,receiving_va_educational_benefits__c,recordtypeid,referred_from_program__c,related_stat__c,re_opened__c,rrrp_customer_service__c,rrrp_effectiveness__c,rrrp_quality__c,rrrp_timeliness__c,salary__c,service_era__c,source_of_client_referral__c,status,stress_level_at_intake__c,subject,type,va_disability__c,veteran_family_member__c FROM Case WHERE Id IN: caseIds]) //va_disability_rating__c,
            {
                csv += rrrp.accountid + ',' + rrrp.actual_hours__c + ',' + rrrp.annual_family_income__c + ',' + rrrp.at_risk_for_homelessness__c + ',' + rrrp.cancelled_by_client__c + ',' + rrrp.casenumber + ',' + ',' + rrrp.combat_related_special_compensation__c + ',' + rrrp.contactid + ',' + rrrp.contact_lost__c + ',' + rrrp.contact_preference__c + ',' + rrrp.current_housing_living_status__c + ',' + rrrp.date_time_of_completed_intake__c + ',' + rrrp.date_time_of_first_referral__c + ',' + rrrp.date_time_of_initial_request__c + ',' + rrrp.date_time_of_permanent_vtm_outreach__c + ',' + rrrp.description + ',' + rrrp.discharge_status__c + ',' + rrrp.emergency_contact__c + ',' + rrrp.employment__c + ',' + rrrp.estimated_hours__c + ',' + rrrp.ethnicity__c + ',' + rrrp.family_income__c + ',' + rrrp.gender__c + ',' + rrrp.healthcare__c + ',' + rrrp.highest_level_of_education__c + ',' + rrrp.how_did_you_hear_about_us__c + ',' + rrrp.id + ',' + rrrp.intake_completed__c + ',' + rrrp.intake_form_completed_date__c + ',' + rrrp.intake_never_completed__c + ',' + rrrp.intake_step_completed__c + ',' + rrrp.intervention_treatment_plan__c + ',' + rrrp.in_household__c + ',' + rrrp.last_case_comment_date__c + ',' + rrrp.locality__c + ',' + rrrp.marital_status__c + ',' + rrrp.mental_health__c + ',' + rrrp.military_retirement_compensation__c + ',' + rrrp.monthly_compensation__c + ',' + rrrp.most_recently_used_education_benefit__c + ',' + rrrp.most_recent_stress_level__c + ',' + rrrp.number_of_children__c + ',' + rrrp.origin + ',' + rrrp.ownerid + ',' + rrrp.position_job_title__c + ',' + rrrp.priority + ',' + rrrp.problem_assessment__c + ',' + rrrp.receiving_public_benefits__c + ',' + rrrp.receiving_va_educational_benefits__c + ',' + rrrp.recordtypeid + ',' + rrrp.referred_from_program__c + ',' + rrrp.related_stat__c + ',' + rrrp.re_opened__c + ',' + rrrp.rrrp_customer_service__c + ',' + rrrp.rrrp_effectiveness__c + ',' + rrrp.rrrp_quality__c + ',' + rrrp.rrrp_timeliness__c + ',' + rrrp.salary__c + ',' + rrrp.service_era__c + ',' + rrrp.source_of_client_referral__c + ',' + rrrp.status + ',' + rrrp.stress_level_at_intake__c + ',' + rrrp.subject + ',' + rrrp.type + ',' + rrrp.va_disability__c + ',' + rrrp.veteran_family_member__c + '\n'; //+ rrrp.va_disability_rating__c + ',' 
                statIds.add(rrrp.related_stat__c);
                programIds.add(rrrp.referred_from_program__c);
                contactIds.add(rrrp.contactid);
                accountIds.add(rrrp.accountid);
            }
            
            // set the blob value before inserting the file
            b = blob.valueOf(csv);
            
            // insert the csv file (already checked to make sure there would be results)
            ContentVersion caseFile = new ContentVersion(title='casesToImport.csv',versionData=b,pathOnClient='/casesToImport.csv');
            insert caseFile;
        }
        
        // reset the csv string and the blob
        csv = null;
        b = null;
        
        // this block creates and inserts the stat csv
        // set the csv header row
        csv = 'Active__c,Amount_Description__c,Amount_Type__c,Frequency__c,General_Stat_link__c,Id,Measurement_Amount_Date__c,Most_Recent_Amount__c,Name,Number_to_Know__c,Other_Citation_Info__c,OwnerId,Private__c,RecordTypeId,Related_Links__c\n';
        
        // loop through query of stats related to the cases, add each to new row in csv file (build the csv)
        if(!statIds.isEmpty())
        {
            for(Stat__c stat: [SELECT Active__c,Amount_Description__c,Amount_Type__c,Frequency__c,General_Stat_link__c,Id,Measurement_Amount_Date__c,Most_Recent_Amount__c,Name,Number_to_Know__c,Other_Citation_Info__c,OwnerId,Private__c,RecordTypeId,Related_Links__c FROM Stat__c WHERE Id IN: statIds])
            {
                csv += stat.Active__c + ',' + stat.Amount_Description__c + ',' + stat.Amount_Type__c + ',' + stat.Frequency__c + ',' + stat.General_Stat_link__c + ',' + stat.Id + ',' + stat.Measurement_Amount_Date__c + ',' + stat.Most_Recent_Amount__c + ',' + stat.Name + ',' + stat.Number_to_Know__c + ',' + stat.Other_Citation_Info__c + ',' + stat.OwnerId + ',' + stat.Private__c + ',' + stat.RecordTypeId + ',' + stat.Related_Links__c + '\n';
            }
            
            // set the blob value before inserting the file
            b = blob.valueOf(csv);
            
            // insert the csv file (already checked to make sure there would be results)
            ContentVersion statFile = new ContentVersion(title='statsToImport.csv',versionData=b,pathOnClient='/statsToImport.csv');
            insert statFile;
        }
        
        // reset the csv string and the blob
        csv = null;
        b = null;
        
        // this block creates and inserts the program csv (also continues building out sets of ids for other objects to be inserted)
        // set the csv header row
        csv = 'Best_in_Class__c,Description__c,Emailed_Description__c,External_Intake_Instructions__c,Focus_Area__c,Funder_s__c,HEEC__c,Id,Internal_Intake_Instructions__c,MOU_Terms__c,MOU__c,Name,Organization__c,OwnerId,Primary_POC__c,Program_City__c,Program_State__c,Program_Street_Address__c,Program_Zip__c,Public_Description__c,Site_Visit_Complete_Y_N__c,Suppress_Emails_for_Program_Merge__c\n';
        
        // loop through query of programs related to the 100 referrals and to the cases, add each to new row in csv file (build the csv)
        if(!programIds.isEmpty())
        {
            for(Program__c program: [SELECT Best_in_Class__c,Description__c,Emailed_Description__c,External_Intake_Instructions__c,Focus_Area__c,Funder_s__c,HEEC__c,Id,Internal_Intake_Instructions__c,MOU_Terms__c,MOU__c,Name,Organization__c,OwnerId,Primary_POC__c,Program_City__c,Program_State__c,Program_Street_Address__c,Program_Zip__c,Public_Description__c,Site_Visit_Complete_Y_N__c,Suppress_Emails_for_Program_Merge__c FROM Program__c WHERE Id IN: programIds])
            {
                csv += program.Best_in_Class__c + ',' + program.Description__c + ',' + program.Emailed_Description__c + ',' + program.External_Intake_Instructions__c + ',' + program.Focus_Area__c + ',' + program.Funder_s__c + ',' + program.HEEC__c + ',' + program.Id + ',' + program.Internal_Intake_Instructions__c + ',' + program.MOU_Terms__c + ',' + program.MOU__c + ',' + program.Name + ',' + program.Organization__c + ',' + program.OwnerId + ',' + program.Primary_POC__c + ',' + program.Program_City__c + ',' + program.Program_State__c + ',' + program.Program_Street_Address__c + ',' + program.Program_Zip__c + ',' + program.Public_Description__c + ',' + program.Site_Visit_Complete_Y_N__c + ',' + program.Suppress_Emails_for_Program_Merge__c + '\n';
                focusAreaIds.add(program.Focus_Area__c);
                contactIds.add(program.Primary_POC__c);
                accountIds.add(program.Organization__c);
            }
            
            // set the blob value before inserting the file
            b = blob.valueOf(csv);
            
            // insert the csv file (already checked to make sure there would be results)
            ContentVersion programFile = new ContentVersion(title='programsToImport.csv',versionData=b,pathOnClient='/programsToImport.csv');
            insert programFile;
        }
        
        // reset the csv string and the blob
        csv = null;
        b = null;
        
        // this block creates and inserts the focus area csv
        // set the csv header row
        csv = 'Active__c,Id,Legislative_Agenda_Year__c,Name,Overview__c,OwnerId,Priority__c,RecordTypeId,Research_Lead__c\n';
        
        // loop through query of focus areas related to the previously queried records, add each to new row in csv file (build the csv)
        if(!focusAreaIds.isEmpty())
        {
            for(Focus_Area__c focus: [SELECT Active__c,Id,Legislative_Agenda_Year__c,Name,Overview__c,OwnerId,Priority__c,RecordTypeId,Research_Lead__c FROM Focus_Area__c WHERE Id IN: focusAreaIds])
            {
                csv += focus.Active__c + ',' + focus.Id + ',' + focus.Legislative_Agenda_Year__c + ',' + focus.Name + ',' + focus.Overview__c + ',' + focus.OwnerId + ',' + focus.Priority__c + ',' + focus.RecordTypeId + ',' + focus.Research_Lead__c + '\n';
            }
            
            // set the blob value before inserting the file
            b = blob.valueOf(csv);
            
            // insert the csv file (already checked to make sure there would be results)
            ContentVersion focusAreaFile = new ContentVersion(title='focusAreasToImport.csv',versionData=b,pathOnClient='/focusAreasToImport.csv');
            insert focusAreaFile;
        }
        
        // loop through contacts to find remaining accounts
        if(!contactIds.isEmpty())
        {
            for(Contact c: [SELECT AccountId FROM Contact WHERE Id IN: contactIds])
            {
                accountIds.add(c.AccountId);
            }
        }
        
        // loop through accounts to find remaining contacts
        if(!accountIds.isEmpty())
        {
            for(Account a: [SELECT POC__c FROM Account WHERE Id IN: accountIds])
            {
                contactIds.add(a.POC__c);
            }
        }
        
        // reset the csv string and the blob
        csv = null;
        b = null;
        
        // this block creates and inserts the contact csv (also continues building out the set of accounts to be inserted)
        // set the csv header row
        csv = 'AccountId,Active_Duty_End_Date__c,Active_Duty_Start_Date__c,Allied_Service_Member__c,Approval_Related_Comments__c,Approved_Date__c,Bad_Email__c,Bad_Phone__c,Bad_Primary_Address__c,Bio__c,Birthdate,Branch_of_Service__c,Civilian_Contractor__c,Combat_Related_Disability__c,Company__c,Confidential_Email__c,Confidential_Phone__c,Confidential_Street_Address__c,Consider_Deleting_this_Record__c,COV_Date__c,COV_ID_External__c,COV_Link__c,Current_Status__c,DataMatch_Age__c,DataMatch_City__c,DataMatch_Conservative_Donor_Household__c,DataMatch_County__c,DataMatch_Date__c,DataMatch_Desription__c,DataMatch_Disc_Income_Formula__c,DataMatch_Est_Household_Income_Formula__c,DataMatch_Ethnicity__c,DataMatch_Gender__c,DataMatch_Liberal_Donor_Household__c,DataMatch_Personicx_Cluster_Code__c,DataMatch_Personicx_Lifestage_Code__c,DataMatch_State__c,DataMatch_Street_Address__c,DataMatch_Underbanked_Inidicator__c,DataMatch_Vet_in_Household__c,DataMatch_Zip_Code__c,DC_Contact__c,Deployment_End_Date__c,Deployment_Start_Date__c,Direct_Mail_OptOut__c,Discharge_Status__c,Documents_Date__c,Dupe_Check_Date__c,Email,Ethnicity__c,Expected_Date_of_Graduation__c,Facebook_ID__c,Fax,FirstName,First_Bounce_Date__c,Gender__c,General_Notes__c,google_ID__c,HasOptedOutOfEmail,Has_Private_Contact_Info__c,Highest_Level_of_Education__c,HomePhone,Home_Town__c,Id,Instagram_ID__c,Interested_in_further_Involvement__c,Interests__c,Interest_in_meeting_other_members__c,LastName,Last_School_Attended__c,Latest_Major_Minor__c,MailingCity,MailingCountry,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStreet,Marital_Status__c,Media_Trained__c,Medical_Retirement__c,Membership_ID__c,Middle_Name__c,MobilePhone,Most_Recent_In_Honor_Of__c,Most_Recent_Unit__c,MOS_Military_Job__c,Name,New_GI_Bill__c,NGIB_Graduation_Date__c,NGIB_School_Name__c,NGIB_School_Status__c,NGIB_School_Type__c,Notes_About_Spokesperson__c,Not_a_Veteran__c,No_Email_Blasts__c,npe01__AlternateEmail__c,npe01__HomeEmail__c,npe01__PreferredPhone__c,npe01__Preferred_Email__c,npe01__WorkEmail__c,npe01__WorkPhone__c,npo02__Soft_Credit_Total__c,npo02__TotalOppAmount__c,npsp__Deceased__c,Number_of_Children__c,NVLSP_Consent_Given__c,OwnerId,Paperwork_Confirmation_Type__c,Paperwork_Confirmation__c,Paperwork_Issue__c,Paperwork_Received__c,Partnership_Contact__c,Phone,Political_Affiliation__c,Post_9_11_Veteran__c,Preferred_Public_Display_Name_Format__c,Press_Contact__c,Primary_IAVA_POC__c,Rank__c,Received_VA_Educational_Benefits__c,RecordTypeId,Salutation,Service_Type__c,Signup_Date__c,Snapshot_Number__c,Source_Details__c,Source__c,Spokesperson__c,Spreadsheet_ID__c,Staff__c,Submitted_Application__c,Submitted_DIA_Member_App__c,Submitted_Supporter_Form__c,Suffix__c,Survivor_of_vet__c,Tag__c,Temp_merge_field_1__c,Temp_merge_field_2__c,Test_Record__c,Text_Opt_In__c,Text_Opt_Out__c,Title,Twitter_ID__c,VA_Disability_Rating__c,VA_Disability__c,Veteran_Family_Member__c,Veteran_Member__c,Veteran_of_OEF__c,Veteran_of_OIF__c,Veteran_of_OND__c,Veteran_of_Other_Era__c,Volunteer__c,Voterbase_ID__c,Website__c,Willing_to_be_interviewed_photographed__c\n';
        
        // loop through query of contacts related to the previously queried records, add each to new row in csv file (build the csv)
        if(!contactIds.isEmpty())
        {
            for(Contact con: [SELECT AccountId,Active_Duty_End_Date__c,Active_Duty_Start_Date__c,Allied_Service_Member__c,Approval_Related_Comments__c,Approved_Date__c,Bad_Email__c,Bad_Phone__c,Bad_Primary_Address__c,Bio__c,Birthdate,Branch_of_Service__c,Civilian_Contractor__c,Combat_Related_Disability__c,Company__c,Confidential_Email__c,Confidential_Phone__c,Confidential_Street_Address__c,Consider_Deleting_this_Record__c,COV_Date__c,COV_ID_External__c,COV_Link__c,Current_Status__c,DataMatch_Age__c,DataMatch_City__c,DataMatch_Conservative_Donor_Household__c,DataMatch_County__c,DataMatch_Date__c,DataMatch_Desription__c,DataMatch_Disc_Income_Formula__c,DataMatch_Est_Household_Income_Formula__c,DataMatch_Ethnicity__c,DataMatch_Gender__c,DataMatch_Liberal_Donor_Household__c,DataMatch_Personicx_Cluster_Code__c,DataMatch_Personicx_Lifestage_Code__c,DataMatch_State__c,DataMatch_Street_Address__c,DataMatch_Underbanked_Inidicator__c,DataMatch_Vet_in_Household__c,DataMatch_Zip_Code__c,DC_Contact__c,Deployment_End_Date__c,Deployment_Start_Date__c,Direct_Mail_OptOut__c,Discharge_Status__c,Documents_Date__c,Dupe_Check_Date__c,Email,Ethnicity__c,Expected_Date_of_Graduation__c,Facebook_ID__c,Fax,FirstName,First_Bounce_Date__c,Gender__c,General_Notes__c,google_ID__c,HasOptedOutOfEmail,Has_Private_Contact_Info__c,Highest_Level_of_Education__c,HomePhone,Home_Town__c,Id,Instagram_ID__c,Interested_in_further_Involvement__c,Interests__c,Interest_in_meeting_other_members__c,LastName,Last_School_Attended__c,Latest_Major_Minor__c,MailingCity,MailingCountry,MailingGeocodeAccuracy,MailingLatitude,MailingLongitude,MailingPostalCode,MailingState,MailingStreet,Marital_Status__c,Media_Trained__c,Medical_Retirement__c,Membership_ID__c,Middle_Name__c,MobilePhone,Most_Recent_In_Honor_Of__c,Most_Recent_Unit__c,MOS_Military_Job__c,Name,New_GI_Bill__c,NGIB_Graduation_Date__c,NGIB_School_Name__c,NGIB_School_Status__c,NGIB_School_Type__c,Notes_About_Spokesperson__c,Not_a_Veteran__c,No_Email_Blasts__c,npe01__AlternateEmail__c,npe01__HomeEmail__c,npe01__PreferredPhone__c,npe01__Preferred_Email__c,npe01__WorkEmail__c,npe01__WorkPhone__c,npo02__Soft_Credit_Total__c,npo02__TotalOppAmount__c,npsp__Deceased__c,Number_of_Children__c,NVLSP_Consent_Given__c,OwnerId,Paperwork_Confirmation_Type__c,Paperwork_Confirmation__c,Paperwork_Issue__c,Paperwork_Received__c,Partnership_Contact__c,Phone,Political_Affiliation__c,Post_9_11_Veteran__c,Preferred_Public_Display_Name_Format__c,Press_Contact__c,Primary_IAVA_POC__c,Rank__c,Received_VA_Educational_Benefits__c,RecordTypeId,Salutation,Service_Type__c,Signup_Date__c,Snapshot_Number__c,Source_Details__c,Source__c,Spokesperson__c,Spreadsheet_ID__c,Staff__c,Submitted_Application__c,Submitted_DIA_Member_App__c,Submitted_Supporter_Form__c,Suffix__c,Survivor_of_vet__c,Tag__c,Temp_merge_field_1__c,Temp_merge_field_2__c,Test_Record__c,Text_Opt_In__c,Text_Opt_Out__c,Title,Twitter_ID__c,VA_Disability_Rating__c,VA_Disability__c,Veteran_Family_Member__c,Veteran_Member__c,Veteran_of_OEF__c,Veteran_of_OIF__c,Veteran_of_OND__c,Veteran_of_Other_Era__c,Volunteer__c,Voterbase_ID__c,Website__c,Willing_to_be_interviewed_photographed__c FROM Contact WHERE Id IN: contactIds])
            {
                csv += con.AccountId + ',' + con.Active_Duty_End_Date__c + ',' + con.Active_Duty_Start_Date__c + ',' + con.Allied_Service_Member__c + ',' + con.Approval_Related_Comments__c + ',' + con.Approved_Date__c + ',' + con.Bad_Email__c + ',' + con.Bad_Phone__c + ',' + con.Bad_Primary_Address__c + ',' + con.Bio__c + ',' + con.Birthdate + ',' + con.Branch_of_Service__c + ',' + con.Civilian_Contractor__c + ',' + con.Combat_Related_Disability__c + ',' + con.Company__c + ',' + con.Confidential_Email__c + ',' + con.Confidential_Phone__c + ',' + con.Confidential_Street_Address__c + ',' + con.Consider_Deleting_this_Record__c + ',' + con.COV_Date__c + ',' + con.COV_ID_External__c + ',' + con.COV_Link__c + ',' + con.Current_Status__c + ',' + con.DataMatch_Age__c + ',' + con.DataMatch_City__c + ',' + con.DataMatch_Conservative_Donor_Household__c + ',' + con.DataMatch_County__c + ',' + con.DataMatch_Date__c + ',' + con.DataMatch_Desription__c + ',' + con.DataMatch_Disc_Income_Formula__c + ',' + con.DataMatch_Est_Household_Income_Formula__c + ',' + con.DataMatch_Ethnicity__c + ',' + con.DataMatch_Gender__c + ',' + con.DataMatch_Liberal_Donor_Household__c + ',' + con.DataMatch_Personicx_Cluster_Code__c + ',' + con.DataMatch_Personicx_Lifestage_Code__c + ',' + con.DataMatch_State__c + ',' + con.DataMatch_Street_Address__c + ',' + con.DataMatch_Underbanked_Inidicator__c + ',' + con.DataMatch_Vet_in_Household__c + ',' + con.DataMatch_Zip_Code__c + ',' + con.DC_Contact__c + ',' + con.Deployment_End_Date__c + ',' + con.Deployment_Start_Date__c + ',' + con.Direct_Mail_OptOut__c + ',' + con.Discharge_Status__c + ',' + con.Documents_Date__c + ',' + con.Dupe_Check_Date__c + ',' + con.Email + ',' + con.Ethnicity__c + ',' + con.Expected_Date_of_Graduation__c + ',' + con.Facebook_ID__c + ',' + con.Fax + ',' + con.FirstName + ',' + con.First_Bounce_Date__c + ',' + con.Gender__c + ',' + con.General_Notes__c + ',' + con.google_ID__c + ',' + con.HasOptedOutOfEmail + ',' + con.Has_Private_Contact_Info__c + ',' + con.Highest_Level_of_Education__c + ',' + con.HomePhone + ',' + con.Home_Town__c + ',' + con.Id + ',' + con.Instagram_ID__c + ',' + con.Interested_in_further_Involvement__c + ',' + con.Interests__c + ',' + con.Interest_in_meeting_other_members__c + ',' + con.LastName + ',' + con.Last_School_Attended__c + ',' + con.Latest_Major_Minor__c + ',' + con.MailingCity + ',' + con.MailingCountry + ',' + con.MailingGeocodeAccuracy + ',' + con.MailingLatitude + ',' + con.MailingLongitude + ',' + con.MailingPostalCode + ',' + con.MailingState + ',' + con.MailingStreet + ',' + con.Marital_Status__c + ',' + con.Media_Trained__c + ',' + con.Medical_Retirement__c + ',' + con.Membership_ID__c + ',' + con.Middle_Name__c + ',' + con.MobilePhone + ',' + con.Most_Recent_In_Honor_Of__c + ',' + con.Most_Recent_Unit__c + ',' + con.MOS_Military_Job__c + ',' + con.Name + ',' + con.New_GI_Bill__c + ',' + con.NGIB_Graduation_Date__c + ',' + con.NGIB_School_Name__c + ',' + con.NGIB_School_Status__c + ',' + con.NGIB_School_Type__c + ',' + con.Notes_About_Spokesperson__c + ',' + con.Not_a_Veteran__c + ',' + con.No_Email_Blasts__c + ',' + con.npe01__AlternateEmail__c + ',' + con.npe01__HomeEmail__c + ',' + con.npe01__PreferredPhone__c + ',' + con.npe01__Preferred_Email__c + ',' + con.npe01__WorkEmail__c + ',' + con.npe01__WorkPhone__c + ',' + con.npo02__Soft_Credit_Total__c + ',' + con.npo02__TotalOppAmount__c + ',' + con.npsp__Deceased__c + ',' + con.Number_of_Children__c + ',' + con.NVLSP_Consent_Given__c + ',' + con.OwnerId + ',' + con.Paperwork_Confirmation_Type__c + ',' + con.Paperwork_Confirmation__c + ',' + con.Paperwork_Issue__c + ',' + con.Paperwork_Received__c + ',' + con.Partnership_Contact__c + ',' + con.Phone + ',' + con.Political_Affiliation__c + ',' + con.Post_9_11_Veteran__c + ',' + con.Preferred_Public_Display_Name_Format__c + ',' + con.Press_Contact__c + ',' + con.Primary_IAVA_POC__c + ',' + con.Rank__c + ',' + con.Received_VA_Educational_Benefits__c + ',' + con.RecordTypeId + ',' + con.Salutation + ',' + con.Service_Type__c + ',' + con.Signup_Date__c + ',' + con.Snapshot_Number__c + ',' + con.Source_Details__c + ',' + con.Source__c + ',' + con.Spokesperson__c + ',' + con.Spreadsheet_ID__c + ',' + con.Staff__c + ',' + con.Submitted_Application__c + ',' + con.Submitted_DIA_Member_App__c + ',' + con.Submitted_Supporter_Form__c + ',' + con.Suffix__c + ',' + con.Survivor_of_vet__c + ',' + con.Tag__c + ',' + con.Temp_merge_field_1__c + ',' + con.Temp_merge_field_2__c + ',' + con.Test_Record__c + ',' + con.Text_Opt_In__c + ',' + con.Text_Opt_Out__c + ',' + con.Title + ',' + con.Twitter_ID__c + ',' + con.VA_Disability_Rating__c + ',' + con.VA_Disability__c + ',' + con.Veteran_Family_Member__c + ',' + con.Veteran_Member__c + ',' + con.Veteran_of_OEF__c + ',' + con.Veteran_of_OIF__c + ',' + con.Veteran_of_OND__c + ',' + con.Veteran_of_Other_Era__c + ',' + con.Volunteer__c + ',' + con.Voterbase_ID__c + ',' + con.Website__c + ',' + con.Willing_to_be_interviewed_photographed__c + '\n';
                accountIds.add(con.AccountId);
            }
            
            // set the blob value before inserting the file
            b = blob.valueOf(csv);
            
            // insert the csv file (already checked to make sure there would be results)
            ContentVersion contactFile = new ContentVersion(title='contactsToImport.csv',versionData=b,pathOnClient='/contactsToImport.csv');
            insert contactFile;
        }
        
        // reset the csv string and the blob
        csv = null;
        b = null;
        
        // this block creates and inserts the account csv
        // set the csv header row
        csv = 'AccountNumber,BillingCity,BillingCountry,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,Conservative_Media__c,Data_cleanup_note__c,Description,Fax,Geo_Location__c,IAVA_Board_Member__c,Id,Industry,Link_to_Contact_Page__c,MA_Latitude__c,MA_Longitude__c,Multiple_D_Hist__c,Name,npe01__One2OneContact__c,npe01__SYSTEMIsIndividual__c,npe01__SYSTEM_AccountType__c,npo02__Best_Gift_Year_Total__c,npo02__LastCloseDate__c,npo02__LastOppAmount__c,npo02__NumberOfClosedOpps__c,npo02__TotalOppAmount__c,Organizational_Ally__c,OwnerId,Phone,POC__c,Press_Outlet_Type__c,Press_Outlet__c,Primary_KW_Contact__c,Prospecting_Status__c,Rating,RecordTypeId,ShippingCity,ShippingCountry,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,Source__c,TMC_Member__c,Type,Vendor__c,VIO__c,Website\n';
        // loop through query of accounts related to the previously queried records, add each to new row in csv file (build the csv)
        if(!accountIds.isEmpty())
        {
            for(Account acct: [SELECT AccountNumber,BillingCity,BillingCountry,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,Conservative_Media__c,Data_cleanup_note__c,Description,Fax,Geo_Location__c,IAVA_Board_Member__c,Id,Industry,Link_to_Contact_Page__c,MA_Latitude__c,MA_Longitude__c,Multiple_D_Hist__c,Name,npe01__One2OneContact__c,npe01__SYSTEMIsIndividual__c,npe01__SYSTEM_AccountType__c,npo02__Best_Gift_Year_Total__c,npo02__LastCloseDate__c,npo02__LastOppAmount__c,npo02__NumberOfClosedOpps__c,npo02__TotalOppAmount__c,Organizational_Ally__c,OwnerId,Phone,POC__c,Press_Outlet_Type__c,Press_Outlet__c,Primary_KW_Contact__c,Prospecting_Status__c,Rating,RecordTypeId,ShippingCity,ShippingCountry,ShippingGeocodeAccuracy,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,Source__c,TMC_Member__c,Type,Vendor__c,VIO__c,Website FROM Account WHERE Id IN: accountIds])
            {
                csv += acct.AccountNumber + ',' + acct.BillingCity + ',' + acct.BillingCountry + ',' + acct.BillingGeocodeAccuracy + ',' + acct.BillingLatitude + ',' + acct.BillingLongitude + ',' + acct.BillingPostalCode + ',' + acct.BillingState + ',' + acct.BillingStreet + ',' + acct.Conservative_Media__c + ',' + acct.Data_cleanup_note__c + ',' + acct.Description + ',' + acct.Fax + ',' + acct.Geo_Location__c + ',' + acct.IAVA_Board_Member__c + ',' + acct.Id + ',' + acct.Industry + ',' + acct.Link_to_Contact_Page__c + ',' + acct.MA_Latitude__c + ',' + acct.MA_Longitude__c + ',' + acct.Multiple_D_Hist__c + ',' + acct.Name + ',' + acct.npe01__One2OneContact__c + ',' + acct.npe01__SYSTEMIsIndividual__c + ',' + acct.npe01__SYSTEM_AccountType__c + ',' + acct.npo02__Best_Gift_Year_Total__c + ',' + acct.npo02__LastCloseDate__c + ',' + acct.npo02__LastOppAmount__c + ',' + acct.npo02__NumberOfClosedOpps__c + ',' + acct.npo02__TotalOppAmount__c + ',' + acct.Organizational_Ally__c + ',' + acct.OwnerId + ',' + acct.Phone + ',' + acct.POC__c + ',' + acct.Press_Outlet_Type__c + ',' + acct.Press_Outlet__c + ',' + acct.Primary_KW_Contact__c + ',' + acct.Prospecting_Status__c + ',' + acct.Rating + ',' + acct.RecordTypeId + ',' + acct.ShippingCity + ',' + acct.ShippingCountry + ',' + acct.ShippingGeocodeAccuracy + ',' + acct.ShippingLatitude + ',' + acct.ShippingLongitude + ',' + acct.ShippingPostalCode + ',' + acct.ShippingState + ',' + acct.ShippingStreet + ',' + acct.Source__c + ',' + acct.TMC_Member__c + ',' + acct.Type + ',' + acct.Vendor__c + ',' + acct.VIO__c + ',' + acct.Website + '\n';
            }
            
            // set the blob value before inserting the file
            b = blob.valueOf(csv);
            
            // insert the csv file (already checked to make sure there would be results)
            ContentVersion accountFile = new ContentVersion(title='accountsToImport.csv',versionData=b,pathOnClient='/accountsToImport.csv');
            insert accountFile;
        }
    }
}