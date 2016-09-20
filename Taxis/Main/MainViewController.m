//
//  MainViewController.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/15/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "MainViewController.h"
#import <MapKit/MapKit.h>
#import "ServiceManager.h"
#import "Taxi.h"
#import "GeoFrame+Actions.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import "LocationManager.h"
#import "AppManager.h"
#import "Annotation.h"

@interface MainViewController () <UITextFieldDelegate, MKMapViewDelegate, AppManagerDelegate> {
    
    float spanX;
    float spanY;
    
    BOOL isConnectionAvailable;
    
}

@property (weak, nonatomic) IBOutlet UIView *connectionBannerView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIView *addressContainerView;

@property (weak, nonatomic) IBOutlet UIButton *requestTaxiButton;
@property (strong, nonatomic) LocationManager *locationManager;
@property (strong, nonatomic) AppManager *appManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    spanX = 0.00725;
    spanY = 0.00725;
    
    self.connectionBannerView.layer.cornerRadius = 4.0;
    self.connectionBannerView.alpha = 0;
    self.connectionBannerView.hidden = YES;
    
    self.locationManager = [LocationManager sharedManager];
    
    self.appManager = [AppManager sharedManager];
    self.appManager.delegate = self;
    
    self.addressContainerView.layer.cornerRadius = 4.0;
    self.addressTextField.delegate = self;
    
    self.requestTaxiButton.layer.shadowRadius  = 4.0f;
    self.requestTaxiButton.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.requestTaxiButton.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.requestTaxiButton.layer.shadowOpacity = 0.5f;
    self.requestTaxiButton.layer.masksToBounds = NO;
    
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = YES;
    
    [self fetchDrivers];
    [self setUpUserLocationAndAdress];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - AppManager Delegate

-(void)didUpdateConnectionStatus:(NSNumber *)status {
    
    if (status.intValue == 0 || status.intValue == -1) {
        isConnectionAvailable = NO;
        
        self.connectionBannerView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.connectionBannerView.alpha = 1;
        }];
        
    }else {
        
        isConnectionAvailable = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.connectionBannerView.alpha = 0;
        } completion:^(BOOL finished) {
            self.connectionBannerView.hidden = YES;
        }];
        
    }
    
}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self becomeFirstResponder];
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (isConnectionAvailable == NO) {
        [self showAlertViewWithMessage:@"Please check your internet connection"];
        return;
    }
    
    for (id annotation in self.mapView.annotations){
        
        if ([annotation isKindOfClass:[Annotation class]]) {
            
            Annotation* addressAnnotation = annotation;
            if (addressAnnotation.isAddress) {
                [self.mapView removeAnnotation:annotation];
            }
            
        }
        
    }
    
    [self.locationManager getLocationFromAddress:self.addressTextField.text completionHandler:^(CLPlacemark * result, NSError *error) {
    
        if (error) {
            
            [self showAlertViewWithMessage:@"Invalid address"];
            
        } else {
            
            MKCoordinateRegion region;
            region.center.latitude = result.location.coordinate.latitude;
            region.center.longitude = result.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
            
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(result.location.coordinate.latitude, result.location.coordinate.longitude);
            [self dropPinWithCoordinate:coordinate title:@"" subtitle:@"" isAddress:YES];
            
        }

    }];
 
}
#pragma mark - Map

- (void)dropPinWithCoordinate:(CLLocationCoordinate2D)coordinateSent title:(NSString*)title subtitle:(NSString*)subtitle isAddress:(BOOL)isAddress{
    
    Annotation *annotation = [[Annotation alloc]init];
    annotation.coordinate = coordinateSent;
    annotation.title = title;
    annotation.subtitle = subtitle;
    annotation.isAddress = isAddress;
    [self.mapView addAnnotation:annotation];
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]){
        
        return nil;
    }
    
    static NSString *identifier = @"AnnotationView";
    MKAnnotationView * annotationView = (MKAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = NO;
        
    }else {
        
        annotationView.annotation = annotation;
        
    }
    
    if ([annotation isKindOfClass:[Annotation class]]) {
        
        Annotation *newAnnotation = annotation;
        
        if (newAnnotation.isAddress) {
            annotationView.image = [UIImage imageNamed:@"user_pin"];
        } else {
           annotationView.image = [UIImage imageNamed:@"taxi_pin"];
        }
        
        
    }
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    if (self.mapView.userTrackingMode) {
        self.mapView.userTrackingMode = NO;
    }
    
}

#pragma mark - Actions

- (void)fetchDrivers {
    
    MKMapRect mRect = self.mapView.visibleMapRect;
    GeoFrame* frame = [[GeoFrame shared] getGeoFrameFromMapRect:mRect];
    
    [[ServiceManager sharedManager] getLastLocationsForDriversInArea:frame completionHandler:^(NSArray *result, NSError *error) {
        
        if (error) {
            
            [self showAlertViewWithMessage:error.localizedDescription];
            
        } else {
            
            for (Taxi * item in result) {
                
                if (item.isDriverAvailable) {
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(item.latitude.doubleValue, item.longitude.doubleValue);
                    [self dropPinWithCoordinate:coordinate title:@"" subtitle:@"" isAddress:NO];
                }
                
            }
            
            
        }
        
    }];
    
}

- (void)setUpUserLocationAndAdress {
    
    [self.locationManager getUserLocationWithCompletionHandler:^(CLLocation *result, NSError *error) {
        
        MKCoordinateRegion region;
        region.center.latitude = result.coordinate.latitude;
        region.center.longitude = result.coordinate.longitude;
        region.span = MKCoordinateSpanMake(spanX, spanY);
        [self.mapView setRegion:region animated:YES];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(result.coordinate.latitude, result.coordinate.longitude);
        [self dropPinWithCoordinate:coordinate title:@"" subtitle:@"" isAddress:YES];
        
        [self.locationManager getAddressFromLocation:result completionHandler:^(NSString *result, NSError *error) {
            self.addressTextField.text = result;
        }];
        
    }];
    
}

- (IBAction)requestTaxi:(UIButton *)sender {
    
    if (self.addressTextField.text.length == 0) {
        [self showAlertViewWithMessage:@"Please enter a valid address"];
        return;
    }
    
    if (isConnectionAvailable == NO) {
        [self showAlertViewWithMessage:@"Please check your internet connection"];
        return;
    }
    
    [[AppManager sharedManager] getRegisteredUserWithcompletionHandler:^(User *result, NSError *error) {
       
        if (result == nil && error == nil) {
            [self performSegueWithIdentifier:@"goToRegistration" sender:self];
            return;
        }
        
        if (error) {
            [self showAlertViewWithMessage:error.localizedDescription];
            return;
        }
        
        if (result) {
            
            [self requestRide:result];
            
        }
 
    }];
    
    
}

- (void)requestRide:(User*)user {
    
    [self.locationManager getLocationFromAddress:self.addressTextField.text completionHandler:^(CLPlacemark * result, NSError *error) {
       
        if (error) {
            
            [self showAlertViewWithMessage:@"Invalid address"];
            
        }else {
           
            user.latitude = @(result.location.coordinate.latitude);
            user.longitude = @(result.location.coordinate.longitude);
            
            [[ServiceManager sharedManager]requestRideForUser:user completionHandler:^(id result, NSError *error) {
                
                if (error) {

                    if (result && [result isKindOfClass:[NSDictionary class]]) {
                        
                        NSDictionary *errorMsg = result;
                        [self showAlertViewWithMessage:[errorMsg objectForKey:@"msg"]];
                        
                    }else {
                        
                        [self showAlertViewWithMessage:error.localizedDescription];
                        
                    }

                }else {
                    
                    if (result && [result isKindOfClass:[Ride class]]) {
                        
                        Ride *ride = result;
                        [self showAlertViewWithMessage:[NSString stringWithFormat:@"Your Ride is on it's way ID: %@",ride.rideId]];
                        
                    }

                }
                
            }];
            
        }

    }];
 
}

- (IBAction)editAddress:(UIButton *)sender {

    [self.addressTextField becomeFirstResponder];
    
}
- (IBAction)updateUserLocation:(UIButton *)sender {
    
    if (isConnectionAvailable == NO) {
        [self showAlertViewWithMessage:@"Please check your internet connection"];
        return;
    }
    
    for (id annotation in self.mapView.annotations){
        
        if ([annotation isKindOfClass:[Annotation class]]) {
            
            Annotation* addressAnnotation = annotation;
            if (addressAnnotation.isAddress) {
                [self.mapView removeAnnotation:annotation];
            }
            
        }
        
    }
    
    [self.locationManager getUserLocationWithCompletionHandler:^(CLLocation *result, NSError *error) {
        
        MKCoordinateRegion region;
        region.center.latitude = result.coordinate.latitude;
        region.center.longitude = result.coordinate.longitude;
        region.span = MKCoordinateSpanMake(spanX, spanY);
        [self.mapView setRegion:region animated:YES];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(result.coordinate.latitude, result.coordinate.longitude);
        [self dropPinWithCoordinate:coordinate title:@"" subtitle:@"" isAddress:YES];
        
        [self.locationManager getAddressFromLocation:result completionHandler:^(NSString *result, NSError *error) {
            self.addressTextField.text = result;
        }];
        
    }];
    
}

#pragma mark - Helpers
- (void)showAlertViewWithMessage:(NSString*)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Taxis" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
