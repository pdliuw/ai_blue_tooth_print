package com.air.ai_blue_tooth_print.print.source;

import android.os.Parcel;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author air
 */
public class EquipData implements Serializable {
    /**
     * 设备型号
     * 0x01,CCDR001；0x02,CCDR100；0x03，CCDR002
     */
    private int equipModel;
    /**
     * 设备ID
     */
    private String equipId;
    /**
     * 通道数量
     * 0x01，表示1路；0x02，表示2路
     */
    private int channelNum;
    /**
     * 探头类型
     * “0”，AM2321B，温湿度传感器(-40~80)；
     * “1”，DS18B20，高精度温度传感器(-55~125)；
     * “2”，PT100，宽量程温度传感器(-200~200)；
     * “3”，SHT20，防水型温湿度传感器(-40~80)
     */
    private String probeType;
    /**
     * 温度上限
     */
    private float maxTemperature;
    /**
     * 温度下限
     */
    private float minTemperature;
    /**
     * 湿度上限
     */
    private float maxHumidity;
    /**
     * 湿度下限
     */
    private float minHumidity;
    /**
     * 数据记录的开始时间
     */
    private Date startDate;
    /**
     * 数据记录的结束时间
     */
    private Date endDate;
    /**
     * 存储设备的所有数据
     */
    private List<SingleData> datas;

    public EquipData() {
    }

    protected EquipData(Parcel in) {
        equipModel = in.readInt();
        equipId = in.readString();
        channelNum = in.readInt();
        probeType = in.readString();
        maxTemperature = in.readFloat();
        minTemperature = in.readFloat();
        maxHumidity = in.readFloat();
        minHumidity = in.readFloat();
    }


    public int getEquipModel() {
        return equipModel;
    }

    public void setEquipModel(int equipModel) {
        this.equipModel = equipModel;
    }

    public String getEquipId() {
        return equipId;
    }

    public void setEquipId(String equipId) {
        this.equipId = equipId;
    }

    public int getChannelNum() {
        return channelNum;
    }

    public void setChannelNum(int channelNum) {
        this.channelNum = channelNum;
    }

    public String getProbeType() {
        return probeType;
    }

    public void setProbeType(String probeType) {
        this.probeType = probeType;
    }

    public float getMaxTemperature() {
        return maxTemperature;
    }

    public void setMaxTemperature(float maxTemperature) {
        this.maxTemperature = maxTemperature;
    }

    public float getMinTemperature() {
        return minTemperature;
    }

    public void setMinTemperature(float minTemperature) {
        this.minTemperature = minTemperature;
    }

    public float getMaxHumidity() {
        return maxHumidity;
    }

    public void setMaxHumidity(float maxHumidity) {
        this.maxHumidity = maxHumidity;
    }

    public float getMinHumidity() {
        return minHumidity;
    }

    public void setMinHumidity(float minHumidity) {
        this.minHumidity = minHumidity;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public List<SingleData> getDatas() {
        return datas;
    }

    public void setDatas(List<SingleData> datas) {
        this.datas = datas;
    }

    @Override
    public String toString() {
        return "EquipData{" +
                "equipModel=" + equipModel +
                ", equipId='" + equipId + '\'' +
                ", channelNum=" + channelNum +
                ", probeType='" + probeType + '\'' +
                ", maxTemperature=" + maxTemperature +
                ", minTemperature=" + minTemperature +
                ", maxHumidity=" + maxHumidity +
                ", minHumidity=" + minHumidity +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", datas=" + datas +
                '}';
    }
}
