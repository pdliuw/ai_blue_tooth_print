package com.air.ai_blue_tooth_print.print.source;

import java.io.Serializable;

/**
 * @author air
 */
public class SingleChannelData implements Serializable {
    /**
     * 数据类型：0x01表示温湿度；0x02表示单温度；
     */
    private int dataType;
    /**
     * 温度数据
     */
    private float temperature;
    /**
     * 湿度数据
     */
    private float humidity;

    public int getDataType() {
        return dataType;
    }

    public void setDataType(int dataType) {
        this.dataType = dataType;
    }

    public float getTemperature() {
        return temperature;
    }

    public void setTemperature(float temperature) {
        this.temperature = temperature;
    }

    public float getHumidity() {
        return humidity;
    }

    public void setHumidity(float humidity) {
        this.humidity = humidity;
    }

    @Override
    public String toString() {
        return "SingleChannelData{" +
                "dataType=" + dataType +
                ", temperature=" + temperature +
                ", humidity=" + humidity +
                '}';
    }
}
