package rmi.server;

import rmi.common.HelloChat;
import rmi.common.Message;

import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

//Server 端主要是构建一个可以被传输的类 User，一个可以被远程访问的类 UserService，同时这个对象要注册到 RMI 开放给客户端使用。

    public class HelloServer implements HelloChat {
    public static final int port = 8080;
    public static final String name = "HelloChat";

    @Override
    //对收到的消息的响应形式为：“Hello， <name>！在客户端上显示此响应
    public String message(String message, String name)
    {
        return "Hello, " + name + "!";
    }


    //在HelloServer类中添加函数objMessage()，它接受Message类的对象。向客户端发送这个类的对象并显示服务器的响应。
    public String objMessage(Message recv_message) throws RemoteException
    {
        return "Hello, " + recv_message.name + "!\n" + "Message: " + recv_message.message;
    }


    public static void main(String[] args) throws Exception
    {
        //创建了一个HelloServer实例
        HelloServer server = new HelloServer();

        //将HelloServer对象绑定到该注册表中，以便客户端可以通过查找注册表来获取HelloServer对象的引用
        Registry registry = LocateRegistry.createRegistry(port);

        //使用UnicastRemoteObject.exportObject方法来将HelloServer对象导出为远程对象，以便客户端能够通过网络访问该对象
        HelloChat obj = (HelloChat) UnicastRemoteObject.exportObject(server, 0);
        registry.bind(name, obj);
        System.out.println("Server started on port: "+port);
    }
}
