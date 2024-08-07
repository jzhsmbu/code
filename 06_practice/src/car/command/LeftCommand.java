package car.command;

import car.Car;
import car.CarServer;

public class LeftCommand extends MoveCommand{
    public LeftCommand(Car car, String count){
        super(car, Integer.parseInt(count), CarServer.Direction.LEFT);
    }
}
