package server;

import car.*;
import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.xml.ws.Endpoint;
import java.io.InputStream;
import java.io.InputStreamReader;
import car.util.ColorFactory;

//完成服务器应用程序代码，实现改变机器颜色的命令。从客户端调用这个命令

//@WebService注解，表示这是一个WebService服务端的实现类。@WebMethod注解用于标记哪些方法暴露给外部调用

@WebService
public class Server {
    BasicCarServer carServer;

    //定义一个静态的常量 url，存储了服务器端的地址和端口
    public static final String url = "http://0.0.0.0:8080/CarServer";


    //定义了一个构造函数 Server，用来创建 Server 对象，该构造函数接受两个参数 fieldMatrix 和 carEventsListener，
    // 分别用来创建 BasicCarServer 对象和 CarEventsListener 对象，并将 carServer 成员变量赋值为创建的 BasicCarServer 对象。
    // 此构造函数被定义为受保护的，只能在 server 包中被访问
    protected Server(FieldMatrix fieldMatrix, CarEventsListener carEventsListener)
    {
        carServer = BasicCarServer.createCarServer(fieldMatrix, carEventsListener);
    }

    //createCar() 方法会创建一个新的汽车（Car）对象，并返回该汽车对象的索引（index）。客户端可以通过这个索引来标识和操作这个汽车对象。
    @WebMethod
    public int createCar()
    {
        Car car = carServer.createCar();
        return car.getIndex();
    }

    //destroyCar(int carIndex) 方法会销毁一个汽车对象。客户端需要传入要销毁的汽车对象的索引来指定要销毁哪个汽车对象
    @WebMethod
    public void destroyCar(int carIndex)
    {
        Car car = carServer.getCar(carIndex);
        carServer.destroyCar(car);
    }

    //moveCarTo用来移动指定车辆，接收两个参数：carIndex表示车辆的索引，direction表示移动的方向
    @WebMethod
    public boolean moveCarTo(int carIndex, CarServer.Direction direction)
    {
        //首先通过carServer.getCar(carIndex)获取指定索引的车辆，
        // 然后调用car.moveTo(direction)方法进行移动，如果移动过程中出现异常，就打印错误信息，并返回false，否则返回移动结果
        Car car = carServer.getCar(carIndex);
        boolean ret = false;
        try {
            ret = car.moveTo(direction);
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
        return ret;
    }

    //setCarName用来设置指定车辆的名称
    @WebMethod
    public void setCarName(int carIndex, String name)
    {
        carServer.getCar(carIndex).setName(name);
    }


    //setCarColor实现改变机器颜色的命令
    public void setCarColor(int carIndex, String color)
    {
        carServer.getCar(carIndex).setColor(ColorFactory.getColor(color));
    }


    public static void main(String[] args)
    {
        //获取资源文件Field10x10.txt的输入流
        InputStream is = CarPainter.class.getClassLoader().getResourceAsStream("Field10x10.txt");

        //通过FieldMatrix.load(new InputStreamReader(is))方法将输入流解析为FieldMatrix对象
        FieldMatrix fm = FieldMatrix.load(new InputStreamReader(is));

        //创建一个CarPainter对象，将FieldMatrix对象传入
        CarPainter p = new CarPainter(fm);

        //创建一个Server对象，将FieldMatrix对象和CarPainter对象传入，然后调用Endpoint.publish(url, server)方法
        // 将Server对象发布为一个Web服务，URL为http://0.0.0.0:8080/CarServer
        Server server = new Server(fm,p);
        Endpoint.publish(url, server);
    }
}
