package hello;

import hello.webservice.HelloServer;
import hello.webservice.HelloServerService;
import hello.webservice.Message;

//客户端向服务器发送消息类对象，并输出收到的响应

public class HelloClient
{
    public static final String url = "http://localhost:8080/Hello?wsdl";

    public static void main(String[] args) throws Exception
    {
        //这两行代码是使用Java API for XML Web Services (JAX-WS)调用Web服务的标准方法

        //创建HelloServerService对象并获取远程服务对象

        //HelloServerService是一个自动生成的客户端代理类，用于访问Web服务的WSDL描述。
        // 它包含与Web服务端点通信的所有方法，例如：获取Web服务的元数据，调用Web服务上的操作，配置Web服务调用等
        //HelloServerService - это автоматически создаваемый класс прокси на стороне
        // клиента для доступа к WSDL-описанию веб-сервиса.
        //Он содержит все методы для взаимодействия с конечной точкой веб-сервиса, например,
        // получение метаданных веб-сервиса, вызов операций над веб-сервисом, конфигурирование вызовов веб-сервиса и т.д.
        HelloServerService service = new HelloServerService();

        //getHelloServerPort()返回一个HelloServer对象，该对象是一个实现了Web服务接口的本地代理对象。
        // 在客户端中，我们可以通过此代理对象来调用Web服务操作。
        //getHelloServerPort() возвращает объект HelloServer, который является локальным прокси-объектом,
        // реализующим интерфейс веб-сервиса.
        //На стороне клиента мы можем использовать этот прокси-объект для вызова операций веб-службы.
        HelloServer server = service.getHelloServerPort();


        //创建一个Message对象并设置相关属性
        String message_name = "new message!";
        String message = "this is a message";

        Message new_message = new Message();

        new_message.setName(message_name);
        new_message.setMessage(message);

        //调用服务端方法并输出响应
        String response = server.sendMessage(new_message);
        System.out.println(response);



    }
}
