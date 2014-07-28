//
//  CheckList.m
//  CheckList
//
//  Created by Bruno Paulino on 7/24/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "CheckList.h"
#import "ChecklistItem.h"

@implementation CheckList

-(id)init{
    if ((self = [super init])) {
        self.items = [[NSMutableArray alloc]initWithCapacity:20];
        self.iconName = @"No Icon";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super init])) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}

-(int)countUncheckedItems{
    int count = 0;
    for (ChecklistItem *item in _items) {
        if (!item.checked) {
            count++;
        }
    }
    return count;
}

@end
