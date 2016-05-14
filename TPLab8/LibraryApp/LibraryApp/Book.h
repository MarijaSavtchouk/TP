//
//  Book.h
//  LibraryApp
//
//  Created by fpmi on 06.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSDate * addingToLibraryDate;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * didRead;
@property (nonatomic, retain) NSNumber * mark;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * pageCount;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSString * publichHouse;
@property (nonatomic, retain) NSNumber * publichYear;
@property (nonatomic, retain) NSNumber * gType;

@end
