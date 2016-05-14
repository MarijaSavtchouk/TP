//
//  AddViewController.h
//  LibraryApp
//
//  Created by fpmi on 06.05.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSArray *dataSource;
@end
