package car.command;

import car.Car;
import car.CarServer;

public abstract class MoveCommand implements Command{
    private final Car car;
    private final int count;
    private final CarServer.Direction direction;

    protected MoveCommand(Car car, int count, CarServer.Direction direction){
        this.car = car;
        this.count = count;
        this.direction = direction;
    }

    @Override
    public boolean execute(){
        for(int i = 0; i < count; i++) {
            if (!car.moveTo(direction)) return false;
        }
        return true;
    }

}
