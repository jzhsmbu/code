package net.server;

import net.CommandCode;

import java.io.*;
import java.net.Socket;
import java.util.Random;
import java.util.List;
import java.util.Arrays;

public class Client implements Runnable {

    //定义连接服务器所需的主机名和端口号
    private String host;
    private int port;
    //定义客户端的名称，该名称将在连接服务器时使用
    private String name;

    //socket变量用于建立客户端与服务器之间的连接，dis和dos变量则分别用于从socket连接中读取数据和向socket连接中写入数据
    private Socket socket;
    private DataInputStream dis;
    private DataOutputStream dos;

    Client(String host, int port) throws IOException {
        this.host = host;
        this.port = port;

        // 初始化socket连接和输入输出流
        this.socket = new Socket(host, port);
        this.dis = new DataInputStream(socket.getInputStream());
        this.dos = new DataOutputStream(socket.getOutputStream());
    }

    public void run()
    {
        // 随机生成第一个命令和参数
        Random random = new Random();

        List<String> colorList = Arrays.asList("yellow", "blue", "green");

        CommandCode[] commands = {CommandCode.UP, CommandCode.DOWN, CommandCode.LEFT,
                CommandCode.RIGHT, CommandCode.CHANGECOLOR,CommandCode.CHANGECOLOR,CommandCode.CHANGECOLOR};

        CommandCode command = CommandCode.values()[random.nextInt(commands.length)];
        String parameter;

        try {

            while (true)
            {
                parameter = (command == CommandCode.CHANGECOLOR) ? colorList.get(random.nextInt(colorList.size())) :
                        Integer.toString(random.nextInt(10));

                // 发送命令到服务器
                dos.writeUTF(command.name());
                dos.writeUTF(parameter);
                //System.out.println(command.name() + " " + parameter);

                // 接收并处理服务器返回的执行结果
                boolean result = dis.readBoolean();

                //通过 CommandCode.values() 方法获取 CommandCode 枚举类型的所有枚举值，然后通过
                // random.nextInt(CommandCode.values().length - 1) 生成一个随机数，随机选择一个枚举值作为下一个命令。
                // 其中 CommandCode.values().length - 1 是因为 random.nextInt 方法的参数是生成的随机数的上限，
                // 而枚举值数组的长度是从 1 开始计数的，因此需要减 1。

                //这段代码的作用是确保下一个要发送的命令不是 SetColor 或 SetName。如果服务器返回了错误的执行结果（result 是 false），
                // 或者当前命令是 SetColor 或 SetName，那么代码会从枚举 CommandCode 中随机选择一个除了 SetColor 或 SetName 之外
                // 的命令作为下一个要发送的命令。这样可以保证客户端发送的命令不会过于单一，从而更好地测试服务器的性能和稳定性。
                switch (command)
                {
                    case CHANGECOLOR:
                    case SETNAME:
                        command = commands[random.nextInt(commands.length)];
                        break;
                    default:
                        if (result == false)
                        {
                            command = commands[random.nextInt(commands.length)];
                        }
                }

            }
        }
        catch (IOException e)
        {
            System.out.println("Connection error.");
        }
    }

    public static void main(String[] args) throws InterruptedException, IOException
    {
        // 创建客户端，并连接到服务器
        Client new_car = new Client("localhost", 8080);

        // 创建线程，并启动客户端
        Thread new_thread = new Thread(new_car);
        new_thread.start();

    }

}