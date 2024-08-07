package car;

public interface CarEventsListener {
    void carCreated(Car car);
    void carDestroyed(Car car);
    void carMoved(Car car, Position from, Position to, boolean success);
    void carParameterChanged(Car car);
}
