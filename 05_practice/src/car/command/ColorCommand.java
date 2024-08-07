package car.command;

import car.Car;
import car.util.ColorFactory;

import java.awt.Color;

public class ColorCommand implements Command{
    private final Car car;
    private final Color color;

    public ColorCommand(Car car, Color colorName){
        this.car = car;
        this.color = colorName;
    }

    @Override
    public boolean execute() {
        car.setColor(color);
        return true;
    }
}
