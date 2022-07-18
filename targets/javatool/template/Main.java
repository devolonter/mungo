
//${PACKAGE_BEGIN}
package com.monkeycoder.javatool;
//${PACKAGE_END}

//${IMPORTS_BEGIN}
//${IMPORTS_END}

class MonkeyConfig {
//${CONFIG_BEGIN}
//${CONFIG_END}
}

//${TRANSCODE_BEGIN}
//${TRANSCODE_END}

public class Main {
    static String[] args;

    public static void main(String[] args) {
        try {
            Main.args = args;

            Boolean gameTarget = (MonkeyConfig.JAVATOOL_BRL_GAMETARGET == "1");
            if (gameTarget) {
                new BBJavaToolGame();
            }

            bb_.bbInit();
            bb_.bbMain();

            if (gameTarget) {
                BBJavaToolGame.JavaToolGame().Run();
            }
        } catch (Throwable e) {
            bb_std_lang.print("Monkey Runtime Error : Uncaught Monkey Exception");
            e.printStackTrace();

            System.exit(1);
        }
    }
}
