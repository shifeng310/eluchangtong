//
//  MsgListCell.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-8.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "MsgListCell.h"

@implementation MsgListCell
@synthesize lb_content;
@synthesize lb_time;
@synthesize lb_title;

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
    lb_time = nil;
    lb_content = nil;
    lb_title = nil;
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    return 53.0f;
}

- (void) setContent:(NSDictionary *)data
{
    lb_title.text = [data objectForKey:@"title"];
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd"];

    if ([[data objectForKey:@"is_notice"] integerValue])
    {
        lb_content.text = [data objectForKey:@"msg"];
        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"date"] doubleValue]]];
        lb_time.text = post_date;
    }
    else
    {
        lb_content.text = [data objectForKey:@"contents"];
        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"addtime"] doubleValue]]];
        lb_time.text = post_date;
    }
 
}


@end
