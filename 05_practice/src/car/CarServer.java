package car;

public interface CarServer {
    enum Direction{
        UP,DOWN,LEFT,RIGHT,DOWNLEFT,DOWNRIGHT,UPLEFT,UPRIGHT
    }

    Car createCar();
    void destroyCar(Car car);
    boolean moveCarTo(Car car, Direction direction);

}
