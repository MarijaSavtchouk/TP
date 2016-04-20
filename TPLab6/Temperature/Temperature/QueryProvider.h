//
//  QueryProvider.h
//  Temperature
//
//  Created by fpmi on 19.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QueryProvider : NSObject
+(NSString*)queryByCity:(NSString *)city;
+(NSString*)queryByLatitude:(double)latitude andLongitude:(double)longitude;
+(UIColor*) colorByTemperature:(double)temperature;
@end
