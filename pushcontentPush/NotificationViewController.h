//
//  NotificationViewController.h
//  pushcontentPush
//
//  Created by admin on 2017/9/30.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
//http://www.jianshu.com/p/25ca24215f75

//Notification Content
//
//iOS 10 新增的另一项 Extension，用于完全自定义推送展示的 UI 界面，响应 Actions 的同时刷新该 UI。简单的说就是你可以把需要推送的内容（比如一条完整的新闻快讯，包括多条文字+图片的组合）全部放到一条推送里，用户点击了一个 Action（如赞、踩、关注、甚至评论等），在推送里立刻刷新 UI（如展示加星动画、评论内容等）。
/*
 特点:
需要添加 Notification content extension
完全自定义 UI
推送 UI 不能响应触摸、点击、滑动等任何手势
可以响应 notification actions
 */


@interface NotificationViewController : UIViewController

@end
/**当你各种 UI 展示后，会发现存在 2 个问题。
 1.是系统会自动展示一遍收到的推送内容，这部分很可能跟你的内容是重复的。
 解决方法
 
 在 Info.plist 中添加如下字段，并且把值设为 YES 即可隐藏系统默认的展示。UNNotificationExtensionDefaultContentHidden
 2.是展示内容比较少的时候，系统仍然会以最大的界面展示出来，会露出很多空白部分。
 方法一：在 viewDidLoad 中调整 self 的 size 以达到一个合适的尺寸。如下获取了 size，并修改至一半的高度。
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 CGSize size = self.view.bounds.size;
 self.preferredContentSize = CGSizeMake(size.width, size.height/2);
// 仔细看你会发现存在小 bug，先展示了完整的高度，然后瞬间变成一半的高度，看起来有个高度适应的动画的样子。导致这种结果的原因是系统准备展示推送的时候，还没有执行到你的代码（展示从系统层级到 App 层级的过程），这是苹果内部的机制所致。
 }
 方法二：还是在 Info.plist 文件添加新的字段，设置缩放比例。
 UNNotificationExtensionInitialContentSizeRatio 设置比例
 这样系统层级会预先读取该数据，用于展示。当然有时候展示的内容不同，需要的高度不同，而这里只能设置成唯一的固定值。不过这也是现阶段苹果所能给你提供的可行方法了。
 

 ***/

