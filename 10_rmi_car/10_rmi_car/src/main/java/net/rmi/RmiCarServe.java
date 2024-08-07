package net.rmi;

import car.CarPainter;
import car.FieldMatrix;
import car.command.Command;
import net.command.SerializableCommand;

import java.rmi.RemoteException;
import car.*;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

//在服务器中注册一个名为RMICarServer的对象。
//在注册的对象中，实现executeCommand方法，该方法接收一个包含命令名称及其参数的SerializableCommand对象的引用。
// executeCommand方法对于CREATECAR命令返回带有机器号的int类型，对于其他命令返回boolean类型。

//基于Java RMI的远程对象服务器RMICarServer
public class RmiCarServe implements RemoteCarServer {

    //存储远程调用的方法中执行操作后得到的新车辆对象
    public Car new_car;

    //RMI服务器的端口号
    public static final int port = 8088;

    //存储读取地图文件的输入流
    public InputStream iostream;

    //RMI服务的名称
    public static final String name = "RemoteCarServer";

    public FieldMatrix fieldMatrix;

    public CarPainter new_carpaint;
    public BasicCarServer carServer;

    //在RMICarServer类的构造方法中，它首先从文件中读取了10x10的矩阵（文件名为Field10x10.txt），并将其传递给一个CarPainter对象p，
    // 用于画出小车运行的场景。然后，它创建了一个BasicCarServer对象carServer，并将矩阵和画家传递给该对象，用于处理与小车的交互。
    // 接着，它调用carServer的createCar方法，创建了一个新的小车car对象。
    RmiCarServe() throws RemoteException
    {
        //CarPainter.class.getClassLoader()获取CarPainter这个类的类加载器；
        //getResourceAsStream("Field10x10.txt")从这个类加载器获取名为"Field10x10.txt"的文件的输入流，如果文件不存在则返回null；
        //this.iostream = ...将获取到的输入流保存到实例变量iostream中。

        //从文件中读取矩阵，用于画出小车运行的场景
        this.iostream = CarPainter.class.getClassLoader().getResourceAsStream("Field10x10.txt");
        this.fieldMatrix = FieldMatrix.load(new InputStreamReader(iostream));
        this.new_carpaint = new CarPainter(fieldMatrix);

        //创建BasicCarServer对象，用于处理与小车的交互
        this.carServer = new BasicCarServer(fieldMatrix, new_carpaint);

        //创建一个新的小车car对象
        this.new_car = carServer.createCar();
    }

    //在注册的对象中，实现executeCommand方法，该方法接收一个包含命令名称及其参数的SerializableCommand对象的引用。
    // executeCommand方法对于CREATECAR命令返回带有机器号的int类型，对于其他命令返回boolean类型。
    public <T> T executeCommand(SerializableCommand command) throws RemoteException
    {
        String commandName = command.commandName;
        String commandparameter = command.commandparameter;
        int carIndex = command.carIndex;

        //创建一个命令对象，并执行命令
        Command new_Command = Command.createCommand(new_car, commandName + " " + commandparameter);

        //使用泛型使得executeCommand方法更加通用，可以返回任意类型的结果
        T result = (T) new_Command.execute();
        return result;
    }
    public static void main(String[] args) throws Exception
    {

        try{
            //创建 RmiCarServe 对象
            RmiCarServe server = new RmiCarServe();

            //创建 RMI 注册表，并指定端口号
            Registry registry = LocateRegistry.createRegistry(port);

            //将 RmiCarServe 对象导出为远程对象
            RemoteCarServer car = (RemoteCarServer) UnicastRemoteObject.exportObject(server, 0);

            //在 RMI 注册表中绑定远程对象和服务名称
            //这段代码使用Java RMI中Registry接口的bind方法将远程对象car绑定到注册表。
            // bind方法用于将指定的名字绑定到远程对象，如果名字已经被绑定到注册表，则抛出AlreadyBoundException。
            // 在这段代码中，name参数指定了要绑定到注册表的名称，car参数是实现Remote接口的对象，代表了远程对象。
            // 绑定完成后，客户端可以使用这个名字找到远程对象

            //Этот код использует метод bind интерфейса Registry в Java RMI для привязки удаленного объекта car к реестру.
            // Метод bind служит для привязки указанного имени к удаленному объекту и выбрасывает AlreadyBoundException,
            // если имя уже привязано к реестру.
            // В этом коде параметр name указывает имя, которое должно быть привязано
            // к реестру, а параметр car - это объект, реализующий интерфейс Remote, который представляет удаленный
            // объект. После завершения привязки клиент может найти удаленный объект, используя это имя
            registry.bind(name, car);

        }catch (Exception e){e.printStackTrace();}

    }
}
