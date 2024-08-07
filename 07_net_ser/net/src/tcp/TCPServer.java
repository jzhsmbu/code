package tcp;

import java.net.*;
import java.io.*;

//这是一个基于TCP协议的服务器端程序，它接受客户端连接并启动新的线程处理客户端请求。下面是主要代码的解释：
//
//int serverPort = args.length>0? Integer.getInteger(args[0]): 8080; 这行代码通过命令行参数或默认端口号（8080）创建一个服务器端口变量 serverPort。
//
//ServerSocket listenSocket = new ServerSocket(serverPort); 创建一个 ServerSocket 对象 listenSocket，用于监听客户端连接请求。
//
//while (true) { Socket clientSocket = listenSocket.accept(); ClientConnection c = new ClientConnection(clientSocket); } 这是主要的处理循环，它不断监听客户端连接请求。一旦有客户端连接请求到达，listenSocket.accept() 方法会返回一个与客户端通信的新的 Socket 对象 clientSocket。程序通过这个 Socket 对象创建一个新的线程 ClientConnection 并启动它，这个线程负责处理客户端的请求。
//
//ClientConnection 类是一个独立的线程类，它继承了 Thread 类。在它的 run() 方法中，它通过 clientSocket.getInputStream() 和 clientSocket.getOutputStream() 获取客户端发送过来的数据和向客户端发送响应数据。此外，还可以对客户端进行认证等其他操作。
//
//通过这种方式，该 TCP 服务器可以同时处理多个客户端的请求，每个客户端的请求都在独立的线程中处理。

//这段代码实现了一个基本的TCP客户端，连接到指定的服务器和端口，并向服务器发送一条消息，然后等待接收服务器的响应。
//
//首先，程序读取命令行参数来获取服务器的主机名、端口和消息内容，如果没有指定

public class TCPServer {
    public static void main(String args[]) {
        try {
            int serverPort = args.length>0? Integer.getInteger(args[0]): 8080; // the server port > 1024
            ServerSocket listenSocket = new ServerSocket(serverPort); // new server port generated
            System.out.println("Server listen port: " + serverPort);
            while (true) {
                Socket clientSocket = listenSocket.accept(); // listen for new connection
                ClientConnection c = new ClientConnection(clientSocket); // launch new thread
            }
        } catch (IOException e) {
            System.out.println("Listen socket:" + e.getMessage());
        }
    }
}
