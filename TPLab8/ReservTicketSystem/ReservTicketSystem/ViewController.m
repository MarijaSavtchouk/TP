//
//  ViewController.m
//  ReservTicketSystem
//
//  Created by fpmi on 03.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"
#import "AppDelegate.h"
#import "Record.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *cityFrom;
@property (weak, nonatomic) IBOutlet UITextField *cityTo;
@property (weak, nonatomic) IBOutlet UITableView *flightsTable;
@property (weak, nonatomic) IBOutlet UILabel *errMessage;
- (IBAction)showFlights:(id)sender;
@property int isCity;
@property MKPointAnnotation *annotationFrom;
@property MKPointAnnotation *annotationTo;

@end

@implementation ViewController
NSMutableArray *tableData;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [NSMutableArray array];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.map addGestureRecognizer:longPressGesture];
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier =
    @"SimpleTableItem";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [tableData
                           objectAtIndex:indexPath.row];
    return cell;
}
- (IBAction)handleLongPressGesture:(UIGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CGPoint point =[sender locationInView: self.map];
        CLLocationCoordinate2D coord = [self.map convertPoint:point toCoordinateFromView:self.map];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
             }
             for (CLPlacemark * placemark in placemarks)
             {
                 [self setAnnotationToMap: _isCity useTitle :placemark.locality andCoords :coord];
             }
         }];
    }
}

-(void) setAnnotationToMap: (int) type useTitle: (NSString *)title andCoords: (CLLocationCoordinate2D) coordinate
{
    if(type==0)
    {
        [_map removeAnnotation: _annotationFrom];
        _annotationFrom = [[MKPointAnnotation alloc] init];
        _annotationFrom.title = title;
        _annotationFrom.coordinate = coordinate;
        [_map addAnnotation: _annotationFrom];
        self.cityFrom.text = title;
    }
    else
    {
        [_map removeAnnotation: _annotationTo];
        _annotationTo = [[MKPointAnnotation alloc] init];
        _annotationTo.title = title;
        _annotationTo.coordinate = coordinate;
        [_map addAnnotation: _annotationTo];
        self.cityTo.text = title;
    }
}

- (IBAction) textFieldDidBeginEditing:(id)textField
{
    NSLog(@"here");
    if(textField==self.cityFrom)
    {
        _isCity = 0;
          NSLog(@"here0");
        
    }
    else if (textField==self.cityTo)
    {
        _isCity = 1;
          NSLog(@"here1");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showFlights:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSArray *myArr  = [app getAllFlightsByCityTo: [_cityTo text] useCityFrom: [_cityFrom text]];
    if([myArr count]==0)
    {
        [_errMessage setText:@"No information about flights"];
    }
    else
    {
        [_errMessage setText:@""];
    }
    tableData = [NSMutableArray array];
    [myArr enumerateObjectsUsingBlock:^(Record *obj, NSUInteger idx, BOOL*stop)
     {
         NSLog(@"%@ %@ %@", obj.price, obj.aviaCompany, obj.dateTime);
         [tableData addObject: [NSString stringWithFormat:@"%@ %@ %@", obj.aviaCompany, obj.dateTime, obj.price] ];
         
     }];
    [_flightsTable reloadData];
    
}
@end
