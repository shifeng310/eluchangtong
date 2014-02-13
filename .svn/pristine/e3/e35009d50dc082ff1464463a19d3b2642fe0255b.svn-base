//
//  NoticeListViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-19.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "NoticeListViewController.h"
#import "MsgListCell.h"
#import "NSDate+Helper.h"
#import "RRToken.h"

@implementation NoticeListViewController
@synthesize buffer;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"提醒列表";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([buffer count] == 0)
    {
        return 1;
    }
    return[buffer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [buffer count] )
	{
		static NSString *cell_id = @"empty_cell";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
		if (nil == cell)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
		}
		
		UIFont *font = [UIFont systemFontOfSize:15.0f];
		cell.textLabel.font = font;
        cell.textLabel.text = @"暂无提醒";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	
		static NSString *CellIdentifier = @"MsgListCell";
       NSMutableDictionary *area_info = [NSMutableDictionary dictionaryWithDictionary:[buffer objectAtIndex:indexPath.row] ];
        [area_info setObject:@"1" forKey:@"is_notice"];
		MsgListCell *cell = (MsgListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (nil == cell)
		{
			UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
			
			cell = (MsgListCell *)uc.view;
			[cell setContent:area_info];
		}
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([buffer count] == 0)
    {
        return;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"知道了",@"下次提醒",nil];
    as.tag = [[[buffer objectAtIndex:indexPath.row] objectForKey:@"type"] integerValue];
    index = indexPath.row;
    [as showInView:self.tableView];
     
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([buffer count] == 0)
	{
		return 70.0f;
	}
	
	if (indexPath.row < [buffer count])
	{
		return [MsgListCell calCellHeight:[buffer objectAtIndex:indexPath.row]];
	}
	return  44.0f;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (0 == buttonIndex)
        {
            [self removeLocalNotifyWithIndex:1];
        }
        else if (1 == buttonIndex)
        {
            [self resetLocalNotifyWithIndex:index andType:1];
        }

    }
    
    if (actionSheet.tag == 2)
    {
        if (0 == buttonIndex)
        {
            [self removeLocalNotifyWithIndex:2];
        }
        else if (1 == buttonIndex)
        {
            [self resetLocalNotifyWithIndex:index andType:2];
        }
        
    }
    
    if (actionSheet.tag == 3)
    {
        if (0 == buttonIndex)
        {
            [self removeLocalNotifyWithIndex:3];
        }
        else if (1 == buttonIndex)
        {
            [self resetLocalNotifyWithIndex:index andType:3];
        }
        
    }

}

- (void) setTipsArr:(NSMutableArray *)arr
{
    if (!buffer)
    {
        buffer = [NSMutableArray arrayWithCapacity:0];
    }
    
    [buffer addObjectsFromArray:arr];
}

- (void)removeLocalNotifyWithIndex:(NSUInteger)row
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if (0 < [oldNotifications count])
    {
        for (UILocalNotification *notification in oldNotifications)
        {
            if ([[notification.userInfo objectForKey:@"type"] integerValue] == row)
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                [buffer removeObjectAtIndex:index];
                [self.tableView reloadData];
                break;
            }
        }
    }
    
    RRToken *token = [RRToken getInstance];
    switch (row)
    {
        case 1:
            [token setProperty:@"1" forKey:@"is_baoyang_notice_change"];
            break;
        case 2:
            [token setProperty:@"1" forKey:@"is_baoxian_notice_change"];
            break;
        case 3:
            [token setProperty:@"1" forKey:@"is_nianjian_notice_change"];
            break;
        default:
            break;
    }
    [token saveToFile];

}

- (void)resetLocalNotifyWithIndex:(NSUInteger)row andType:(NSUInteger)type
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    NSDictionary *usrInfo = [buffer objectAtIndex:index];
    for (UILocalNotification *notification in oldNotifications)
    {
        if ([[notification.userInfo objectForKey:@"type"]integerValue] == type)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            // Create a new notification
            UILocalNotification *alarm = [[UILocalNotification alloc] init];
            if (alarm)
            {
                if (type == 1)
                {
                    if ([[self getCurrentTime]doubleValue] + 2*24*3600 < [[notification.userInfo objectForKey:@"date"]integerValue])
                    {
                        alarm.fireDate = [NSDate dateWithTimeIntervalSince1970:[[self getCurrentTime]doubleValue] + 2*24*3600];
                    }
                    else
                    {
                        alarm.fireDate = [NSDate dateWithTimeIntervalSince1970:[[notification.userInfo objectForKey:@"date"]integerValue] - 2*24*3600];
                    }
                }
                else
                {
                    if ([[self getCurrentTime]doubleValue] + 15*24*3600 < [[notification.userInfo objectForKey:@"date"]integerValue])
                    {
                        alarm.fireDate = [NSDate dateWithTimeIntervalSince1970:[[self getCurrentTime]doubleValue] + 15*24*3600];
                    }
                    else
                    {
                        alarm.fireDate = [NSDate dateWithTimeIntervalSince1970:[[notification.userInfo objectForKey:@"date"]integerValue] - 2*24*3600];

                    }
                }
                alarm.timeZone = [NSTimeZone defaultTimeZone];
                alarm.repeatInterval = NSWeekCalendarUnit;
                alarm.soundName = @"ping.caf";
                alarm.alertBody = [usrInfo objectForKey:@"msg"],
                alarm.userInfo = usrInfo;
                alarm.applicationIconBadgeNumber = 1;
                [app scheduleLocalNotification:alarm];
                [buffer removeObjectAtIndex:index];
                [self.tableView reloadData];
            }
        }
    }
    
    RRToken *token = [RRToken getInstance];
    switch (type)
    {
        case 1:
            [token setProperty:@"1" forKey:@"is_baoyang_notice_change"];
            break;
        case 2:
            [token setProperty:@"1" forKey:@"is_baoxian_notice_change"];
            break;
        case 3:
            [token setProperty:@"1" forKey:@"is_nianjian_notice_change"];
            break;
        default:
            break;
    }
    [token saveToFile];

}

- (NSString *)getCurrentTime
{
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:date1];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval b =[theDate timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",b];
    return timeString;
}

@end
