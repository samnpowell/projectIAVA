public with sharing class dc_ctrl_template {

	public string gettitle() 
	{
		return StaticVar.title;	
		
	}
	
	public string getoldieversion()
	{
		String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
    	system.debug('userAgent::::::::::::::::::::::' + userAgent);
    	if(userAgent != null && userAgent.contains('MSIE 7'))
    		return 'true';
    	else if(userAgent != null && userAgent.contains('MSIE'))
    		return 'false';
    	else return 'none';    		
	}
	
	public string getMacos()
	{
		String user_Agent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
    	system.debug('userAgent::::::::::::::::::::::' + user_Agent);
    	if(user_Agent != null && user_Agent.contains('Mac'))
    		return 'true';
    	else return 'none';    		
	}

}