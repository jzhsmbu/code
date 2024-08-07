package car.command;

import car.Car;

import java.awt.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Constructor;
import java.util.*;
import java.util.List;

public class Script {
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
                System.out.println("command = "+command+" paramener="+parameter);
                switch (command){
                    case "DOWN":
                        script.add(new DownCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "UP":
                        script.add(new UpCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "LEFT":
                        script.add(new LeftCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "RIGHT":
                        script.add(new RightCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "DOWNRIGHT":
                        script.add(new DownRightCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "DOWNLEFT":
                        script.add(new DownLeftCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "UPRIGHT":
                        script.add(new UpRightCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "UPLEFT":
                        script.add(new UpLeftCommand(car, Integer.parseInt(parameter)));
                        break;
                    case "CHANGECOLOR":
                        switch(parameter)
                        {
                            case "blue":
                                script.add(new ColorCommand(car, Color.BLUE));
                                break;
                            case "black":
                                script.add(new ColorCommand(car, Color.BLACK));
                                break;
                            case "green":
                                script.add(new ColorCommand(car, Color.GREEN));
                                break;
                            default:
                                System.out.println("Unknown color = "+parameter);
                        }
                    break;
                    case "NAME":
                        script.add(new NameCommand(car,parameter));
                        break;
                    case "BLINK":
                        switch(parameter)
                        {
                            case "blue":
                                script.add(new BlinkCommand(car, Color.BLUE));
                                break;
                            case "black":
                                script.add(new BlinkCommand(car, Color.BLACK));
                                break;
                            case "green":
                                script.add(new BlinkCommand(car, Color.GREEN));
                                break;
                            default:
                                System.out.println("Unknown blink color = "+parameter);
                        }
                    break;
                    default:
                        System.out.println("Unknown command = "+command);
                }
            }
            return script;
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }

    }

}
