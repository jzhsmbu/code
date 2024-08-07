package car.command;

import car.Car;

public class SetNameCommand extends Command<String> {

    static{
        factory.put(SetNameCommand.class, (param, car)->new SetNameCommand(param,car));
    }

    public SetNameCommand(String parameter, Car car){
        super(parameter,car);
    }

    @Override
    public boolean execute() {
        car.setName(parameter);
        return true;
    }
}
