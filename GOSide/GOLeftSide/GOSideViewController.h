//
//  GOSideViewController.h
//  GOSide
//
//  Created by DingDing on 16/4/143.
//  Copyright © 2016年 2GoRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SideStatus) {
    SideStatusOpen = 0,
    SideStatusClose
};

@interface GOSideViewController : UIViewController

@property (nonatomic, readonly) UIViewController *leftViewController;

@property (nonatomic, readonly) UIViewController *contentViewController;

@property (nonatomic, readonly) SideStatus sideCurrentStatus;

/// 开启时 left视图 与 屏幕的距离
@property (nonatomic) CGFloat lSpace;

/*
 *  初始化配置 leftVC 和 contentVC
 */
- (void)configSideWithLeftViewController:(UIViewController *)leftVC contentViewController:(UIViewController *)contentVC;

/*
 * 开启左视图
 */
- (void)openLeftSide;

/*
 * 关闭
 */
- (void)closeLeftSide;

@end
