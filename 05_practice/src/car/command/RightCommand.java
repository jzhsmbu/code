package car.command;

import car.Car;
import car.CarServer;

public class RightCommand extends MoveCommand{

    public RightCommand(Car car, int count){
        super(car, count, CarServer.Direction.RIGHT);
    }
}
