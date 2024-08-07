package car;

import car.command.*;

import java.awt.*;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * @author : Alex
 **/
public class Main {
    public static void main(String[] args) throws Exception
    {
        FieldMatrix fm = new FieldMatrix(10,15);
        CarPainter p = new CarPainter(fm);
        BasicCarServer carServer = new BasicCarServer(fm, p);
        Car car = carServer.createCar();
        car.setName("Alexey");
        car.setColor(Color.BLUE);


        ColorCommand ccommand = new ColorCommand(car, Color.GREEN);
        ccommand.execute();
        new NameCommand(car, "Class").execute();
        MoveCommand command;
        command = new DownCommand(car, 4);
        command.execute();
        command = new UpCommand(car, 4);
        command.execute();

        Script script = new Script();
        script.add(new ColorCommand(car, Color.BLUE));
        script.add(new NameCommand(car,"Queue"));
        script.add(new SpeedCommand(car,10));
        script.add(new DownRightCommand(car, 3));
        script.add(new SpeedCommand(car,250));
        script.add(new RightCommand(car, 7));
        script.add(new UpCommand(car, 4));
        script.add(new SpeedCommand(car,500));
        script.add(new DownLeftCommand(car, 60));

        Position pp = car.getPosition();


        script.execute();


    }
}
