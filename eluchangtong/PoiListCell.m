//
//  PoiListCell.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-6.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "PoiListCell.h"
#import "sqlService.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRURLRequest.h"
#import "RRLoader.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "RoadRover.h"
#import "AHAlertView.h"

@implementation PoiListCell
@synthesize btn_save;
@synthesize btn_send;
@synthesize lb_addr;
@synthesize lb_name;
@synthesize lb_poi;
@synthesize im_poi;

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

+ (CGFloat) calCellHeight:(NSDictionary *)data
{
    return 53.0f;
}

- (void) setBuffer:(NSMutableArray *)buffer;
{
    if (arr)
    {
        [arr removeAllObjects];
        arr = nil;
    }
    
    arr = [NSMutableArray arrayWithArray:buffer];
}

- (void) setContent:(NSDictionary *)data
{
    NSArray *index_arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];
    if ([[data objectForKey:@"index"] integerValue] < [index_arr count] - 1 && ![data objectForKey:@"hide_zimu"])
    {
        lb_poi.text = [index_arr objectAtIndex:[[data objectForKey:@"index"] integerValue]];
    }
    else
    {
        lb_poi.text = @"";
    }
    
    lb_name.text = [data objectForKey:@"name"];
    lb_addr.text = [data objectForKey:@"addr"];
    
    if (![[data objectForKey:@"is_search"] integerValue])
    {
        [btn_save removeFromSuperview];
        btn_send.frame = CGRectMake(btn_send.frame.origin.x + 20.0f, btn_send.frame.origin.y, btn_send.frame.size.width, btn_send.frame.size.height);
    }

    btn_save.tag = [[data objectForKey:@"index"]integerValue];
    btn_send.tag = [[data objectForKey:@"index"]integerValue];
}

- (IBAction)btn_send_click:(id)sender
{
    dic = [arr objectAtIndex:[sender tag]];
    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele checkToken];
}

- (IBAction)btn_save_click:(id)sender
{
    RRToken *token = [RRToken getInstance];
    sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"poiSavedb_%@.sql",[token getProperty:@"service_number"]]];
	sqlTestList *sqlInsert = [[sqlTestList alloc]init];
    
    NSMutableDictionary *dict = [arr objectAtIndex:[sender tag]];
    NSMutableString *str = [NSMutableString string];
    NSMutableString *str_tmp = [NSMutableString string];
    
    for (int i = 0; i < [dict count]; i++)
    {
        [str appendFormat:@"\"%@\":\"%@\",",[dict.allKeys objectAtIndex:i],[dict.allValues objectAtIndex:i]];
    }
    
    [str deleteCharactersInRange:NSMakeRange([str length] -1 ,1)];
    [str_tmp appendFormat:@"{%@}",str];
    
    sqlInsert.sqlID = [[dict objectForKey:@"addr"] hash];
    sqlInsert.sqlText = str_tmp;
    
    //调用封装好的数据库插入函数
    [sqlSer insertTestList:sqlInsert];
    str = nil;
    str_tmp = nil;
    
    [RWAlertView show:@"收藏成功!"];
}

#pragma mark check token

- (void) checkTokenSuccess
{
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"请选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送导航",@"发送好友",nil];
    [as showInView:self.superview];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        [RWShowView show:@"loading"];
        NSString *poi = [NSString stringWithFormat:@"%@|%@|%@,%@|1|%@",[dic objectForKey:@"city"],[dic objectForKey:@"name"],[dic objectForKey:@"lng"],[dic objectForKey:@"lat"],[dic objectForKey:@"addr"]];
        
        NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_POI_URL];
        RRToken *token = [RRToken getInstance];
        RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
        [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
        [req setParam:poi forKey:@"poi"];
        
        [req setHTTPMethod:@"POST"];
        
        RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
        [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
        [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethNew:)];
        [loader loadwithTimer];
    }
    else if (1 == buttonIndex)
    {
        [self applyCustomAlertAppearance];
        NSString *title = @"发送汽车位置";
        NSString *message = @"请输入好友服务号";
        AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        __weak AHAlertView *alert =_alert;
        [alert setCancelButtonTitle:@"发送" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleFade;
        }];
        [alert addButtonWithTitle:@"取消" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
        }];
        
        [alert setAlertViewStyle:AHAlertViewStylePlainTextInput];
        [alert show];
    }
}

- (void)alertViewDidSendWithId:(NSString *)no
{
    [RWShowView show:@"loading"];
    NSString *poi = [NSString stringWithFormat:@"%@|%@|%@,%@|1|%@",[dic objectForKey:@"city"],[dic objectForKey:@"name"],[dic objectForKey:@"lng"],[dic objectForKey:@"lat"],[dic objectForKey:@"addr"]];
    
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_POI_URL];
    RRToken *token = [RRToken getInstance];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:poi forKey:@"poi"];
    [req setParam:no forKey:@"service_number"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethNew:)];
	[loader loadwithTimer];
}


- (void) onFethNew:(NSNotification *)notify
{
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        [RWShowView closeAlert];
        [RWAlertView show:@"网络链接失败!" ];
 		return;
	}
    
    [RWAlertView show:@"发送成功!" ];
}

- (void) onFetchFail:(NSNotification *)notify
{
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
