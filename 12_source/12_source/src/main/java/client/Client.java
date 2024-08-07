package client;

import car.webservice.Direction;
import car.webservice.Server;
import car.webservice.ServerService;
import java.net.URL;
import java.util.Random;


//完成在服务器上创建和移动机器的客户应用代码。
//机器首先应该向一个随机的方向移动，然后在碰撞后改变方向。

public class Client {
    public static void main(String[] args) throws Exception {
        //url，存储服务器的 Web Service 定义语言 (WSDL) 地址，该地址是客户端与服务器进行通信的入口
        String url = "http://127.0.0.1:8080/CarServer?wsdl";

        //创建 ServerService 对象，并通过 URL 对象传入服务器 WSDL 地址，从而初始化服务实例
        ServerService service = new ServerService(new URL(url));

        //创建第一辆车的线程
        Thread car1Thread = new Thread(() -> {
            try {
                //创建 Server 类型的对象 serverPort，用来与服务端进行交互，并调用 getServerPort() 方法获取服务端的端口
                Server serverPort = service.getServerPort();

                //调用 createCar() 方法创建一个新的汽车，并获取汽车的 carIndex
                int carIndex1 = serverPort.createCar();
                System.out.println("Car 1 created with index " + carIndex1);

                Random new_random1 = new Random();

                //使用Random类的枚举方法在数组中随机选择一个元素作为新方向
                Direction new_Direction = Direction.values()[new_random1.nextInt(Direction.values().length)];

                //定义一个存储颜色名称的数组
                String[] colors1 = {"blue", "green", "yellow", "black", "pink", "white"};

                //设置小车的颜色为随机选择的颜色
                serverPort.setCarColor(carIndex1, colors1[new_random1.nextInt(colors1.length)]);

                //声明一个 Boolean 类型的变量 if_NoWall，用于存储 moveCarTo 方法的返回值
                Boolean if_NoWall = true;

                do {
                    serverPort.setCarColor(carIndex1, colors1[new_random1.nextInt(colors1.length)]);

                    //调用 moveCarTo 方法，将返回值存储到 if_NoWall 变量中
                    if_NoWall = serverPort.moveCarTo(carIndex1, new_Direction);

                    //如果 if_NoWall 变量的值为 false，则重新随机生成一个方向，将其存储到 new_Direction 变量中
                    if (!if_NoWall) {
                        new_Direction = Direction.values()[new_random1.nextInt(Direction.values().length)];
                    }
                } while (true);

            } catch (Exception e) {
                e.printStackTrace();
            }
        });

        // 创建第二辆车的线程
        Thread car2Thread = new Thread(() -> {
            try {
                Server serverPort = service.getServerPort();

                int carIndex2 = serverPort.createCar();
                System.out.println("Car 2 created with index " + carIndex2);

                Random new_random2 = new Random();

                Direction new_Direction2 = Direction.values()[new_random2.nextInt(Direction.values().length)];

                String[] colors2 = {"red", "orange", "purple", "gray", "cyan", "magenta"};;

                serverPort.setCarColor(carIndex2, colors2[new_random2.nextInt(colors2.length)]);

                Boolean if_NoWall2 = true;

                do {
                    serverPort.setCarColor(carIndex2, colors2[new_random2.nextInt(colors2.length)]);

                    if_NoWall2 = serverPort.moveCarTo(carIndex2, new_Direction2);

                    if (!if_NoWall2) {
                        new_Direction2 = Direction.values()[new_random2.nextInt(Direction.values().length)];
                    }
                } while (true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });

        // 启动两个线程
        car1Thread.start();
        car2Thread.start();

    }
}

