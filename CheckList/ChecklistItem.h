//
//  ChecklistItem.h
//  CheckList
//
//  Created by Bruno Paulino on 7/19/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChecklistItem : NSObject <NSCoding>


@property (nonatomic, assign)NSInteger itemId;
@property (nonatomic, assign) BOOL shouldRemaind;
@property (nonatomic, copy) NSDate *dueDate;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;

-(void) toggleChecked;
-(void)scheduleNotification;

@end
