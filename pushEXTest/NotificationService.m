//
//  NotificationService.m
//  pushEXTest
//
//  Created by admin on 2017/9/30.
//  Copyright © 2017年 admin. All rights reserved.
//
//这里我们要注意一定要有"mutable-content": "1",以及一定要有Alert的字段，否则可能会拦截通知失败。（苹果文档说的）。除此之外，我们还可以添加自定义字段，比如，图片地址，图片类型，
//{"aps":{"alert":"Enter your message","badge":1,"sound":"default","mutable-content":1}}
#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    self.bestAttemptContent.title=@"我是标题";
    self.bestAttemptContent.subtitle=@"我是副标题";
    self.bestAttemptContent.body=@"来自ssp";
    self.bestAttemptContent.launchImageName=@"test1";
    
    NSDictionary *dict=self.bestAttemptContent.userInfo;
    NSLog(@"====userinfo==%@",dict);
    NSDictionary *notiDict=dict[@"aps"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@",notiDict[@"imageAbsoluteString"]];
    if (!imgUrl.length) {
        self.contentHandler(self.bestAttemptContent);
    }
    
//    [self loadAttachmentForUrlString:imgUrl withType:@"png" completionHandle:^(UNNotificationAttachment *attach) {
//
//        if (attach) {
//            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
//        }
//
//
//    self.contentHandler(self.bestAttemptContent);
//         }];
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
