package tcp;

import java.net.*;
import java.io.*;

//这段代码实现了一个基本的TCP客户端，连接到指定的服务器和端口，并向服务器发送一条消息，然后等待接收服务器的响应。
//
//首先，程序读取命令行参数来获取服务器的主机名、端口和消息内容，如果没有指定，则使用默认值。接着，程序创建一个新的套接字 Socket 对象，并尝试连接到指定的服务器和端口。
//
//如果连接成功，程序将使用 DataInputStream 和 DataOutputStream 来与服务器进行通信。DataOutputStream 中的 writeUTF() 方法将消息字符串编码为 UTF 格式，
// 并写入到输出流中。然后，程序从输入流中读取服务器发送的响应消息，并将其打印到控制台上。
//
//如果在任何时候发生异常，程序将捕获并打印错误消息。例如，如果指定的主机名无法解析，则会抛出 UnknownHostException 异常；如果流达到了流的末尾，
// 则会抛出 EOFException 异常；如果在读取流时发生错误，则会抛出 IOException 异常。

public class TCPClient {
    public static void main(String args[]) {
        // arguments supply hostname, port and message
        String serverHost = args.length>0? args[0]: "localhost";
        int serverPort = args.length>1? Integer.getInteger(args[1]): 8080;
        String message = args.length>2? args[2]: "Hello TCP for java!";
        System.out.print("Connecting to "+serverHost+":"+serverPort+"...");
        try (Socket s = new Socket(serverHost, serverPort)) {
            System.out.println("Connected!");
            DataInputStream in = new DataInputStream(s.getInputStream());
            DataOutputStream out = new DataOutputStream(s.getOutputStream());
            out.writeUTF(message); // UTF is a string encoding
            String data = in.readUTF(); // read a line of data from the stream
            System.out.println("Received: " + data);
        } catch (UnknownHostException e) {
            System.out.println("Socket:" + e.getMessage()); // host cannot be resolved
        } catch (EOFException e) {
            System.out.println("EOF:" + e.getMessage()); // end of stream reached
        } catch (IOException e) {
            System.out.println("readline:" + e.getMessage()); // error in reading the stream
        }
    }
}
