//
//  PoiListViewCell.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "PoiListViewCell.h"

@implementation PoiListViewCell
@synthesize lb_time;

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
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    return 53.0f;
}

- (void) setContent:(NSDictionary *)data
{
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *min_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"mintime"] doubleValue]]];
    NSString *max_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"maxtime"] doubleValue]]];

	lb_time.text = [NSString stringWithFormat:@"%@ -- %@",min_date,max_date];
    
}

@end
