package net.rmi;

import car.Car;
import car.CarServer;
import net.command.SerializableCommand;

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import java.util.List;

//创建一个RemoteCarClient类
//连接到RMI名称注册处
//从注册中心获得一个名为RMICarServer的对象
//使用executeCommand方法，远程调用CREATECAR命令
//在一个循环中，移动汽车直到executeCommand返回true，然后将移动方向改为随机。

//Создать класс RemoteCarClient
//Подключиться к реестру имен RMI
//Получить из реестра объект с именем RMICarServer
//Вызвать удаленно команду CREATECAR через метод executeCommand
//В цикле перемещать машинку пока executeCommand возвращает true, затем менять направление движение на случайное.


public class RemoteCarClient {

    //RMI服务器的端口号
    public static final int port = 8088;

    //RMI名称
    public static final String name = "RemoteCarServer";

    //主机号
    public static final String host = "127.0.0.1";

    public static void main(String[] args) throws Exception
    {

        //使用使用Naming.lookup()方法获得远程注册表上的远程对象
        // 如果成功，它会得到一个远程引用，可以使用它来调用远程对象的方法
        RemoteCarServer server = (RemoteCarServer) Naming.lookup("rmi://" + host + ":" + port + "/" + name);


        //客户端创建了一个SerializableCommand对象，然后调用远程服务器上的executeCommand()方法来执行该命令。
        // 该命令是用来在远程服务器上创建一辆汽车，它的参数是汽车的ID和命令名称。
        //public SerializableCommand(int carIndex, String commandName, String commandparameter)
        SerializableCommand serializableCommand = new SerializableCommand(1,"CREATECAR","1");
        server.executeCommand(serializableCommand);


        //int commandDirection = new Random().nextInt(4);

        //使用Math.random()方法生成[0,1)之间的随机数，然后使用乘法和强制类型转换将其转换为[0,4)之间的整数
        CarServer.Direction new_Direction = CarServer.Direction.values()[(int) (Math.random() * 4)];

        while(true)
        {
            //move_Direction为移动方向
            String move_Direction = new_Direction.toString();

            //移动汽车直到executeCommand返回true，然后将移动方向改为随机
            SerializableCommand new_serializableCommand = new SerializableCommand(1, move_Direction, "1");

            Boolean result = server.executeCommand(new_serializableCommand);

            if(result == false)
            {
                new_Direction = CarServer.Direction.values()[(int) (Math.random() * 4)];
            }
        }
    }
}

