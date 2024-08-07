package car.command;

import car.Car;
import car.util.ColorFactory;

import java.awt.*;

public class BlinkCommand implements Command{
    private final Car car;
    private final Color blinkColor;

    public BlinkCommand(Car car, Color blinkColor){
        this.car = car;
        this.blinkColor = blinkColor;
    }

    @Override
    public boolean execute() {
        Color oldColor = car.getColor();
        for(int i = 0; i<10;i++) {
            car.setColor(blinkColor);
            try {
                Thread.sleep(500);
                System.out.println("blink!!!");
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            car.setColor(oldColor);
        }
        return true;
    }
}
