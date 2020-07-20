package com.air.ai_blue_tooth_print.print.adapter;

/**
 * @author air
 */
public class BlueDevice {
    private String name;
    private String address;

    public BlueDevice(String name, String address) {
        this.name = name;
        this.address = address;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "BlueDevice{" +
                "name='" + name + '\'' +
                ", address='" + address + '\'' +
                '}';
    }
}
