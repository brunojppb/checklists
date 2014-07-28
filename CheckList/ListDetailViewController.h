//
//  ListDetailViewController.h
//  CheckList
//
//  Created by Bruno Paulino on 7/26/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconPickerViewController.h"

@class ListDetailViewController;
@class CheckList;

@protocol ListDetailViewControllerDelegate <NSObject>

-(void) listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
-(void) listDetailViewController:(ListDetailViewController *)controller didFinishAddingCheckList:(CheckList *)checklist;
-(void) listDetailViewController:(ListDetailViewController *)controller didFinishEditingCheckList:(CheckList *)checklist;

@end

@interface ListDetailViewController : UITableViewController <UITextFieldDelegate, IconPickerViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;
@property (nonatomic, weak) id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) CheckList *checkListToEdit;

- (IBAction)cancel;
- (IBAction)done;

@end
