package car.command;

import car.Car;
import car.CarServer;

public class DownRightCommand extends MoveCommand{

    public DownRightCommand(Car car, int count){
        super(car, count, CarServer.Direction.DOWNRIGHT);
    }

}