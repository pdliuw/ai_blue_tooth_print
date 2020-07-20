package com.air.ai_blue_tooth_print;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.RequiresApi;


import com.air.ai_blue_tooth_print.print.BlueService;
import com.air.ai_blue_tooth_print.print.adapter.BlueDevice;
import com.air.ai_blue_tooth_print.print.adapter.SearchAdapter;
import com.air.ai_blue_tooth_print.print.other.DataHandleHelper;
import com.air.ai_blue_tooth_print.print.source.EquipData;
import com.air.ai_blue_tooth_print.print.source.PrintAdd;
import com.air.ai_blue_tooth_print.print.utils.TimeUtils;
import com.lvrenyang.io.BTPrinting;
import com.lvrenyang.io.Pos;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class SearchPrintActivity extends Activity {

    public static final String INFOLIST = "infolist";
    public static final String ISPRINT = "isPrint";

    private static final String TAG = "SearchActivityPrint";

    public static final String ICON = "ICON";
    public static final String PRINTERNAME = "PRINTERNAME";
    public static final String PRINTERMAC = "PRINTERMAC";
    private static final int HANDLEING_DATA = 107;
    private static final int HANDLE_DATA_FINISHED = 108;
    private static final int PRINT_FINISHED = 109;
    private static final int PINT_FAILED = 110;
    ListView lv1;
    LinearLayout linearlayoutdevices;

    TextView txtLookat; //暂无

    TextView txtTitle;//暂无

    RelativeLayout rlTitle;
    private List<Map<String, Object>> boundedPrinters;
    private MHandler mHandler;
    private ProgressDialog dialog;
    private BroadcastReceiver broadcastReceiver = null;
    private IntentFilter intentFilter = null;
    private List<BlueDevice> list;
    private BluetoothAdapter mBluetoothAdapter;
    private BlueService mBlueService;
    private String permissionInfo;
    private int SDK_PERMISSION_REQUEST = 127;
    private AlertDialog alertDialog;
    //存储设备数据
    private EquipData equipData;

    private int model = 0;
    public static final int RECEIVE_DATA = 0;
    public static final int PRINT_DATA = 1;
    private String[] printData;
    //30
    ExecutorService es = Executors.newScheduledThreadPool(100);
    Pos mPos = new Pos();
    BTPrinting mBt = new BTPrinting();
    //数据集合
    private ArrayList<String> infoData;
    private PrintTask printTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
//        getSupportActionBar().hide();

        setContentView(R.layout.activity_search_print);

        initView();
        init();
        //11.9 yx
        getData();
    }

    private void initView() {

        lv1 = findViewById(R.id.lv1);
        linearlayoutdevices = findViewById(R.id.linearlayoutdevices);
        txtLookat = findViewById(R.id.txt_lookat);
        txtTitle = findViewById(R.id.txt_title);
        rlTitle = findViewById(R.id.rl_title);


    }

    private void getData() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            boolean isPrint = bundle.getBoolean(ISPRINT, false);
            String[] printInfo = bundle.getStringArray("info");
            infoData = bundle.getStringArrayList(INFOLIST);
            if (isPrint) {
                setPrintMode();
                printData = printInfo;
            }
        }
    }

    private void init() {
        mPos.Set(mBt);
        mHandler = new MHandler(this);
        if (openBluetooth()) return;
        list = getBoundedDevices();
        mBlueService = new BlueService(this, mHandler);
        final SearchAdapter adapter = new SearchAdapter(list, this);
        lv1.setAdapter(adapter);
        lv1.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                AlertDialog.Builder builder = new AlertDialog.Builder(SearchPrintActivity.this);
                builder.setTitle("打印");
                builder.setMessage("确定立即打印数据吗？");
                builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        BlueDevice blueDevice = list.get(position);
                        if (blueDevice != null) {
                            String name = blueDevice.getName();
                            String address = blueDevice.getAddress();
                            connect(name, address);
                        }
                        //dismiss dialog
                        dialogInterface.dismiss();
                    }
                });
                builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });
                builder.show();


            }
        });
        txtLookat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                Intent intent = new Intent(SearchPrintActivity.this, ShowAndPrintActivityPrint.class);
//                startActivity(intent);
            }
        });


        dialog = new ProgressDialog(this);
        initBroadcast();
        getPersimmions();
        setReceiveMode();

    }

    public void setReceiveMode() {
        txtTitle.setText(R.string.name_choose_recorder);
        txtTitle.setTextColor(Color.WHITE);
        rlTitle.setBackgroundResource(R.color.title_ques);
        model = RECEIVE_DATA;

    }

    public void setPrintMode() {
        txtTitle.setText("打印");
        txtTitle.setTextColor(Color.WHITE);
        rlTitle.setBackgroundResource(R.color.title_print);

        model = PRINT_DATA;
    }

    /**
     * @param name
     * @param address
     */
    private void connect(String name, String address) {
        if (address != null) {
            if (model == PRINT_DATA) {
                if (DataHandleHelper.isRecorder(name)) {
                    showNotPrinter(address);
                } else {
                    printImp(address);
                }

            } else {
                if (!DataHandleHelper.isRecorder(name)) {
                    showNotRecorder(address);
                } else {
                    receiveData(address);
                }
            }
        }
    }

    private void printImp(String address) {
        dialog = new ProgressDialog(SearchPrintActivity.this);
        dialog.show();
        dialog.setMessage("正在连接打印机...");
//        es.submit(new PrintTask(mPos, mBt, SearchActivityPrint.this, address));
        printTask = new PrintTask(mPos, mBt, SearchPrintActivity.this, address);
        es.execute(printTask);
        //

    }

    /**
     * 此设备不是打印机
     *
     * @param address
     */
    private void showNotPrinter(final String address) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.name_not_printer);
        builder.setMessage(R.string.msg_not_printer);
        builder.setPositiveButton(R.string.name_continue_choose_print, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                printImp(address);
//                es.submit(new PrintTask(mPos, mBt, SearchActivityPrint.this, address));
            }
        });
        builder.setNegativeButton(R.string.name_give_up, null);
        builder.create().show();

    }

    /**
     * 提示选择的设备不是记录仪
     *
     * @param address
     */
    private void showNotRecorder(final String address) {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);

        builder.setTitle(R.string.name_not_recorder);
        builder.setMessage(R.string.msg_not_recorder);
        builder.setPositiveButton(R.string.name_continue, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                receiveData(address);
            }
        });
        builder.setNegativeButton(R.string.name_give_up, null);
        builder.create().show();
    }

    class PrintTask extends Thread {
        private String adress;
        private Context context;
        private BTPrinting bt;
        private Pos pos;

        public PrintTask(Pos pos, BTPrinting bt, Context context, String adress) {
            Log.e("进去print构造", "fdsafds");
            this.pos = pos;
            this.bt = bt;
            this.context = context;
            this.adress = adress;
            pos.Set(bt);

        }

        @Override
        public void run() {
            Log.e("进入了run方法", "fdsafds");
            boolean a = bt.Open(adress, context);
            if (a) {
//                Toast.makeText(SearchActivityPrint.this,"要打印数据了",Toast.LENGTH_LONG).show();


                pos.POS_S_Align(1);

                //这个if判断没有进去
//                if (pos.POS_QueryStatus(new byte[1], 2000, 3)) {
//                    pos.POS_S_TextOut(printData[0] + "\r\n", 0, 0, 0, 0, 0);
//                }
                pos.POS_S_Align(0);
//                for (int i = 1; i < printData.length; i++) {
//                    //这个if判断没有进去
//                    if (pos.POS_QueryStatus(new byte[1], 2000, 3)) {
//                        pos.POS_S_TextOut(printData[i] + "\r\n", 0, 0, 0, 0, 0);
//                    }
//                }
                if (infoData != null && infoData.size() > 0) {
                    for (int i = 0; i < infoData.size(); i++) {

                        try {

                            printTask.sleep(125); //125
                            pos.POS_S_Align(0);
//                            String s = Tools.urlEncode(infoData.get(i));
                            pos.POS_TextOut(infoData.get(i) + "\r\n", 0, 0, 0, 0, 0, 0);

                        } catch (Exception e) {  //Interrupted
                            e.printStackTrace();

                        }
//                        pos.POS_TextOut(infoData.get(i) + "\r\n", 0, 0, 0, 0, 0, 0);
                    }
                }


                pos.POS_FeedLine();
                pos.POS_FeedLine();
                pos.POS_FeedLine();
                mHandler.obtainMessage(PRINT_FINISHED).sendToTarget();
            } else {
                Log.d("flag", "连接打印机失败");
                mHandler.obtainMessage(PINT_FAILED).sendToTarget();
            }

        }
    }
    //............................................................................


    public class TaskClose implements Runnable {
        BTPrinting bt = null;

        public TaskClose(BTPrinting bt) {
            this.bt = bt;
        }

        @Override
        public void run() {
            bt.Close();
        }

    }

    /**
     * 请求权限
     */
    private void getPersimmions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ArrayList<String> permissions = new ArrayList<String>();
            /***
             * 定位权限为必须权限，用户如果禁止，则每次进入都会申请
             */
            // 定位精确位置
            if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.ACCESS_FINE_LOCATION);
            }
            if (checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.ACCESS_COARSE_LOCATION);
            }
            //添加相机权限
            if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.CAMERA);
            }
            //打电话权限
            if (checkSelfPermission(Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.CALL_PHONE);
            }
            if (checkSelfPermission(Manifest.permission.BLUETOOTH) != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.BLUETOOTH);
            }
            if (checkSelfPermission(Manifest.permission.BLUETOOTH_ADMIN) != PackageManager.PERMISSION_GRANTED) {
                permissions.add(Manifest.permission.BLUETOOTH_ADMIN);
            }

            /*
             * 读写权限和电话状态权限非必要权限(建议授予)只会申请一次，用户同意或者禁止，只会弹一次
             */
            // 读写权限
            if (addPermission(permissions, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                permissionInfo += "Manifest.permission.WRITE_EXTERNAL_STORAGE Deny \n";
            }
            // 读取电话状态权限
            if (addPermission(permissions, Manifest.permission.READ_PHONE_STATE)) {
                permissionInfo += "Manifest.permission.READ_PHONE_STATE Deny \n";
            }
            if (permissions.size() > 0) {
                requestPermissions(permissions.toArray(new String[permissions.size()]), SDK_PERMISSION_REQUEST);
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.M)
    private boolean addPermission(ArrayList<String> permissionsList, String permission) {
        if (checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED) { // 如果应用没有获得对应权限,则添加到列表中,准备批量申请
            if (shouldShowRequestPermissionRationale(permission)) {
                return true;
            } else {
                permissionsList.add(permission);
                return false;
            }

        } else {
            return true;
        }
    }

    /**
     * 打开蓝牙 true 打开成功
     *
     * @return
     */
    @SuppressLint("MissingPermission")
    private boolean openBluetooth() {
        mBluetoothAdapter = BluetoothAdapter
                .getDefaultAdapter();
        if (null == mBluetoothAdapter) {
            finish();
            return true;
        }

        if (!mBluetoothAdapter.isEnabled()) {
            if (mBluetoothAdapter.enable()) {
                while (!mBluetoothAdapter.isEnabled())
                    ;
                Log.v("flag", "Enable BluetoothAdapter");
            } else {
                finish();
                return true;
            }
        }
        return false;
    }


    /**
     * 连接记录仪 并从记录仪中读取数据
     *
     * @param address
     */
    private synchronized void receiveData(String address) {
        BluetoothDevice device = mBluetoothAdapter.getRemoteDevice(address);
        // Attempt to receiveData to the device
        mBlueService.connect(device, true);
        dialog.setMessage("正在连接设备...");
        dialog.setCancelable(true);
        if (!dialog.isShowing()) {
            dialog.show();
        }
    }

    @SuppressLint("MissingPermission")
    private List<BlueDevice> getBoundedDevices() {
        List<BlueDevice> temp = new ArrayList<>();
        if (mBluetoothAdapter == null) {
            // Device does not support Bluetooth
            return temp;
        }
        Set<BluetoothDevice> pairedDevices = mBluetoothAdapter
                .getBondedDevices();
        // If there are paired devices
        if (pairedDevices.size() > 0) {
            // Loop through paired devices
            for (BluetoothDevice device : pairedDevices) {
                // Add the name and address to an array adapter to show in a
                // ListView
                BlueDevice blueDevice = new BlueDevice(device.getName(), device.getAddress());
                temp.add(blueDevice);
            }
        }
        return temp;
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        mHandler = null;
        uninitBroadcast();
    }


    /**
     * 搜索设备
     *
     * @param view
     */
    @SuppressLint("MissingPermission")
    public void search(View view) {

        BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
        adapter.cancelDiscovery();
        linearlayoutdevices.removeAllViews();
        TimeUtils.WaitMs(10);
        adapter.startDiscovery();
        dialog.setMessage("正在搜索蓝牙设备");
        dialog.setIndeterminate(true);
        dialog.setCancelable(true);
        dialog.show();


    }

    public void back(View view) {
        onBackPressed();
    }

    @SuppressLint("MissingPermission")
    private void initBroadcast() {
        broadcastReceiver = new BroadcastReceiver() {

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
            @Override
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                BluetoothDevice device = intent
                        .getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);

                if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                    if (device == null)
                        return;
                    final String address = device.getAddress();
                    String name = device.getName();
                    int type = device.getType();
                    int bondState = device.getBondState();
                    System.out.println("name:" + name + "type:" + type + "state:" + bondState);
                    if (name == null)
                        name = "BT";
                    if (name.equals("WizarPOS_Printer"))
                        return;
                    else if (name.equals(address))
                        name = "BT";
                    Button button = new Button(context);
                    button.setText(name + ": " + address);
                    button.setGravity(Gravity.CENTER_VERTICAL
                            | Gravity.LEFT);
                    final String finalName = name;
                    button.setOnClickListener(new View.OnClickListener() {

                        public void onClick(View arg0) {
                            AlertDialog.Builder builder = new AlertDialog.Builder(SearchPrintActivity.this);
                            builder.setTitle("打印");
                            builder.setMessage("确定立即打印数据吗？");
                            builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialogInterface, int i) {
                                    connect(finalName, address);
                                    dialogInterface.dismiss();
                                }
                            });
                            builder.setNegativeButton("取消", new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialogInterface, int i) {
                                    dialogInterface.dismiss();
                                }
                            });
                            builder.show();

                        }
                    });
                    button.getBackground().setAlpha(100);
                    linearlayoutdevices.addView(button);
                    dialog.cancel();
                } else if (BluetoothAdapter.ACTION_DISCOVERY_STARTED
                        .equals(action)) {
                } else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED
                        .equals(action)) {

                }

            }

        };
        intentFilter = new IntentFilter();
        intentFilter.addAction(BluetoothDevice.ACTION_FOUND);
        intentFilter.addAction(BluetoothAdapter.ACTION_DISCOVERY_STARTED);
        intentFilter.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        registerReceiver(broadcastReceiver, intentFilter);
    }


    private void uninitBroadcast() {
        if (broadcastReceiver != null)
            unregisterReceiver(broadcastReceiver);
    }

    class MHandler extends Handler {

        WeakReference<SearchPrintActivity> mActivity;

        MHandler(SearchPrintActivity activity) {
            mActivity = new WeakReference<SearchPrintActivity>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            SearchPrintActivity theActivity = mActivity.get();
            switch (msg.what) {
                /**
                 * DrawerService 的 onStartCommand会发送这个消息
                 */
                case BlueService.START_RECEIVE:
                    if (dialog != null && dialog.isShowing()) {
                        dialog.setMessage("连接成功,正在接受数据..");
                    }
                    break;
                case BlueService.RECEIVE_COMPLETE:
                    final String path = msg.obj.toString();
                    Log.d("flag", "接收的数据:" + path);
                    parserData(path);
                    Toast.makeText(theActivity, "数据接收完成", Toast.LENGTH_SHORT).show();
                    break;
                case BlueService.CONN_FAIL:
                    closeDialog(dialog);
                    Toast.makeText(theActivity, "设备连接失败", Toast.LENGTH_SHORT).show();
                    ShowConnectFailed();
                    break;
                case BlueService.CONN_ERROR:
                    closeDialog(dialog);
                    Toast.makeText(theActivity, "数据接收失败，请检查选择设备是否正确", Toast.LENGTH_SHORT).show();
                    break;
                case BlueService.DATA_PARSER_SUCCESSFUL:
                    closeDialog(dialog);
                    printData();
                    Toast.makeText(theActivity, "数据解析成功", Toast.LENGTH_SHORT).show();
                    break;
                case BlueService.DATA_PARSER_FAILED:
                    closeDialog(dialog);
                    showDataParseFailed();
//                    Toast.makeText(theActivity, "数据解析失败,请检查是否设备选择错误!", Toast.LENGTH_LONG).show();
                    break;
                case HANDLEING_DATA://处理打印数据
                    dialog = new ProgressDialog(theActivity);
                    dialog.setMessage("正在处理需打印的数据...");
                    break;
                case HANDLE_DATA_FINISHED://处理完成
                    closeDialog(dialog);
                    remindPrint();
                    break;
                case PRINT_FINISHED:
                    closeDialog(dialog);
                    continuePrint();
                    break;
                case PINT_FAILED:
                    closeDialog(dialog);
                    rePrintDialog();
                    break;
                case 666:
                    Toast.makeText(SearchPrintActivity.this, msg.obj + "", Toast.LENGTH_LONG).show();
                    break;
                case 777:
                    Toast.makeText(SearchPrintActivity.this, "抛出异常了....", Toast.LENGTH_LONG).show();
                    Log.e("----------", "抛出异常了。。。。。。。。。。。。。");
                    break;

            }
        }


    }

    private void ShowConnectFailed() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.name_device_connect_failed);
        builder.setMessage(R.string.msg_device_connect_failed);
        builder.setCancelable(false);
        builder.setPositiveButton(R.string.confirm, null);
        builder.create().show();
    }

    /**
     * 关闭对话框
     *
     * @param dialog
     */
    private void closeDialog(ProgressDialog dialog) {
        if (dialog != null && dialog.isShowing()) {
            dialog.dismiss();
        }
    }

    /**
     * 重新打印的dialog
     */
    private void rePrintDialog() {

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.name_re_print);
        builder.setMessage(R.string.msg_re_print);
        builder.setCancelable(false);
        builder.setPositiveButton(R.string.confirm, null);
        builder.create().show();
    }

    /**
     * 提示选择打印机打印
     */
    private void remindPrint() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.name_remind_print);
        builder.setMessage(R.string.msg_remind_print);
        builder.setCancelable(false);
        builder.setPositiveButton(R.string.confirm, null);
        builder.create().show();
    }

    /**
     * 打印完成
     */
    private void continuePrint() {

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.name_continue_print);
        builder.setMessage(R.string.msg_continue_print);
        builder.setCancelable(false);//R.string.reprint
        builder.setPositiveButton(R.string.confirm, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //暂时把这行注释掉
//                setReceiveMode();
//                closePrinter();
            }
        });
        builder.setNegativeButton("", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                closePrinter();
            }
        });
        builder.create().show();
    }

    /**
     * 断开与打印机的关联
     */
    private void closePrinter() {
        es.submit(new TaskClose(mBt));
    }

    /**
     * 跳转到打印页面进行数据打印
     */
    private void printData() {
        //TODO：下面几行注释2020/1/10日
//        Intent intent = new Intent(this, PrintActivityPrint.class);
//        intent.putExtra("data", equipData);
//        startActivityForResult(intent, 101);
    }

    /**
     * 解析数据
     *
     * @param absPath 文件的绝对路径
     */
    private void parserData(final String absPath) {
        dialog.setMessage("数据接收完成,正在解析...");
        new Thread(new Runnable() {
            @Override
            public void run() {
                equipData = DataHandleHelper.parseData(absPath);
                if (equipData != null) {
                    mHandler.obtainMessage(BlueService.DATA_PARSER_SUCCESSFUL).sendToTarget();
                } else {
                    mHandler.obtainMessage(BlueService.DATA_PARSER_FAILED).sendToTarget();

                }
            }
        }).start();
    }

    private void showDataParseFailed() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle(R.string.name_data_parse_failed);
        builder.setMessage(R.string.msg_date_parse_failed);
        builder.setCancelable(false);
        builder.setPositiveButton(R.string.confirm, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

            }
        });
        builder.create().show();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 101:
                if (data != null) {
                    this.model = data.getIntExtra("type", 0);
                    setPrintMode();
                    PrintAdd printAdd = (PrintAdd) data.getSerializableExtra("printAdd");
                    if (printAdd != null) {
                        new HandlePrintDataThread(printAdd).start();
                    }
                }
//                Toast.makeText(this, "请选择打印机", Toast.LENGTH_SHORT).show();
                break;
        }
    }

    /**
     * 处理数据
     */
    class HandlePrintDataThread extends Thread {
        private PrintAdd printAdd;

        public HandlePrintDataThread(PrintAdd printAdd) {
            this.printAdd = printAdd;
        }

        @Override
        public void run() {
            mHandler.obtainMessage(HANDLEING_DATA).sendToTarget();
            printData = DataHandleHelper.handleDataReturnArray(printAdd, equipData);
            for (int i = 0; i < printData.length; i++) {
                Log.e("从记录仪获取的数据......0.00.0", printData[i]);
            }
            Log.e(TAG, "============================打印的数据:" + printData.toString());
            mHandler.obtainMessage(HANDLE_DATA_FINISHED).sendToTarget();
        }
    }
}
