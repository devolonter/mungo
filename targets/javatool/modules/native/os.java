import java.io.*;
import java.nio.channels.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class JavaToolOS {
    static String[] _args;
    static File _currentDir = new File(System.getProperty("user.dir"));
    static Map<String, String> _processEnv = new HashMap<String, String>();

    static String _fixPath(String path) {
        File n = null;
        if (path.charAt(0) == '/') {
            // Unix absolute path
            n = new File(_realPath(path));
        } else if (path.length() >= 3 && path.charAt(1) == ':' && path.charAt(2) == '\\') {
            // Windows absolute path
            n = new File(_realPath(path));
        } else {
            // relative path
            n = new File(_realPath(_currentDir.getAbsolutePath() + "/" + path));
        }

        return n.toString();
    }

    static void _printThread(final InputStream in) {
        new Thread() {
            public void run() {
                try {
                    while (true) {
                        int x = in.read();
                        if (x < 0) {
                            return;
                        }
                        System.out.write(x);
                    }
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }.start();
    }

    static String _realPath(String path) {
        try {
            return new File(path).getCanonicalPath();
        } catch (IOException e) {
            return path;
        }
    }

    static Pattern _splitPattern = Pattern.compile("\\s*(\"[^\"]+\"|[^\\s\"]+)");

    static String[] _splitCmd(String cmd) {
        ArrayList<String> args = new ArrayList<String>();

        Matcher matcher = _splitPattern.matcher(cmd);
        while (matcher.find()) {
            args.add(matcher.group().trim().replaceAll("^\"|\"$", ""));
        }

        return args.toArray(new String[args.size()]);
    }

    // ==========================================================================
    // Monkey API
    // ==========================================================================

    static String AppPath() {
        if (GetEnv("MONKEY_APP_PATH").length() > 0) {
            // helper environment variable
            return GetEnv("MONKEY_APP_PATH");
        } else {
            return new File(System.getProperty("user.dir")).getAbsolutePath() + "/java";
        }
    }

    static String[] AppArgs() {
        if (_args == null) {
            _args = new String[Main.args.length + 1];
            _args[0] = AppPath();
            System.arraycopy(Main.args, 0, _args, 1, Main.args.length);
        }
        return _args;
    }

    static int ChangeDir(String path) {
        if (path.charAt(0) == '/') {
            // Unix absolute path
            _currentDir = new File(RealPath(path));
        } else if (path.length() >= 3 && path.charAt(1) == ':' && path.charAt(2) == '\\') {
            // Windows absolute path
            _currentDir = new File(RealPath(path));
        } else {
            // relative path
            _currentDir = new File(RealPath(_currentDir.getAbsolutePath() + "/" + path));
        }

        return 0;
    }

    static int CopyFile(String srcpath, String dstpath) {
        srcpath = _fixPath(srcpath);
        dstpath = _fixPath(dstpath);

        File srcFile = new File(srcpath);
        File destFile = new File(dstpath);

        if (!destFile.exists()) {
            try {
                destFile.createNewFile();
            } catch (IOException e) {
                return 0;
            }
        }

        FileChannel source = null;
        FileChannel destination = null;

        try {
            source = new FileInputStream(srcFile).getChannel();
            destination = new FileOutputStream(destFile).getChannel();
            destination.transferFrom(source, 0, source.size());

            return 1;
        } catch (IOException e) {
            // ignore
        } finally {
            if (source != null) {
                try {
                    source.close();
                } catch (IOException e) {
                    // ignore
                }
            }
            if (destination != null) {
                try {
                    destination.close();
                } catch (IOException e) {
                    // ignore
                }
            }
        }

        return 0;
    }

    static int CreateDir(String path) {
        path = _fixPath(path);
        new File(path).mkdir();
        return new File(path).isDirectory() ? 1 : 0;
    }

    static String CurrentDir() {
        return _currentDir.toString();
    }

    static int DeleteDir(String path) {
        path = _fixPath(path);
        new File(path).delete();
        return (new File(path)).exists() ? 0 : 1;
    }

    static int DeleteFile(String path) {
        path = _fixPath(path);
        new File(path).delete();
        return (new File(path)).exists() ? 0 : 1;
    }

    static int Execute(String cmd) {
        ProcessBuilder pb = new ProcessBuilder(_splitCmd(cmd));
        Map<String, String> env = pb.environment();
        for (String k : _processEnv.keySet()) {
            env.put(k, _processEnv.get(k));
        }
        pb.directory(_currentDir);
        pb.redirectErrorStream(true);

        int r = 0;
        try {
            Process p = pb.start();
            _printThread(p.getInputStream());

            r = p.waitFor();
        } catch (IOException e) {
            // ignore
        } catch (InterruptedException e) {
            // ignore
        }

        return r;
    }

    static int ExitApp(int retcode) {
        System.exit(retcode);
        return 0;
    }

    static int FileSize(String path) {
        path = _fixPath(path);
        File f = new File(path);
        if (!f.exists()) {
            return -1;
        }
        return (int) f.length();
    }

    static int FileTime(String path) {
        path = _fixPath(path);
        File f = new File(path);
        if (!f.exists()) {
            return -1;
        }
        return (int) (f.lastModified() / 1000L);
    }

    static int FileType(String path) {
        path = _fixPath(path);
        File f = new File(path);
        if (!f.exists()) {
            return 0;
        } else if (f.isFile()) {
            return 1;
        } else if (f.isDirectory()) {
            return 2;
        } else {
            return 0; // never
        }
    }

    static String GetEnv(String name) {
        String r = _processEnv.get(name);
        if (r != null) {
            return r;
        }
        r = System.getenv(name);
        return r == null ? "" : r;
    }

    static String HostOS() {
        String osName = System.getProperty("os.name");
        if (osName.indexOf("Windows") > -1) {
            return "winnt";
        } else if (osName.indexOf("Linux") > -1 || osName.indexOf("LINUX") > -1) {
            return "linux";
        } else if (osName.indexOf("Mac") > -1) {
            return "macos";
        } else {
            return "";
        }
    }

    static String LoadString(String path) {
        path = _fixPath(path);

        RandomAccessFile randomAccessFile = null;
        try {
            randomAccessFile = new RandomAccessFile(path, "r");
            byte[] buf = new byte[(int) randomAccessFile.length()];
            randomAccessFile.readFully(buf);
            return new String(buf);
        } catch (FileNotFoundException e) {
            // ignore
        } catch (IOException e) {
            // ignore
        } finally {
            if (randomAccessFile != null) {
                try {
                    randomAccessFile.close();
                } catch (IOException ex) {
                    // ignore
                }
            }
        }

        return "";
    }

    static String[] LoadDir(String path) {
        path = _fixPath(path);

        ArrayList<String> filenames = new ArrayList<String>();

        File root = new File(path);
        File[] list = root.listFiles();

        if (list == null)
            return new String[0];

        for (File f : list) {
            if (f.isFile() || f.isDirectory()) {
                filenames.add(f.getName());
            }
        }

        return filenames.toArray(new String[filenames.size()]);
    }

    static String RealPath(String path) {
        return _fixPath(path);
    }

    static int SaveString(String str, String path) {
        path = _fixPath(path);

        PrintStream out = null;
        try {
            out = new PrintStream(new FileOutputStream(path));
            out.print(str);
        } catch (FileNotFoundException e) {
            return -1;
        } finally {
            if (out != null)
                out.close();
        }

        return 0;
    }

    static int SetEnv(String name, String value) {
        _processEnv.put(name, value);
        return 0;
    }
}
