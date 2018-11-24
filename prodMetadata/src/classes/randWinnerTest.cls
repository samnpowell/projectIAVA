public class randWinnerTest
{
    // use this class to test the anonymous apex code to generate a list of random winners for the cic forum give
    
    // IN PROGRESS: create visualforce page - random winner (https://cs7.salesforce.com/apex/randomWinner)
    // TO-DO: create method to find number of give registrants or event attendees
    // TO-DO: create method to print give winner(s) to screen
    // TO-DO: create method to print event winner(s) to screen
    // TO-DO: create method to save csv containing give winner(s) to files
    // TO-DO: create method to save csv containing give winner(s) to files
    
    public Boolean isEvent {get; set;} // conditionally require this or isGive, only allow one to be completed
    public Boolean isGive {get; set;} // conditionally require this or isEvent, only allow one to be completed
    public String name {get; set;} // the name of the event or give
    public Integer numWins {get; set;} // integer to hold the number of winners
    public Boolean onScreen {get; set;} // conditionally require this or inCsv, only allow one to be completed
    public Boolean inCsv {get; set;} // conditionally require this or onScreen, only allow one to be completed
    public String winner {get; set;} // think this needs to go here so I can get to it from both pages...we'll see what happens
    public ContentVersion winCSV {get; set;} // see if this works...
    public List<IAVAEvent_Attendee__c> eWinList {get; set;} // see what happens...
    public List<Give_Request__c> gWinList {get; set;} // see what happens...
    public Integer winSiz {get; set;} // think this needs to go here so I can get to it from both pages
    public String ident {get; set;} // pass the type to the page so it knows which table to render
    //public Id campId {get; set;} // the id of the campaign if the winners are to be added to a csv file - for now, just add same info that prints on screen to csv
    
    public PageReference getWinner()
    {
        boolean isError = false;
        
        if(isEvent && isGive)
        {
            ApexPages.Message bothTypes = new ApexPages.Message(ApexPages.Severity.ERROR,'Both Event and Give cannot be selected, select one or the other and resubmit.');
            ApexPages.addMessage(bothTypes);
            isError = true;
        } // throw an error if someone picked both Event and Give on the form
        else if(!isEvent && !isGive)
        {
            ApexPages.Message neitherType = new ApexPages.Message(ApexPages.Severity.ERROR,'You must select either Event or Give in order to select a random winner.');
            ApexPages.addMessage(neitherType);
            isError = true;
        } // throw an error if someone picked neither Event nor Give on the form
        
        if(numWins == 0)
        {
            ApexPages.Message noWinners = new ApexPages.Message(ApexPages.Severity.ERROR,'You must enter a number greater than zero.');
            ApexPages.addMessage(noWinners);
            isError = true;
        } // throw an error if someone entered 0 as the number of winners
          // the number of winners field is required so don't need to check for null
          
        if(onScreen && inCsv)
        {
            ApexPages.Message bothResults = new ApexPages.Message(ApexPages.Severity.ERROR,'Both on screen and in csv file cannot be selected, select one or the other and resubmit.');
            ApexPages.addMessage(bothResults);
            isError = true;
        } // throw an error if someone picked both on screen and in csv file on the form
          // the code was written to handle one or the other, but not both in an attempt to prevent excessive file storage in salesforce
        else if(!onScreen && !inCsv)
        {
            ApexPages.Message neitherResult = new ApexPages.Message(ApexPages.Severity.ERROR,'You must select to view the results either on screen or in a csv file in order to select a random winner.');
            ApexPages.addMessage(neitherResult);
            isError = true;
        } // throw an error if someone picked neither on screen nor in csv file on the form
        // name is a required field - don't need to check for that, this code will throw an error if no matching Give or Event is found
        
        if(isError)
        {
            return null;
        }
        
        if(isEvent && !isGive && (!onScreen && inCsv) && numWins > 0)
        {
            system.debug('about to get number of attendees for ' + name);
            Integer numAtt = getNumAttendees(); // call the class that find the number of event attendees (who attended the event)
            winCSV = eventWinnerCSV(numAtt); // call the class that compiles the csv of winners, pass through number of attendees
            ident = 'Event - in CSV';
            system.debug('the csv file was created ' + winCSV);
        }
        else if(isEvent && !isGive && (onScreen && !inCsv) && numWins > 0)
        {
            system.debug('about to get number of attendees for ' + name);
            Integer numAtt = getNumAttendees(); // find the number of event attendees who showed up
            eWinList = eventWinnerSCN(numAtt); // call the class that compiles the list of winners, pass through number of attendees
            winSiz = eWinList.size();
            ident = 'Event - On Screen';
        }
        else if(isGive && !isEvent && (!onScreen && inCsv) && numWins > 0)
        {
            system.debug('about to get number of requestors for ' + name);
            Integer numReq = getNumRequestors();
            winCSV = giveWinnerCSV(numReq);
            ident = 'Give - in CSV';
        }
        else if(isGive && !isEvent && (onScreen && !inCsv) && numWins > 0)
        {
            system.debug('about to get number of requestors for ' + name);
            Integer numReq = getNumRequestors(); // find the number of give requesters
            gWinList = giveWinnerSCN(numReq); // call the class that compiles the list of winners, pass through number of requesters
            winSiz = gWinList.size();
            ident = 'Give - On Screen';
        }
        
        PageReference pageRef = new PageReference('/apex/theWinnerIs');
        pageRef.setRedirect(false);
        return pageRef;
    }
    
    public Integer getNumAttendees()
    {
        // find the number of event attendees based on event name
        String qSafeName = name.escapeJava(); // java escaped name so soql will work
        system.debug('my query is SELECT count() FROM IAVAEvent_Attendee__c WHERE Event_Name__c = \'' + qSafeName + '\' AND Attended__c = \'Yes\'');
        Integer eAtt = database.countQuery('SELECT count() FROM IAVAEvent_Attendee__c WHERE Event_Name__c = \'' + qSafeName + '\' AND Attended__c = \'Yes\'');
        return eAtt;
    }
    
    public Integer getNumRequestors()
    {
        // find the number of give requestors based on give name
        String qSafeName = name.escapeJava(); // java escaped name so soql will work
        system.debug('my query is SELECT count() FROM Give_Request__c WHERE Give_Name__c = \'' + qSafeName + '\'');
        Integer gReq = database.countQuery('SELECT count() FROM Give_Request__c WHERE Give_Name__c = \'' + qSafeName + '\'');
        return gReq;
    }
    
    public ContentVersion eventWinnerCSV(Integer lim)
    {
        Integer rand; // this will hold the random integer
        set<Integer> randSet = new set<Integer>(); // create a set to hold the random integers
        String event = name.escapeJava(); // java escaped name so soql will work
        Integer count = 0; // the counter for the while loop
        String csv = 'Id,Name,Email,Phone\n'; // create the first line of the csv file, place to store the winner(s)
        
        system.debug('we should select ' + numWins + ' winners from the ' + lim + ' event attendees');
        while(count<numWins)
        {
            rand = generateRandomNum(lim);
            system.debug('the random number is: ' + rand);
            
            if(!randSet.contains(rand))
            {
                for(IAVAEvent_Attendee__c eAtt: [SELECT Contact__c, Contact__r.Name, Contact__r.Email, Contact__r.MobilePhone FROM IAVAEvent_Attendee__c WHERE Event_Name__c =: event LIMIT 1 OFFSET :rand])
                {
                    csv += eAtt.Contact__c + ',' + eAtt.Contact__r.Name + ',' + eAtt.Contact__r.Email + ',' + eAtt.Contact__r.MobilePhone + '\n';
                }
                randSet.add(rand);
            }
            count = randSet.size();
            system.debug('the count is now ' + count);
            system.debug('the randset contains ' + randset);
        }
        
        ContentVersion eFile = new ContentVersion(title = name+'Winners.csv',versionData = Blob.valueOf(csv),pathOnClient = '/'+name+'Winners.csv');
        insert eFile;
        return eFile;
    }
    
    public List<IAVAEvent_Attendee__c> eventWinnerSCN(Integer lim)
    {
        Integer rand; // this will hold the random integer
        set<Integer> randSet = new set<Integer>(); // create a set to hold the random integers
        String event = name.escapeJava(); // java escaped name so soql will work
        Integer count = 0; // the counter for the while loop
        List<IAVAEvent_Attendee__c> eWins = new List<IAVAEvent_Attendee__c>();
        
        system.debug('we should select ' + numWins + ' winners from the ' + lim + ' event attendees');
        while(count<numWins)
        {
            rand = generateRandomNum(lim);
            system.debug('the random number is: ' + rand);
            
            if(!randSet.contains(rand))
            {
                for(IAVAEvent_Attendee__c eAtt: [SELECT Contact__c, Contact__r.Name, Contact__r.Email, Contact__r.MobilePhone FROM IAVAEvent_Attendee__c WHERE Event_Name__c =: event LIMIT 1 OFFSET :rand])
                {
                    eWins.add(eAtt);
                }
                randSet.add(rand);
            }
            count = randSet.size();
            system.debug('the count is now ' + count);
            system.debug('the randset contains ' + randset);
        }
        return eWins;
    }
    
    public ContentVersion giveWinnerCSV(Integer lim)
    {
        Integer rand; // this will hold the random integer
        set<Integer> randSet = new set<Integer>(); // create a set to hold the random integers
        String give = name.escapeJava(); // java escaped name so soql will work
        Integer count = 0; // the counter for the while loop
        String csv = 'Id,Name,Email,Phone\n'; // create the first line of the csv file, place to store the winner(s)
        
        system.debug('we should select ' + numWins + ' winners from the ' + lim + ' give requestors');
        while(count<numWins)
        {
            rand = generateRandomNum(lim);
            
            if(!randSet.contains(rand))
            {
                for(Give_Request__c req: [SELECT Applicant__c, Applicant__r.Name, Applicant__r.Email, Applicant__r.MobilePhone FROM Give_Request__c WHERE Give_Name__c =: give LIMIT 1 OFFSET :rand])
                {
                    csv += req.Applicant__c + ',' + req.Applicant__r.Name + ',' + req.Applicant__r.Email + ',' + req.Applicant__r.MobilePhone + '\n';
                }
                randSet.add(rand);
            }
            count = randSet.size();
        }
        
        ContentVersion eFile = new ContentVersion(title = name+'Winners.csv',versionData = Blob.valueOf(csv),pathOnClient = '/'+name+'Winners.csv');
        insert eFile;
        return eFile;
    }
    
    public List<Give_Request__c> giveWinnerSCN(Integer lim)
    {
        Integer rand; // this will hold the random integer
        set<Integer> randSet = new set<Integer>(); // create a set to hold the random integers
        String give = name.escapeJava(); // java escaped name so soql will work
        Integer count = 0; // the counter for the while loop
        List<Give_Request__c> gWins = new List<Give_Request__c>();
        
        system.debug('we should select ' + numWins + ' winners from the ' + lim + ' give requesters');
        while(count<numWins)
        {
            rand = generateRandomNum(lim);
            system.debug('the random number is: ' + rand);
            
            if(!randSet.contains(rand))
            {
                for(Give_Request__c req: [SELECT Applicant__c, Applicant__r.Name, Applicant__r.Email, Applicant__r.MobilePhone FROM Give_Request__c WHERE Give_Name__c =: give LIMIT 1 OFFSET :rand])
                {
                    gWins.add(req);
                }
                randSet.add(rand);
            }
            count = randSet.size();
            system.debug('the count is now ' + count);
            system.debug('the randset contains ' + randset);
        }
        return gWins;
    }
    
    public Integer generateRandomNum(Integer size)
    {
        // use the number of event attendees or give requestors to generate a random number that falls within the range of potential winners
        Double dub = math.random()*size;
        Integer randNum = dub.intValue();
        return randNum;
    }
    
    /*
    string csv = 'ContactId,CampaignId\n';
    applicant__c, applicant__r.name, applicant__r.email, applicant__r.mobilephone
    contact__c, contact__r.name, contact__r.email, contact__r.mobilephone
    Id campId = '701C0000001Lo4w';
    
    List<Give_Request__c> greqs = [SELECT Applicant__c FROM Give_Request__c WHERE Give_Name__c = 'Attend IAVA\'s Commander-in-Chief Forum in NYC'];
    
    set<integer> randSet = new set<integer>();
    double dub;
    integer rand;
    integer reqs = greqs.size();
    
    integer count = 0;
    
    public void randomWinner()
    {
        while(count<100)
        {
            dub = math.random()*reqs;
            rand = dub.intValue();
            
            if(!randSet.contains(rand))
            {
                for(Give_Request__c req: [SELECT Applicant__c FROM Give_Request__c WHERE Give_Name__c = 'Attend IAVA\'s Commander-in-Chief Forum in NYC' LIMIT 1 OFFSET :rand])
                {
                    csv += req.Applicant__c + ',' + campId + '\n';
                }
                randSet.add(rand);
            }
            count = randSet.size();
        }
        
        ContentVersion file = new ContentVersion(title = 'giveWinners.csv',versionData = Blob.valueOf(csv),pathOnClient = '/giveWinners.csv');
        
        insert file;
        system.debug(file);
    }
    */
    
    // TO-DO: modify this so it accepts parameters and can be run for any give
    // TO-DO: add to this so it can also be used for events
    
    /*
    string csv = 'ContactId,CampaignId\n'; // to be added to new campaign so Pike can pull more info about the winners
    Id campId = '701C0000001Lo4w';
    
    set<integer> randSet = new set<integer>();
    double dub;
    integer rand;
    integer reqs = 1686; // use workbench to find the number of people who requested this give
    integer count = 0;
    
    while(count<100)
    {
      dub = math.random()*reqs;
      rand = dub.intValue();
      if(!randSet.contains(rand))
      {
          for(Give_Request__c req: [SELECT Applicant__c FROM Give_Request__c WHERE Give_Name__c = 'Attend IAVA\'s Commander-in-Chief Forum in NYC' LIMIT 1 OFFSET :rand])
          {
              csv += req.Applicant__c + ',' + campId + '\n';
          }
          randSet.add(rand);
      }
      count = randSet.size();
    }
      
    ContentVersion file = new ContentVersion(title = 'giveWinners.csv',versionData = Blob.valueOf(csv),pathOnClient = '/giveWinners.csv');
    
    insert file;
    system.debug(file);
    */
}