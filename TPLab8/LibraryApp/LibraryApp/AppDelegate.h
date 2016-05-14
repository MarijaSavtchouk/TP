//
//  AppDelegate.h
//  LibraryApp
//
//  Created by fpmi on 05.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void) addNewBookUsingName: (NSString*) name andAuthor: (NSString *)author andPublichYear: (int) year andPageCount: (int) pageCount andPublichHouse: (NSString*) publishHouse andNote: (NSString*) note andPhoto: (NSData*) photofile andType: (int) type andMark: (int) mark andDidRead:(BOOL) didRead;
-(NSArray*)getBooksByName: (NSString*) name;
-(NSArray*)getBooksByAuthor: (NSString*) author;
-(NSArray*)sortByYear;
-(NSArray*)sortByAuthor;
-(NSArray*)getAllBooks;
@end

