@isTest
private class dc_Rucksack_bizlogic_Tests {

 static testMethod void FCFS_tests() {
            
            
            Partnership_Request__c p1 = new Partnership_Request__c (Name = 'p1', Public_Partner_Name__c = 'p1');
            insert p1;
            
            Give__c g1 = new Give__c(
                  Name='g1',
                  Partnership_Request__c = p1.id,
                  Type__c = 'First Come First Served',
                  Waitlist__c = 'Waitlist',
                  Status__c = 'Open',
                  Maximum_Units_per_Member__c = 2,
                  National_Give__c = true             
            );
            insert g1;
            
            Give_Instance__c i1 = new Give_Instance__c(
                  Give__c = g1.id,
                  Number_of_Units__c = 2
            );
            insert i1;
            
            Contact c1 = new Contact(LastName='c1');
            Contact c2 = new Contact(LastName='c2');
            Contact c3 = new Contact(LastName='c3');
            Contact c4 = new Contact(LastName='c4');
            Contact c5 = new Contact(LastName='c5');
            Contact c6 = new Contact(LastName='c6');
            insert new List<Contact>{c1, c2, c3, c4, c5, c6};
 

            
            Give_Request__c r1 = new Give_Request__c(
                  Applicant__c = c1.id,
                  Give_Instance__c = i1.id,
                  Units_Requested__c = 2,
                  Email_Address__c = 'samdorman+rucksackunittest@gmail.com',
                  Primary_Phone__c = '555-555-5123',
                  Address__c = '12345 Street St',
                  City__c = 'New York',
                  State__c = 'NY',
                  Zip_Code__c = '10001'
            );
            insert r1;
            
            // Test that a first-come request for a give with space will go to Tentative Conf status
            System.assertEquals('Tentative confirmation',[select Stage__c from Give_Request__c where Applicant__c=:c1.id].Stage__c);
            
            
            
            Give_Request__c r2 = new Give_Request__c(
                  Applicant__c = c2.id,
                  Give_Instance__c = i1.id,
                  Units_Requested__c = 2,
                  Email_Address__c = 'samdorman+rucksackunittest@gmail.com',
                  Primary_Phone__c = '555-555-5123',
                  Address__c = '12345 Street St',
                  City__c = 'New York',
                  State__c = 'NY',
                  Zip_Code__c = '10001'
            );
            insert r2;
            
            // Test that a first-come request for a give with waitlist and no space will go to Wait-list status
            System.assertEquals('Wait-list',[select Stage__c from Give_Request__c where Applicant__c=:c2.id].Stage__c);
            
            
            g1.Type__c = 'Screened Give';
            update g1;
            
            
            Give_Request__c r3 = new Give_Request__c(
                  Applicant__c = c3.id,
                  Give_Instance__c = i1.id,
                  Units_Requested__c = 2,
                  Email_Address__c = 'samdorman+rucksackunittest@gmail.com',
                  Primary_Phone__c = '555-555-5123',
                  Address__c = '12345 Street St',
                  City__c = 'New York',
                  State__c = 'NY',
                  Zip_Code__c = '10001'
            );
            insert r3;
            
            // Test that a premium reward request for a give will stay in Give Requested status
            System.assertEquals('Give requested',[select Stage__c from Give_Request__c where Applicant__c=:c3.id].Stage__c);
            
            
            i1.Number_of_Units__c = null;
            update i1;
            
            
            Give_Request__c r4 = new Give_Request__c(
                  Applicant__c = c4.id,
                  Give_Instance__c = i1.id,
                  Units_Requested__c = 2,
                  Email_Address__c = 'samdorman+rucksackunittest@gmail.com',
                  Primary_Phone__c = '555-555-5123',
                  Address__c = '12345 Street St',
                  City__c = 'New York',
                  State__c = 'NY',
                  Zip_Code__c = '10001'
            );
            insert r4;
            
            // Test that a give request is still created even if the Give Instance doesn't have a number of units specified.
            System.assertEquals('Give requested',[select Stage__c from Give_Request__c where Applicant__c=:c4.id].Stage__c);
            
            g1.Type__c = 'Unlimited Give';
            update g1;
            
            
            Give_Request__c r5 = new Give_Request__c(
                  Applicant__c = c5.id,
                  Give_Instance__c = i1.id,
                  Units_Requested__c = 2,
                  Email_Address__c = 'samdorman+rucksackunittest@gmail.com',
                  Primary_Phone__c = '555-555-5123',
                  Address__c = '12345 Street St',
                  City__c = 'New York',
                  State__c = 'NY',
                  Zip_Code__c = '10001'
            );
            insert r5;
            
            // Test that a unlimited reward request for a give will go to Final confirmation status
            System.assertEquals('Final confirmation',[select Stage__c from Give_Request__c where Applicant__c=:c5.id].Stage__c);


            g1.Type__c = 'Information';
            g1.Fulfillment_Instructions_rtf__c = 'Instructions';
            update g1;
            
            
            Give_Request__c r6 = new Give_Request__c(
                  Applicant__c = c6.id,
                  Give_Instance__c = i1.id,
                  Units_Requested__c = 2,
                  Email_Address__c = 'samdorman+rucksackunittest@gmail.com',
                  Primary_Phone__c = '555-555-5123',
                  Address__c = '12345 Street St',
                  City__c = 'New York',
                  State__c = 'NY',
                  Zip_Code__c = '10001'
            );
            insert r6;
            
            // Test that a information reward request for a give will go to Information sent status
            System.assertEquals('Information sent',[select Stage__c from Give_Request__c where Applicant__c=:c6.id].Stage__c);

            
            
    }
}