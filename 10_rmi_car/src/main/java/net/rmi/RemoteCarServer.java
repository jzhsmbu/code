package net.rmi;

import net.command.SerializableCommand;

import java.rmi.Remote;
import java.rmi.RemoteException;

//这段代码定义了一个远程接口RemoteCarServer，它继承了Java RMI中的Remote接口。Remote接口是所有远程对象接口的父接口，
// 其作用是标识接口，表示该接口中的方法可以被远程调用。

public interface RemoteCarServer extends Remote{

    //RemoteCarServer接口中声明了一个executeCommand方法，该方法接受一个SerializableCommand类型的参数，并返回一个泛型类型T。
    <T> T executeCommand(SerializableCommand command) throws RemoteException;
}