//
//  CheckListViewController.h
//  CheckList
//
//  Created by Bruno Paulino on 7/13/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "ChecklistItem.h"
#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class CheckList;

@interface CheckListViewController : UITableViewController <ItemDetailViewControllerDelegate>

@property (nonatomic, strong) CheckList *checkList;

@end
