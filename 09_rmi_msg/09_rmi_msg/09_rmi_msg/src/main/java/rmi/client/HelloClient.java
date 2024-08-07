package rmi.client;

import rmi.common.HelloChat;
import rmi.common.Message;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

//RMI的主要作用是使Java程序能够调用在远程计算机上运行的Java对象的方法。这些远程对象可以像本地对象一样使用，
// 而且通过RMI传输的数据是基于Java对象的，因此能够保证类型安全。
//Основная роль RMI заключается в том, чтобы позволить Java-программам вызывать методы Java-объектов,
// работающих на удаленном компьютере. Эти удаленные объекты можно использовать как локальные объекты, а данные,
// передаваемые через RMI, основаны на Java-объектах и поэтому безопасны с точки зрения типов.

//相比 Server 端，Client 端就简单的多。直接引入可远程访问和需要传输的类，通过端口和 Server 端绑定的地址，就可以发起一次调用。

public class HelloClient {
    //RMI注册表的端口号
    public static final int port = 8080;
    //绑定在注册表中的对象名称
    public static final String name = "HelloChat";
    //RMI服务器的主机名
    public static final String host = "127.0.0.1";

    public static void main(String[] args) throws Exception
    {
        //使用LocateRegistry.getRegistry()方法连接到RMI注册表。如果连接成功，则打印一条连接成功的消息
        Registry registry = LocateRegistry.getRegistry(host, port);
        System.out.println(String.format("Client connected to registry on host %s and port %d",host, port));

        //调用registry.lookup(name)方法来获取在注册表中绑定的远程对象的引用
        HelloChat server = (HelloChat) registry.lookup(name);

        //向远程服务器发送一条消息，并打印输出
        System.out.println("server = "+server);

        //接收服务器端的message()函数中返回格式为"Hello, <name>!"的应答，并在客户端显示该应答(Вывести этот ответ на клиенте)
        //server.message("Alex", "Hello");
        System.out.println("task1:Вывести этот ответ на клиенте \n");
        System.out.println(server.message("Hello", "Alex"));

        //向客户端发送这个类的对象并显示服务器的响应(Отправить клиентом объект этого класса и вывести ответ от сервера)
        System.out.println("task2:Отправить клиентом объект этого класса и вывести ответ от сервера \n");
        System.out.println(server.objMessage(new Message("Alex","Hello,new message")));

        String res3 = server.objMessage(new Message2("Alex","Hello,new message_2"));
        System.out.println(res3);


    }
}
