//
//  YLToNorthView.h
//  ToNorthView
//
//  Created by 杨磊 on 2018/4/13.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 类似于吃鸡等游戏类的指南针 更容易引导用户的方向感

@class YLToNorthView;

typedef YLToNorthView *(^YLCalibration)(float value);
typedef YLToNorthView *(^YLDegreeInterval)(float value);
typedef YLToNorthView *(^YLCreat)(void);

@interface YLToNorthView : UIView

/**
 手机朝向
 */
@property (nonatomic, assign) float degree;


/**
 每个刻度之间间隔的屏幕像素
 */
@property (nonatomic,  copy)YLCalibration cali;

/**
 每个刻度之间间隔的角度
 */
@property (nonatomic,  copy)YLDegreeInterval degr;

/**
 初始化 放在最后
 */
@property (nonatomic,  copy)YLCreat creat;

@end
