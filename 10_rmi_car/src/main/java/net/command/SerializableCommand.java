package net.command;

import java.io.Serializable;

//这段代码的作用是定义一个可序列化的命令对象，可以用于在分布式系统中传递命令信息

/**
 * @author : Alex
 * @created : 23.03.2021, вторник
 **/
public class SerializableCommand implements Serializable {
    //carIndex：一个int类型的常量，表示汽车的索引。
    public final int carIndex;

    //commandName：一个String类型的常量，表示要执行的命令的名称。
    public final String commandName;

    //commandparameter：一个String类型的常量，表示要执行的命令的参数。
    public final String commandparameter;

    public SerializableCommand(int carIndex, String commandName, String commandparameter){
        this.carIndex = carIndex;
        this.commandName = commandName;
        this.commandparameter = commandparameter;

    }
}
