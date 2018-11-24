public class cov_attachmentpuller {
 
	public string giveId {get; set;}
	public string attid {set;}
	public string maxwidth {get; set;}
	public string maxheight {get; set;}

	public String getAttId() {

		List<Attachment> atts = [Select id From Attachment Where Parentid=:giveId and (Name like '%logo%' or Name like '%image%')];

		system.debug('atts: ' + atts);

		return atts.size() > 0 ? atts[0].Id : null;

	}


}