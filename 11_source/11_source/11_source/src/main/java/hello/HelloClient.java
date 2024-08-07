package hello;

import hello.webservice.HelloServer;
import hello.webservice.HelloServerService;
import hello.webservice.Message;

//�ͻ����������������Ϣ����󣬲�����յ�����Ӧ

public class HelloClient
{
    public static final String url = "http://localhost:8080/Hello?wsdl";

    public static void main(String[] args) throws Exception
    {
        //�����д�����ʹ��Java API for XML Web Services (JAX-WS)����Web����ı�׼����

        //����HelloServerService���󲢻�ȡԶ�̷������

        //HelloServerService��һ���Զ����ɵĿͻ��˴����࣬���ڷ���Web�����WSDL������
        // ��������Web����˵�ͨ�ŵ����з��������磺��ȡWeb�����Ԫ���ݣ�����Web�����ϵĲ���������Web������õ�
        //HelloServerService - ���� �ѧӧ��ާѧ�ڧ�֧�ܧ� ���٧էѧӧѧ֧ާ�� �ܧݧѧ�� ����ܧ�� �ߧ� ������ߧ�
        // �ܧݧڧ֧ߧ�� �էݧ� �է������ �� WSDL-���ڧ�ѧߧڧ� �ӧ֧�-��֧�ӧڧ��.
        //���� ���է֧�اڧ� �ӧ�� �ާ֧��է� �էݧ� �ӧ٧ѧڧާ�է֧ۧ��ӧڧ� �� �ܧ�ߧ֧�ߧ�� ����ܧ�� �ӧ֧�-��֧�ӧڧ��, �ߧѧ��ڧާ֧�,
        // ���ݧ��֧ߧڧ� �ާ֧�ѧէѧߧߧ�� �ӧ֧�-��֧�ӧڧ��, �ӧ�٧�� ���֧�ѧ�ڧ� �ߧѧ� �ӧ֧�-��֧�ӧڧ���, �ܧ�ߧ�ڧԧ��ڧ��ӧѧߧڧ� �ӧ�٧�ӧ�� �ӧ֧�-��֧�ӧڧ�� �� ��.��.
        HelloServerService service = new HelloServerService();

        //getHelloServerPort()����һ��HelloServer���󣬸ö�����һ��ʵ����Web����ӿڵı��ش������
        // �ڿͻ����У����ǿ���ͨ���˴������������Web���������
        //getHelloServerPort() �ӧ�٧ӧ�ѧ�ѧ֧� ��ҧ�֧ܧ� HelloServer, �ܧ������ ��ӧݧ�֧��� �ݧ�ܧѧݧ�ߧ�� ����ܧ��-��ҧ�֧ܧ���,
        // ��֧ѧݧڧ٧���ڧ� �ڧߧ�֧��֧ۧ� �ӧ֧�-��֧�ӧڧ��.
        //���� ������ߧ� �ܧݧڧ֧ߧ�� �ާ� �ާ�ا֧� �ڧ���ݧ�٧�ӧѧ�� ����� ����ܧ��-��ҧ�֧ܧ� �էݧ� �ӧ�٧�ӧ� ���֧�ѧ�ڧ� �ӧ֧�-��ݧ�اҧ�.
        HelloServer server = service.getHelloServerPort();


        //����һ��Message���������������
        String message_name = "new message!";
        String message = "this is a message";

        Message new_message = new Message();

        new_message.setName(message_name);
        new_message.setMessage(message);

        //���÷���˷����������Ӧ
        String response = server.sendMessage(new_message);
        System.out.println(response);



    }
}
