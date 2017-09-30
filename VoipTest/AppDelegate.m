//
//  AppDelegate.m
//  VoipTest
//
//  Created by admin on 2017/9/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerPushDemo:application];
   [self registerPushKit];
    return YES;
}
#pragma mark - 本地推送
-(void)createAction{
    if (@available(iOS 10.0, *)) {
        UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"reply" title:@"Reply" options:UNNotificationActionOptionNone];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"reply" title:@"Reply2" options:UNNotificationActionOptionNone];
        
        UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"message" actions:@[action,action2] intentIdentifiers:@[@"idid"] options:UNNotificationCategoryOptionCustomDismissAction];
        //        if (@available(iOS 11.0, *)) {
        //            UNNotificationCategory *category2=[UNNotificationCategory categoryWithIdentifier:@"message2" actions:@[action] intentIdentifiers:@[@"idid"] hiddenPreviewsBodyPlaceholder:@"ddddd" options:UNNotificationCategoryOptionCustomDismissAction];
        //        } else {
        //            // Fallback on earlier versions
        //        }
        
        
        
    } else {
        // Fallback on earlier versions
    }
}

-(void)locationPush{
    //2 分钟后提醒
    if (@available(iOS 10.0, *)) {
        
        UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"reply" title:@"Reply" options:UNNotificationActionOptionNone];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"reply" title:@"Reply2" options:UNNotificationActionOptionNone];
        
        UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:@"message" actions:@[action,action2] intentIdentifiers:@[@"idid"] options:UNNotificationCategoryOptionCustomDismissAction];
        
        NSString *requestIdentifier = @"sampleRequest";
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:30 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"Introduction to Notifications";
        content.subtitle = @"Session 707";
        content.body = @"Woah! These new notifications look amazing! Don’t you agree?";
        content.badge = @1;
        content.categoryIdentifier=@"message";
        
        [center setNotificationCategories:[NSSet setWithArray:@[category]]];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                              content:content
                                                                              trigger:trigger1];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        
        
    } else {
        // Fallback on earlier versions
    }
    
}
#pragma mark - 远程推送
-(void)registerPushDemo:(UIApplication *)application{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            // 必须写代理，不然无法监听通知的接收与点击
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    // 点击允许
                    NSLog(@"注册成功");
                    
                    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        NSLog(@"%@", settings);
                        
                    }];
                } else {
                    // 点击不允许
                    NSLog(@"注册失败");
                }
            }];
        } else {
            // Fallback on earlier versions
        }
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >8.0){
        //iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        
    }else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        //iOS8系统以下
        //        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [self createAction];
}

//此方法不确定需不需要
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];//必须先实现这个方法，才会走下面的方法
}

//静默push必须实现下面协议
//而当程序处于后台或者被杀死状态，收到远程通知后，当你进入(aunch)程序时
//实现此方法didReceiveRemoteNotification将不会被调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    NSLog(@"====%s===userInfo==%@",__func__,userInfo);
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
}



//应用在运行状态（也就是打卡状态），收到远程推送
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"====%s===",__func__);
    NSLog(@"iOS6及以下系统，收到通知:%@",userInfo );
   
}
#ifdef NSFoundationVersionNumber_iOS_10_x_Max
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"====%s===userInfo=%@",__func__,userInfo);
        //应用处于前台时的远程推送接受
        
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    //    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"====%s===",__func__);
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
           
        }else{
            //应用处于后台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
}
#endif
// 获得Device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *token = [NSString stringWithFormat:@"%@", [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""]];
    //获取终端设备标识，这个标识需要通过接口发送到服务器端，服务器端推送消息到APNS时需要知道终端的标识，APNS通过注册的终端标识找到终端设备
    NSLog(@"==token=====%@",token);
}
// 获得Device Token失败
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - pushkit  PKPushRegistryDelegate

-(void)registerPushKit{
   NSLog(@"====registerPushKit===");
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
 
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    NSString *str = [NSString stringWithFormat:@"%@",credentials.token];
    NSString* tokenStr = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"==pushkit=token==%@",tokenStr);
} //这个代理方法是获取了设备的唯tokenStr，是要给服务器的
- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(PKPushType)type{
    NSLog(@"===%s===",__func__);
    
}
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void(^)(void))completion NS_AVAILABLE_IOS(11_0){
    NSLog(@"===%s===",__func__);
}
- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type NS_DEPRECATED_IOS(8_0, 11_0){
    NSLog(@"===%s===",__func__);
}

#pragma mark - 生命周期
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
