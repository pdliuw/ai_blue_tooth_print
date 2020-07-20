package com.air.ai_blue_tooth_print.print.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;


import com.air.ai_blue_tooth_print.R;
import com.air.ai_blue_tooth_print.print.other.DataHandleHelper;

import java.util.List;


/**
 * @author air on 2020
 */
public class SearchAdapter extends MyBaseAdapter<BlueDevice> {

    public SearchAdapter(List mData, Context context) {
        super(mData, context);
    }

    @Override
    protected View initView(int position, View convertView, ViewGroup viewGroup) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_bounded, null);
            holder = new ViewHolder(convertView);
            holder.name = (TextView) convertView.findViewById(R.id.name);
            holder.mac = (TextView) convertView.findViewById(R.id.mac);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        BlueDevice blueDevice = mData.get(position);
        if (blueDevice != null) {
            String name = blueDevice.getName();
            if (name != null) {
                holder.name.setText(name);
                if (DataHandleHelper.isRecorder(name)) {
                    holder.img.setImageResource(R.drawable.logo);
                } else {
                    holder.img.setImageResource(R.drawable.bluetooth10);
                }
            }
            String address = blueDevice.getAddress();
            if (address != null) {
                holder.mac.setText(address);
            }
        }

        return convertView;
    }


    static class ViewHolder {
        ImageView img;
        TextView name;
        TextView mac;

        ViewHolder(View view) {
            img = view.findViewById(R.id.img);
            name = view.findViewById(R.id.name);
            mac = view.findViewById(R.id.mac);
        }
    }
}
