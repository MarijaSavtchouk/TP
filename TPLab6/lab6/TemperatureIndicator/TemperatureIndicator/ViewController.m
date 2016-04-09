//
//  ViewController.m
//  TemperatureIndicator
//
//  Created by Admin on 09.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *indicator;
@end

@implementation ViewController
- (IBAction)refresh:(id)sender
{
    [[self indicator] setText:@"0 C"];
    NSURL *url = [[NSURL alloc]              initWithString:@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22minsk%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"];
    NSData *contents = [[NSData alloc] initWithContentsOfURL:url];
    NSDictionary *forecast = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
    double temperature = [[NSString stringWithFormat:@"%@ F", forecast[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"]] doubleValue];
    temperature = (temperature - 32.0) * 5.0 / 9.0;
    [_indicator setText:[NSString stringWithFormat:@"%.1f C", temperature]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
