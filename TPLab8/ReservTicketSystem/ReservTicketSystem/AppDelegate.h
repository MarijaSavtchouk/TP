//
//  AppDelegate.h
//  ReservTicketSystem
//
//  Created by fpmi on 03.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray*)getAllFlightsByCityTo: (NSString*) cityTo useCityFrom: (NSString *)cityFrom;


@end

