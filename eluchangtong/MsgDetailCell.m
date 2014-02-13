//
//  MsgDetailCell.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-9.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "MsgDetailCell.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "RoadRover.h"

static CGFloat const CELL_NORMAL_HIGHT	= 110.0f;
static CGFloat const CONTENT_WIDTH		= 280.0f;
static CGFloat const CONTENT_FONT_SIZE	= 14.0f;
static CGFloat const TRANSIMIT_FONT_SIZE= 14.0f;

@implementation MsgDetailCell
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

-(void)dealloc
{
    lb_title = nil;
    lb_time = nil;
    lb_content = nil;
    im = nil;
}

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    //固定的原始大小
	CGFloat height = CELL_NORMAL_HIGHT;
	
	NSString *content_text = [data objectForKey:@"contents"];
	UIFont *font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
	CGSize containt_size = CGSizeMake(CONTENT_WIDTH, 1000);
	CGSize content_frm_size = [content_text sizeWithFont:font
									   constrainedToSize:containt_size
										   lineBreakMode:UILineBreakModeWordWrap];
	
	NSString *image = [data objectForKey:@"images"];
	if ([image length])
	{
        if (content_frm_size.height + 110 > height)
        {
            height += content_frm_size.height + 110 - height;
        }
        
        height  = height + 200;
	}
	
	else if (content_frm_size.height + 110 > height)
	{
		height += content_frm_size.height + 110 -height;
	}
	
	return height;

}

- (void) setContent:(NSDictionary *)data
{
    lb_title.text = [data objectForKey:@"title"];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
	NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"addtime"] doubleValue]]];
	lb_time.text = post_date;

    NSString *content_text = [data objectForKey:@"contents"];
	UIFont *font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
	CGSize containt_size = CGSizeMake(CONTENT_WIDTH, 1000);
	CGSize content_frm_size = [content_text sizeWithFont:font
									   constrainedToSize:containt_size
										   lineBreakMode:UILineBreakModeWordWrap];
    
    lb_content = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 90.0f, CONTENT_WIDTH, content_frm_size.height)];
    lb_content.text = content_text;
    lb_content.textColor = [UIColor darkGrayColor];
    lb_content.font = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
    lb_content.backgroundColor = [UIColor clearColor];
    lb_content.numberOfLines = 0;

    NSString *str = [data objectForKey:@"images"];

    if ([str length])
    {
        NSArray *arr = [str componentsSeparatedByString:@"|"];
        NSString *url = [arr objectAtIndex:0];
        NSString *image_url = [NSString stringWithFormat:@"%@/data/uploads/%@",BASE_URL,url];
        im = [[UIImageView alloc]initWithFrame:CGRectMake(60.0f, 90.0f, 200.0f, 200.0f)];
        UIImage *avatar_im = [RRImageBuffer readFromFile:image_url];
        if (avatar_im)
        {
            [im setImage:avatar_im];
        }
        else
        {
            RRRemoteImage *remote_img = [[RRRemoteImage alloc] initWithURLString:image_url parentView:im delegate:self defaultImageName:@"default_pic_big.png"];
            [im setImage:remote_img ];
        }
        
        lb_content.frame = CGRectMake(lb_content.frame.origin.x, im.frame.origin.y +im.frame.size.height + 10, lb_content.frame.size.width, lb_content.frame.size.height);
        
        [self addSubview:im];
    }
    
    [self addSubview:lb_content];
}

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage
{
    [im setImage:[UIImage imageNamed:@"home_beauty_broken.png"]];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
	UIImageView *i = (UIImageView *)remoteImage.parent_view;
	[i setImage:newImage];
	
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}


@end
