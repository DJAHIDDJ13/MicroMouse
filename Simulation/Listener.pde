public class Listener extends Communication {
    FileInputStream rxStream;
    String output;

    public Listener(Semaphore semaphore) {
        this.semaphore = semaphore;
        this.setName("Listener process");
        this.setDaemon(true);
        this.start();
    }

    public void run() {
        while (true) {
            System.out.println("JAVA - LISTENING...");
            read_fifo();
            System.out.println(this.output);
        }
    }

    public void read_fifo() {
        try {
            //this.semaphore.acquire();
            rxStream = new FileInputStream(FIFO_PATH + FIFO_RX_FILENAME);
            int character = 0;
            this.output = "";
            while ((character = rxStream.read()) != -1)
            this.output += (char) character;
            rxStream.close();
            //this.semaphore.release();
        } catch(Exception e) {
            e.printStackTrace(); 
            System.out.println(e); 
        }
    }

    public void write_fifo(String input) {
        //
    }

    String getOutput() {
        return this.output; 
    }

}
