public with sharing class dc_CustomGive {

        public Id giveid {get; set;}
        public string title {get; set;}
        public string description {get; set;}
        public string available {get; set;}
        public string gwhen {get; set;}
        public string gwhere {get; set;}
        public string quantity {get; set;}
        public string deadline {get; set;}
        public string agelimit {get; set;}
        public string noofgiveinst {get; set;}
        public string logo {get; set;}
        public string partner {get; set;}
        public string defaultlogo {get; set;}
        public string givetype {get; set;}
        public string partnerid {get; set;}
        public string partnerlogo {get; set;}
        public string instanceId {get;set;}
        public string fulfillmentInstructions {get; set;}
        public string latitude {get; set;}
        public string longitude {get; set;}
        public string instDifferentiator {get; set;}
        
        public dc_customgive(){}
        public dc_customgive(id gId, string t, string descr, string avail, string gw, string gwher, string qty,string dline, string alimit,
          string noofgivein, string lo, string part, string dl, string gt, string p, string plogo, string fulfill, string lat, string lon)      
        {
            
            giveid = gId;
            title = t;
            description =  descr;
            available = avail;
            gwhen = gw;
            gwhere = gwher;
            quantity = qty;
            deadline = dline;
            agelimit =  alimit;
            noofgiveinst = noofgivein;
            logo = lo;
            partner = part;
            defaultlogo = dl;
            givetype = gt;
            partnerid  = p;
            partnerlogo = plogo;
            fulfillmentInstructions = fulfill;
            latitude = lat;
            longitude = lon;
            system.debug('gwhere here+++' + gwhere);
            system.debug('quantity here+++' +quantity );
            system.debug('deadline here+++' +deadline);
            system.debug('agelimit here+++' +agelimit +'-'+noofgivein);

        }

        public List<string> dc_createlist(Give__c give)     
        {
            List<string> listcg = new list<string>();
            
            string gwhen = ' ';
            string noofgiveinst = ' ';
            list<string> date_to = new list<string>();
            list<string> date_from = new list<string>();
            list<string> time_to = new list<string>();
            list<string> time_from = new list<string>();
            
            if(give.Give_Instances__r.size() > 1)
                {
                    //multigive = true;
                    gwhen = 'Multiple Dates & Times | ';
                    if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c != null && give.Give_Instances__r[0].date_from__c.contains(' ') && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.contains(' ') && give.Give_Instances__r[0].date_from__c.split(' ')[0] == give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.split(' ')[0]) 
                        gwhen = gwhen + give.Give_Instances__r[0].date_from__c.split(' ')[0] + ' ' + give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.split(' ')[1];
                    if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c != null && give.Give_Instances__r[0].date_from__c.contains(' ') && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.contains(' ') && give.Give_Instances__r[0].date_from__c.split(' ')[0] != give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.split(' ')[0]) 
                        gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ' - ' + give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c;
                    if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c == null)    
                        gwhen = gwhen + give.Give_Instances__r[0].date_from__c; 
                    if(give.Give_Instances__r[0].date_from__c == null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c != null)    
                        gwhen = gwhen + give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c;
                    noofgiveinst = 'true';
                    system.debug('noofgiveinst = true');
                }
                else
                {
                    gwhen = ' ';
                     if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c != null && give.Give_Instances__r[0].date_from__c.contains(' ') && give.Give_Instances__r[0].date_to__c.contains(' ') &&  give.Give_Instances__r[0].date_from__c.split(' ')[0] == give.Give_Instances__r[0].date_to__c.split(' ')[0] && give.Give_Instances__r[0].date_from__c != give.Give_Instances__r[0].date_to__c) 
                        gwhen = gwhen + give.Give_Instances__r[0].date_from__c + '-' + give.Give_Instances__r[0].date_to__c.split(' ')[1];

                     if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c != null && give.Give_Instances__r[0].date_from__c.contains(' ') && give.Give_Instances__r[0].date_to__c.contains(' ') &&  give.Give_Instances__r[0].date_from__c.split(' ')[0] != give.Give_Instances__r[0].date_to__c.split(' ')[0] && give.Give_Instances__r[0].date_from__c != give.Give_Instances__r[0].date_to__c) 
                        gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ' - ' + give.Give_Instances__r[0].date_to__c;
            
                    if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c != null && give.Give_Instances__r[0].date_from__c == give.Give_Instances__r[0].date_to__c) 
                        gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ', ' + give.Give_Instances__r[0].Year_Start_Date__c; 
                //  if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c != null && give.Give_Instances__r[0].date_from__c.split(' ')[0] != give.Give_Instances__r[0].date_to__c.split(' ')[0]) 
                //      gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ' - ' + give.Give_Instances__r[0].date_to__c + ', ' + give.Give_Instances__r[0].Year_Start_Date__c;
                    if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c == null)  
                        gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ', ' + give.Give_Instances__r[0].Year_Start_Date__c; 
                    if(give.Give_Instances__r[0].date_from__c == null && give.Give_Instances__r[0].date_to__c != null)  
                        gwhen = gwhen + give.Give_Instances__r[0].date_to__c  + ', ' + give.Give_Instances__r[0].Year_End_Date__c;
                    if(give.Give_Instances__r[0].start_time__c != null || give.Give_Instances__r[0].end_time__c != null)
                        gwhen = gwhen + ' - ';
                    if(give.Give_Instances__r[0].start_time__c != null) 
                        gwhen = gwhen + give.Give_Instances__r[0].start_time__c;
                    if(give.Give_Instances__r[0].start_time__c != null && give.Give_Instances__r[0].end_time__c != null)
                        gwhen = gwhen + ' - ';
                    if(give.Give_Instances__r[0].end_time__c != null    )
                        gwhen = gwhen + give.Give_Instances__r[0].end_time__c;
                        noofgiveinst = 'false';
                }
                
                string gwhere = ' ';
                if(give.Location_Description__c != null)
                    gwhere = give.Location_Description__c;
                else if(give.City__c != null)
                    gwhere = give.City__c;
                else if(give.Location_Formula__c == 'National')
                    gwhere = 'National';
                else if(give.Location_Description__c != null)
                    gwhere = give.Location_Description__c;
                else if(give.City__c != null && give.Location_by_State_s__c != null)
                    gwhere = give.City__c + ', ' + give.Location_by_State_s__c;
                else if(give.City__c != null && give.Location_by_State_s__c == null) 
                    gwhere = give.City__c + ', ' + give.Zip_Code_s__c;
                else if(give.City__c == null && give.Location_by_State_s__c != null)
                    gwhere = give.Location_by_State_s__c;
                else if(give.City__c == null && give.Location_by_State_s__c == null)
                    gwhere = give.Zip_Code_s__c;    
                else gwhere = give.Location_Formula__c;
                string quantity = ' ';
                // MD: commented out 6/10 
                /*
                if(give.Number_Remaining__c != null && give.Number_Remaining__c != 0)
                    quantity = give.Number_Remaining__c + ' total' ;
                if(give.Number_Remaining__c != null && give.Number_Remaining__c != 0 && give.Maximum_Units_per_Member__c != null && give.Maximum_Units_per_Member__c != 0)
                    quantity = quantity + '| ';     
                */              
                if(give.Maximum_Units_per_Member__c != null && give.Maximum_Units_per_Member__c != 0)   
                    quantity = give.Maximum_Units_per_Member__c.intValue() + ' per person';
                    // quantity = quantity + give.Maximum_Units_per_Member__c + ' per veteran';
                if(give.Maximum_Units_per_Member__c == null)
                    quantity = 'Unlimited';
                string deadline = ' ';
                if(give.Latest_Application_Deadline__c != null)
                deadline = give.Deadline__c;
                else deadline = 'N/A';
                
                string agelimit = ' ';
                if(give.Must_be_21__c == true)
                agelimit = 'Age 21+';
                          
                
                system.debug(give.name + '::::noofgiveinst::' + noofgiveinst);
                string logo = ' ';

                if(give.Attachments.size() > 0)
                {
                    //logo = '/servlet/servlet.FileDownload?file=' + give.Attachments[0].id;

                    List<String> imageIds = cov_utilities.parseImagesFromAttachments(give.Attachments);
                    if (!String.isEmpty(imageIds[0])) {
                        //hasPicFull = true;
                        //picFullId = imageIds[0];
                        logo = 'servlet/servlet.FileDownload?file=' + imageIds[0];
                    }
                    //} else {
                    //    hasPicFull = false;
                    //}
                    //if (!String.isEmpty(imageIds[1])) {
                    //    hasPicThumb = true;
                    //    picThumbId = imageIds[1];
                    //    picThumb = 'servlet/servlet.FileDownload?file=' + imageIds[1];
                    //} else {
                    //    hasPicThumb = false;
                    //}


                }
                
                string partner = ' ';
                partner = give.Partnership_Request__r.Public_Partner_Name__c;   
                string defaultlogo  = give.Category__c + '.jpg';    
                
                Attachment FP_at = new Attachment();
                string strFP = ' ';
                /**for(Partnership_Request__c FP:[Select Id, Public_Description__c,(select id From Attachments where Name like '%logo%' limit 1) from Partnership_Request__c where id = :give.Partnership_Request__c limit 1])
                                {
                                    
                                    if(FP.Attachments.size() > 0){
                                    for(integer i=0;i<FP.Attachments.size();i++)
                                    {   
                                        FP_at = FP.Attachments.get(i);
                                        system.debug('at::::::::::::::' + FP_at);
                                        system.debug('at::id::::::::::::' + FP_at.id);
                                        strFP = '/servlet/servlet.FileDownload?file=' + FP_at.id;
                                    }}
                                }**/
                string partnerid = ' ';
                partnerid = give.Partnership_Request__c;

                string latString = give.Latitude__c == null ? ' ' : String.valueof(give.Latitude__c);
                string lonString = give.Longitude__c == null ? ' ' : String.valueof(give.Longitude__c);


            if(give.name != null)
                listcg.add(give.name);
                    else listcg.add(' ');
            if(give.description__c != null)
                listcg.add(give.description__c);
                    else listcg.add(' ');
            if(give.available__c != null)
                listcg.add(give.available__c);
                    else listcg.add(' ');
            listcg.add(gwhen);
            listcg.add(gwhere);
            listcg.add(quantity);
            listcg.add(deadline);
            listcg.add(agelimit);
            listcg.add(noofgiveinst);
            listcg.add(logo);
            listcg.add(partner);
            listcg.add(defaultlogo);
            if(give.type__c != null)
                listcg.add(give.type__c);
                    else listcg.add(' ');
            listcg.add(partnerid);
            listcg.add(strFP);
            listcg.add(give.Fulfillment_Instructions_for_Winner__c);
            listcg.add(latString);
            listcg.add(lonString);
            return listcg;
        }   
        
        public List<string> dc_createinstlist(Give_Instance__c giveinst)        
        {
            List<string> listcgi = new list<string>();
            
            string inst_avail = ' ';
            string inst_when = ' ';
            string inst_differentiator = ' ';
            if(giveinst.Status__c == 'Closed'){
                inst_avail = 'Closed';
            } else if(giveinst.Status__c == 'Waitlist'){
                inst_avail = 'Waitlist';
            } else if(giveinst.Number_Remaining__c >= 25){
                inst_avail = '25+ Available';
            } else if(giveinst.Number_Remaining__c > 0){
                inst_avail = giveinst.Number_Remaining__c.intValue() +  ' Available';
            } else inst_avail = 'Closed';
            
            /*
            if(giveinst.Number_Remaining__c > 0)
                inst_avail = giveinst.Number_Remaining__c +  ' LEFT';
            else inst_avail = 'Closed';
            */
                    
            string gwhen = ' ';
            
             if(giveinst.date_from__c != null && giveinst.date_to__c != null &&  giveinst.date_from__c.contains(' ') && giveinst.date_to__c.contains(' ') && giveinst.date_from__c.split(' ')[0] == giveinst.date_to__c.split(' ')[0] && giveinst.date_from__c != giveinst.date_to__c) 
                gwhen = gwhen + giveinst.date_from__c + ' - ' + giveinst.date_to__c  + ', ' + giveinst.Year_Start_Date__c;
            
             if(giveinst.date_from__c != null && giveinst.date_to__c != null &&  giveinst.date_from__c == giveinst.date_to__c) 
                gwhen = gwhen + giveinst.date_from__c + ', ' + giveinst.Year_Start_Date__c; 
            
            
            system.debug('gwhen........2....................................' + gwhen);
            //else if(giveinst.date_from__c != null && giveinst.date_to__c != null && giveinst.date_from__c.split(',')[0] != giveinst.date_to__c.split(',')[0]) 
            //  gwhen = gwhen + giveinst.date_from__c + ' - ' + giveinst.date_to__c;
            
            system.debug('gwhen.........3...................................' + gwhen);
            if(giveinst.date_from__c != null && giveinst.date_to__c == null)    
                gwhen = gwhen + giveinst.date_from__c  + ', ' + giveinst.Year_Start_Date__c; 
            
            system.debug('gwhen.........4...................................' + gwhen);
            if(giveinst.date_from__c == null && giveinst.date_to__c != null)    
                gwhen = gwhen + giveinst.date_to__c + ', ' + giveinst.Year_End_Date__c;
            
            system.debug('gwhen............5................................' + gwhen);
            if((giveinst.date_from__c != null && giveinst.date_to__c != null && giveinst.date_from__c == giveinst.date_to__c) || giveinst.date_to__c == null || giveinst.date_from__c == null)
            {
                if(giveinst.start_time__c != null || giveinst.end_time__c != null)
                    gwhen = gwhen + ' | ';
            
                system.debug('gwhen............6................................' + gwhen);
                if(giveinst.start_time__c != null) 
                    gwhen = gwhen + giveinst.start_time__c;
            
                system.debug('gwhen..............7..............................' + gwhen);
                if(giveinst.end_time__c != null)
                    gwhen = gwhen + '-';
            
                system.debug('gwhen...............8.............................' + gwhen);
                if(giveinst.end_time__c != null )
                    gwhen = gwhen + giveinst.end_time__c;   
           
                system.debug('gwhen................9............................' + gwhen);
            }

            inst_differentiator = giveinst.Differentiator__c == null ? ' ' : giveinst.Differentiator__c;


            listcgi.add(' ');//title
            listcgi.add(' ');//desc
            listcgi.add(inst_avail);//avail
            listcgi.add(gwhen);//when
            listcgi.add(' ');//where
            listcgi.add(' '); //qty
            listcgi.add(' ');//deadline
            listcgi.add(' ');//agelimit
            listcgi.add(' ');//noofgiveinst
            listcgi.add(' ');//logo
            listcgi.add(' ');//partner
            listcgi.add(' ');//default logo
            listcgi.add(' ');//give type
            listcgi.add(' ');//partner id
            listcgi.add(' ');//partner logo
            listcgi.add(giveinst.id); // instance id
            listcgi.add(inst_differentiator); // instance differentiator
            return listcgi;
        }
    }