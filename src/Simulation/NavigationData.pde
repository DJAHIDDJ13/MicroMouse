import java.io.ByteArrayOutputStream;

/* MESSAGE TYPE : TX */
public class NavigationData extends Message {
    float[] navData;

    public NavigationData() {
        this.flag = CommunicationUtility.NAVIGATION_FLAG;
        this.content = new byte[CommunicationUtility.NAVIGATION_CONTENT_SIZE];
    }

    public NavigationData (float[] navData) {
        this.flag = CommunicationUtility.NAVIGATION_FLAG;
        if (navData.length != 1) {
            CommunicationUtility.logMessage("WARNING", "NavigationData", 
                                            "Constructor", "Array sizes not matching.");  
        } else {
            this.navData = navData;
        }
    }

    public void setNavData(float[] navData) {
        if (navData.length != 1)
            CommunicationUtility.logMessage("WARNING", "NavigationData", "setnavData", 
                                            "navData array size not matching : is " 
                                            + navData.length + " - should be 1.");
        else
            this.navData = navData;
    }

    public void setContent() {
        if (navData == null || navData.length != 1) {

                CommunicationUtility.logMessage("ERROR", "NavigationData", "setContent", 
                                                "Cannot format message content because data are incomplete.");
        } else {
            this.content = CommunicationUtility.packFloatArray(navData);
        }
    }

    public String dumpContent() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("INFO", "NavigationData", "dumpContent", "Content is empty");
            return "";
        } else {
            String strContent = "";

            float[] arr = CommunicationUtility.extractByteArray(content);
            for(float f: arr) {
               strContent += f + " ";
            }
            return strContent;
        }
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

    public void setContent(String strContent) {

    }
}
