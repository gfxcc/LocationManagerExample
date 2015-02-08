//
//  NewUITestViewController.m
//  LocationManagerExample
//
//  Created by caoyong on 2/6/15.
//  Copyright (c) 2015 Intuit Inc. All rights reserved.
//

#import "NewUITestViewController.h"

@interface NewUITestViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation NewUITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIToolbar *curBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,60.0)];
    [self.view addSubview:curBar];
    curBar.translucent = true;
    CALayer *TopBorder = [CALayer layer];
    UIColor *borderColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:189.0/255 alpha:1.0];
    TopBorder.frame = CGRectMake(0.0f, 60.0f, curBar.frame.size.width, 1.0f);
    TopBorder.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector
         (requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    if ([CLLocationManager locationServicesEnabled])
    {
        _mapView.mapType = MKMapTypeStandard;
        //_mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
