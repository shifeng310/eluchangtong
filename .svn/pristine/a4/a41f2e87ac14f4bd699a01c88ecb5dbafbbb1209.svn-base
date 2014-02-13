//
//  RWUsrEditCell.m
//  RW
//
//  Created by fang honghao on 12-4-1.
//  Copyright (c) 2012年 roadrover. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RWUsrEditCell.h"

@implementation RWUsrEditCell
@synthesize im_avatar;
@synthesize lb_name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    im_avatar = nil;
    lb_name = nil;
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
	return 44.0f;
}

- (void) setAvatar:(UIImage *)avatar
{
	[im_avatar setImage:avatar];
	im_avatar.layer.cornerRadius = 2.5f;
	im_avatar.layer.masksToBounds = YES;

}

@end
