package car.command;

import car.Car;

public class NameCommand implements Command{
    private final Car car;
    private final String name;

    public NameCommand(Car car, String name){
        this.car = car;
        this.name= name;
    }

    @Override
    public boolean execute(){
        car.setName(name);
        return true;
    }

}
