package car.command;

import car.Car;
import car.CarServer;

public class UpRightCommand extends MoveCommand{

    public UpRightCommand(Car car, int count){
        super(car, count, CarServer.Direction.UPRIGHT);
    }

}