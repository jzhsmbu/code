package car;

public interface CarServer {
    enum Direction{
        UP,DOWN,LEFT,RIGHT,DOWNRIGHT,DOWNLEFT,UPRIGHT,UPLEFT
    }

    Car createCar();
    void destroyCar(Car car);
    boolean moveCarTo(Car car, Direction direction);

}
