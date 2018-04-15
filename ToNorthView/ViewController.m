//
//  ViewController.m
//  ToNorthView
//
//  Created by 杨磊 on 2018/4/13.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "YLToNorthView.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) YLToNorthView *firstView;
@property (nonatomic, strong) YLToNorthView *secondView;
@property (nonatomic, strong) YLToNorthView *thirdView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locationMap];
}

#pragma mark -  最上面的
- (YLToNorthView *)firstView
{
    if (!_firstView)
    {
        float w = 224;
        _firstView = [[YLToNorthView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - w)/2, 100, w, 50)];
        _firstView.backgroundColor  = [UIColor yellowColor];
        _firstView.degr(20).cali(w/10).creat();
        [self.view addSubview:_firstView];
    }
    return _firstView;
}

- (YLToNorthView *)secondView
{
    if (!_secondView)
    {
        float w = 300;
        _secondView = [[YLToNorthView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - w)/2, 200, w, 50)];
        _secondView.backgroundColor = [UIColor purpleColor];
        _secondView.degr(20).cali(w/12).creat();
        [self.view addSubview:_secondView];
    }
    return _secondView;
}

- (YLToNorthView *)thirdView
{
    if (!_thirdView)
    {
        float w = SCREEN_WIDTH;
        _thirdView = [[YLToNorthView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - w)/2, 300, w, 50)];
        _thirdView.backgroundColor = [UIColor clearColor];
        _thirdView.degr(30).cali(w/10).creat();
        [self.view addSubview:_thirdView];
    }
    return _thirdView;
}

- (void)locationMap
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 0.1;
    [self.locationManager startUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    float degreeS = newHeading.magneticHeading;
    NSLog(@"%f",degreeS);
    self.firstView.degree  = degreeS;
    self.secondView.degree = degreeS;
    self.thirdView.degree  = degreeS;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
