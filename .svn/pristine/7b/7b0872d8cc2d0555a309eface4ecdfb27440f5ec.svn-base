//
//  RWCache.m
//  RW
//
//  Created by fang honghao on 12-3-23.
//  Copyright (c) 2012年 roadrover. All rights reserved.
//

#import "RWCache.h"

static RWCache *instance = nil;

@implementation RWCache

@synthesize uid;

#pragma mark -
#pragma mark class method

+ (RWCache *) getInstanceWithName:(NSString *)name
{
	[self checkWithName:name];
	return instance;
}

- (NSUInteger) getCount
{
	return [arr count];
}

- (NSMutableArray *) getArr
{
	return arr;
}

- (void) cleanCache
{
	[arr removeAllObjects];
}

+ (BOOL) checkWithName:(NSString *)name
{
	NSString *last_login_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_login_uid"];
	if (!last_login_uid)
	{
		return NO;
	}
	
	if (instance)
	{
		instance = nil;
	}
	
	RWCache *token = [[RWCache alloc] initWithUID:last_login_uid andName:name];
	
	if ([token loadFromFileWithName:name])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

#pragma mark -

- (id) initWithUID:(NSString *)UID andName:(NSString *)name
{
	if (nil == UID || [UID isEqualToString:@""])
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		instance = self;
		
		self.uid = UID;
		
		
		if (arr)
		{
			arr = nil;
		}
		arr = [[NSMutableArray alloc] init];

		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSMutableDictionary *exist_tokens = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"tokens"]];
		if (exist_tokens)
		{
			if (![exist_tokens objectForKey:UID])
			{
				[exist_tokens setObject:[NSString stringWithFormat:@"%@_%@.plist",name, UID] forKey:UID];
				[defaults setObject:exist_tokens forKey:@"tokens"];
			}
		}
		else
		{
			exist_tokens = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@_%@.plist",name, UID] , UID, nil];
			[defaults setObject:exist_tokens forKey:@"tokens"];
		}
	}
	
	return self;
}

- (void) dealloc
{
	
	arr = nil;
	
	
	instance = nil;
	
}

#pragma mark -

#pragma mark Store/Restore
- (BOOL) loadFromFileWithName:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"%@_%@.plist",name,uid];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
	NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:token_file];
	if (nil != array)
	{
		[arr addObjectsFromArray:array];

		return YES;
	}
	else
	{
		return NO;
	}
}

- (void) saveToFileWithName:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"%@_%@.plist",name,uid];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
    
    [arr writeToFile:token_file atomically:YES];

}

- (void) deleteFileWithName:(NSString *)name Index:(NSUInteger)index
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"%@_%@.plist",name,uid];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
	[arr removeObjectAtIndex:index];
	[arr writeToFile:token_file atomically:YES];
}
#pragma mark Property

- (void) setArr:(NSMutableArray *)value WithName:(NSString *)name
{
	[self loadFromFileWithName:name];
	
    for(NSDictionary *dic in value)
    {
        [arr addObject:dic];
    }
}


@end
