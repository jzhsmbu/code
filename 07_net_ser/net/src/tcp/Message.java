package tcp;

import java.io.Serializable;
import java.util.Arrays;

public class Message implements Serializable {
    public int priority;
    public String message;
    //Add the number of the UDP port that the client is listening to to the sent message class
    public int udpPort;
    public Integer[] data = new Integer[10];
    public Message(int p, int udpPort,String msg) {
        this.priority = p;
        this.message = msg;
        this.udpPort=udpPort;

        Arrays.fill(data, 20);
    }
        @Override
        public String toString() {
            return "class Message: priority=" + priority + " udp= " + udpPort + " message=" + message + " arrays=" + Arrays.asList(data);
        }
}