package rmi.common;

import java.io.Serializable;

//在服务器端添加一个名为Message的新类，包含name和message字符串。
public class Message implements Serializable {
    public String name;
    public String message;

    public Message(String name, String message)
    {
        this.message = message;
        this.name = name;
    }
}
