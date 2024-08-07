package car;

import java.util.ArrayList;
import java.util.List;

public class BasicCarServer implements CarServer {
    protected final FieldMatrix fieldMatrix;
    protected final List<Car> cars;
    protected final CarEventsListener carEventsListener;

    protected BasicCarServer(FieldMatrix fieldMatrix, CarEventsListener carEventsListener){
        cars = new ArrayList<>();
        this.fieldMatrix = fieldMatrix;
        this.carEventsListener = carEventsListener;
    }

    @Override
    public Car createCar() {
        Position freeCell = fieldMatrix.occupyFirstFreeCellByCar();
        Car car = new Car(this, freeCell);
        cars.add(car);
        carEventsListener.carCreated(car);
        return car;
    }

    @Override
    public void destroyCar(Car car) {
        cars.remove(car);
        carEventsListener.carDestroyed(car);
    }

    @Override
    public boolean moveCarTo(Car car, Direction direction) {
        Position from = car.getPosition();
        Position to = from.move(direction);

        if((from.move(direction).row >= fieldMatrix.rows || to.row <= 0)
                || (to.col >= fieldMatrix.cols || to.col <= 0 ))
        {
            return false;
        }
        else
        {
            boolean ret = fieldMatrix.moveCarTo(from.row, from.col, to.row, to.col);
            carEventsListener.carMoved(car,from,to,ret);
            return ret;
        }



    }

}
