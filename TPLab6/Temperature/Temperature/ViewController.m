//
//  ViewController.m
//  Temperature
//
//  Created by fpmi on 14.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UILabel *temperature;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)update:(id)sender
{
    NSMutableString *url_buf = [[NSMutableString alloc] initWithString:@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22"];

    [url_buf appendString: [_cityField text]];
    [url_buf appendString:@"%2C%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"];
    NSURL *url = [[NSURL alloc] initWithString:url_buf];
    NSData *contents = [[NSData alloc] initWithContentsOfURL:url];
    
    NSDictionary *forecast = [NSJSONSerialization JSONObjectWithData:contents options:NSJSONReadingMutableContainers error:nil];
    if([[NSString stringWithFormat:@"%@", forecast[@"query"][@"count"]] isEqualToString:@"1"])
    {
        double temperature = [[NSString stringWithFormat:@"%@ F", forecast[@"query"][@"results"][@"channel"][@"item"][@"condition"][@"temp"]] doubleValue];
        temperature = (temperature - 32) * 5/ 9.0;
    
        [_temperature setText:[NSString stringWithFormat:@"%.1fC", temperature]];
        float green = 0;
        float blue = 0;
        float red = 0;
        if(temperature<=0)
        {
            blue = 1.0f;
            red = green = (255+6*temperature)/255.0f;
        }
        else
        {
            red = 1.0f;
            blue = green = (255-6*temperature)/255.0f;
        }
        
        [[self temperature] setTextColor:[UIColor colorWithRed:red
                    green:green
                     blue:blue
                    alpha:1.0f]];
    }
    else
    {
        [_temperature setText:@""];
         }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
