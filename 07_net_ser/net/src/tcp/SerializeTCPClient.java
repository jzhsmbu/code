package tcp;

import java.io.IOException;
import java.io.EOFException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.net.UnknownHostException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;

public class SerializeTCPClient {
    public static void main(String args[]) {
        // arguments supply message and hostname
        int serverPort = 8088;
        String serverHost = "localhost";//args[1];
        String message = "Hello world";//args[6];
        System.out.print("Connecting to "+serverHost+":"+serverPort+"...");
        try (Socket s = new Socket(serverHost, serverPort))
        {
            System.out.println("Connected!");
            ObjectInputStream in = new ObjectInputStream(s.getInputStream());
            ObjectOutputStream out = new ObjectOutputStream(s.getOutputStream());

            //创建了一个DatagramSocket对象new_Socket，并获取其绑定的本地端口号
            DatagramSocket new_Socket=new DatagramSocket();
            Message msg = new Message(9, new_Socket.getLocalPort(),"HELP!!!");
            out.writeObject(msg);
            System.out.println("Data sent: " + msg);

            //When receiving a delivery confirmation from the server, the client must output a message to the console.
            //使用DatagramSocket对象new_Socket创建一个DatagramPacket对象reply，用于接收服务器发送的确认消息。
            //然后，代码通过调用new_Socket.receive(reply_message)方法等待接收确认消息，并将接收到的消息输出到控制台上
            byte buffer[]=new byte[64];
            DatagramPacket reply_message=new DatagramPacket(buffer,64);
            new_Socket.receive(reply_message);
            System.out.println("The Client has received the message.");
            new_Socket.close();

        } catch (
                UnknownHostException e) {
            System.out.println("Socket:" + e.getMessage()); // host cannot be resolved
        } catch (
                EOFException e) {
            System.out.println("EOF:" + e.getMessage()); // end of stream reached
        } catch (
                IOException e) {
            System.out.println("Readline:" + e.getMessage()); // error in reading the stream
        }
    }
}