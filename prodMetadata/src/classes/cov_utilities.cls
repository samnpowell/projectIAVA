public with sharing class cov_utilities {


	public static List<String> parseImagesFromAttachments(List<Attachment> atts) {
		return parseImagesFromAttachments(atts, 'image-full', 'image-thumb');
	}

	public static List<String> parseImagesFromAttachments(List<Attachment> atts, String fullsizeImageSearchTerm, String thumbnailImageSearchTerm) {
		// returns List of strings with full size image ID followed by thumbnail image ID
		// if not present will return blank string

		Boolean hasPicThumb = false;
		Boolean hasPicFull = false;
		String picFullId = '';
		String picThumbId = '';

		Integer numImages = atts.size();
		if(numImages > 0) {

			String backupImage;
			Id backupImageId;
			//Attachment backupImageFile;
			
			Integer i = 0;
			while (i < numImages && (!hasPicThumb || !hasPicFull)) {
				String attachmentName = atts[i].Name;
				//system.debug('attachmentName: ' + attachmentName);
				if (attachmentName.contains(thumbnailImageSearchTerm) && !hasPicThumb) {
					hasPicThumb = true;
					//picThumb = 'servlet/servlet.FileDownload?file=' + atts[i].Id;
					picThumbId = atts[i].Id;
				} else if (attachmentName.contains(fullsizeImageSearchTerm) && !hasPicFull) {
					hasPicFull = true;
					//picFull = 'servlet/servlet.FileDownload?file=' + atts[i].Id;
					picFullId = atts[i].Id;
					//imageFile = atts[i];
					//imageAttachmentIndex = i;
				} else if (!hasPicFull && (attachmentName.right(4) == '.jpg' || attachmentName.right(4) == '.gif' || attachmentName.right(4) == '.png')) {
					//system.debug('appears to be an image file ending with: ' + attachmentName.right(4));
					//backupImage = 'servlet/servlet.FileDownload?file=' + atts[i].Id;
					backupImageId = atts[i].Id;
					//backupImageFile = atts[i];
				}
				i++;

			} 
			if (!hasPicFull && !String.isEmpty(backupImageId)) {
				//picFull = backupImage;
				picFullId = backupImageId;
				//imageFile = backupImageFile;
				hasPicFull = true;
			}

			if (hasPicFull && !hasPicThumb) {
				//picThumb = picFull;
				picThumbId = picFullId;
				hasPicThumb = true;
			}
			
		}
		return new List<String>{picFullId, picThumbId};
	}

public static Boolean validateEmail(String email) {

	if (email == null) {
		return false;
	}

	// https://developer.salesforce.com/forums/ForumsMain?id=906F000000092GXIAY
    Boolean res = true;

    String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank">http://www.regular-expressions.info/email.html</a>
    Pattern MyPattern = Pattern.compile(emailRegex);
    Matcher MyMatcher = MyPattern.matcher(email);

    if (!MyMatcher.matches())
        res = false;
    return res;
}


// These date methods may not be needed anymore.  
    // Were used when sending strings to VF instead of objects.
    public static String niceDateSlashes(Date d) {
        String returnVal;
        Datetime dt = Datetime.newinstance(d.year(), d.month(), d.day(),0,0,0);
        if (d.year() == Date.Today().year()) {
            returnVal = dt.format('M/d');
        } else {
            returnVal = dt.format('M/d/yyyy');
        }
        return returnVal;
    }
    //public static String niceDateWords(Date d) {
    //    String returnVal;
    //    Datetime dt = Datetime.newinstance(d.year(), d.month(), d.day(),0,0,0);
    //    if (d.year() == Date.Today().year()) {
    //        returnVal = dt.format('MMM dd');
    //    } else {
    //        returnVal = dt.format('MMM dd, yyyy');
    //    }
    //    return returnVal;
    //}

    public static List<User> sortUsersWithPhotosFirst(List<User> userListIn) {
    	List<User> earlierList = new List<User>();
    	List<User> laterList = new List<User>();
    	for (User uIn : userListIn) {
    		if (uIn != null && uIn.SmallPhotoURL != null && uIn.SmallPhotoURL.right(5) == '005/T') {
    			laterList.add(uIn);
    		} else {
    			earlierList.add(uIn);
    		}
    	}
    	earlierList.addAll(laterList);
    	return earlierList;
    }

    public static PageReference addAllCurrentParameters(PageReference pr) {
        Map<String, String> params = apexpages.currentpage().getparameters();
        for (String p : params.keySet()) {
            if (p != 'id') {
                pr.getParameters().put(p, params.get(p));
            }
        }
        return pr;
    }

    // https://developer.salesforce.com/blogs/developer-relations/2013/07/selecting-random-numbers-and-records-on-the-force-com-platform-part-1.html
	public static Integer generateRandomIntegerUpTo(Integer upperLimit){
	    Integer rand = Math.round(Math.random()*1000);
	    return Math.mod(rand, upperLimit);
	}

	public static User getBackgroundAdminUser() {
		User badminton = (User)(cov_nosharing_utilities.runSingleQuery('select Id from User where isActive = true and FirstName = \'Background Admin\' and LastName = \'Robot\''));
		if (badminton == null) {
			badminton = (User)(cov_nosharing_utilities.runSingleQuery('select Id from User where isActive = true and User.Profile.Name = \'System Administrator\''));
		}
		return badminton;
	}

	public static Id getBackgroundAdminUserId() {
		User badminton = getBackgroundAdminUser();
		return badminton == null ? null : badminton.Id;
	}



}