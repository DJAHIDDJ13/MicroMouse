/* MESSAGE TYPE : RX */
public class WallData extends Message {
    
    Vec2 cell;
    float wallIndicator;

    public WallData() {
        this.flag = CommunicationUtility.WALL_FLAG;
        this.content = new byte[CommunicationUtility.WALL_CONTENT_SIZE];
    }

    protected void setCell() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("WARNING", "WallData", "setCell", "Content is empty - no data has been received.");
        } else {
            /* According to data format : 
             *      - cell(X) = [0:4]bytes
             *      - cell(Y) = [4:8]bytes 
             */
            byte[] sliced = new byte[4];
            this.cell = new Vec2();
            /* cell(X) */
            sliced = Arrays.copyOfRange(this.content, 0, 4);
            this.cell.x = ByteBuffer.wrap(sliced).order(ByteOrder.LITTLE_ENDIAN).getFloat();
            /* cell(Y) */
            sliced = Arrays.copyOfRange(this.content, 4, 8);
            this.cell.y = ByteBuffer.wrap(sliced).order(ByteOrder.LITTLE_ENDIAN).getFloat();
        }
    }

    protected void setWallIndicator() {
        if (this.content == null || this.content.length == 0) {
            CommunicationUtility.logMessage("WARNING", "WallData", "setWallIndicator", "Content is empty - no data has been received.");
        } else {
            /* According to data format : wall indicator = [8:12]bytes */
            byte[] sliced = new byte[4];
            sliced = Arrays.copyOfRange(this.content, 8, 12);
            this.wallIndicator = ByteBuffer.wrap(sliced).order(ByteOrder.LITTLE_ENDIAN).getFloat();
        }
    }
    
    public void setCell(Vec2 cell) {
        this.cell = cell;
    }
    
    public void setWallIndicator(float wallIndicator) {
        this.wallIndicator = wallIndicator;
    }

    public Vec2 getCell() {
        return this.cell;
    }
    
    public float getWallIndicator() {
        return this.wallIndicator;
    }

    public void formatMessage() {
        setCell();
        setWallIndicator();
    }
    
    public void setContent(byte[] content) {
        this.content = content;
    }
    
    /* TO_DO or REMOVE */
    public void setContent() {
        /**/
    }
    
    public void setContent(String strContent) {
        /**/ 
    }
    
    public String dumpContent() {
        /**/
        return "";
    }
}
