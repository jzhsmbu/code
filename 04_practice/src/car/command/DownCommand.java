package car.command;

import car.Car;
import car.CarServer;

public class DownCommand extends MoveCommand{

    public DownCommand(Car car, int count){
        super(car, count, CarServer.Direction.DOWN);
    }

}
