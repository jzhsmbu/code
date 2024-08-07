package tcp;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.DatagramPacket;
import java.net.DatagramSocket;

public class SerializeTCPServer {
    public static void main(String args[]) {
        try {
            int serverPort = 8088; // the server port
            ServerSocket listenSocket = new ServerSocket(serverPort); // new server port generated
            System.out.println("SerializeServer listen port: " + serverPort);
            while (true) {
                Socket clientSocket = listenSocket.accept(); // listen for new connection
                ObjectOutputStream ous = new ObjectOutputStream(clientSocket.getOutputStream());
                ObjectInputStream ois = new ObjectInputStream(clientSocket.getInputStream());
                Object data = ois.readObject();
                System.out.println("Received data: " + data);

                Message msg= (Message) data;
                //DatagramSocket的主要作用是：
                //1.创建一个DatagramSocket对象来监听指定的UDP端口，以接收UDP数据报；
                //2.创建一个DatagramPacket对象，并使用DatagramSocket对象将其发送到指定的UDP地址和端口；
                //3.接收从其他主机发送的DatagramPacket对象，并将其作为数据报处理。
                DatagramSocket new_Socket=new DatagramSocket();
                byte buffer[] =new byte[64];
                //buffer：表示一个byte类型的数组，用于存储UDP数据报的内容；
                //100：表示UDP数据报的最大长度，即UDP数据报能够传输的最大数据量；
                //clientSocket.getInetAddress()：表示客户端的IP地址；
                //msg.udpPort：表示客户端的UDP端口号，即用于接收服务器回复消息的UDP端口号。
                DatagramPacket Reply_message=new DatagramPacket(buffer,64,clientSocket.getInetAddress(),msg.udpPort);
                new_Socket.send(Reply_message);
                new_Socket.close();
            }
        } catch (IOException e) {
            System.out.println("Listen socket:" + e.getMessage());
        } catch (ClassNotFoundException e){
            e.printStackTrace();
        }
    }
}