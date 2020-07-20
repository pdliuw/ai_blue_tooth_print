package com.air.ai_blue_tooth_print.print.source;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author air
 */
public class SingleData implements Serializable {
    /**
     * 数据的采集时间
     */
    private Date date;
    /**
     * 记录的数据类型
     */
    private String dataType;
    /**
     * 存储每条数据里的各路数据
     * 如果长度是1 表示存储了1路数据
     * 如果长度是2 表示存储了2路数据
     */
    private List<SingleChannelData> mChannelDatas;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public List<SingleChannelData> getmChannelDatas() {
        return mChannelDatas;
    }

    public void setmChannelDatas(List<SingleChannelData> mChannelDatas) {
        this.mChannelDatas = mChannelDatas;
    }

    @Override
    public String toString() {
        return "SingleData{" +
                "date=" + date +
                ", dataType='" + dataType + '\'' +
                ", mChannelDatas=" + mChannelDatas +
                '}';
    }
}
