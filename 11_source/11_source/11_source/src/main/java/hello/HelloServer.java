package hello;
import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.xml.ws.Endpoint;

//在服务器上创建sendMessage方法，接收来自客户端的Message类对象，输出名称和收到的消息，并向客户端返回响应，如： "你好，<名>！"。

//URL（Uniform Resource Locator）是一种定位网络资源的地址，包含了网络协议、主机名、端口号和资源路径等信息。
// 在 Web 应用程序中，URL 地址用于定位 Web 资源，如 HTML 页面、图像、视频、样式表、JavaScript 文件等。
// URL地址可以被浏览器和其他客户端使用，以访问网络资源。

// 在本例中，URL地址用于发布 Web Service，并指定其绑定的端口号和资源路径。客户端通过该 URL 地址访问 Web Service，从而实现与服务器之间的通信。
//URL-адрес используется для публикации веб-службы и указания номера порта и пути к ресурсу, к которому она привязана.
// Клиент обращается к веб-службе через этот URL-адрес для обеспечения связи с сервером

@WebService
public class HelloServer
{
    //定义了Web Service的URL地址
    public static final String url = "http://0.0.0.0:8080/Hello"; //bind all IPv4 interfaces

    //sayHello()方法用于返回一个字符串"Hello!"。这个方法在Web Service中被定义为一个可供客户端调用的Web Method
    @WebMethod
    public String sayHello()
    {
        return "Hello!";
    }

    //sendMessage()方法接收一个Message对象作为参数，并返回一个字符串。此方法也是一个Web Method
    @WebMethod
    public String sendMessage(Message new_message)
    {
        String name;
        name = new_message.getName();
        return "Hello! " + name;
    }

    //创建了一个HelloServer对象并将其发布到指定的URL地址上
    //Создал объект HelloServer и разместил его по указанному URL-адресу
    public static void main(String[] args)
    {
        HelloServer helloServer = new HelloServer();

        //Endpoint.publish(url, helloServer)语句用于将服务端发布到指定的URL地址上
        Endpoint.publish(url, helloServer);
        System.out.println("WebService started");
    }
}
