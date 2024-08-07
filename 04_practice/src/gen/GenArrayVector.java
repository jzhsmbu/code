package gen;

public class GenArrayVector {
    Object[] data;
    int size;
    public GenArrayVector(int size){
        data = new Object[size];
        this.size = size;
    }

    public <T> void set(int index, T element){
        data[index] = element;
    }
    public <T> T get(int index){
        return (T)data[index];
    }
    @Override
    public String toString(){
        String s = "{";
        for(int i = 0; i < size; i++) s = s + data[i]+" ";
        s = s + "}";
        return s;
    }

    public static void main(String[] args) {
        GenArrayVector vi = new GenArrayVector(10);
        for(int i = 0; i<10; i++) vi.set(i, i*2);
        vi.set(0,"test");
        System.out.println(vi);
    }

}
