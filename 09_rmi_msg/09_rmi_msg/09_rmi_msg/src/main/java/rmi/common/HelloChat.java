package rmi.common;

import java.rmi.Remote;
import java.rmi.RemoteException;

//定义一个Java RMI（Remote Method Invocation）远程接口，名为HelloChat，它继承了Remote接口。
// 这个接口包含message,objMessage方法，可以被客户端调用。方法抛出RemoteException异常，这个异常是Java RMI框架用来处理远程调用失败的一种异常。
// 接口中的方法实现将在远程服务器上执行，用于向服务器发送消息。
public interface HelloChat extends Remote {
    //void message(String name, String message) throws RemoteException;
    String message(String message,String name) throws RemoteException;
    String objMessage(Message recv_message) throws RemoteException;
}
