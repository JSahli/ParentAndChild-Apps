//
//  ViewController.h
//  ParentApp
//
//  Created by Jesse Sahli on 5/18/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Equations.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController  <UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *createLabel;
@property (strong, nonatomic) IBOutlet UILabel *updateLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusError;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *radiusTextField;
@property (strong, nonatomic) IBOutlet UITextField *zoneLongitude;
@property (strong, nonatomic) IBOutlet UITextField *zoneLatitude;
@property(nonatomic) double distance;
@property(nonatomic) double radiusDouble;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UIView *errorView;
- (IBAction)createButton:(id)sender;
- (IBAction)updateButton:(id)sender;
- (IBAction)statusButton:(id)sender;
- (IBAction)myCoordinatesButton:(id)sender;
-(void)hideLabel: (UILabel*)label;

@end

