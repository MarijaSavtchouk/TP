////  ViewController.m
//  DrawApplication
//
//  Created by fpmi on 26.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *canvas;
@property (weak, nonatomic) IBOutlet UILabel *lineSizeLabel;
@property (weak, nonatomic) IBOutlet UIStepper *sizeChanger;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UISlider *redColor;
@property (weak, nonatomic) IBOutlet UISlider *greenColor;
@property (weak, nonatomic) IBOutlet UISlider *blueColor;
@property (weak, nonatomic) IBOutlet UISlider *alphaColor;
@property (weak, nonatomic) IBOutlet UIView *colorShow;
@property CGPoint lastPoint;
@end

@implementation ViewController
@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSArray arrayWithObjects:
                       @"Round",
                       @"Butt",
                       @"Square",
                       nil];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pickerView = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [dataSource objectAtIndex:row];
}
- (IBAction)saveButtonPressed:(id)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
    [UIImagePNGRepresentation([_canvas image]) writeToFile:filePath atomically:YES];
}
- (IBAction)valueSizeChanged:(id)sender
{
    //[_shapeChooser ]
    [_lineSizeLabel setText:[NSString stringWithFormat:@"%d",(int)[_sizeChanger value]]];
}
- (IBAction)valueColorChanged:(id)sender
{
    [_colorShow setBackgroundColor:[UIColor colorWithRed:[_redColor value]/255.0f
                                                    green:[_greenColor value]/255.0f
                                                     blue:[_blueColor value]/255.0f
                                                    alpha:[_alphaColor value]/255.0f] ];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self setLastPoint:[touch locationInView:self.view]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext([_canvas bounds].size);
    
    CGRect drawRect = CGRectMake([_canvas bounds].origin.x, [_canvas bounds].origin.y, [_canvas bounds].size.width, [_canvas bounds].size.height);
    
    [[[self canvas] image] drawInRect:drawRect];
    long row = [_pickerView  selectedRowInComponent:0];
    switch (row)
    {
        case 0:
        {
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        } break;
        case 1:
        {
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapButt);
        } break;
        case 2:
        {
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
        } break;
        default: CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    }
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [_sizeChanger value]);

    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), [_redColor value]/255.0f, [_greenColor value]/255.0f, [_blueColor value]/255.0f, [_alphaColor value]/255.0f);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), _lastPoint.x , _lastPoint.y - [_canvas frame].origin.y);
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y - [_canvas frame].origin.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    [[self canvas] setImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    _lastPoint = currentPoint;
}
@end
