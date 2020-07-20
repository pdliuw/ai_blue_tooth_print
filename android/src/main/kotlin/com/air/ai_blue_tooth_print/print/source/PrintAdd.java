package com.air.ai_blue_tooth_print.print.source;

import java.io.Serializable;
import java.util.Date;

/**
 * @author air
 */
public class PrintAdd implements Serializable {
    /**
     * 标题
     */
    private String title;
    /**
     * 客户
     */
    private String customer;
    /**
     * 冷藏货品
     */
    private String goods;
    /**
     * 运输开始时间
     */
    private Date startDate;
    /**
     * 签收时间
     */
    private Date endDate;

    public PrintAdd() {
    }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCustomer() {
        return customer;
    }

    public void setCustomer(String customer) {
        this.customer = customer;
    }

    public String getGoods() {
        return goods;
    }

    public void setGoods(String goods) {
        this.goods = goods;
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

    @Override
    public String toString() {
        return "PrintAdd{" +
                "title='" + title + '\'' +
                ", customer='" + customer + '\'' +
                ", goods='" + goods + '\'' +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                '}';
    }
}
