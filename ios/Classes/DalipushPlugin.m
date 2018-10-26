#import "DalipushPlugin.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "MJExtension.h"

@interface DalipushPlugin() <FlutterStreamHandler>

@property (nonatomic, strong) FlutterEventSink eventSink;

@end

@implementation DalipushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"dalipush"
            binaryMessenger:[registrar messenger]];
  DalipushPlugin* instance = [[DalipushPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"dalipush_event" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
    
    [instance registerMessageReceive];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - FlutterStreamHandler

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)eventSink{
    self.eventSink = eventSink;
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments{
    return nil;
}

/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    
    NSLog(@"onMessageReceived userinfo : %@", notification.userInfo);
    
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"title"] = title;
    dict[@"body"] = body;
    NSString *jsonStr = [[dict mj_JSONString] copy];
    self.eventSink(jsonStr);
}



@end
