package car;

import car.command.*;

import java.awt.*;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Random;


/**
 * @author : Alex
 **/
public class Main {
    public static void main(String[] args) throws Exception{
        InputStream is = CarPainter.class.getClassLoader().getResourceAsStream("field.txt");
        FieldMatrix fm = FieldMatrix.load(new InputStreamReader(is));
        //FieldMatrix fm = new FieldMatrix(10,10);
        CarPainter p = new CarPainter(fm);
        BasicCarServer carServer = new BasicCarServer(fm, p);
        Car car = carServer.createCar();


        is = CarPainter.class.getClassLoader().getResourceAsStream("script.txt");
        Script script = Script.load(new InputStreamReader(is), car);
        //script.add(new DownCommand(car, 6));
        script.execute();
    }
}
