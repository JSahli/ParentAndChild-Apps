//
//  ViewController.m
//  ParentApp
//
//  Created by Jesse Sahli on 5/18/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()

@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, strong) NSString *longitude;
@end


@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.radiusTextField.delegate = self;
    self.usernameTextField.delegate = self;
    self.zoneLatitude.delegate = self;
    self.zoneLongitude.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    [self.updateLabel setHidden:YES];
    [self.createLabel setHidden:YES];
    [self.statusError setHidden:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation * updatedLocation = locations[0];
    
    self.latitude = [NSString stringWithFormat:@"%f", updatedLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", updatedLocation.coordinate.longitude];
}

//Button to use current Latitude/Longitude
- (IBAction)myCoordinatesButton:(id)sender {
    self.zoneLongitude.text = self.longitude;
    self.zoneLatitude.text = self.latitude;
}

//This code makes the keyboard go when enter it pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//This code makes keyboards disappear when anywhere else on the screen is touched
- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    [self.radiusTextField resignFirstResponder];
    [self.zoneLongitude resignFirstResponder];
    [self.zoneLatitude resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (IBAction)createButton:(id)sender {
    
    //Testing for proper text field input
     NSCharacterSet * numberSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
    BOOL validRadius = [[self.radiusTextField.text stringByTrimmingCharactersInSet:numberSet]isEqualToString:@""];
    BOOL validLongitude = [[self.zoneLongitude.text stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
     BOOL validLatitude = [[self.zoneLatitude.text stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
    
    if (validRadius && validLatitude && validLongitude) {
        
        NSString *username = self.usernameTextField.text;
        username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    NSDictionary *userDetails = @{@"username":username,@"latitude":self.zoneLatitude.text,@"longitude":self.zoneLongitude.text,@"radius":self.radiusTextField.text};
   
        //Hide Error Message if it exists
        
        [self.errorView setHidden:YES];
        [self.createLabel setHidden:NO];
        [self performSelector:@selector(hideLabel:) withObject:self.createLabel afterDelay:2];
        //PUT Request to create a new user
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails options:0 error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", username]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"PUT"];
    
    [[session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   NSLog(@"request complete");
               }]
     resume];
    
        
        //Create Error message if there are letters or symbols in the text fields
    } else {
        NSLog(@"There are letters in textfields that require only numbers");
        dispatch_async(dispatch_get_main_queue(), ^{
        self.errorView = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:kNilOptions] objectAtIndex:0];
            self.errorView.frame = CGRectMake(0, 0, 350, 20);
            [self.view addSubview:self.errorView];
        });
    }
}



- (IBAction)updateButton:(id)sender {
    NSCharacterSet * numberSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
    BOOL validRadius = [[self.radiusTextField.text stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
    BOOL validLongitude = [[self.zoneLongitude.text stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
    BOOL validLatitude = [[self.zoneLatitude.text stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
    
    NSString *username = self.usernameTextField.text;
    username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    if (validRadius && validLatitude && validLongitude) {
        NSDictionary *userDetails = @{@"username":username ,@"latitude":self.zoneLatitude.text,@"longitude":self.zoneLongitude.text,@"radius":self.radiusTextField.text};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.errorView setHidden:YES];
            [self.updateLabel setHidden:NO];
            [self performSelector:@selector(hideLabel:) withObject:self.updateLabel afterDelay:2];
        });
        
        
        //patch request to change the data at a URL
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDetails options:0 error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        }
        NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", username]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"PATCH"];
        
        [[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSLog(@"request complete");
                    }]
         resume];
        
    } else {
        NSLog(@"There are letters in textfields that require only numbers");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorView = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:kNilOptions] objectAtIndex:0];
            self.errorView.frame = CGRectMake(0, 0, 350, 20);
            [self.view addSubview:self.errorView];
        });
    }
}


//hide label
-(void)hideLabel:(UILabel*) label {
    label.hidden = true;
}



//C Function to measure the distance between long/lat coordinates
double meterDistance(double lat1, double long1, double lat2, double long2) {
    #define d2r (M_PI / 180.0)
    double dlong = (long2 - long1) * d2r;
    double dlat = (lat2 - lat1) * d2r;
    double a = pow(sin(dlat/2.0), 2) + cos(lat1*d2r) * cos(lat2*d2r) * pow(sin(dlong/2.0), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = (6367 * c) * 1000;
    
    return d;
}



- (IBAction)statusButton:(id)sender {
    
    NSString *username = self.usernameTextField.text;
    username = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://turntotech.firebaseio.com/digitalleash/%@.json", username]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"GET";
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if(error){
                        [self.statusError setHidden:NO];
                        [self.statusError performSelector:@selector(setHidden:) withObject:self.statusError afterDelay:1];

                    } else {
             
       NSError *jsonError;
        NSDictionary *jsonToDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers
                                                                         error:&jsonError];
                if(jsonError){
                             dispatch_async(dispatch_get_main_queue(), ^{
                            [self.statusError setHidden:NO];
                            [self performSelector:@selector(hideLabel:) withObject:self.statusError afterDelay:2];
                             });
                } else {
                        
                    NSNumber *parentLong = [jsonToDictionary valueForKey:@"longitude"];
                    NSNumber *parentLat = [jsonToDictionary valueForKey:@"latitude"];
                    NSNumber *childLong = [jsonToDictionary valueForKey:@"current_longitude"];
                    NSNumber *childLat = [jsonToDictionary valueForKey:@"current_latitude"];
                    NSNumber *radius = [jsonToDictionary valueForKey:@"radius"];
                    
                NSLog(@"parentX:%@ \n parentY:%@ \n childX:%@ \n childY:%@ \n radius:%@", parentLong, parentLat, childLong, childLat, radius);
                    
                    double parentX = [parentLong doubleValue];
                    double parentY = [parentLat doubleValue];
                    double childX = [childLong doubleValue];
                    double childY = [childLat doubleValue];
                    self.radiusDouble = [radius doubleValue];
                    
                NSLog(@"distance in meters = %f", meterDistance(parentY, parentX, childY, childX));
                    
                   self.distance = meterDistance(parentY, parentX, childY, childX);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.distance < self.radiusDouble){
                            [self performSegueWithIdentifier:@"showSuccess" sender:nil];
                        } else if(!childX || !childY){
                            [self noReportedChildAlert];
                        }
                        else {
                            [self performSegueWithIdentifier:@"showFailure" sender:nil];
                        }
                    });
                        }
                    }
                }]
     resume];
}


-(void)noReportedChildAlert {
    NSString *title = NSLocalizedString(@"Unreported Child Location", nil);
    NSString *message = NSLocalizedString(@"No child location data has been reported for this username", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", nil);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];

    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end


