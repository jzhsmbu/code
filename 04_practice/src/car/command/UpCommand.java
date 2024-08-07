package car.command;

import car.Car;
import car.CarServer;

public class UpCommand extends MoveCommand{

    public UpCommand(Car car, int count){
        super(car, count, CarServer.Direction.UP);
    }

}
