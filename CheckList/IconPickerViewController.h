//
//  IconPickerViewController.h
//  CheckList
//
//  Created by Bruno Paulino on 7/27/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>

-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic, weak) id <IconPickerViewControllerDelegate> delegate;

@end
