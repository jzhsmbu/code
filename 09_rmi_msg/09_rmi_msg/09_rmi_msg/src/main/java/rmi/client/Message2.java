package rmi.client;

import rmi.common.Message;

//在客户端添加一个从Message继承的名为Message2的新类，该类除了包含字符串名称和消息外，还包含getName()方法，
// 该方法返回名称。通过给Message类的客户端对象分配相同的serialVersionUID并使用不变的函数objMessage()在服务器上接收Message2来实现。
public class Message2 extends Message
{

    //在Java中，serialVersionUID是一个特殊的变量，用于控制类的序列化和反序列化版本之间的兼容性。如果不指定serialVersionUID，
    // 则系统会根据类的结构和编译器的版本等信息自动生成一个版本号，这样可能会导致序列化和反序列化版本不一致的问题，从而导致程序出现问题。

    //在类的定义中，添加了一个私有静态常量serialVersionUID，用于在进行对象序列化和反序列化时，确保类的版本兼容性。
    // 如果不指定serialVersionUID，那么在反序列化过程中，如果类的定义发生了变化，会导致InvalidClassException异常。
    //
    //在本代码中，显式声明了serialVersionUID = 1L，表示类的序列化版本为1，如果类的定义发生了变化，只要序列化版本仍然为1，
    // 就不会抛出InvalidClassException异常，但是新添加的属性或修改的属性将不会被反序列化的对象读取。

    //serialVersionUID - это специальная переменная, используемая для контроля совместимости между
    // сериализованной и десериализованной версиями класса.
    //В этом коде serialVersionUID = 1 явно объявлен, чтобы указать, что сериализованная версия класса равна 1.
    // Если определение класса изменится, InvalidClassException не будет выброшен, пока сериализованная версия по-прежнему равна 1.
    private static final long serialVersionUID = 15L;

    public Message2(String name, String message)
    {
        super(name, message);// 调用父类构造函数
    }

    public String getName()
    {
        return name;
    }


}
