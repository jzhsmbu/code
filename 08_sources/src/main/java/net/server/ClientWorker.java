package net.server;

import car.BasicCarServer;
import car.Car;
import car.command.Command;
import net.CommandCode;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;

public class ClientWorker implements Runnable {
    private final Socket clientSocket;
    private final DataInputStream dis;
    private final DataOutputStream dos;
    private final BasicCarServer carServer;
    private final Car car;

    public ClientWorker(Socket clientSocket, BasicCarServer carServer) throws IOException {
        this.clientSocket = clientSocket;
        this.carServer = carServer;
        this.car = carServer.createCar();
        this.dis = new DataInputStream(clientSocket.getInputStream());
        this.dos = new DataOutputStream(clientSocket.getOutputStream());
    }

    //在循环中，首先使用DataInputStream的readUTF()方法读取来自客户端的命令和参数，并将它们合并成一个字符串形式的命令。
    // 接下来使用这个命令字符串创建一个Command对象，然后执行这个Command对象。Command对象的具体实现是在execute()方法中定义的，
    // 它根据命令类型和参数执行不同的操作，并返回执行结果。
    //
    //如果执行结果为true，则使用DataOutputStream的writeBoolean()方法向客户端发送执行成功的信号，否则发送执行失败的信号。
    // 如果在执行命令的过程中出现异常，则在catch块中处理并不发送执行结果。
    @Override
    public void run() {
        try {
            while (true) {
                String stringCommand = dis.readUTF();
                String parameter = dis.readUTF();
                Command command = Command.createCommand(car, stringCommand + " " + parameter);
                boolean result = false;
                try {
                    result = command.execute();
                }catch (Exception e){}
                dos.writeBoolean(result);
            }
        } catch (IOException e) {
            carServer.destroyCar(car);
            e.printStackTrace();
        }
    }
}
