//
//  ViewController.m
//  VoipTest
//
//  Created by admin on 2017/9/29.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 60)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(locationPushIOS10) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)LocalNotificationIOS8{
    UIUserNotificationType types = UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings =[UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.timeZone = [NSTimeZone defaultTimeZone];
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];
    localNote.alertBody = @"liao";
    localNote.regionTriggersOnce=YES;
    localNote.alertAction = @"接听";
    //            localNote.alertTitle = @"提示";
    localNote.soundName = UILocalNotificationDefaultSoundName;
    localNote.applicationIconBadgeNumber = 0;
    
    localNote.userInfo = @{@"type":@1};
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

-(void)locationPushIOS10{
    //2 分钟后提醒
    if (@available(iOS 10.0, *)) {
         NSString *requestIdentifier = @"sampleRequest";
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
//        action
        UNTextInputNotificationAction *textInputAction = [UNTextInputNotificationAction actionWithIdentifier:@"textInputAction" title:@"请输入信息" options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:@"输入" textInputPlaceholder:@"还有多少话要说……"];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"销毁模式，不进入APP" options:UNNotificationActionOptionDestructive];
         UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"前台模式，进入APP" options:UNNotificationActionOptionForeground];
//       category
        UNNotificationCategory *category=[UNNotificationCategory categoryWithIdentifier:requestIdentifier actions:@[textInputAction,action2,action3] intentIdentifiers:@[requestIdentifier] options:UNNotificationCategoryOptionCustomDismissAction];
        
       
        
//       trigger
        UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:30 repeats:NO];
//       content
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"Introduction to Notifications";
        content.subtitle = @"Session 707";
        content.body = @"Woah! These new notifications look amazing! Don’t you agree?";
        content.badge = @1;
        content.categoryIdentifier=requestIdentifier;
        
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                              content:content
                                                                              trigger:trigger1];
//        可以远程push添加这些，也可以本地推送添加，
//        远程触发
//        {
//            aps : {
//                alert : "Welcome to WWDC !",
//                category : "message"
//            }
//        }
//        本地触发
//        UNMutableNotificationContent的categoryIdentifier
        
        [center setNotificationCategories:[NSSet setWithArray:@[category]]];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        
        
    } else {
        // Fallback on earlier versions
    }
    
}
#pragma mark -- UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0){
    NSLog(@"====%s====",__func__);
    
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
    
    if ([categoryIdentifier isEqualToString:@"handlecategory"]) {//识别需要被处理的拓展
        
        if ([response.actionIdentifier isEqualToString:@"textInputAction"]) {//识别用户点击的是哪个 action
            
            //假设点击了输入内容的 UNTextInputNotificationAction 把 response 强转类型
            if (@available(iOS 10.0, *)) {
                UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse*)response;
                //获取输入内容
                NSString *userText = textResponse.userText;
                //发送 userText 给需要接收的方法
                NSLog(@"输入的内容为：%@",userText);
            } else {
                // Fallback on earlier versions
            }
            
        }else{
            
        }
        
    }
    completionHandler();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
