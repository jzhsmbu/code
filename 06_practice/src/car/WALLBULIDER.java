package car;

import java.util.Random;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class WALLBULIDER implements Runnable
{
    private final FieldMatrix fieldMatrix;
    private boolean isrun;
    private Random random;

    public WALLBULIDER(FieldMatrix fm)
    {
        this.fieldMatrix = fm;
        this.isrun = true;
        this.random = new Random();
    }

    //ScheduledExecutorService是基于ExecutorService的功能实现的延迟和周期执行任务的功能。每个任务以及每个任务的每个周期都会提交到线程池中
    //由线程去执行，所以任务在不同周期内执行它的线程可能是不同的。ScheduledExecutorService接口的默认实现类是ScheduledThreadPoolExecutor。
    //在周期执行的任务中，如果任务执行时间大于周期时间，则会以任务时间优先，等任务执行完毕后才会进入下一次周期。

    //我们创建了一个 ScheduledExecutorService，然后使用 scheduleAtFixedRate 方法定期运行一个 lambda 表达式。
    //该 lambda 表达式将随机选择一个位置并添加或移除墙。第一个参数是要运行的代码，第二个参数是延迟时间(Delay time)（以毫秒为单位），
    //第三个参数是运行代码的频率(Frequency of running code)（以毫秒为单位）。这里我们使用了 random.nextInt(1000) 作为延迟时间和运行代码的频率，
    //因此代码将在添加/删除墙之前等待一段随机时间。
    public void run() {
        // 创建一个单线程的 ScheduledExecutorService
        ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
        // 使用 scheduleAtFixedRate 方法定期运行一个 lambda 表达式
        scheduler.scheduleAtFixedRate(() -> {
            // 在随机位置添加或移除墙
            int row = random.nextInt(fieldMatrix.rows);
            int col = random.nextInt(fieldMatrix.cols);

            synchronized (fieldMatrix)
            { // 加入 synchronized 代码块，并锁定 fieldMatrix 对象
                if (fieldMatrix.getCellState(row, col) != FieldMatrix.CellState.WALL)
                {
                    fieldMatrix.cells[row][col] = FieldMatrix.CellState.WALL;
                }
                else
                {
                    fieldMatrix.cells[row][col] = FieldMatrix.CellState.EMPTY;
                }
            }
        }, 0, random.nextInt(100), TimeUnit.MILLISECONDS);
    }
}

