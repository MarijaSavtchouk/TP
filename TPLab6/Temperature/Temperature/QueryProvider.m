//
//  QueryProvider.m
//  Temperature
//
//  Created by fpmi on 19.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "QueryProvider.h"
#import <UIKit/UIKit.h>

@implementation QueryProvider
static NSString* queryFirst = @"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22";
static NSString* querySecond = @"%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys";

+(NSString*)queryByCity:(NSString *)city
{
    
    NSMutableString *query = [[NSMutableString alloc] initWithString:queryFirst];
    [query appendString:city];
    [query appendString:querySecond];
    return [[NSString alloc] initWithString:query];
}
+ (NSString *) queryByLatitude:(double)latitude andLongitude:(double)longitude
{
    
    NSMutableString *query = [[NSMutableString alloc] initWithString:queryFirst];
    [query appendString:[NSString stringWithFormat:@"(%f,%f)", latitude, longitude]];
    [query appendString:querySecond];
    return [[NSString alloc] initWithString:query];
}
+ (UIColor *) colorByTemperature:(double)temperature
{
    
    float green = 0;
    float blue = 0;
    float red = 0;
    if(temperature<=0)
    {
        blue = 1.0f;
        red = green = (200+5*temperature)/255.0f;
        if(red<0)
        {
            red = green = 0;
        }
    }
    else
    {
        red = 1.0f;
        blue = green = (200-5*temperature)/255.0f;
        if(blue<0)
        {
            blue = green = 0;
        }
    }
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:1.0f];

}
@end;