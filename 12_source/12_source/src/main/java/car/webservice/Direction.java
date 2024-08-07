
package car.webservice;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>direction的 Java 类。
 * 
 * <p>以下模式片段指定包含在此类中的预期内容。
 * <p>
 * <pre>
 * &lt;simpleType name="direction"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;enumeration value="UP"/&gt;
 *     &lt;enumeration value="DOWN"/&gt;
 *     &lt;enumeration value="LEFT"/&gt;
 *     &lt;enumeration value="RIGHT"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "direction")
@XmlEnum
public enum Direction {

    UP,
    DOWN,
    LEFT,
    RIGHT;

    public String value() {
        return name();
    }

    public static Direction fromValue(String v) {
        return valueOf(v);
    }

}
