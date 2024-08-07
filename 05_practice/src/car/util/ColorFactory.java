package car.util;

import java.awt.*;
import java.lang.reflect.Field;

public class ColorFactory {
    private static Class classz = Color.class;
    private static Color defaultColor = Color.RED;

    public static Color getColor(String colorName){ // Green --> GREEN
        try {
            Field field  = classz.getDeclaredField(colorName.toUpperCase());
            return (Color)field.get(null);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return defaultColor;
    }
}
