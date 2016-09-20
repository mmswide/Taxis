//
//  IntroductionViewController.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/18/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "IntroductionViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface IntroductionViewController() <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UIButton *allowLocationButton;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowLocationButton.layer.cornerRadius = 4.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)didTouchAllowLocation:(UIButton *)sender {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];

}

#pragma mark - Helpers
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusAuthorizedAlways) {
        
        NSUserDefaults* defauts = [NSUserDefaults standardUserDefaults];
        [defauts setObject:[NSNumber numberWithBool:YES] forKey:@"introShowed"];
        [defauts synchronize];
        [self performSegueWithIdentifier:@"goToMain" sender:self];
        
    }
}

@end
