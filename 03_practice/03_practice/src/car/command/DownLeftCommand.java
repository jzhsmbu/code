package car.command;

import car.Car;
import car.CarServer;

public class DownLeftCommand extends MoveCommand{

    public DownLeftCommand(Car car, int count){
        super(car, count, CarServer.Direction.DOWNLEFT);
    }

}