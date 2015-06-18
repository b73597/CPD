package com.parse.starter;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.widget.Toast;

public class Utils {
    static boolean isConnectionAvailable(Context context){
        return isConnectionAvailable(context, false);
    }
    static boolean isConnectionAvailable(Context context, boolean warn){
        try {
            ConnectivityManager connectivityService = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            NetworkInfo netInfo = connectivityService.getActiveNetworkInfo();
            if (netInfo != null && netInfo.getState() == NetworkInfo.State.CONNECTED) {
                return true;
            }
        }catch (Exception ex){
        }
        Toast.makeText(context, "No network connection", Toast.LENGTH_SHORT).show();
        return false;
    }
}
