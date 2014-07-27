//
//  CheckList.h
//  CheckList
//
//  Created by Bruno Paulino on 7/24/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckList : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray *items;

@end
