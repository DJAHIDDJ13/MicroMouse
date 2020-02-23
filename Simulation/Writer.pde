public class Writer extends Communication {
    FileOutputStream txStream;
    String input;

    public Writer(Semaphore semaphore) {
        this.semaphore = semaphore;
        this.setName("Writer process");
        this.setDaemon(true);
        this.start();
    }

    public void run() {
        /*
        System.out.println("JAVA - READING...");
        while (true) {
            System.out.println("JAVA - READING...");
            write_fifo("PING");
            System.out.println("JAVA - END OF READING...");
        }
        */
    }

    public void write_fifo(String input) {
        try {
            //this.semaphore.acquire(); 
            txStream = new  FileOutputStream(FIFO_PATH + FIFO_TX_FILENAME);
            byte stringToByte[] = input.getBytes();
            txStream.write(stringToByte);
            txStream.close();
            //this.semaphore.release(); 
        } catch(Exception e) {
            e.printStackTrace();  
            System.out.println(e); 
        }
    }

    public void read_fifo() {
        // 
    }

    String getInput() {
        return this.input; 
    }

}
