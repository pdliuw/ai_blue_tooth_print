package com.air.ai_blue_tooth_print.print.other;

import android.util.Log;


import com.air.ai_blue_tooth_print.print.constant.Constant;
import com.air.ai_blue_tooth_print.print.source.EquipData;
import com.air.ai_blue_tooth_print.print.source.PrintAdd;
import com.air.ai_blue_tooth_print.print.source.SingleChannelData;
import com.air.ai_blue_tooth_print.print.source.SingleData;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


/**
 * Created by ada on 2017/2/13.
 * description: 处理从设备读取的数据
 */

public class DataHandleHelper {

    private static final String TAG = "DataHandleHelper";


//    /**
//     * 解析单温设备的数据
//     *
//     * @param fileName
//     */
//    public static EquipData parseSingleTemp(String fileName) {
//        EquipData data = null;
//        List<Equip> mList = null;
//        String origin = readFile(fileName);
//        if (origin != null && origin.length() > 0) {
//            mList = new ArrayList<>();
//            data = new EquipData();
//            String foreDate = "";
//            String[] split = origin.split("\r\n");
//            if (!(split.length > 6)) {
//                return null;
//            }
//            String trim = split[3].trim();
//            String equipNo = trim.substring(5, trim.length());
//            if (equipNo != null && equipNo.length() > 0) {
//                data.setEquipNo(equipNo);
//            }
//            for (int i = 6; i < split.length; i++) {
//                String line = split[i];
//                if (!line.contains("*")) {
//                    foreDate = line.trim();
//                } else {
//                    String[] dataArray = line.trim().split("\\*");
//                    for (int y = 0; y < dataArray.length; y++) {
//                        String trim1 = dataArray[y].trim();
//                        if (trim1.contains("   ")) {
//                            String[] singleData = trim1.split("   ");
//                            String time = foreDate + " " + singleData[0];
//                            Date date = string2Date(time);
//                            float temp = parserTemperture(singleData[1]);
//                            Equip equip = new Equip();
//                            if (date != null) {
//                                equip.setDate(date);
//                            }
//                            if (temp != -300) {
//                                equip.setTemperture(temp);
//                            }
//                            mList.add(equip);
//                        }
//                    }
//                }
//            }
//            if (mList != null && mList.size() > 0) {
//                data.setMlist(mList);
//            } else {
//                return null;
//            }
//        }
//        return data;
//    }
//
//
//    /**
//     * 解析温湿度记录仪数据
//     *
//     * @param fileName
//     * @return
//     */
//    public static EquipData parseTempAndHum(String fileName) {
//        EquipData data = null;
//        List<Equip> mlist = null;
//        String origin = readFile(fileName);
//        if (origin != null && origin.length() > 0) {
//            mlist = new ArrayList<>();
//            data = new EquipData();
//            String foreDate = "";
//            String[] split = origin.split("\r\n");
//            if (!(split.length > 6)) {
//                return null;
//            }
//            String trim = split[3].trim();
//            String equipNo = trim.substring(5, trim.length());
//            if (equipNo != null && equipNo.length() > 0) {
//                data.setEquipNo(equipNo);
//            }
//            for (int i = 6; i < split.length - 3; i++) {
//                String trim1 = split[i].trim();
//                if (trim1.contains(" ")) {
//                    String[] lines = trim1.split(" ");
//                    if (lines.length == 5) {
//                        Date date = string2DateLong(lines[0] + " " + lines[1]);
//                        float temp = parserTemperture(lines[2]);
//                        float humi = parserTemperture(lines[3]);
//                        Equip equip = new Equip();
//                        if (date != null) {
//                            equip.setDate(date);
//                        }
//                        if (temp != -300) {
//                            equip.setTemperture(temp);
//                        }
//                        if (humi != -1) {
//                            equip.setHumidity(humi);
//                        }
//                        mlist.add(equip);
//
//                    }
//                }
//
//
//            }
//            if (mlist != null && mlist.size() > 0) {
//                data.setMlist(mlist);
//            } else {
//                return null;
//            }
//        }
//        return data;
//    }

    public static EquipData parseData(String fileName) {
        EquipData equipData = null;
//        fileName = "/storage/emulated/0/Android/data/com.zyhx.bluetoothprint.bluetoothprint/cache/data/20170221094219652.txt";
        Log.e(TAG, "=========================获取fileName:" + fileName);
        try {
            String origin = readFile(fileName);
            Log.e(TAG, "=========================读取文件的信息:" + origin);
            if (origin != null && origin.length() > 0) {
                if (origin.trim().contains(Constant.DATA_END)) {
                    equipData = new EquipData();
                    String[] split = origin.split(Constant.DATA_END);
                    if (split.length > 1) {
                        List<SingleData> datas = new ArrayList<>();
                        for (int i = 0; i < split.length; i++) {
                            String single = split[i];
                            //校验
                            if (checkData(single)) { //校验通过
                                if (single.length() > 6) {
                                    int paramsType = hex2Dec(single.substring(4, 6));
                                    if (paramsType == 1) {//数据类型为参数
                                        parseParams(single, equipData);
                                    }
                                    if (paramsType == 2) {//数据类型为数据
                                        SingleData singleData = parseSinleData(single);
                                        if (singleData != null) {
                                            datas.add(singleData);
                                        }
                                    }
                                }

                            }
                        }
                        if (datas.size() > 0) {
                            equipData.setDatas(datas);
                            Date startDate = datas.get(0).getDate();
                            Date endDate = datas.get(datas.size() - 1).getDate();
                            if (startDate != null) {
                                equipData.setStartDate(startDate);
                            }
                            if (endDate != null) {
                                equipData.setEndDate(endDate);
                            }
                        }

                    } else {//无数据

                    }
                }

            }
        } catch (Exception e) {
            Log.d("flag", "数据解析出错");
        }
        Log.e(TAG, "=========================最终返回的数据:" + equipData.toString());
        return equipData;
    }

    /**
     * 将十六进制转换成十进制
     *
     * @param hex 十六进制字符串
     * @return
     */
    public static int hex2Dec(String hex) {
        return Integer.valueOf(hex, 16).shortValue();
    }

    /**
     * 解析单条数据
     *
     * @param single 去掉尾部的单条数据
     */
    private static SingleData parseSinleData(String single) {
        int totalNum = hex2Dec(single.substring(8, 12));
        int no = hex2Dec(single.substring(12, 16));//序号
        int channelNum = hex2Dec(single.substring(16, 18));//通道数
        int year = hex2Dec(single.substring(18, 20));//年
        int month = hex2Dec(single.substring(20, 22));//月
        int day = hex2Dec(single.substring(22, 24));//日
        int hour = hex2Dec(single.substring(24, 26));//时
        int minute = hex2Dec(single.substring(26, 28));//分
        int second = hex2Dec(single.substring(28, 30));//秒
        Date date = getDate(year, month, day, hour, minute, second);
        String dataType = Character.toString((char) hex2Dec(single.substring(30, 32)));//秒
        List<SingleChannelData> channelDatas = null;
        if (channelNum != 0) {
            channelDatas = new ArrayList<>();
            for (int i = 0; i < channelNum; i++) {
                SingleChannelData channel = parseChannelData(single, 32 + 0 * i);
                if (channel != null) {
                    channelDatas.add(channel);
                }

            }
        }
        SingleData singleData = new SingleData();
        if (totalNum != 0) {
        }
        if (date != null) {
            singleData.setDate(date);
        }
        if (dataType != null && dataType.length() > 0) {
            singleData.setDataType(dataType);
        }
        if (channelDatas != null && channelDatas.size() > 0) {
            singleData.setmChannelDatas(channelDatas);
        }
        return singleData;

    }

    /**
     * 解析通道数据
     *
     * @param single        去除尾部的单条数据
     * @param startPosition 开始解析的位置
     * @return
     */
    private static SingleChannelData parseChannelData(String single, int startPosition) {
        SingleChannelData channel = new SingleChannelData();
        int dataType = hex2Dec(single.substring(startPosition, startPosition + 2));
        float temperature = hex2Dec(single.substring(startPosition + 2, startPosition + 6)) / 10f;
        float humidity = hex2Dec(single.substring(startPosition + 6, startPosition + 10)) / 10f;
        if (dataType != -1) {
            channel.setDataType(dataType);
        }
        channel.setTemperature(temperature);
        if (temperature > Constant.MIN_TEMPERATURE && temperature < Constant.MAX_TEMPERATURE) {
        }
        channel.setHumidity(humidity);
        if (humidity > Constant.MIN_HUMIDITY && humidity < Constant.MAX_HUMIDITY) {
        }
        return channel;
    }

    /**
     * 解析参数
     *
     * @param single    去掉尾部的单条数据
     * @param euqipData
     */
    private static void parseParams(String single, EquipData euqipData) {
        int equipModel = hex2Dec(single.substring(8, 10));
        int channelNum = hex2Dec(single.substring(10, 12));
        String probeType = Character.toString((char) hex2Dec(single.substring(12, 14)));
        String equipId = Integer.toString(hex2Dec(single.substring(14, 18)));
        float minTemperature = hex2Dec(single.substring(18, 22)) / 10f;
        float maxTemperature = hex2Dec(single.substring(22, 26)) / 10f;
        float minHumidity = hex2Dec(single.substring(26, 30)) / 10f;
        float maxHumidity = hex2Dec(single.substring(30, 34)) / 10f;
        if (equipModel != 0) {
            euqipData.setEquipModel(equipModel);
        }
        if (channelNum != 0) {
            euqipData.setChannelNum(channelNum);
        }
        if (!probeType.equals("-1")) {
            euqipData.setProbeType(probeType);
        }
        if (!equipId.equals("0")) {
            euqipData.setEquipId(equipId);
        }
        if (minTemperature > Constant.MIN_TEMPERATURE) {
            euqipData.setMinTemperature(minTemperature);
        }
        if (maxTemperature < Constant.MAX_TEMPERATURE) {
            euqipData.setMaxTemperature(maxTemperature);
        }
        if (minHumidity > Constant.MIN_HUMIDITY) {
            euqipData.setMinHumidity(minHumidity);
        }
        if (maxHumidity < Constant.MAX_HUMIDITY) {
            euqipData.setMaxHumidity(maxHumidity);
        }
    }


    /**
     * 累加和校验(从第2项计算到第4项)  如果数值转换成十六进制后超过两位 则取最后两位(例如 0x23 0x12 去后变成0x12 )
     * 在这里 校验位为最后两位
     *
     * @param single 去除结尾的单条数据
     * @return
     */
    private static boolean checkData(String single) {
        int sum = 0;
        int length = single.length();
        if (single != null && length > 0 && length % 2 == 0) {
            for (int i = 4; i <= length - 4; i++, i++) {
                String substring = single.substring(i, i + 2);
                int dec = hex2Dec(substring);
                sum += dec;
            }
            String s = Integer.toHexString(sum);
            String sumHex = s.substring(s.length() - 2, s.length());
            if (sumHex.equals(single.substring(length - 2, length))) {
                return true;
            }
        }
        return false;
    }

    public static String readFile(String fileName) {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(new File(fileName)));
            String line = null;
            //时间的前半部分 比如 2016-12-03 12:45 中的2016-12-03
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return sb.toString();
    }

    public static Date string2Date(String date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date parse = null;
        try {
            parse = dateFormat.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return parse;
    }

    /**
     * @param date
     * @return
     */
    public static Date string2DateLong(String date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMddHHmmss");
        Date parse = null;
        try {
            parse = dateFormat.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return parse;
    }

    public static Date getDate(int year, int month, int day, int hour, int minute, int second) {
        Date date = null;
        String sYear = Integer.toString(year);
        if (sYear.length() % 2 != 0) {
            sYear = "0" + sYear;
        }
        String sMonth = Integer.toString(month);
        if (sMonth.length() % 2 != 0) {
            sMonth = "0" + sMonth;
        }
        String sDay = Integer.toString(day);
        if (sDay.length() % 2 != 0) {
            sDay = "0" + sDay;
        }
        String sHour = Integer.toString(hour);
        if (sHour.length() % 2 != 0) {
            sHour = "0" + sHour;
        }
        String sMinute = Integer.toString(minute);
        if (sMinute.length() % 2 != 0) {
            sMinute = "0" + sMinute;
        }
        String sSecond = Integer.toString(second);
        if (sSecond.length() % 2 != 0) {
            sSecond = "0" + sSecond;
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMddHHmmss");
        try {
            date = dateFormat.parse(sYear + sMonth + sDay + sHour + sMinute + sSecond);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return date;
    }


    public static float parserTemperture(String s) {
        float temp;
        try {
            temp = Float.parseFloat(s);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            Log.e("flag", "温度数据转换异常");
            temp = -300;
        }
        return temp;
    }

    public static float parserHumidity(String s) {
        float humi;
        try {
            humi = Float.parseFloat(s);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            Log.e("flag", "温度数据转换异常");
            humi = -1;
        }
        return humi;
    }

    public static String bytesToHexString(byte[] src, int length) {
        StringBuilder stringBuilder = new StringBuilder("");
//        if (src == null || src.length <= 0) {
//            return null;
//        }
        for (int i = 0; i < length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
        }
        return stringBuilder.toString();
    }

    /**
     * 比较两个日期 如果datebefore dateAfter 靠前 返回true
     *
     * @param datebefore
     * @param dateAfter
     * @return
     */
    public static boolean dataBefore(Date datebefore, Date dateAfter) {
        if (datebefore.getTime() <= dateAfter.getTime()) {
            return true;
        }
        return false;
    }


    /**
     * 处理打印的数据
     *
     * @param printAdd
     * @param equipData
     * @return
     */
    public static String handleData(PrintAdd printAdd, EquipData equipData) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-M-dd HH:mm:ss");
        StringBuilder sb = new StringBuilder();
        String title = printAdd.getTitle();
        String customer = printAdd.getCustomer();
        String goods = printAdd.getGoods();
        Date startDate = printAdd.getStartDate();
        Date endDate = printAdd.getEndDate();
        String equipId = equipData.getEquipId();
        sb.append("   " + title + "\n");
        sb.append("运输开始时间:" + format.format(startDate) + "\n");
        sb.append("签收时间:" + format.format(endDate) + "\n");
        sb.append("设备号:" + equipId + "\n");
        sb.append("客户:" + customer + "\n");
        sb.append("冷藏货品:" + goods + "\n");
        List<SingleData> datas = equipData.getDatas();
        for (SingleData singleData : datas) {
            Date date = singleData.getDate();
            if (dataBefore(startDate, date) && dataBefore(date, endDate)) {
                String time = format.format(date);
                sb.append(time);
                List<SingleChannelData> channelDatas = singleData.getmChannelDatas();
                for (SingleChannelData channelData : channelDatas) {
                    float temperature = channelData.getTemperature();
                    float humidity = channelData.getHumidity();
                    if (temperature > Constant.MIN_TEMPERATURE && temperature < Constant.MAX_TEMPERATURE) {
                        sb.append(" " + temperature + "℃");
                    }
                    if (humidity > Constant.MIN_HUMIDITY && humidity < Constant.MAX_HUMIDITY) {
                        sb.append(" " + humidity + "%");
                    }
                }
                sb.append("\n");
            }
        }
        sb.append("打印时间:" + format.format(new Date()) + "\n");
        return sb.toString();
    }

    /**
     * 处理打印的数据
     *
     * @param printAdd
     * @param equipData
     * @return
     */
    public static String[] handleDataReturnArray(PrintAdd printAdd, EquipData equipData) {
        String[] split = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        StringBuilder sb = new StringBuilder();
        String title = printAdd.getTitle();
        String customer = printAdd.getCustomer();
        String goods = printAdd.getGoods();
        Date startDate = printAdd.getStartDate();
        Date endDate = printAdd.getEndDate();
        String equipId = equipData.getEquipId();
        sb.append(title + "\n");
        sb.append("开始时间:" + format.format(startDate) + "\n");
        sb.append("签收时间:" + format.format(endDate) + "\n");
        sb.append("设备号:" + equipId + "\n");
        sb.append("客户:" + customer + "\n");
        sb.append("冷藏货品:" + goods + "\n");
        List<SingleData> datas = equipData.getDatas();
        for (SingleData singleData : datas) {
            Date date = singleData.getDate();
            if (dataBefore(startDate, date) && dataBefore(date, endDate)) {
                String time = format.format(date);
                sb.append(time);
                List<SingleChannelData> channelDatas = singleData.getmChannelDatas();
                for (SingleChannelData channelData : channelDatas) {
                    float temperature = channelData.getTemperature();
                    int dataType = channelData.getDataType();
                    float humidity = channelData.getHumidity();
                    if (temperature > Constant.MIN_TEMPERATURE && temperature < Constant.MAX_TEMPERATURE) {
                        sb.append(" " + temperature + "℃");
                    } else {
                        sb.append(" err");
                    }
                    if (humidity > Constant.MIN_HUMIDITY && humidity < Constant.MAX_HUMIDITY) {
                        sb.append(" " + humidity + "%");
                    }
                }
                sb.append("\n");
            }
        }
        sb.append("打印时间:" + format.format(new Date()) + "\n");
        String sfinal = sb.toString();
        if (sfinal != null && sfinal.length() > 0 && sfinal.contains("\n")) {
            split = sfinal.split("\n");
        }
        return split;
    }

    /**
     * 通过设备名称判断是否是记录仪
     *
     * @param name
     * @return
     */
    public static boolean isRecorder(String name) {
        if (name != null && name.length() == 5) {
            int i = parseRecorderName(name);
            if (i != -1 && i > 10000 && i < 65535) {
                return true;
            }
        }
        return false;
    }

    public static int parseRecorderName(String name) {
        int i = -1;
        try {
            i = Integer.valueOf(name);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            Log.d("flag", "记录仪名称解析失败");
        }
        return i;
    }
}
