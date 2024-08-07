package car.command;

import car.Car;
import car.CarServer;

public class DownCommand extends MoveCommand{

    public DownCommand(Car car, String count){
        super(car, Integer.parseInt(count), CarServer.Direction.DOWN);
    }

}
