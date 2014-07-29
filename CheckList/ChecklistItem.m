//
//  ChecklistItem.m
//  CheckList
//
//  Created by Bruno Paulino on 7/19/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "ChecklistItem.h"
#import "DataModel.h"

@implementation ChecklistItem

-(id)init{
    if (self = [super init]) {
        self.itemId = [DataModel nextCheckListItemId];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemId"];
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemaind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
    }
    
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.itemId forKey:@"ItemId"];
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeBool:self.shouldRemaind forKey:@"ShouldRemind"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    
}

-(void) toggleChecked{
    self.checked = !self.checked;
}

-(void)scheduleNotification{
    
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"Found an existing notification %@", existingNotification);
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
    
    if (_shouldRemaind && ([_dueDate compare:[NSDate date]] != NSOrderedAscending)) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        localNotification.fireDate = _dueDate;
        localNotification.alertBody = _text;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemId": @(_itemId)};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"Scheduled notification %@ for itemId %d", localNotification, _itemId);
    }
}

-(UILocalNotification *)notificationForThisItem{
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification *notificaiton in allNotifications) {
        NSNumber *number = [notificaiton.userInfo objectForKey:@"ItemId"];
        if (number != nil && [number integerValue] == _itemId) {
            return  notificaiton;
        }
    }
    return nil;
}

//===============================================================================
//To dealoc the object drom memory and remove the notification that was scheduled
-(void)dealloc{
    UILocalNotification *notification = [self notificationForThisItem];
    if (notification) {
        NSLog(@"Removing existing notification %@...", notification);
        [[UIApplication sharedApplication]cancelLocalNotification:notification];
    }
}


@end
