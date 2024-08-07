package hello;

//创建带有名称和文本字段的Message类。

//定义了一个名为 Message 的类，包含了两个公共的成员变量 name 和 message，以及一些公共方法用于获取和设置这些变量的值。

public class Message
{
    public String name;
    public String message;

    //构造函数 Message() 是一个无参的构造函数，用于创建一个新的 Message 对象
    //Конструктор Message () - это конструктор без параметров, используемый для создания нового объекта Message

    //这个无参数构造函数在 Web 服务中也比较常见，因为在使用 Web 服务调用远程方法时，
    // 需要将传输的数据序列化成对象并传递给远程服务，因此无参数构造函数可以在创建对象时被调用。
    public Message() {}

    //setName(String name) 用于设置 name 成员变量的值
    void setName(String name)
    {
        this.name = name;
    }

    //setMessage(String message) 用于设置 message 成员变量的值
    void setMessage(String message)
    {
        this.message = message;
    }

    //getName() 用于获取 name 成员变量的值
    public String getName()
    {
        return this.name;
    }

    //getMessage() 用于获取 message 成员变量的值
    public String getMessage()
    {
        return this.message;
    }

}
