//
//  PoiListViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "PoiListViewController.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRURLRequest.h"
#import "RRLoader.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "RoadRover.h"
#import "PoiListViewCell.h"
#import "AHAlertView.h"
#import "BMKGeometry.h"
@implementation PoiListViewController
@synthesize delegate;

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
    
    self.title = @"历史记录";
    buffer = [NSMutableArray arrayWithCapacity:0];
    
    page = 1;
    
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
    
    btn_select = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_select_click:)];
    self.navigationItem.rightBarButtonItem = btn_select;
    
    stime = @"1";
    etime = [self getCurrentTime];
    [self fethNew];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}

- (void)dealloc
{
    buffer = nil;
    btn_select = nil;
    delegate = nil;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([buffer count] == 0)
    {
        return 1;
    }
    else if (is_more)
	{
		return [buffer count] + 1;
	}
    
	return [buffer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	if (0 == [buffer count] && YES == is_loading)
	{
		static NSString *cell_id = @"empty_cell";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
		if (nil == cell)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
		}
		
		UIFont *font = [UIFont systemFontOfSize:15.0f];
		cell.textLabel.text = @"载入中...";
		cell.textLabel.font = font;
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
    
	if (0 == [buffer count] && NO == is_loading)
	{
		static NSString *cell_id = @"empty_cell";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
		if (nil == cell)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
		}
		
		UIFont *font = [UIFont systemFontOfSize:15.0f];
		cell.textLabel.font = font;
		if (is_fail)
		{
			cell.textLabel.text = @"网络异常,请稍后再试!";
		}
		else
		{
			cell.textLabel.text = @"暂无数据";
		}
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	
	if (indexPath.row < [buffer count])
	{
		static NSString *CellIdentifier = @"PoiListViewCell";
		NSDictionary *area_info = [buffer objectAtIndex:indexPath.row];
		
		PoiListViewCell *cell = (PoiListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (nil == cell)
		{
			UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
			
			cell = (PoiListViewCell *)uc.view;
			[cell setContent:area_info];
		}
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		return cell;
	}
    
	static NSString *cell_id = @"more_cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
	}
	
	UIFont *font = [UIFont systemFontOfSize:15.0f];
	switch (action_type)
	{
		case 0:
			cell.textLabel.text = @"加载中...";
			break;
		case 1:
			cell.textLabel.text = @"+ 更多内容";
			break;
		case 2:
			cell.textLabel.text = @"松开即可刷新...";
			break;
		default:
			break;
	}
	if (is_loading)
	{
		cell.textLabel.text = @"加载中...";
	}
	cell.textLabel.textColor = [UIColor darkGrayColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.font = font;
	cell.tag = 110;
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_cell_back.png"]];
    
	UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	aiv.center = CGPointMake(cell.backgroundView.center.x - 50.0f, cell.backgroundView.center.y);
	[aiv startAnimating];
	if (action_type == 0)
	{
		[cell.backgroundView addSubview:aiv];
	}
	return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([buffer count] == 0)
	{
		return 70.0f;
	}
	
	if (indexPath.row < [buffer count])
	{
		return [PoiListViewCell calCellHeight:[buffer objectAtIndex:indexPath.row]];
	}
	return  44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [buffer count])
	{
		return;
	}
	if (indexPath.row >= [buffer count])
	{
        page = page + 1;
		[self fethNew];
		return;
	}
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
     NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    mintime = [dic objectForKey:@"mintime"];
    maxtime = [dic objectForKey:@"maxtime"];

    [self fethDetail];
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
	if (!scrollView.isDragging)
	{
		return;
	}
	
	UITableViewCell *cell = (UITableViewCell *)[self.tableView viewWithTag:110];
    
	if (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 22.0f)
	{
		cell.textLabel.text = @"+ 更多内容";
		if (is_loading)
		{
			cell.textLabel.text = @"加载中...";
		}
        
	}
	else if (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 22.0f)
	{
		cell.textLabel.text = @"松开即可刷新...";
		if (is_loading)
		{
			cell.textLabel.text = @"加载中...";
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentSize.height > scrollView.bounds.size.height &&
        scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 22.0f)
	{
		if (is_more)
		{
            page = page + 1;
  			[self fethNew];
		}
	}
}

- (void) fethNew
{
    if (is_loading)
	{
		return;
	}
    
    action_type = 0;
    
	is_loading = YES;
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GPS_LIST_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [req setParam:stime forKey:@"stime"];
	[req setParam:etime forKey:@"etime"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethNew:)];
	[loader loadwithTimer];
    
}

- (void) onFethNew:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        is_fail = YES;
        [RWShowView closeAlert];
        [RWAlertView show:@"网络链接失败!" ];
        [self.tableView reloadData];
 		return;
	}
    
    NSMutableDictionary *dic = [json objectForKey:@"data"];
    if ([[dic objectForKey:@"total"] integerValue] > [[dic objectForKey:@"rows"] count] + [buffer count])
    {
        is_more = YES;
    }
    else
    {
        is_more = NO;
        
    }
    
    if (is_select)
    {
        is_select = NO;
        [buffer removeAllObjects];
    }
    
    NSArray *arr = [dic objectForKey:@"rows"];
    [buffer addObjectsFromArray:arr];
    action_type = 1;
    [self.tableView reloadData];
    
}

- (void) fethDetail
{
    if (is_loading)
	{
		return;
	}
    
    is_loading = YES;
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GPS_DETAIL_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:mintime forKey:@"mintime"];
    [req setParam:maxtime forKey:@"maxtime"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethDetail:)];
	[loader loadwithTimer];

}

- (void) onFethDetail:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        is_fail = YES;
        [RWShowView closeAlert];
        [RWAlertView show:@"网络链接失败!" ];
        [self.tableView reloadData];
 		return;
	}
    
    NSArray *arr = [json objectForKey:@"data"];
    NSMutableArray *arr_baidu = [NSMutableArray array];

    for (int i = 0; i < [arr count]; i++)
    {
        NSDictionary *dic = [arr objectAtIndex:i];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] floatValue], [[dic objectForKey:@"lng"] floatValue]);
        NSDictionary *dic_baidu = BMKBaiduCoorForWgs84(location);
        CLLocationCoordinate2D location_baidu = BMKCoorDictionaryDecode(dic_baidu);
        NSDictionary *d = @{@"lat" : [NSString stringWithFormat:@"%f",location_baidu.latitude ],@"lng":[NSString stringWithFormat:@"%f",location_baidu.longitude],@"time":[dic objectForKey:@"time"]};
        [arr_baidu addObject:d];
    }
    
    if (delegate && [delegate respondsToSelector:@selector(getPoiBuffer:)])
    {
        [delegate performSelector:@selector(getPoiBuffer:) withObject:arr_baidu];
    }
    
    int i=[self.navigationController.viewControllers count];
	[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i-2] animated:YES];
}

- (void) onFetchFail:(NSNotification *)notify
{
    is_fail = YES;
    is_loading = NO;
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView reloadData];
    
}

- (NSString *)getCurrentTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * curTime = [formater stringFromDate:date];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval a =[theDate timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",a];
    return  timeString;
}

- (void) btn_select_click:(id)sender
{
    [self applyCustomAlertAppearance];
    page = 1;
    NSString *title = @"选择日期";
    NSString *message = @"";
    AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
    __weak AHAlertView *alert = _alert;
    [alert setCancelButtonTitle:@"确定" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleFade;
    }];
    [alert addButtonWithTitle:@"取消" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
    }];
    
    [alert setAlertViewStyle:AHAlertViewStyleSetDate];
    [alert show];
}

- (void)setStime:(NSString *)s_time etime:(NSString *)e_time
{
    stime = s_time;
    etime = e_time;
    is_select = YES;
    [self fethNew];
}

- (void) alertViewDidCancel
{
     
}

- (void)applyCustomAlertAppearance
{
	[[AHAlertView appearance] setContentInsets:UIEdgeInsetsMake(12, 18, 12, 18)];
	
	[[AHAlertView appearance] setBackgroundImage:[UIImage imageNamed:@"custom-dialog-background"]];
	
	UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(20, 8, 20, 8);
	
	UIImage *cancelButtonImage = [[UIImage imageNamed:@"custom-cancel-normal"]
								  resizableImageWithCapInsets:buttonEdgeInsets];
	UIImage *normalButtonImage = [[UIImage imageNamed:@"custom-button-normal"]
								  resizableImageWithCapInsets:buttonEdgeInsets];
    
    UIImage *cancelButtonImageHighlight = [[UIImage imageNamed:@"custom-cancel-normal-highlight"]
                                           resizableImageWithCapInsets:buttonEdgeInsets];
	UIImage *normalButtonImageHighlight = [[UIImage imageNamed:@"custom-button-normal-highlight"]
                                           resizableImageWithCapInsets:buttonEdgeInsets];
    
	[[AHAlertView appearance] setCancelButtonBackgroundImage:normalButtonImage
													forState:UIControlStateNormal];
	[[AHAlertView appearance] setButtonBackgroundImage:cancelButtonImage
											  forState:UIControlStateNormal];
    
    [[AHAlertView appearance] setSaveImage:[UIImage imageNamed:@"custom-weixuan.png"]];
    [[AHAlertView appearance] setCancelButtonBackgroundImage:normalButtonImageHighlight
													forState:UIControlStateHighlighted];
	[[AHAlertView appearance] setButtonBackgroundImage:cancelButtonImageHighlight
											  forState:UIControlStateHighlighted];
	
	[[AHAlertView appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                      [UIColor whiteColor], UITextAttributeTextColor,
                                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                                      [NSValue valueWithCGSize:CGSizeMake(0, 0)], UITextAttributeTextShadowOffset,
                                                      nil]];
    
	[[AHAlertView appearance] setMessageTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIFont systemFontOfSize:15], UITextAttributeFont,
                                                        [UIColor darkGrayColor], UITextAttributeTextColor,
                                                        [UIColor clearColor], UITextAttributeTextShadowColor,
                                                        [NSValue valueWithCGSize:CGSizeMake(0, 0)], UITextAttributeTextShadowOffset,
                                                        nil]];
    
	[[AHAlertView appearance] setButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIFont boldSystemFontOfSize:14], UITextAttributeFont,
                                                            [UIColor whiteColor], UITextAttributeTextColor,
                                                            [UIColor clearColor], UITextAttributeTextShadowColor,
                                                            [NSValue valueWithCGSize:CGSizeMake(0, 0)], UITextAttributeTextShadowOffset,
                                                            nil]];
}


@end
