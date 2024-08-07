package car.command;

import car.Car;
import car.CarServer;

public class UpCommand extends MoveCommand{

    public UpCommand(Car car, String count){
        super(car, Integer.parseInt(count), CarServer.Direction.UP);
    }

}
