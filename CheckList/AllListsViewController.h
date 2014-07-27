//
//  AllListsViewController.h
//  CheckList
//
//  Created by Bruno Paulino on 7/24/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetailViewController.h"

@class DataModel;

@interface AllListsViewController : UITableViewController <ListDetailViewControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) DataModel *dataModel;

@end
