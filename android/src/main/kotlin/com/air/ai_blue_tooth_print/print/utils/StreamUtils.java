package com.air.ai_blue_tooth_print.print.utils;

import android.util.Log;

import java.io.Closeable;
import java.io.IOException;

/**
 * 输入输出流工具类
 *
 * @author linfenliang
 * @version 1.0
 * @date 2018-01-03
 */

public class StreamUtils {
    public static final void colseQuietly(Closeable obj) {
        try {
            obj.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            obj = null;
        }
    }

    /**
     * @param obj
     * @param tag
     * @param msg
     * @author linfenliang
     * @date 2017-01-03
     * @version v1.0
     */
    public static final void colseQuietly(Closeable obj, String tag, String msg) {
        try {
            obj.close();
        } catch (IOException e) {
            Log.e(tag, msg, e);
        } finally {
            obj = null;
        }
    }
}
