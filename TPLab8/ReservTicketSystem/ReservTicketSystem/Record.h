//
//  Record.h
//  ReservTicketSystem
//
//  Created by fpmi on 05.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * aviaCompany;
@property (nonatomic, retain) NSString * cityFrom;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * cityTo;
@property (nonatomic, retain) NSString * dateTime;

@end
