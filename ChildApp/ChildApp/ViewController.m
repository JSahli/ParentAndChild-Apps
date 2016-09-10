//
//  ViewController.m
//  ChildApp
//
//  Created by Jesse Sahli on 5/18/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import "ViewController.h"
#import "reportedViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.usernameTextField.delegate = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation * updatedLocation = locations[0];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", updatedLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", updatedLocation.coordinate.longitude];
    
    NSLog(@"Latitude : %@", latitude);
    NSLog(@"Longitude : %@",longitude);
    NSString *username = self.usernameTextField.text;
    username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.childDict = @{@"username":username,@"current_latitude":latitude,@"current_longitude":longitude};
}



- (IBAction)reportLocation:(id)sender {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.childDict options:0 error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
    NSString *username = self.usernameTextField.text;
    username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", username]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"PATCH"];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    NSLog(@"request complete");
                }]

     resume];
    
      [self performSegueWithIdentifier:@"showReport" sender:nil];
    
    }
}



@end











