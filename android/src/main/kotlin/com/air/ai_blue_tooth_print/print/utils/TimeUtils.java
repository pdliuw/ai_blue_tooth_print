package com.air.ai_blue_tooth_print.print.utils;

/**
 * @author air
 */
public class TimeUtils {

    public static void WaitMs(long ms) {
        long time = System.currentTimeMillis();
        while (System.currentTimeMillis() - time < ms) ;
    }
}
