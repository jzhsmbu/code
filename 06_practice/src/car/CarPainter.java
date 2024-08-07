package car;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;

import static javax.swing.WindowConstants.EXIT_ON_CLOSE;

public class CarPainter extends JPanel implements CarEventsListener {

    private final FieldMatrix fieldMatrix;
    private final static int defaultCellSize = 50;
    private final static int minGap = 20;

    private final java.util.List<Car> cars;

    public CarPainter(FieldMatrix fieldMatrix) {
        super();
        cars = new ArrayList<>();
        this.fieldMatrix = fieldMatrix;
        JFrame f = new JFrame("Cars");
        setBackground(Color.LIGHT_GRAY);
        f.setSize(fieldMatrix.cols * defaultCellSize + 2 * minGap,
                fieldMatrix.rows * defaultCellSize + 2 * minGap);
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
        int gridWidth = screenWidth - 2 * minGap;
        int gridHeight = screenHeight - 2 * minGap;
        int step = Math.min(gridWidth / fieldMatrix.cols, gridHeight / fieldMatrix.rows);

        int verticalGap = (gridHeight - step * fieldMatrix.rows) / 2 + minGap;
        int horizontalGap = (gridWidth - step * fieldMatrix.cols) / 2 + minGap;
        int left = horizontalGap;
        int top = verticalGap;
        int right = left + fieldMatrix.cols * step;
        int bottom = top + fieldMatrix.rows * step;

        // Drawing vertical lines
        for (int i = 0; i <= fieldMatrix.cols; i++) {
            g.drawLine(left + i * step, top, left + i * step, bottom);
        }
        // Drawing horizontal lines
        for (int i = 0; i <= fieldMatrix.rows; i++) {
            g.drawLine(left, top + i * step, right, top + i * step);
        }

        for (int i = 0; i < fieldMatrix.rows; i++)
            for (int j = 0; j < fieldMatrix.cols; j++) {
                if (fieldMatrix.getCellState(i, j) == FieldMatrix.CellState.WALL) {
                    g.setColor(Color.RED);
                    g.fill3DRect(left + j * step, top + i * step, step, step, false);
                    g.setColor(Color.BLACK);
                }
            }
        for (Car car : cars) {
            Position p = car.getPosition();
            g.setColor(car.getColor());
            g.fill3DRect(left + p.col * step, top + p.row * step, step, step, false);
            if (car.getName() != null) {
                int stringWidth = fm.stringWidth(car.getName());
                g.setColor(Color.WHITE);
                g.drawString(car.getName(), left + p.col * step + (step - stringWidth) / 2,
                        top + p.row * step + step / 2);
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
