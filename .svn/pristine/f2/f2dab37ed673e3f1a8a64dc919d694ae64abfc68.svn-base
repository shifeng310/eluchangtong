//
//  MsgListController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-8.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "MsgListController.h"
#import "MsgListCell.h"
#import "RWCache.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRURLRequest.h"
#import "RRLoader.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "RoadRover.h"
#import "sqlService.h"
#import "JSON.h"
#import "MsgDetailController.h"

@implementation MsgListController

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
    self.title = @"消息中心";
    buffer = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];

    
    btn_edit = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_edit_click:)];
    btn_clear = [[UIBarButtonItem alloc]initWithTitle:@"清除" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_clear_click:)];
    
    CGRect top_rect = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height);
	refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:top_rect];
	refreshHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]];
	[self.tableView addSubview:refreshHeaderView];

    CGRect bottom_rect = CGRectMake(0.0f, -30.0f, 320.0f, 60.0f);
	refreshHeaderView_bottom = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:bottom_rect];
	refreshHeaderView_bottom.backgroundColor = [UIColor whiteColor];
	refreshHeaderView_bottom.state = EGOOPullRefreshNormalUP;
    refreshHeaderView_bottom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]];

	[self.tableView addSubview:refreshHeaderView_bottom];
	refreshHeaderView_bottom.hidden = YES;
    
    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele checkToken];
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
    action_type = nil;
    buffer = nil;
    btn_edit = nil;
    btn_clear = nil;
    refreshHeaderView = nil;
    refreshHeaderView_bottom = nil;
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
	
    static NSString *CellIdentifier = @"MsgListCell";
    NSDictionary *area_info = [buffer objectAtIndex:indexPath.row];
    
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self updateItemAtIndexPath:indexPath withString:nil];
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
		return [MsgListCell calCellHeight:[buffer objectAtIndex:indexPath.row]];
	}
	return  44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [buffer count])
	{
		return;
	}
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = [buffer objectAtIndex:indexPath.row];
    MsgDetailController *ctrl = [[MsgDetailController alloc]initWithStyle:UITableViewStyleGrouped];
    ctrl.dic = dic;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row + 1 == [buffer count] &&
		tableView.contentSize.height > tableView.bounds.size.height)
	{
		CGRect bottom_rect = CGRectMake(0.0f, tableView.contentSize.height, 320.0f, 60.0f);
		refreshHeaderView_bottom.frame = bottom_rect;
		refreshHeaderView_bottom.hidden = NO;
	}
}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
	if (!scrollView.isDragging)
	{
		return;
	}
	if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -20.0f && scrollView.contentOffset.y < 0.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshNormal];
	}
	else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -20.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshPulling];
	}
	
	if (refreshHeaderView_bottom.state == EGOOPullRefreshPulling &&
        scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 20.0f)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	}
	else if (refreshHeaderView_bottom.state == EGOOPullRefreshNormalUP &&
			 scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 20.0f)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshPulling];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentOffset.y < - 20.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		
		[self fethNew];
	}
	else if (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 20.0f)
	{
		[refreshHeaderView_bottom setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
		
		[self fetchOld];
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
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MSG_LIST_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:@"1" forKey:@"page"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:[NSString stringWithFormat:@"msg_maxid_%@",[token getProperty:@"service_number"]]])
    {
        [req setParam:[defaults objectForKey:[NSString stringWithFormat:@"msg_maxid_%@",[token getProperty:@"service_number"]]] forKey:@"maxid"];
    }
    else
    {
        [req setParam:@"0" forKey:@"maxid"];
    }
    
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFethFail:)];
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
        [self updateTableView:0];
        [self.tableView reloadData];
 		return;
	}
    
    NSMutableDictionary *dic = [json objectForKey:@"data"];
    NSArray *arr = [dic objectForKey:@"rows"];
    if ([arr count] == 0)
    {
        [self updateTableView:0];
        return;
    }

    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];

    if ([buffer count])
    {
        self.navigationItem.rightBarButtonItem = btn_edit;
    }

    RRToken *token = [RRToken getInstance];
    sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"msgdb_%@.sql",[token getProperty:@"service_number"]]];
	sqlTestList *sqlInsert = [[sqlTestList alloc]init];
    NSArray *listData = [sqlSer getTestList];
    sqlTestList *sqlList = [[sqlTestList alloc]init];

    for (int i = 0; i < [listData count]; i++)
    {
        sqlList = [listData objectAtIndex:i];
        [sqlSer deleteTestList:sqlList];
    }
    
    for (int i = 0;i < [buffer count];i++)
    {
        NSDictionary *dict = [buffer objectAtIndex:i];
        NSMutableString *str = [NSMutableString string];
        NSMutableString *str_tmp = [NSMutableString string];
        
        for (int j = 0; j < [dict count]; j++)
        {
            NSString *s = [dict.allValues objectAtIndex:j];
            NSCharacterSet *whitespaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
            NSArray *parts = [s componentsSeparatedByCharactersInSet:whitespaces];
            NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
            s = [filteredArray componentsJoinedByString:@""];
            [str appendFormat:@"\"%@\":\"%@\",",[dict.allKeys objectAtIndex:j],s];
        }
        
        if (i == 0)
        {
            maxid = [dict objectForKey:@"id"];
        }
        if (i == [buffer count] -1)
        {
            minid = [dict objectForKey:@"id"];
        }

        [str deleteCharactersInRange:NSMakeRange([str length] -1 ,1)];
        [str_tmp appendFormat:@"{%@}",str];
        
        sqlInsert.sqlID = [[dict objectForKey:@"id"] integerValue];
        sqlInsert.sqlText = str_tmp;
        
        //调用封装好的数据库插入函数
        [sqlSer insertTestList:sqlInsert];
        
        str = nil;
        str_tmp = nil;
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (maxid)
    {
        [defaults setObject:maxid forKey:[NSString stringWithFormat:@"msg_maxid_%@",[token getProperty:@"service_number"]]];

    }

    if (minid)
    {
        [defaults setObject:minid forKey:[NSString stringWithFormat:@"msg_minid_%@",[token getProperty:@"service_number"]]];
    }
    
    [defaults synchronize];
    [self updateTableView:0];


}

- (void) fetchOld
{
    if (is_loading)
	{
		return;
	}
    
    action_type = 0;
    
	is_loading = YES;
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, MSG_LIST_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:@"1" forKey:@"page"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:[NSString stringWithFormat:@"msg_minid_%@",[token getProperty:@"service_number"]]])
    {
        [req setParam:[defaults objectForKey:[NSString stringWithFormat:@"msg_minid_%@",[token getProperty:@"service_number"]]] forKey:@"minid"];
    }
    else
    {
        [req setParam:minid forKey:@"minid"];
    }
    
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFethFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFetchOld:)];
	[loader loadwithTimer];
    
}

- (void) onFetchOld:(NSNotification *)notify
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
        [self updateTableViewBefore:0];
 		return;
	}
    
    NSMutableDictionary *dic = [json objectForKey:@"data"];
    NSArray *arr = [dic objectForKey:@"rows"];
    [buffer addObjectsFromArray:arr];
    
    if ([buffer count])
    {
        self.navigationItem.rightBarButtonItem = btn_edit;
    }
    
    [self.tableView reloadData];
    RRToken *token = [RRToken getInstance];
    sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"msgdb_%@.sql",[token getProperty:@"service_number"]]];
	sqlTestList *sqlInsert = [[sqlTestList alloc]init];
    
    for (NSDictionary *dict in arr)
    {
        NSMutableString *str = [NSMutableString string];
        NSMutableString *str_tmp = [NSMutableString string];
        
        for (int i = 0; i < [dict count]; i++)
        {
            NSString *s = [dict.allValues objectAtIndex:i];
            NSCharacterSet *whitespaces = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
            NSArray *parts = [s componentsSeparatedByCharactersInSet:whitespaces];
            NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
            s = [filteredArray componentsJoinedByString:@""];
            [str appendFormat:@"\"%@\":\"%@\",",[dict.allKeys objectAtIndex:i],s];
            if (i == [dict count] - 1)
            {
                minid = [dict objectForKey:@"id"];
            }
        }
        
        [str deleteCharactersInRange:NSMakeRange([str length] -1 ,1)];
        [str_tmp appendFormat:@"{%@}",str];
        
        sqlInsert.sqlID = [[dict objectForKey:@"id"] integerValue];
        sqlInsert.sqlText = str_tmp;
        
        //调用封装好的数据库插入函数
        [sqlSer insertTestList:sqlInsert];
        
        str = nil;
        str_tmp = nil;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (minid)
    {
        RRToken *token = [RRToken getInstance];
        [defaults setObject:minid forKey:[NSString stringWithFormat:@"msg_minid_%@",[token getProperty:@"service_number"]]];
    }
    [defaults synchronize];
    [self updateTableViewBefore:0];

    
}

- (void) onFethFail:(NSNotification *)notify
{
    is_fail = YES;
    is_loading = NO;
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
    [self updateTableView:0];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.tableView reloadData];


}

- (void) updateTableView:(NSUInteger)new_rows
{
	[self updateTableView:new_rows updatedRows:nil];
}

- (void) updateTableView:(NSUInteger)new_rows updatedRows:(NSIndexSet *)updated_rows
{
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.2];
	self.tableView.contentInset = UIEdgeInsetsZero;
	[UIView commitAnimations];
	
	[self.tableView reloadData];
}

- (void) updateTableViewBefore:(NSUInteger)num
{
	[refreshHeaderView_bottom setState:EGOOPullRefreshNormalUP];
	refreshHeaderView_bottom.hidden = YES;
	
	self.tableView.contentInset = UIEdgeInsetsZero;
	
	[self.tableView reloadData];
}


#pragma mark check token

- (void) checkTokenSuccess
{
    RRToken *token = [RRToken getInstance];
    sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"msgdb_%@.sql",[token getProperty:@"service_number"]]];
	NSArray *listData = [sqlSer getTestList];
	
	if (buffer)
	{
		[buffer removeAllObjects];
	}
	
	buffer = [NSMutableArray arrayWithCapacity:0];
	
    sqlTestList *sqlList = [[sqlTestList alloc] init];

	for (int j = 0; j < [listData count]; j++ )
	{
        sqlList = [listData objectAtIndex:j];
        NSDictionary *dic = [sqlList.sqlText JSONValue];
        [buffer addObject:dic];
	}
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if ([buffer count])
    {
        self.navigationItem.rightBarButtonItem = btn_edit;
    }
    
    [self fethNew];
    
    [self.tableView reloadData];
}

- (void) alertViewDidCancel
{
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];

}

- (void) popToViewController
{
	[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void) btn_edit_click:(id)sender
{
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing)
    {
        self.navigationItem.leftBarButtonItem = btn_clear;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;

    }
}

- (void) btn_clear_click:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"是否清除所有已加载的消息?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除" otherButtonTitles:nil];
    [as showInView:self.tableView];
}
- (void) updateItemAtIndexPath:(NSIndexPath *)indexPath withString: (NSString *)string
{
    RRToken *token = [RRToken getInstance];
    sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"msgdb_%@.sql",[token getProperty:@"service_number"]]];
    NSArray *listData = [sqlSer getTestList];
	sqlTestList *sqlList = [[sqlTestList alloc]init];
	sqlList = [listData objectAtIndex:indexPath.row];
    [sqlSer deleteTestList:sqlList];
	
    [buffer removeObjectAtIndex:indexPath.row];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView reloadData];
	if ([buffer count] == 0)
	{
		btn_edit.enabled = NO;
		[self.tableView setEditing:NO animated:YES];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        RRToken *token = [RRToken getInstance];
        sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"msgdb_%@.sql",[token getProperty:@"service_number"]]];
        NSArray *listData = [sqlSer getTestList];
        sqlTestList *sqlList = [[sqlTestList alloc]init];
        for (int i = 0; i < [listData count]; i++)
        {
            sqlList = [listData objectAtIndex:i];
            [sqlSer deleteTestList:sqlList];
        }
        
        [sqlSer deleteTestList:sqlList];
        [buffer removeAllObjects];
        btn_edit.enabled = NO;
		[self.tableView setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem = nil;
        [self.tableView reloadData];
    }
}
@end
