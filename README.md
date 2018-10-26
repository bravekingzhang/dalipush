# dalipush

集成了阿里推送，提供给flutter开发者使用。

## Getting Started

#### 资源申请
1、首先，你需要到阿里云上面去申请一个appid，申请地址：[阿里云](https://emas.console.aliyun.com/)
2、注意，如果你需要小米，华为离线推送的话，需要参考这里 [参考](https://help.aliyun.com/document_detail/30067.html?spm=a2c4g.11186623.4.3.d82752e7CWEORK)

#### Andriod方面

1、写一个application继承自FlutterApplication

注意，这个是阿里推送的要求

> 移动推送的初始化必须在Application中，不能放到Activity中执行。移动推送在初始化过程中将启动后台进程channel，必须保证应用进程和channel进程都执行到推送初始化代码。
  如果设备成功注册，将回调callback.onSuccess()方法。
  但如果注册服务器连接失败，则调用callback.onFailed方法，并且自动进行重新注册，直到onSuccess为止。（重试规则会由网络切换等时间自动触发。）
  请在网络通畅的情况下进行相关的初始化调试，如果网络不通，或者App信息配置错误，在onFailed方法中，会有相应的错误码返回，可参考错误处理。
  
```java
public class FApp extends io.flutter.app.FlutterApplication {

    private static final String TAG = "FApp";

    @Override
    public void onCreate() {
        super.onCreate();
        initCloudChannel(this);
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

```
2、修改build.gradle文件

```groovy
defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.brzhang.sophixtest"
        minSdkVersion 16
        targetSdkVersion 27
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
        manifestPlaceholders = [
                ALIPUSH_PKGNAME  : applicationId,
                ALIPUSH_APPKEY   : "24xxxx5693", //ALIPush上注册的包名对应的appkey.
                ALIPUSH_APPSECRET: "dd973xxxxxxxxxxxf575aee1ab1", //appsecret.
        ]
        //todo
//        ndk {
//            //选择要添加的对应cpu类型的.so库。
//            abiFilters 'armeabi', 'x86', 'armeabi-v7a', 'armeabi-v8a'
//        }
    }
```
主要是两个地方注意：
一个是applicationId，这里要填你在阿里上申请的appid相关的那个包名
二个是manifestPlaceholders，这里注意填你的

3、请注意，不要使用我的appid到你的项目中，你用了也没办法推送，因为，要等登陆我的账号去发推送消息。


#### IOS

TODO

