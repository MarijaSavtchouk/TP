//
//  ViewController.m
//  LibraryApp
//
//  Created by fpmi on 05.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Book.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *booksTable;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UISwitch *sortByYear;
@property (weak, nonatomic) IBOutlet UILabel *nameOfBook;
@property (weak, nonatomic) IBOutlet UILabel *yearOfBook;
@property (strong, nonatomic) IBOutlet UILabel *authorOfBook;
@property (strong, nonatomic) IBOutlet UILabel *publishHouse;
@property (strong, nonatomic) IBOutlet UILabel *noteOfBook;
@property (strong, nonatomic) IBOutlet UILabel *numberOfPages;
@property (strong, nonatomic) IBOutlet UILabel *markOfBook;
@property (strong, nonatomic) IBOutlet UILabel *didReadBook;
@property (strong, nonatomic) IBOutlet UILabel *genre;
@property (strong, nonatomic) IBOutlet UITextField *findByName;

@end

@implementation ViewController
NSMutableArray *tableData;
NSMutableArray *images;
NSArray *dataSource;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"didLoad");
    dataSource = [NSArray arrayWithObjects: @"Fantasy",
                  @"Drama",
                  @"Tragedy",
                  @"Satire",
                  @"Science fiction",
                  @"Horror",
                  @"Classic",
                  nil];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *res = [app sortByYear];
    tableData = [NSMutableArray array];
    images = [NSMutableArray array];
    [res enumerateObjectsUsingBlock:^(Book *obj, NSUInteger idx, BOOL*stop)
     {
         NSLog(@"%@ %@ %@", obj.name, obj.author, obj.note);
         [tableData addObject: [NSString stringWithFormat:@"%@ - %@",obj.name, obj.author]];
         NSLog(@"%d", obj.photo==nil);
         if(obj.photo == nil)
         {
             NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://rostislav.kiev.ua/wp-content/uploads/2014/04/kniga.jpg"]];
            [images addObject:[UIImage imageWithData:data]];
         }
         else
             [images addObject:[UIImage imageWithData:obj.photo]];
         
     }];
    [_booksTable reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)findAction:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *res;
        res = [app getBooksByName:[_findByName text]];
    if([res count]==0)
    {
        [_nameOfBook setHidden:true];
        [_authorOfBook setHidden: true];
        [_publishHouse setHidden:true];
        [_yearOfBook setHidden:true];
        [_noteOfBook setHidden:true];
        [_numberOfPages setHidden:true];
        [_markOfBook setHidden:true];
        [_didReadBook setHidden:false];
        [_didReadBook setText:@"No such book"];
        [_photo setHidden:true];
        [_genre setHidden:true];
    }
    else
    {
        Book* book = [res objectAtIndex:0];
        [_nameOfBook setText:book.name];
        [_authorOfBook setText:book.author];
        [_publishHouse setText: book.publichHouse];
        [_yearOfBook setText:[NSString stringWithFormat:@"%@",book.publichYear]];
        [_noteOfBook setText:book.note];
        [_numberOfPages setText:[NSString stringWithFormat:@"%@",book.pageCount]];
        [_markOfBook setText:[NSString stringWithFormat:@"%@",book.mark]];
        [_didReadBook setText:[book.didRead boolValue]?@"You have read this book":@"You haven't read this book"];
        [_photo setImage:[UIImage imageWithData:book.photo]];
        
        [_genre setText: dataSource[[book.gType integerValue]]];
        
        [_nameOfBook setHidden:false];
        [_authorOfBook setHidden: false];
        [_publishHouse setHidden:false];
        [_yearOfBook setHidden:false];
        [_noteOfBook setHidden:false];
        [_numberOfPages setHidden:false];
        [_markOfBook setHidden:false];
        [_didReadBook setHidden:false];
        [_photo setHidden:false];
        [_genre setHidden:false];
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)stateChanged:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *res;
    if([_sortByYear isOn])
        res = [app sortByYear];
    else
       res = [app sortByAuthor];
    tableData = [NSMutableArray array];
    images = [NSMutableArray array];
    [res enumerateObjectsUsingBlock:^(Book *obj, NSUInteger idx, BOOL*stop)
     {
         NSLog(@"%@ %@ %@", obj.name, obj.author, obj.note);
         [tableData addObject: [NSString stringWithFormat:@"%@ - %@",obj.name, obj.author]];
         if(obj.photo == nil)
         {
             NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://rostislav.kiev.ua/wp-content/uploads/2014/04/kniga.jpg"]];
             [images addObject:[UIImage imageWithData:data]];
         }
         else
             [images addObject:[UIImage imageWithData:obj.photo]];
         
     }];
    [_booksTable reloadData];
    
}
- (IBAction)goToAdding:(id)sender
{
     [self performSegueWithIdentifier:@"AddBooks" sender:self];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *res;
    if([_sortByYear isOn])
        res = [app sortByYear];
    else
        res = [app sortByAuthor];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Book* book = [res objectAtIndex:indexPath.row];
    [_nameOfBook setText:book.name];
    [_authorOfBook setText:book.author];
    [_publishHouse setText: book.publichHouse];
    [_yearOfBook setText:[NSString stringWithFormat:@"%@",book.publichYear]];
    [_noteOfBook setText:book.note];
    [_numberOfPages setText:[NSString stringWithFormat:@"%@",book.pageCount]];
    [_markOfBook setText:[NSString stringWithFormat:@"%@",book.mark]];
    [_didReadBook setText:[book.didRead boolValue]?@"You have read this book":@"You haven't read this book"];
    [_photo setImage:[UIImage imageWithData:book.photo]];
    
    [_genre setText: dataSource[[book.gType integerValue]]];
    
    [_nameOfBook setHidden:false];
    [_authorOfBook setHidden: false];
    [_publishHouse setHidden:false];
    [_yearOfBook setHidden:false];
    [_noteOfBook setHidden:false];
    [_numberOfPages setHidden:false];
    [_markOfBook setHidden:false];
    [_didReadBook setHidden:false];
    [_photo setHidden:false];
    [_genre setHidden:false];
    
    
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
    cell.imageView.image = [images objectAtIndex:indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
@end
