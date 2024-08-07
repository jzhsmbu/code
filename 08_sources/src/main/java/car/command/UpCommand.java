package car.command;

import car.Car;
import car.CarServer;

public class UpCommand extends MoveCommand{
    public UpCommand(Integer parameter, Car car){
        super(parameter, car, CarServer.Direction.UP);
    }

    static{
        factory.put(UpCommand.class, (param, car)->new UpCommand(Integer.parseInt(param),car));
    }
}
