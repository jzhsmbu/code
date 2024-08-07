package car.command;

import car.Car;
import car.util.ColorFactory;

import java.awt.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.*;
import java.util.List;

public class Script {
    private static Properties classnames = new Properties();

    static{
        try {
            InputStream is = Script.class.getClassLoader().getResourceAsStream("commands.txt");
            classnames.load(is);
            System.out.println(classnames);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    List<Command> commands;

    public Script(){
        commands = new ArrayList<>();
    }

    public void add(Command command){
        commands.add(command);
    }

    public void execute(){
        for(Command command : commands){
            command.execute();
        }
    }

    public static Script load(InputStreamReader isr, Car car){
        try (Scanner scanner = new Scanner(isr) ) {
            Script script = new Script();
            while(scanner.hasNextLine()){
                String line = scanner.nextLine();
                StringTokenizer st = new StringTokenizer(line);
                String command = st.nextToken();
                String parameter = st.nextToken();
                //System.out.println("command = "+command+" paramener="+parameter);
                String classname = classnames.getProperty(command);
                Class classz = Class.forName(classname);
                Constructor[] constructors = classz.getConstructors();
                //System.out.println(Arrays.asList(constructors));

                Command com = (Command)constructors[0].newInstance(car, parameter);
                //System.out.println("com="+com);
                script.add(com);
            }
            return script;
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }

    }

}
