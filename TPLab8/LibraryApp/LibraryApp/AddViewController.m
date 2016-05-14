//
//  AddViewController.m
//  LibraryApp
//
//  Created by fpmi on 06.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "AddViewController.h"
#import "AppDelegate.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *author;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *note;
@property (weak, nonatomic) IBOutlet UITextField *pagesCount;
@property (weak, nonatomic) IBOutlet UITextField *publishHouse;
@property (weak, nonatomic) IBOutlet UITextField *publishYear;
@property (weak, nonatomic) IBOutlet UIPickerView *pikerGanera;
@property (weak, nonatomic) IBOutlet UILabel *error;
@property (weak, nonatomic) IBOutlet UIStepper *markCounter;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchDidRead;
@property (strong, nonatomic) IBOutlet UIImageView *photoFile;

@end

@implementation AddViewController
@synthesize dataSource;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSArray arrayWithObjects:
                       @"Fantasy",
                       @"Drama",
                       @"Tragedy",
                       @"Satire",
                       @"Science fiction",
                       @"Horror",
                       @"Classic",
                       nil];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://rostislav.kiev.ua/wp-content/uploads/2014/04/kniga.jpg"]];
    _photoFile.image=[UIImage imageWithData:data];
    // Do any additional setup after loading the view.
}
//long row = [_pickerView  selectedRowInComponent:0];
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didPressButton:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self;
    [self presentModalViewController:pickerController animated:YES];

}
- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    self.photoFile.image = image;
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component
{
    return dataSource.count;
}
- (IBAction)changedMark:(UIStepper*)sender
{
    [_markLabel setText: [NSString stringWithFormat:@"%d",(int)sender.value]];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [dataSource objectAtIndex:row];
}
- (IBAction)addBook:(id)sender
{
    //-(void) addNewBookUsingName: (NSString*) name andAuthor: (NSString *)author andPublichYear: (int) year andPageCount: (int) pageCount andPublichHouse: (NSString*) publishHouse andNote: (NSString*) note andPhoto: (NSString*) photofile andType: (int) type
    
    NSString* bname = [NSString stringWithString: [_name text]];
    NSString* bauthor = [NSString stringWithString: [_author text]];
    NSString* bpublishHouse = [NSString stringWithString: [_publishHouse text]];
    int bpublishYear = [[_publishYear text] intValue];
    int bpageCount = [[_pagesCount text] intValue];
    NSString* bnote = [NSString stringWithString: [_note text]];
    int type = (int)[_pikerGanera selectedRowInComponent:0];
    int bmark = (int)[_markCounter value];
    BOOL bdidRead = [_switchDidRead isOn];
    NSData* dat;
    NSLog(@"+");
    dat = UIImagePNGRepresentation([_photoFile image]);
    
    if(bname.length==0 || bauthor.length==0||bpublishHouse.length==0||bpublishYear<=0||bpageCount<=0||bnote.length == 0)
    {
        NSLog(bname);
        NSLog(bauthor);
        NSLog(bpublishHouse);
        NSLog(bnote);
        NSLog(@"%d",bpublishYear);
        NSLog(@"%d",bpageCount);
        [_error setText:@"Not everything is filled"];
    }
    else
    {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app addNewBookUsingName:bname andAuthor:bauthor andPublichYear:bpublishYear andPageCount:bpageCount andPublichHouse:bpublishHouse andNote:bnote andPhoto:dat andType:type andMark:bmark andDidRead:bdidRead];
         NSLog(@"+");

        
    }
     NSLog(@"+");
    
}
- (IBAction)backButton:(id)sender
{
         [self performSegueWithIdentifier:@"ShowView" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
