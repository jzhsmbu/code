package car.command;

import car.Car;
import java.awt.Color;

public class ColorCommand implements Command{
    private final Car car;
    private final Color color;

    public ColorCommand(Car car, Color color){
        this.car = car;
        this.color = color;
    }

    @Override
    public boolean execute() {
        car.setColor(color);
        return true;
    }
}
