//
//  ViewController.m
//  Temperature
//
//  Created by fpmi on 14.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "ViewController.h"
#import "QueryProvider.h"
@import CoreLocation;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UISwitch *isGPS;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.geocoder = [[CLGeocoder alloc] init];
    //[self.locationManager startUpdatingLocation];
}
double temperature = 0 ;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[[locations count] - 1];
    
    if (location != nil)
    {
        NSString* url_buf = [QueryProvider queryByLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
        
        NSURL *url = [[NSURL alloc] initWithString:url_buf];
        NSData *contents = [[NSData alloc] initWithContentsOfURL:url];
        NSDictionary *forecast = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
        if([[NSString stringWithFormat:@"%@", forecast[@"query"][@"count"]] isEqualToString:@"1"])
        {
            temperature = [[NSString stringWithFormat:@"%@ F", forecast[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"]] doubleValue];
            temperature = (temperature - 32) * 5/ 9.0;
            
            [_temperature setText:[NSString stringWithFormat:@"%.1fC", temperature]];
            [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error == nil && [placemarks count] > 0) {

                    CLPlacemark *placemark = [placemarks lastObject];
                    [_cityField setText: [NSString stringWithFormat:@"%@", placemark.locality]];
                } else {
                    NSLog(@"%@", error.debugDescription);
                }
            } ];
        
        }
        else
        {
            [_temperature setText:@"Unknown"];
        }
    }
    else {
        [_temperature setText:@"Unknown"];
    }
    
    [[self temperature] setTextColor:[QueryProvider colorByTemperature: temperature]];
    [self.locationManager stopUpdatingLocation];
}
- (IBAction)update:(id)sender
{
    if([_isGPS isOn])
    {
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        
        NSString* url_buf = [QueryProvider queryByCity:[_cityField text]];
        NSURL *url = [[NSURL alloc] initWithString:url_buf];
        NSData *contents = [[NSData alloc] initWithContentsOfURL:url];
        NSDictionary *forecast = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
        if([[NSString stringWithFormat:@"%@", forecast[@"query"][@"count"]] isEqualToString:@"1"])
        {
            temperature = [[NSString stringWithFormat:@"%@ F", forecast[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"]] doubleValue];
            temperature = (temperature - 32) * 5/ 9.0;
            
            [_temperature setText:[NSString stringWithFormat:@"%.1fC", temperature]];
        }
        else
        {
            [_temperature setText:@"Unknown"];
        }
    }
        
    [[self temperature] setTextColor:[QueryProvider colorByTemperature: temperature]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
