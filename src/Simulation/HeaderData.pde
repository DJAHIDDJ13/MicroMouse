/* MESSAGE TYPE : TX */
public class HeaderData extends Message {
    int[] mazeData;
    int[] initialPosData;
    int[] targetPosData;

    public HeaderData() {
        this.flag = CommunicationUtility.HEADER_FLAG;
        this.content = new byte[CommunicationUtility.HEADER_CONTENT_SIZE];
    }

    public HeaderData (int[] mazeData, int[] initialPosData, int[] targetPosData) {
        this.flag = CommunicationUtility.HEADER_FLAG;
        if (mazeData.length != 2 || initialPosData.length != 3 || targetPosData.length != 2) {
            CommunicationUtility.logMessage("WARNING", "HeaderData", "Constructor", "Array sizes not matching.");  
        } else {
            this.mazeData = mazeData;
            this.initialPosData = initialPosData;
            this.targetPosData = targetPosData;
        }
    }

    public void setMazeData(int[] mazeData) {
        if (mazeData.length != 2)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "setMazeData", "mazeData array size not matching : is " + mazeData.length + " - should be 2.");
        else
            this.mazeData = mazeData;
    }

    public void setInitialPosData(int[] initialPosData) {
        if (initialPosData.length != 3)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "setInitialPosData", "initialPosData array size not matching : is " + initialPosData.length + " - should be 3.");
        else
            this.initialPosData = initialPosData;
    }

    public void setTargetPosData(int[] targetPosData) {
        if (targetPosData.length != 2)
            CommunicationUtility.logMessage("WARNING", "HeaderData", "targetPosData", "targetPosData array size not matching : is " + targetPosData.length + " - should be 2.");
        else
            this.targetPosData = targetPosData;
    }

    public void setContent() {
        if (mazeData == null || mazeData.length == 0 ||
            initialPosData == null || initialPosData.length == 0 ||
            targetPosData == null || targetPosData.length == 0) {
                CommunicationUtility.logMessage("ERROR", "HeaderData", "setContent", "Cannot format message content because data are incomplete.");
        } else {
            byte intToByte = 0;
            int cursor = 0;

            /* MAZE DIMENSION */
            for (int value : this.mazeData) {
                for (int i = 0; i < 2; i++) {
                    this.content[cursor] = (byte) ((value >> i*8) & 0xFF);
                    cursor++;
                }
            }

            /* INITIAL POSITION INFORMATION */
            for (int value : this.initialPosData) {
                for (int i = 0; i < 2; i++) {
                    this.content[cursor] = (byte) ((value >> i*8) & 0xFF);
                    cursor++;
                }
            }

            /* TARGET POSITION INFORMATION */
            for (int value : this.targetPosData) {
                for (int i = 0; i < 2; i++) {
                    this.content[cursor] = (byte) ((value >> i*8) & 0xFF);
                    cursor++;
                }
            }
        }
    }

    public String dumpContent() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("INFO", "HeaderData", "dumpContent", "Content is empty");
            return "";
        } else {
            String strContent = "";
            int intVal = 0;
            int cursor = 0;
            for (byte value : this.content) {
                if (cursor == 0) {
                    intVal = ((value & 0xff) << cursor*8);
                    cursor++;
                } else if (cursor < 2) {
                    intVal |= ((value & 0xff) << cursor*8);
                    cursor++;
                } 
                
                if (cursor == 2) {
                    strContent += intVal + " ";
                    intVal = 0;
                    cursor = 0;
                }
            }
            return strContent;
        }
    }

    public void setContent(byte[] content) {
        this.content = content;
    }

    /* TO_DO */
    public void setContent(String strContent) {
        
    }
}
