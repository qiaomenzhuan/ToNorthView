//
//  YLToNorthView.m
//  ToNorthView
//
//  Created by 杨磊 on 2018/4/13.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "YLToNorthView.h"

@interface YLToNorthView()

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, assign) float lastDegree;
@property (nonatomic, assign) float calibration;//每个刻度相隔的像素数
@property (nonatomic, assign) float degreeInterval;//每个刻度间隔的度数
@end

@implementation YLToNorthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    self.myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.myScrollView];
    
    UIImageView *viewline = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 10)/2, 0,10, 10)];
    viewline.image = [UIImage imageNamed:@"icon_act_jiantou"];
    [self addSubview:viewline];
}

#pragma mark - 计算代码
- (void)setDegree:(float)degree
{
    _degree = degree;
    float count = 360.f/self.degreeInterval;//一整个圆周被分割成多少份
    float x = self.calibration*degree/self.degreeInterval + self.calibration/2.f;//myScrollView需要做的偏移量
    x = MIN(x, self.calibration*(count+1));
    if ((self.lastDegree > 350 && degree < 10)||(self.lastDegree < 10 && degree>350))
    {//这里是临界点0度和360度 经过这里的时候会让myScrollView从尾部偷偷滑到头部
        [self.myScrollView setContentOffset:CGPointMake(x, 0)];
    }else
    {
        [UIView animateWithDuration:0.1 animations:^{
            [self.myScrollView setContentOffset:CGPointMake(x, 0)];
        }];
    }
    //记录上一次的角度
    self.lastDegree = degree;
}

- (void)scrollToNorthViewAddSubView
{//0到360度每隔DEGREE度画一个点  然后在0度的左边增加myScrollView一半宽度的刻度 360的右边增加myScrollView一半宽度的刻度 这样可以保证显示的刻度始终在myScrollView的正中间
    float w = self.myScrollView.frame.size.width;
    float count = 360.f/self.degreeInterval;//360度一共显示多少个刻度
    float fullCount = w/self.calibration + 1;//myScrollView宽度能显示多少个刻度 +1是为了显示全刻度上的文字
    
    int degree = -self.degreeInterval*(fullCount + 1)/2.f;
    for (int i = 0; i < count + fullCount; i++)
    {
        degree = degree + self.degreeInterval;
        UIView *viewBack = [UIView new];
        UIView *view = [self scrollSub:degree];
        viewBack.frame = CGRectMake(self.calibration*i, 0,self.calibration, 20);
        [viewBack addSubview:view];
        [self.myScrollView addSubview:viewBack];
    }
}


/**
 可以设置刻度尺上显示的文字

 @param degree 角度
 @return 每一个刻度子view
 */
- (UIView *)scrollSub:(int)degree
{
    UIColor *tColor = [UIColor blackColor];
    
    if (degree < 0) {
        degree = 360 + degree;
    }else if (degree > 360)
    {
        degree = degree - 360;
    }
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, self.calibration, 20);
    UIView *viewLine = [UIView new];
    UILabel *label = [UILabel new];
    viewLine.clipsToBounds = YES;
    viewLine.backgroundColor = tColor;
    
    label.textColor = tColor;
    label.textAlignment = NSTextAlignmentCenter;
    NSString *str = [NSString stringWithFormat:@"%d",degree];
    NSInteger flag = 0;
    if (degree == 0 || degree == 360)
    {
        str = @"北";
        flag = 1;
    }else if (degree == 45)
    {
        str = @"东北";
        flag = 1;
    }else if (degree == 90)
    {
        str = @"东";
        flag = 1;
    }else if (degree == 135)
    {
        str = @"东南";
        flag = 1;
    }else if (degree == 180)
    {
        str = @"南";
        flag = 1;
    }else if (degree == 225)
    {
        str = @"西南";
        flag = 1;
    }else if (degree == 270)
    {
        str = @"西";
        flag = 1;
    }else if (degree == 315)
    {
        str = @"西北";
        flag = 1;
    }
    CGRect lineFrame = CGRectMake((self.calibration -2)/2, 0, 2, 6);
    CGFloat lineW = 1.f;
    label.font = [UIFont systemFontOfSize:10.f];
    if (flag)
    {
        lineFrame = CGRectMake((self.calibration -2)/2, 0, 3, 8);
        lineW = 1.5f;
        label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.f];
    }
    viewLine.frame = lineFrame;
    viewLine.layer.cornerRadius = lineW;
    label.frame = CGRectMake(0, 10, self.calibration, 10);
    label.text = str;
    [view addSubview:viewLine];
    [view addSubview:label];
    return view;
}

- (YLCalibration)cali
{
    __weak typeof(self) weakSelf = self;
    return ^(float value)
    {
        self.calibration  = value;
        return weakSelf;
    };
}

- (YLDegreeInterval)degr
{
    __weak typeof(self) weakSelf = self;
    return ^(float value)
    {
        self.degreeInterval  = value;
        return weakSelf;
    };
}

- (YLCreat)creat
{
    __weak typeof(self) weakSelf = self;
    return ^(void)
    {
        [self scrollToNorthViewAddSubView];
        
        float w = self.frame.size.width;
        float count = 360.f/self.degreeInterval;//360度一共显示多少个刻度
        float fullCount = w/self.calibration + 1;//myScrollView宽度能显示多少个刻度 +1是为了显示全刻度上的文字
        self.myScrollView.contentSize = CGSizeMake((count + fullCount)*self.calibration, 20);//总长度
        return weakSelf;
    };
}
@end
