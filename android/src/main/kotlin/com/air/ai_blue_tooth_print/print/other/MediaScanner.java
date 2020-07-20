package com.air.ai_blue_tooth_print.print.other;

import android.content.Context;
import android.media.MediaScannerConnection;
import android.net.Uri;

import java.io.File;

/**
 * @author air
 */

public class MediaScanner implements MediaScannerConnection.MediaScannerConnectionClient {

    private MediaScannerConnection mMSC;
    private File mImageFile;

    @Override
    public void onMediaScannerConnected() {
        mMSC.scanFile(mImageFile.getAbsolutePath(), "image");
    }

    @Override
    public void onScanCompleted(String s, Uri uri) {
        mMSC.disconnect();
    }

    public MediaScanner(Context context, File file) {
        this.mImageFile = file;
        if (mMSC == null) {
            mMSC = new MediaScannerConnection(context, this);
        }

    }

    public void refresh() {
        if (mMSC != null && !mMSC.isConnected()) {
            mMSC.connect();
        }
    }

}
