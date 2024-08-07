package car.command;

import car.Car;
import car.CarServer;

public class LeftCommand extends MoveCommand{
    public LeftCommand(Car car, int count){
        super(car, count, CarServer.Direction.LEFT);
    }
}
