package car.util;

import java.awt.*;
import java.lang.reflect.Field;

public class ColorFactory {
    private static final Color defColor = Color.BLACK;

    public static Color getColor(String colorName){
        Color color;
        try {
            Field field = Class.forName("java.awt.Color").getField(colorName);
            color = (Color)field.get(null);
        } catch (Exception e) {
            color = defColor; // Not defined
        }
        return color;
    }
}
