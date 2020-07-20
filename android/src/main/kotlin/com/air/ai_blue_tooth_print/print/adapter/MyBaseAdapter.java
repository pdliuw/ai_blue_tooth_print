package com.air.ai_blue_tooth_print.print.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.List;

/**
 * @author air
 */
public abstract class MyBaseAdapter<T> extends BaseAdapter {
    protected List<T> mData;
    protected LayoutInflater inflater;

    public MyBaseAdapter(List<T> mData, Context context) {
        this.mData = mData;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return mData != null ? mData.size() : 0;
    }

    @Override
    public Object getItem(int i) {
        return mData == null ? null : mData.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {

        return initView(i, view, viewGroup);
    }

    protected abstract View initView(int position, View convertView, ViewGroup viewGroup);
}
