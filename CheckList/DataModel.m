//
//  DataModel.m
//  CheckList
//
//  Created by Bruno Paulino on 7/27/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(id)init{
    if ((self = [super init])){
        [self loadCheckLists];
    }
    return self;
}

//Save and recovery data from .plist file
- (NSString *)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

-(NSString *)dataFilePath{
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Checklists.plist"];
}

-(void)saveChecklists{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:_lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

-(void)loadCheckLists{
    NSLog(@"Path: %@", [self dataFilePath]);
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        _lists = [unarchiver decodeObjectForKey:@"Checklists"];
        [unarchiver finishDecoding];
    }else{
        _lists = [[NSMutableArray alloc]initWithCapacity:20];
    }
}

@end