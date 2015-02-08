//
//  ParkingSpaceInf.m
//  LocationManagerExample
//
//  Created by gfxcc on 1/19/15.
//  Copyright (c) 2015 Intuit Inc. All rights reserved.
//

#import "ParkingSpaceInf.h"
#import "INTUAppDelegate.h"

@interface ParkingSpaceInf ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ParkingSpaceInf


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIToolbar *curBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0.0,0.0,320.0,90.0)];
    [self.view addSubview:curBar];
    curBar.translucent = true;
    CALayer *TopBorder = [CALayer layer];
    UIColor *borderColor = [UIColor colorWithRed:200.0/255 green:198.0/255 blue:189.0/255 alpha:1.0];
    TopBorder.frame = CGRectMake(0.0f, curBar.frame.size.height, curBar.frame.size.width, 1.0f);
    TopBorder.backgroundColor = borderColor.CGColor;
    [self.view.layer addSublayer:TopBorder];
    [self.view bringSubviewToFront:_parkInf];
    
    
    
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
    [_mapView addGestureRecognizer:lpress];//m_mapView是MKMapView的实例
    //[lpress release];
    
    _mapView.mapType = MKMapTypeStandard;
    _mapView.delegate = self;
    
    //self.parkInf.text = [NSString stringWithFormat:@"Address:%@",address];
    /////////////////
    
    //locate the address on map
    NSString *inf=[NSString stringWithFormat:@"%@ \t%@", address,city];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:inf completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //NSLog(@"查询记录数：%i",[placemarks count]);
        
        if ([placemarks count] > 0) {
            [_mapView removeAnnotations:_mapView.annotations];
        }
        
        for (int i = 0; i < [placemarks count]; i++) {
            
            CLPlacemark* placemark = placemarks[i];
            
            //关闭键盘
            //[_txtQueryKey resignFirstResponder];
            
            //调整地图位置和缩放比例
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate, 700, 700);
            [_mapView setRegion:viewRegion animated:YES];
    
            /*
            MapLocation *annotation = [[MapLocation alloc] init];
            //annotation.streetAddress = address;
            annotation.city = placemark.locality;
            annotation.state = placemark.administrativeArea;
            annotation.zip = placemark.postalCode;
            annotation.coordinate = placemark.location.coordinate;
            [_mapView addAnnotation:annotation];
            */
            
            
            
        }
    }];
    
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
    
    [self analyze];
}

// function to respond longPress
- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        return;
    }
    
    if(_mapView.annotations.count > 1) {
        return;
    }
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    
    
    
    MKPointAnnotation*　pointAnnotation = nil;
    pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = touchMapCoordinate;
    pointAnnotation.title = [NSString stringWithFormat:@"%@",city];
    [_mapView addAnnotation:pointAnnotation];
    
    
    CLLocationCoordinate2D destCoordinate=pointAnnotation.coordinate;
    
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        destCoordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                  destCoordinate.longitude]);
    
    CLLocation *currLocation =[[CLLocation alloc] initWithLatitude:destCoordinate.latitude longitude:destCoordinate.longitude];
    NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                        currLocation.coordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                           currLocation.coordinate.longitude]);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if ([placemarks count] > 0) {
                           
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =  placemark.addressDictionary;
                           
                           extern NSString *address;
                           
                           address = [addressDictionary
                                      objectForKey:(NSString *)kABPersonAddressStreetKey];
                           address = address == nil ? @"": address;
                           
                           extern NSString *state;
                           state = [addressDictionary
                                    objectForKey:(NSString *)kABPersonAddressStateKey];
                           state = state == nil ? @"": state;
                           
                           extern NSString *city;
                           city = [addressDictionary
                                   objectForKey:(NSString *)kABPersonAddressCityKey];
                           city = city == nil ? @"": city;
                           
                           //sSelf.streetInf.text = [NSString stringWithFormat:@"%@ \t%@ \t%@",state, address,city];
                           NSLog(@"%@ \t%@ \t%@",state, address,city);
                       }
                       
                   }];
    
    
    
    
}

// analyze parking information after updata location inf
- (void) analyze {
    
    self.parkInf.text = @"";
    //[self.parkInf clearsContextBeforeDrawing];
    int blockindex = 0;
    // locate block
    for(;![[address substringWithRange:NSMakeRange(blockindex, 1)] isEqualToString:@" "];blockindex++)
    {
        //NSString *tt = [address substringWithRange:NSMakeRange(blockindex, 1)];
    }
    NSString *addressNum = [address substringToIndex:blockindex];
    NSString *addressSt = [address substringFromIndex:blockindex+1];
    
    NSString *textTmp = self.parkInf.text;
    textTmp = [NSString stringWithFormat:@"%@\n%@\n%@",textTmp,addressNum,addressSt];
    //self.parkInf.text = textTmp;
    
    //read inf
    NSArray* lines = [self readfile];
    
    //search from inf
    for(int index=0;index!=lines.count;index++)
    {
        NSArray *detail = [lines[index] componentsSeparatedByString:@"\t"];
        
        //begin match
        if([detail[0] isEqualToString:addressSt])
        {
            if([self judgeNum:addressNum infNum:detail[5]])
            {
                if([direction isEqualToString:detail[1]]||[direction isEqualToString:@"all"])//judge navigation
                {
                    NSString *textTmp = self.parkInf.text;
                    
                    NSString *newinf = [NSString stringWithFormat:@"%@\t%@\t%@\t%@\t%@",detail[0],detail[1],detail[2],detail[3],detail[5]];
                    textTmp = [NSString stringWithFormat:@"%@\n%@",textTmp,newinf];
                    self.parkInf.text = textTmp;
                    //self.infText.text = textTmp;
                }
            }
        }
    }
}


#pragma mark -
#pragma mark Map View Delegate Methods
/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}*/

- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error
{
    NSLog(@"error : %@",[error description]);
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];//导航栏右边回到当前位置的按钮可用
        return nil;
    }
    
    
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView* customPinView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!customPinView) {
        customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        
        //customPinView.pinColor = MKPinAnnotationColorRe;//设置大头针的颜色
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.draggable = YES;//可以拖动
        
        //添加tips上的按钮
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
    }else{
        customPinView.annotation = annotation;
    }
    return customPinView;
    
}

- (void)showDetails:(UIButton*)sender
{
    [self analyze];
}



- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    switch (newState) {
        case MKAnnotationViewDragStateStarting: {
            NSLog(@"拿起");
            CLLocationCoordinate2D destCoordinate=view.annotation.coordinate;
            
            
            return;
        }
        case MKAnnotationViewDragStateDragging: {
            NSLog(@"开始拖拽");
            return;
        }
        case MKAnnotationViewDragStateEnding: {
            NSLog(@"放下,并将大头针");
            CLLocationCoordinate2D destCoordinate=view.annotation.coordinate;
            
            NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                                destCoordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                          destCoordinate.longitude]);
            
            CLLocation *currLocation =[[CLLocation alloc] initWithLatitude:destCoordinate.latitude longitude:destCoordinate.longitude];
            NSLog(@"%@ /t  %@",[NSString stringWithFormat:@"%3.5f",
                                currLocation.coordinate.latitude],[NSString stringWithFormat:@"%3.5f",
                                                          currLocation.coordinate.longitude]);

            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:currLocation
                           completionHandler:^(NSArray *placemarks, NSError *error) {
                               
                               if ([placemarks count] > 0) {
                                   
                                   CLPlacemark *placemark = placemarks[0];
                                   
                                   NSDictionary *addressDictionary =  placemark.addressDictionary;
                                   
                                   extern NSString *address;
                                   
                                   address = [addressDictionary
                                              objectForKey:(NSString *)kABPersonAddressStreetKey];
                                   address = address == nil ? @"": address;
                                   
                                   extern NSString *state;
                                   state = [addressDictionary
                                            objectForKey:(NSString *)kABPersonAddressStateKey];
                                   state = state == nil ? @"": state;
                                   
                                   extern NSString *city;
                                   city = [addressDictionary
                                           objectForKey:(NSString *)kABPersonAddressCityKey];
                                   city = city == nil ? @"": city;
                                   
                                   //sSelf.streetInf.text = [NSString stringWithFormat:@"%@ \t%@ \t%@",state, address,city];
                                   NSLog(@"%@ \t%@ \t%@",state, address,city);
                               }
                               
                           }];
            
            //[self analyze];

            return;
        }
        default:
            return;
    }
}


#pragma mark -
#pragma mark Map View Delegate Methods



- (IBAction)closeClick:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:^{
        NSLog(@"Present Modal View");
    }];
}


- (BOOL)judgeNum: (NSString*)locNum infNum:(NSString*)infNum{
    
    NSString *errinf = @"^^^";
    if([infNum isEqualToString:@"all"])
    {
        return true;
    }
    else
    {
        if(![infNum isEqualToString:@"!#!"])
        {
            //locate #
            int sepindex = 0;
            for(;![[infNum substringWithRange:NSMakeRange(sepindex, 1)] isEqualToString:@"#"];sepindex++)
            {
                //
            }
            int min = [[infNum substringToIndex:sepindex] intValue];
            int max = [[infNum substringFromIndex:sepindex+1] intValue];
            
            if(locNum.length<=4)
            {
                NSString *judgeInf = [NSString stringWithFormat:@"Analyse Inf num: loc:%@  \n File Inf:%@-%@",locNum,[infNum substringToIndex:sepindex],[infNum substringFromIndex:sepindex+1]];
                //locNum is a num
                if([locNum intValue]>=min&&[locNum intValue]<=max)
                {
                    //updata message
                    
                    NSString *textTmp = self.parkInf.text;
                    textTmp = [NSString stringWithFormat:@"%@\n%@",textTmp,judgeInf];
                    //self.parkInf.text = textTmp;
                    return true;
                }
                errinf = judgeInf;
            }
            else
            {
                //locNum is a scope
                //
                if(min==0&&max==329)
                {
                    int breakpoint;
                }
                //analyse locNum
                int locindex = 0;
                for(;![[locNum substringWithRange:NSMakeRange(locindex,1)] isEqualToString:@"–"];locindex++)
                {
                    NSString *tempt = [locNum substringWithRange:NSMakeRange(locindex,1)];
                    bool jud = [tempt isEqualToString:@"–"];
                }
                int locmin = [[locNum substringToIndex:locindex] intValue];
                int locmax = [[locNum substringFromIndex:locindex+1] intValue];
                
                NSString *judgeInf = [NSString stringWithFormat:@"Analyse Inf scope: loc:%@-%@  \n File Inf:%@-%@",[locNum substringToIndex:locindex],[locNum substringFromIndex:locindex+1],[infNum substringToIndex:sepindex],[infNum substringFromIndex:sepindex+1]];
                if(min<=locmin && max>=locmax)
                {
                    //updata message
                    
                    NSString *textTmp = self.parkInf.text;
                    textTmp = [NSString stringWithFormat:@"%@\n%@",textTmp,judgeInf];
                    //self.parkInf.text = textTmp;
                    return true;
                }
                errinf = judgeInf;
            }
        }
    }
    
    //put out err inf
    /*
    NSString *textTmp = self.parkInf.text;
    textTmp = [NSString stringWithFormat:@"%@\n%@",textTmp,errinf];
    self.parkInf.text = textTmp;
    */
    return false;
}


- (NSArray*)readfile{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"ParkingInf" ofType:@""];
    NSArray *lines;
    lines = [[NSString stringWithContentsOfFile:path encoding: NSUTF8StringEncoding error:nil]
             componentsSeparatedByString:@"\n"];
    return lines;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
