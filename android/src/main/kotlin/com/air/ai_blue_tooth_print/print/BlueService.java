package com.air.ai_blue_tooth_print.print;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.os.Handler;
import android.util.Log;


import com.air.ai_blue_tooth_print.print.other.DataHandleHelper;
import com.air.ai_blue_tooth_print.print.utils.FileUtils;
import com.air.ai_blue_tooth_print.print.utils.StreamUtils;

import org.apache.commons.io.IOUtils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.UUID;

/**
 * Created by ada on 2016/6/3.
 */


public class BlueService {
    private static final UUID MY_UUID_SECURE =
            UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
    private static final UUID MY_UUID_INSECURE =
            UUID.fromString("8cf255c0-200a-11e0-ac64-0800200c9a66");

    public static final int START_RECEIVE = 101;
    public static final int RECEIVE_COMPLETE = 102;
    public static final int CONN_FAIL = 103;
    public static final int CONN_ERROR = 104;
    public static final int DATA_PARSER_SUCCESSFUL = 105;
    public static final int DATA_PARSER_FAILED = 106;

    private final String TAG = "flag";
    private Context context;
    private Handler mHandler;
    private BluetoothAdapter mAdapter;

    private ConnectThread mConnectThread;
    private ConnectedThread mConnectedThread;
    private boolean isDebugger = true;


    public BlueService(Context context, Handler mhandler) {
        this.context = context;
        this.mHandler = mhandler;
        mAdapter = BluetoothAdapter.getDefaultAdapter();
    }

    public synchronized void start() {
        // Cancel any thread attempting to make a connection
        if (mConnectThread != null) {
            mConnectThread.cancel();
            mConnectThread = null;
        }

        // Cancel any thread currently running a connection
        if (mConnectedThread != null) {
            mConnectedThread.cancel();
            mConnectedThread = null;
        }
    }

    private class ConnectThread extends Thread {
        private final BluetoothSocket mmSocket;
        private final BluetoothDevice mmDevice;
        private String mSocketType;


        @SuppressLint("MissingPermission")
        public ConnectThread(BluetoothDevice device, boolean secure) {
            mmDevice = device;

            BluetoothSocket tmpSocket = null;
            mSocketType = secure ? "Secure" : "Insecure";

            // Get a BluetoothSocket for a connection with the
            // given BluetoothDevice
            try {
                if (secure) {
                    tmpSocket = device.createRfcommSocketToServiceRecord(
                            MY_UUID_SECURE);
                } else {
                    tmpSocket = device.createInsecureRfcommSocketToServiceRecord(
                            MY_UUID_SECURE);
                }
            } catch (IOException e) {
                Log.e(TAG, "Socket Type: " + mSocketType + "create() failed", e);
            }
            mmSocket = tmpSocket;
        }

        public void run() {
            Log.i(TAG, "BEGIN mConnectThread SocketType:" + mSocketType);
            setName("ConnectThread" + mSocketType);

            // Always cancel discovery because it will slow down a connection
            mAdapter.cancelDiscovery();

            // Make a connection to the BluetoothSocket
            try {
                // This is a blocking call and will only return on a
                // successful connection or an exception
                Log.d("flag", "connect()开始");
                mmSocket.connect();
                Log.d("flag", "connect()完成");
            } catch (IOException e) {
                // Close the socket
                StreamUtils.colseQuietly(mmSocket, TAG, "unable to close " + mSocketType + " socket during connection failure ");
                connectionFailed();
                mHandler.obtainMessage(CONN_FAIL).sendToTarget();
                return;
            }

            // Reset the ConnectThread because we're done
            synchronized (BlueService.this) {
                mConnectThread = null;
            }

            // Start the connected thread
            connected(mmSocket, mmDevice, mSocketType);
        }

        public void cancel() {
            StreamUtils.colseQuietly(mmSocket, TAG, "close() of connect " + mSocketType + " socket failed");
        }
    }

    private void connectionFailed() {
        BlueService.this.start();

    }

    private class ConnectedThread extends Thread {
        private final BluetoothSocket mmSocket;
        private final InputStream mmInStream;
        private final OutputStream mmOutStream;

        public ConnectedThread(BluetoothSocket socket, String socketType) {
            Log.d(TAG, "create ConnectedThread: " + socketType);
            mmSocket = socket;
            InputStream tmpIn = null;
            OutputStream tmpOut = null;

            // Get the BluetoothSocket input and output streams
            try {
                tmpIn = socket.getInputStream();
                tmpOut = socket.getOutputStream();
            } catch (IOException e) {
                Log.e(TAG, "temp sockets not created", e);
            }
            mmInStream = tmpIn;
            mmOutStream = tmpOut;
        }

        public void run() {
//            readData();
//            readData2();
//            readProgress();

            mHandler.obtainMessage(START_RECEIVE).sendToTarget();
            writeData(FileUtils.getDateFilePath(context), readHexData(mmInStream));
            mHandler.obtainMessage(RECEIVE_COMPLETE, FileUtils.getDateFilePath(context)).sendToTarget();
        }

        private void readData2() {
            mHandler.obtainMessage(START_RECEIVE).sendToTarget();
            BufferedWriter writer = null;
            byte[] buffer = new byte[512];
            int a;
            String dateFilePath = FileUtils.getDateFilePath(context);
            int index = 0;
            try {
                writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(dateFilePath), "utf-8"));
                while ((a = mmInStream.read(buffer)) != -1) {
                    String s = DataHandleHelper.bytesToHexString(buffer, a);
                    writer.write(s.toLowerCase());
                    System.out.println(s);
                    Log.e("info-----", s + "路径" + dateFilePath.toString());
                    if (index == 0 && s != null && s.length() > 0) {
                        if (!"5".equals(s.substring(0, 1))) {
                            break;
                        }
                    }

                    index++;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            StreamUtils.colseQuietly(writer);
            mHandler.obtainMessage(RECEIVE_COMPLETE, dateFilePath).sendToTarget();
//            if (sb != null && sb.length() > 0) {
//            mHandler.obtainMessage(RECEIVE_COMPLETE, dateFilePath).sendToTarget();
//            } else {
//            mHandler.obtainMessage(CONN_ERROR).sendToTarget();
//            }
        }

        private void readProgress() {
            String s;
            try {
                s = IOUtils.toString(mmInStream);
                System.out.println("hhhL:" + s);
            } catch (IOException e) {
                e.printStackTrace();
            }
//            System.out.println(s);

        }

        private String readHexData(InputStream instream) {
            String value = null;
            try {
                byte[] arr = IOUtils.toByteArray(instream);
                value = DataHandleHelper.bytesToHexString(arr, arr.length);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return value;
        }

        private void writeData(String filePath, String str) {
            FileUtils.SaveToFile(str, filePath);
        }

        private void readData() {
            Log.i(TAG, "BEGIN mConnectedThread");
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = null;
            String aa = "";
            BufferedWriter writer = null;
            String dateFilePath = FileUtils.getDateFilePath(context);
            try {
                writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(dateFilePath), "utf-8"));
                reader = new BufferedReader(new InputStreamReader(mmInStream, "gb2312"));
                mHandler.obtainMessage(START_RECEIVE, "开始接收数据").sendToTarget();
                while ((aa = reader.readLine()) != null) {
                    sb.append(aa + "\n");
                    Log.d("flag", "收到数据：" + aa);
                    writer.write(aa + "\r\n");
                    writer.flush();
                }
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                StreamUtils.colseQuietly(writer);
                StreamUtils.colseQuietly(reader);

                if (sb != null && sb.length() > 0) {
                    mHandler.obtainMessage(RECEIVE_COMPLETE, dateFilePath).sendToTarget();
                } else {
                    mHandler.obtainMessage(CONN_ERROR).sendToTarget();
                }
            }
        }


        public void cancel() {
            StreamUtils.colseQuietly(mmSocket, TAG, "close() of connect socket failed");
        }
    }

    public synchronized void connect(BluetoothDevice device, boolean secure) {
        if (isDebugger) Log.d(TAG, "connect to: " + device);

        // Cancel any thread attempting to make a connection
//        if (mState == STATE_CONNECTING) {
        if (mConnectThread != null) {
            mConnectThread.cancel();
            mConnectThread = null;
        }
//        }

        // Cancel any thread currently running a connection
        if (mConnectedThread != null) {
            mConnectedThread.cancel();
            mConnectedThread = null;
        }

        // Start the thread to connect with the given device
        mConnectThread = new ConnectThread(device, secure);
        mConnectThread.start();
//        setState(STATE_CONNECTING);
    }

    public synchronized void connected(BluetoothSocket socket, BluetoothDevice
            device, final String socketType) {
        if (isDebugger) Log.d(TAG, "connected, Socket Type:" + socketType);

        // Cancel the thread that completed the connection
        if (mConnectThread != null) {
            mConnectThread.cancel();
            mConnectThread = null;
        }

        // Cancel any thread currently running a connection
        if (mConnectedThread != null) {
            mConnectedThread.cancel();
            mConnectedThread = null;
        }

        // Start the thread to manage the connection and perform transmissions
        mConnectedThread = new ConnectedThread(socket, socketType);
        mConnectedThread.start();

        // Send the name of the connected device back to the UI Activity
//        Message msg = mHandler.obtainMessage(BlueService.MESSAGE_DEVICE_NAME);
//        Bundle bundle = new Bundle();
//        bundle.putString(BlueService.DEVICE_NAME, device.getName());
//        msg.setData(bundle);
//        mHandler.sendMessage(msg);

//        setState(STATE_CONNECTED);
    }

    /**
     * Stop all threads
     */
    public synchronized void stop() {
        if (isDebugger) Log.d(TAG, "stop");

        if (mConnectThread != null) {
            mConnectThread.cancel();
            mConnectThread = null;
        }

        if (mConnectedThread != null) {
            mConnectedThread.cancel();
            mConnectedThread = null;
        }

    }
}
