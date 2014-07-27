//
//  DataModel.h
//  CheckList
//
//  Created by Bruno Paulino on 7/27/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong)NSMutableArray *lists;

-(void)saveChecklists;

@end
