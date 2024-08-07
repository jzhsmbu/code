package car;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;

import static javax.swing.WindowConstants.EXIT_ON_CLOSE;

public class CarPainter extends JPanel implements CarEventsListener {

    private final FieldMatrix fieldMatrix;
    private final static int preferedCellSize = 50;
    private final static int preferedGap = 20;

    private final java.util.List<Car> cars;

    public CarPainter(FieldMatrix fieldMatrix) {
        super();
        cars = new ArrayList<>();
        this.fieldMatrix = fieldMatrix;
        JFrame f = new JFrame("Cars");
        setBackground(Color.LIGHT_GRAY);
        f.setSize(fieldMatrix.cols * preferedCellSize + 2 * preferedGap,
                fieldMatrix.rows * preferedCellSize + 2 * preferedGap);
        f.add(this);
        f.setDefaultCloseOperation(EXIT_ON_CLOSE);
        f.setVisible(true);
    }

    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        int screenWidth = getWidth();
        int screenHeight = getHeight();
        FontMetrics fm = g.getFontMetrics();
        g.setColor(Color.BLACK);
        int width = screenWidth - 2 * preferedGap;
        int height = screenHeight - 2 * preferedGap;
        int step = Math.min(width / fieldMatrix.rows, height / fieldMatrix.cols);
        int left = (width - step * fieldMatrix.cols) / 2;
        int top = (height - step * fieldMatrix.rows) / 2;
        for (int i = 0; i <= fieldMatrix.rows; i++)
            for (int j = 0; j <= fieldMatrix.cols; j++) {
                g.drawLine(left + j * step + preferedGap, top + i * step + preferedGap, left + fieldMatrix.cols * step,
                        top + i * step + preferedGap);
                g.drawLine(left + j * step + preferedGap, top + i * step + preferedGap, left + j * step + preferedGap,
                        top + fieldMatrix.rows * step);
                if (i < fieldMatrix.rows && j < fieldMatrix.cols
                        && fieldMatrix.getCellState(i, j) == FieldMatrix.CellState.WALL) {
                    g.setColor(Color.RED);
                    g.fill3DRect(left + j * step + preferedGap, top + i * step + preferedGap, step, step, false);
                    g.setColor(Color.BLACK);
                }
            }
        for (Car car : cars) {
            Position p = car.getPosition();
            g.setColor(car.getColor());
            g.fill3DRect(left + p.col * step + preferedGap, top + p.row * step + preferedGap, step, step, false);
            if (car.getName() != null) {
                int stringWith = fm.stringWidth(car.getName());
                g.setColor(Color.WHITE);
                g.drawString(car.getName(), left + p.col * step + preferedGap + (step - stringWith) / 2,
                        top + p.row * step + preferedGap + step / 2);
            }

        }
    }

    @Override
    public void carCreated(Car car) {
        cars.add(car);
    }

    @Override
    public void carDestroyed(Car car) {
        cars.remove(car);
    }

    @Override
    public void carMoved(Car car, Position from, Position to, boolean success) {
        repaint();
    }

}
