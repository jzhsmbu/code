package car.command;

import car.Car;
import car.CarServer;

public class UpLeftCommand extends MoveCommand{

    public UpLeftCommand(Car car, int count){
        super(car, count, CarServer.Direction.UPLEFT);
    }

}