package com.brzhang.dalipushexample;

import android.content.Context;
import android.util.Log;

import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.sdk.android.push.register.GcmRegister;
import com.alibaba.sdk.android.push.register.HuaWeiRegister;
import com.alibaba.sdk.android.push.register.MiPushRegister;

public class FApp extends io.flutter.app.FlutterApplication {

    private static final String TAG = "FApp";

    @Override
    public void onCreate() {
        super.onCreate();
        initCloudChannel(this);
        // 注册方法会自动判断是否支持小米系统推送，如不支持会跳过注册。
        MiPushRegister.register(this, "2882303761517882020", "5671788227020");
// 注册方法会自动判断是否支持华为系统推送，如不支持会跳过注册。
        HuaWeiRegister.register(this);
//GCM/FCM辅助通道注册
//        GcmRegister.register(this, sendId, applicationId); //sendId/applicationId为步骤获得的参数
    }

    /**
     * 初始化云推送通道
     *
     * @param applicationContext
     */
    private void initCloudChannel(Context applicationContext) {
        PushServiceFactory.init(applicationContext);
        CloudPushService pushService = PushServiceFactory.getCloudPushService();
        pushService.register(applicationContext, new CommonCallback() {
            @Override
            public void onSuccess(String response) {
                Log.d(TAG, "init cloudchannel success");
            }

            @Override
            public void onFailed(String errorCode, String errorMessage) {
                Log.d(TAG, "init cloudchannel failed -- errorcode:" + errorCode + " -- errorMessage:" + errorMessage);
            }
        });
    }
}
