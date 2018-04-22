# ToNorthView
好吧，我们老大热衷于在我们的应用中加入一些游戏元素，要我实现这种指南针，喏，就是下面的它：
![ezgif.com-resize.gif](https://github.com/qiaomenzhuan/MyImages/6206716-0ddc6e52a7533ea9.gif)
这个是根据手机朝向显示方向的哦！

##实现原理利用了CLLocationManager的Heading获得手机朝向，然后用一个UIscrollview显示刻度尺，最后根据手机朝向给scrollview设置偏移量setContentOffset，对，就是这么简单，我简单封装了下，拿走用吧，创建很方便。

其实核心代码就下面这些，计算偏移量🤣
```
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
```

这是调用代码，有没有很惊艳
```
        float w = 224;
        _firstView = [[YLToNorthView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - w)/2, 100, w, 50)];
        _firstView.backgroundColor  = [UIColor yellowColor];
        _firstView.degr(20).cali(w/10).creat();
        [self.view addSubview:_firstView];
```

然后传值，也就是把手机朝向传过去
```
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    float degreeS = newHeading.magneticHeading;
    NSLog(@"%f",degreeS);
    self.firstView.degree  = degreeS;
}
```
以上。
