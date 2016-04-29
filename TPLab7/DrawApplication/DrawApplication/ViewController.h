//
//  ViewController.h
//  DrawApplication
//
//  Created by fpmi on 26.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) NSArray *dataSource;

@end

