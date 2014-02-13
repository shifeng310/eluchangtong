//
//  RWAlertView.m
//  RW
//
//  Created by 方鸿灏 on 12-2-27.
//  Copyright 2012 roadrover. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RWAlertView.h"

static NSTimer *timer;
static UILabel *label;

@implementation RWAlertView

+ (void)show:(NSString *)text
{
	UIFont *fnt = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
	CGSize text_frm_size = [text sizeWithFont:fnt
							constrainedToSize:CGSizeMake(210.0f, 50.0f)
								lineBreakMode:UILineBreakModeWordWrap];
	
	CGRect src_bounds = [UIScreen mainScreen].bounds;
	
	if (label)
	{
		[label removeFromSuperview];
	}
	
	label = [[UILabel alloc] initWithFrame:CGRectMake(src_bounds.origin.x + (src_bounds.size.width-220.0f) * 0.5f,
													  src_bounds.origin.y + (src_bounds.size.height - 44.0f - text_frm_size.height - 18.0f - 20.0f),
													 text_frm_size.width + 10.0f,
													  text_frm_size.height + 5.0f)];
	
	label.center = CGPointMake(src_bounds.origin.x + src_bounds.size.width * 0.5f, src_bounds.origin.y + (src_bounds.size.height - 44.0f - text_frm_size.height - 18.0f - 20.0f));
	label.layer.cornerRadius = 5.0f;
	label.backgroundColor = [UIColor blackColor];
	label.numberOfLines = 0;
	label.font = [UIFont systemFontOfSize:15.0f];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.text = text;
	
	UIWindow *w = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	[w addSubview:label];
	
	
	[timer invalidate];
	timer = [NSTimer scheduledTimerWithTimeInterval:3
											 target:[RWAlertView class]
										   selector:@selector(closeAlert)
										   userInfo:nil
											repeats:NO];
}

+ (void) closeAlert
{
	[timer invalidate];
	timer = nil;
	[label removeFromSuperview];
	label = nil;
}


@end
