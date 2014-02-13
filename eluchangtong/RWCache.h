//
//  RWCache.h
//  RW
//
//  Created by fang honghao on 12-3-23.
//  Copyright (c) 2012年 roadrover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWCache : NSObject
{
	NSString			*uid;
	NSMutableArray      *arr;
	BOOL				is_copy;

}

@property (nonatomic, copy) NSString *uid;


+ (RWCache *) getInstanceWithName:(NSString *)name;

- (NSUInteger) getCount;

- (void) cleanCache;

+ (BOOL) checkWithName:(NSString *)name;

- (id) initWithUID:(NSString *)UID andName:(NSString *)name;

- (BOOL) loadFromFileWithName:(NSString *)name;

- (void) saveToFileWithName:(NSString *)name;

- (void) setArr:(NSMutableArray *)value WithName:(NSString *)name;

- (NSMutableArray *) getArr;

- (void) deleteFileWithName:(NSString *)name Index:(NSUInteger)index;


@end
