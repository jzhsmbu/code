package hello;

//�����������ƺ��ı��ֶε�Message�ࡣ

//������һ����Ϊ Message ���࣬���������������ĳ�Ա���� name �� message���Լ�һЩ�����������ڻ�ȡ��������Щ������ֵ��

public class Message
{
    public String name;
    public String message;

    //���캯�� Message() ��һ���޲εĹ��캯�������ڴ���һ���µ� Message ����
    //����ߧ����ܧ��� Message () - ���� �ܧ�ߧ����ܧ��� �ҧ֧� ��ѧ�ѧާ֧����, �ڧ���ݧ�٧�֧ާ�� �էݧ� ���٧էѧߧڧ� �ߧ�ӧ�ԧ� ��ҧ�֧ܧ�� Message

    //����޲������캯���� Web ������Ҳ�Ƚϳ�������Ϊ��ʹ�� Web �������Զ�̷���ʱ��
    // ��Ҫ��������������л��ɶ��󲢴��ݸ�Զ�̷�������޲������캯�������ڴ�������ʱ�����á�
    public Message() {}

    //setName(String name) �������� name ��Ա������ֵ
    void setName(String name)
    {
        this.name = name;
    }

    //setMessage(String message) �������� message ��Ա������ֵ
    void setMessage(String message)
    {
        this.message = message;
    }

    //getName() ���ڻ�ȡ name ��Ա������ֵ
    public String getName()
    {
        return this.name;
    }

    //getMessage() ���ڻ�ȡ message ��Ա������ֵ
    public String getMessage()
    {
        return this.message;
    }

}
