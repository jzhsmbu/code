package net.server;

import car.BasicCarServer;
import car.CarEventsListener;
import car.CarPainter;
import car.FieldMatrix;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;

public class Server extends BasicCarServer implements Runnable{
    private final int port;

    public Server(FieldMatrix fieldMatrix, CarEventsListener carEventsListener, int port){
        super(fieldMatrix,carEventsListener);
        this.port = port;
        new Thread(this).start();
    }

    public static void main(String[] args) {
        InputStream is = CarPainter.class.getClassLoader().getResourceAsStream("Field10x10.txt");
        FieldMatrix fm = FieldMatrix.load(new InputStreamReader(is));
        CarPainter p = new CarPainter(fm);
        new Server(fm, p, 8080);
    }

    //这段代码是一个服务器端的主线程，它在给定的端口上创建一个ServerSocket，等待客户端的连接。当客户端连接时，
    // 它会创建一个新的线程（ClientWorker），并将socket和服务器对象作为参数传递给它，然后启动该线程。
    // 在启动线程之后，主线程会回到等待状态，继续等待新的客户端连接。
    @Override
    public void run() {
        try {
            ServerSocket serverSocket = new ServerSocket(port);
            while(true) {
                Socket socket = serverSocket.accept();
                new Thread(new ClientWorker(socket, this)).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
