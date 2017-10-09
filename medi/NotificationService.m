//
//  NotificationService.m
//  medi
//
//  Created by admin on 2017/9/30.
//  Copyright © 2017年 admin. All rights reserved.
//
/*
{
    aps : {
        alert : {...},
        mutable-content : 1 //必须
    }
    your-attachment : aPicture.png //必须
}
*/
//mutable-content : 1 说明该推送在接收后可被修改，这个字段决定了系统是否会调用 Notification Service 中的方法。
#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler     = contentHandler;
    
    // 1.把推送内容转为可变类型
    self.bestAttemptContent = [request.content mutableCopy];
    
    // 2.获取 1 中自定义的字段 value
    NSString *urlStr = [request.content.userInfo valueForKey:@"your-attachment"];
    
    // 3.将文件夹名和后缀分割
    NSArray *urls    = [urlStr componentsSeparatedByString:@"."];
    
    // 4.获取该文件在本地存储的 url
    NSURL *urlNative = [[NSBundle mainBundle] URLForResource:urls[0] withExtension:urls[1]];
    
    // 5.依据 url 创建 attachment
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:urlStr URL:urlNative options:nil error:nil];
    
    // 6.赋值 @[attachment] 给可变内容
    self.bestAttemptContent.attachments = @[attachment];
    
    // 7.处理该内容
    self.contentHandler(self.bestAttemptContent);
    
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
