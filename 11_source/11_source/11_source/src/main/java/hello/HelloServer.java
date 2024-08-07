package hello;
import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.xml.ws.Endpoint;

//�ڷ������ϴ���sendMessage�������������Կͻ��˵�Message�����������ƺ��յ�����Ϣ������ͻ��˷�����Ӧ���磺 "��ã�<��>��"��

//URL��Uniform Resource Locator����һ�ֶ�λ������Դ�ĵ�ַ������������Э�顢���������˿ںź���Դ·������Ϣ��
// �� Web Ӧ�ó����У�URL ��ַ���ڶ�λ Web ��Դ���� HTML ҳ�桢ͼ����Ƶ����ʽ��JavaScript �ļ��ȡ�
// URL��ַ���Ա�������������ͻ���ʹ�ã��Է���������Դ��

// �ڱ����У�URL��ַ���ڷ��� Web Service����ָ����󶨵Ķ˿ںź���Դ·�����ͻ���ͨ���� URL ��ַ���� Web Service���Ӷ�ʵ���������֮���ͨ�š�
//URL-�ѧէ�֧� �ڧ���ݧ�٧�֧��� �էݧ� ���ҧݧڧܧѧ�ڧ� �ӧ֧�-��ݧ�اҧ� �� ��ܧѧ٧ѧߧڧ� �ߧ�ާ֧�� ������ �� ����� �� ��֧�����, �� �ܧ�����ާ� ��ߧ� ���ڧӧ�٧ѧߧ�.
// ���ݧڧ֧ߧ� ��ҧ�ѧ�ѧ֧��� �� �ӧ֧�-��ݧ�اҧ� ��֧�֧� ����� URL-�ѧէ�֧� �էݧ� ��ҧ֧��֧�֧ߧڧ� ��ӧ�٧� �� ��֧�ӧ֧���

@WebService
public class HelloServer
{
    //������Web Service��URL��ַ
    public static final String url = "http://0.0.0.0:8080/Hello"; //bind all IPv4 interfaces

    //sayHello()�������ڷ���һ���ַ���"Hello!"�����������Web Service�б�����Ϊһ���ɹ��ͻ��˵��õ�Web Method
    @WebMethod
    public String sayHello()
    {
        return "Hello!";
    }

    //sendMessage()��������һ��Message������Ϊ������������һ���ַ������˷���Ҳ��һ��Web Method
    @WebMethod
    public String sendMessage(Message new_message)
    {
        String name;
        name = new_message.getName();
        return "Hello! " + name;
    }

    //������һ��HelloServer���󲢽��䷢����ָ����URL��ַ��
    //����٧էѧ� ��ҧ�֧ܧ� HelloServer �� ��ѧ٧ާ֧��ڧ� �֧ԧ� ��� ��ܧѧ٧ѧߧߧ�ާ� URL-�ѧէ�֧��
    public static void main(String[] args)
    {
        HelloServer helloServer = new HelloServer();

        //Endpoint.publish(url, helloServer)������ڽ�����˷�����ָ����URL��ַ��
        Endpoint.publish(url, helloServer);
        System.out.println("WebService started");
    }
}
