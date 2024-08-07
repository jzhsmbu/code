package car.command;

import car.Car;
import car.CarServer;

public class RightCommand extends MoveCommand{

    public RightCommand(Car car, String count){
        super(car, Integer.parseInt(count), CarServer.Direction.RIGHT);
    }
}
