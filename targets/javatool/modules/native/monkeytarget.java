import java.util.concurrent.*;
import java.awt.image.*;
import javax.imageio.*;

class BBJavaToolGame extends BBGame {

    static BBJavaToolGame _javaToolGame;

    GameTimer _timer;
    static ScheduledExecutorService _scheduler;

    String _savedState = "";

    public BBJavaToolGame() {
        _javaToolGame = this;
    }

    public static BBJavaToolGame JavaToolGame() {
        return _javaToolGame;
    }

    // ***** Timing *****

    static class GameTimer implements Runnable {

        long nextUpdate;
        long updatePeriod;
        boolean cancelled;

        public GameTimer(int fps) {
            updatePeriod = 1000000000 / fps;
            nextUpdate = System.nanoTime();
            if (_scheduler == null) {
                _scheduler = Executors.newSingleThreadScheduledExecutor();
            }
            _scheduler.schedule(this, updatePeriod, TimeUnit.NANOSECONDS);
        }

        public void cancel() {
            cancelled = true;
        }

        public void run() {
            try {
                if (cancelled)
                    return;

                int updates;
                for (updates = 0; updates < 4; ++updates) {
                    nextUpdate += updatePeriod;

                    _javaToolGame.UpdateGame();
                    if (cancelled)
                        return;

                    if (nextUpdate - System.nanoTime() > 0)
                        break;
                }

                _javaToolGame.RenderGame();

                if (cancelled)
                    return;

                if (updates == 4) {
                    nextUpdate = System.nanoTime();
                    _scheduler.schedule(this, 0, TimeUnit.NANOSECONDS);
                } else {
                    long delay = nextUpdate - System.nanoTime();
                    _scheduler.schedule(this, delay > 0 ? delay : 0, TimeUnit.NANOSECONDS);
                }
            } catch (Throwable e) {
                bb_std_lang.print("Monkey Runtime Error : Uncaught Monkey Exception");
                e.printStackTrace();

                _scheduler.shutdown();
                System.exit(1);
            }
        }
    }

    void ValidateUpdateTimer() {
        if (_timer != null) {
            _timer.cancel();
            _timer = null;
        }
        if (_updateRate != 0 && !_suspended) {
            _timer = new GameTimer(_updateRate);
        }
    }

    void Run() {
        if (Delegate() == null) {
            // No app, skip...
        } else {
            if (!Started())
                StartGame();
        }
    }

    // ***** BBGame ******

    public void SetUpdateRate(int hertz) {
        super.SetUpdateRate(hertz);
        ValidateUpdateTimer();
    }

    public int SaveState(String state) {
        _savedState = state;
        return 1;
    }

    public String LoadState() {
        return _savedState;
    }

    String PathToFilePath(String path) {
        if (!path.startsWith("monkey://")) {
            return path;
        } else if (path.startsWith("monkey://internal/")) { // NOT SUPPORTED YET
            return path.substring(18);
        } else if (path.startsWith("monkey://external/")) { // NOT SUPPORTED YET
            return path.substring(18);
        }
        return "";
    }

    String PathToAssetPath(String path) {
        if (path.startsWith("monkey://data/"))
            return "assets/" + path.substring(14);
        return "";
    }

    public InputStream OpenInputStream(String path) {
        if (!path.startsWith("monkey://data/"))
            return super.OpenInputStream(path);
        try {
            return new FileInputStream(PathToAssetPath(path));
        } catch (IOException ex) {
        }
        return null;
    }

    public BufferedImage LoadBitmap(String path) {
        try {
            InputStream in = OpenInputStream(path);
            if (in == null)
                return null;

            BufferedImage img = ImageIO.read(in);
            in.close();

            return img;
        } catch (IOException e) {
        }
        return null;
    }

    // ***** INTERNAL *****

    public void SuspendGame() {
        super.SuspendGame();
        ValidateUpdateTimer();
    }

    public void ResumeGame() {
        super.ResumeGame();
        ValidateUpdateTimer();
    }
}
