//
//  AppDelegate.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-5.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "NavController.h"
#import "HomeViewController.h"
#import "BMapKit.h"
#import "RRToken.h"
#import "RRURLRequest.h"
#import "RRLoader.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "RoadRover.h"
#import "SFHFKeychainUtils.h"
#import "MsgListController.h"
#import "ServiceBaseViewController.h"

static AppDelegate *instance = nil;

NSString *pushStatus ()
{
	return [[UIApplication sharedApplication] enabledRemoteNotificationTypes] ?
	@"Notifications were active for this application" :
	@"Remote notifications were not active for this application";
}

BMKMapManager *_mapManager;
@implementation AppDelegate
@synthesize delegate;
@synthesize pushToken;

+ (AppDelegate *) getInstance
{
	return instance;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];

    application.applicationSupportsShakeToEdit = YES;
    instance = self;
    tips_arr = [NSMutableArray arrayWithCapacity:0];
    HomeViewController *ctrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    NavController *nav = [[NavController alloc] initWithRootViewController:ctrl];
    
//    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    [nav.navigationBar setTintColor:[UIColor colorWithRed:71.0f/255.0f green:158.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    

#if !(TARGET_IPHONE_SIMULATOR)
    [self confirmationWasHidden:nil];
#endif

    _mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"63D8BE53EC0EA69D774385D5CEB683290675DC08" generalDelegate:self];
	if (!ret)
	{
		NSLog(@"manager start failed!");
	}

    NSLog(@"%@",[NSString stringWithFormat:@"%@",[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"]]);
    
    if ([[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"])
    {
        NSString *msg = [[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"] objectForKey:@"alert"];
        NSDictionary *dic = @{@"msg" : msg,@"title" : @"新消息",@"type": @"msg"};
        arr = [NSMutableArray arrayWithObject:dic];
        [self performSelector:@selector(handleNotification) withObject:nil afterDelay:1.0f];
    }
    else if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsLocalNotificationKey"])
    {
        
        [self performSelector:@selector(handleLocalNotification) withObject:nil afterDelay:1.0f];
    }
    return YES;
}

- (void) confirmationWasHidden: (NSNotification *) notification
{ 
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0)
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeNewsstandContentAvailability)];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound)];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// Retrieve the device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (![deviceToken length])
    {
        return;
    }
    
    pushToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    pushToken = [pushToken stringByReplacingOccurrencesOfString:@"" withString:@""];
    NSLog(@"%@",pushToken);
}

// Provide a user explanation for when the registration fails
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSString *status = [NSString stringWithFormat:@"%@\nRegistration failed.\n\nError: %@", pushStatus(), [error localizedDescription]];
    NSLog(@"Error in registration. Error: %@", error);
    NSLog(@"%@",status);
    
}

// Handle an actual notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	NSString *status = [NSString stringWithFormat:@"Notification received:\n%@",[userInfo description]];
    NSLog(@"%@",status);
    
    RRToken *token = [RRToken getInstance];
    if (!token || ![[[userInfo objectForKey:@"aps"] objectForKey:@"service_number"] isEqualToString:[token getProperty:@"service_number"]])
    {
        return;
    }
	
	//接收到push
	NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSDictionary *dic = @{@"msg" : msg,@"title" : @"新消息",@"type": @"msg"};
    arr = [NSMutableArray arrayWithObject:dic];
    NavController *nav = (NavController *)self.window.rootViewController;
    HomeViewController *ctrl = [[nav viewControllers] objectAtIndex:0];
    if (!is_active)
    {
        [ctrl setMsgsArr:arr];
        [ctrl setTipsLable];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    else
    {
        MsgListController *ctrl_msg = [[MsgListController alloc]initWithStyle:UITableViewStylePlain];
        [ctrl.navigationController pushViewController:ctrl_msg animated:YES];
    }
}

- (void)handleNotification
{
    NavController *nav = (NavController *)self.window.rootViewController;
    HomeViewController *ctrl = [[nav viewControllers] objectAtIndex:0];
    MsgListController *ctrl_msg = [[MsgListController alloc]initWithStyle:UITableViewStylePlain];
    [ctrl.navigationController pushViewController:ctrl_msg animated:YES];
}

- (void)handleLocalNotification
{
    NavController *nav = (NavController *)self.window.rootViewController;
    HomeViewController *ctrl = [[nav viewControllers] objectAtIndex:0];
    ServiceBaseViewController *ctrl_msg = [[ServiceBaseViewController alloc]initWithNibName:@"ServiceBaseViewController" bundle:nil];
    [ctrl.navigationController pushViewController:ctrl_msg animated:YES];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    is_active = NO;

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    is_active = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    is_active = NO;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    is_active = NO;

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [tips_arr addObject:notification.userInfo];
    NavController *nav = (NavController *)self.window.rootViewController;
    HomeViewController *ctrl = [[nav viewControllers] objectAtIndex:0];
    [ctrl setTipsArr:tips_arr];
    [ctrl setTipsLable];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark check token

- (void) checkToken
{
    is_active = NO;
	if (![RRToken check])
	{
        [self applyCustomAlertAppearance];
        NSString *title = @"登录";
        NSString *message = @"";
        is_save = YES;
        AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        alert = _alert;

        [alert setCancelButtonTitle:@"登录" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleFade;
        }];
        [alert addButtonWithTitle:@"申请" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
        }];
     
        
        [alert setAlertViewStyle:AHAlertViewStyleLoginAndPasswordInput];
        [alert setSaveFlag:YES];
        [alert setSaveImage:[UIImage imageNamed:@"custom-gouxuan.png"]];
        [alert show];
        
	}
	else
	{
		[self checkTokenSuccess];
	}
}

- (void) checkTokenSuccess
{
    if (delegate && [delegate respondsToSelector:@selector(checkTokenSuccess)])
    {
        [delegate performSelector:@selector(checkTokenSuccess)];
    }
}

- (void) alertViewDidCancel
{
    if (delegate && [delegate respondsToSelector:@selector(alertViewDidCancel)])
    {
        [delegate performSelector:@selector(alertViewDidCancel)];
    }

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

- (void)btn_save_click:(id)sender
{
    if (!is_save)
    {
        [alert setSaveImage:[UIImage imageNamed:@"custom-gouxuan.png"]];
    }
    else
    {
        [alert setSaveImage:[UIImage imageNamed:@"custom-weixuan.png"]];
        
    }
    [alert setSaveFlag:is_save];
    is_save = !is_save;
}

- (void)loginWithUsr:(NSString *)usr andPass:(NSString *)pass
{
    service_number = usr;
    password = pass;
    
    if (is_reg)
    {
        [self reg];
    }
    
    else
    {
        [self login];
        
    }

}

- (void)btn_reg_click:(id)sender
{
    is_reg = YES;
    [self performSelector:@selector(performRegisterView) withObject:nil afterDelay:0.5f];
}

- (void)performRegisterView
{
    NSString *title = @"申请服务号";
    NSString *message = @"";
    [self applyCustomAlertAppearance];
    AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
    alert = _alert;
    [alert setCancelButtonTitle:@"提交" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleFade;
    }];
    [alert setAlertViewStyle:AHAlertViewStyleRegister];
    [alert show];
}

- (void) reg
{
    if (is_loading)
	{
		return;
	}
    
	is_loading = YES;
	[RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, REG_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:password forKey:@"password"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onReg:)];
	[loader loadwithTimer];
}

- (void) onReg:(NSNotification *)notify
{
    is_loading = NO;
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        is_reg = NO;
        [RWShowView closeAlert];
        NSString *title = @"申请提示";
        NSString *message = @"网络链接失败!";
        [self applyCustomAlertAppearance];
        AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        alert = _alert;
        [alert setAlertViewStyle:AHAlertViewStyleDefault];
        [alert show];
		return;
	}
    
    NSDictionary *dic = [json objectForKey:@"data"];
    service_number = [dic objectForKey:@"service_number"];
    [self login];
}

- (void) login
{
    if (is_loading)
	{
		return;
	}
    
	is_loading = YES;
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:password forKey:@"password"];
    [req setParam:service_number forKey:@"service_number"];
    
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLogin:)];
	[loader loadwithTimer];
    
}

- (void) onLogin:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        is_reg = NO;
        [RWShowView closeAlert];
        NSString *title = @"登录提示";
        NSString *message;
        if ([[json objectForKey:@"errcode"] integerValue] == 600)
        {
            message = @"服务号或者密码错误!";
        }
        else if ([[json objectForKey:@"errcode"] integerValue] == 500)
        {
            message = @"网络链接失败!";
        }

        [self applyCustomAlertAppearance];
        AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        alert = _alert;
        [alert setAlertViewStyle:AHAlertViewStyleDefault];
        [alert show];
		return;
	}
    
    NSDictionary *dic = [json objectForKey:@"data"];
    NSString *tokens = [dic objectForKey:@"token"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"token_%@.plist", service_number];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
    if (![[NSFileManager defaultManager] fileExistsAtPath:token_file])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![[defaults objectForKey:@"last_server_no"] length])
        {
            [defaults setObject:service_number forKey:@"last_server_no"];
            
        }
    }
    
    RRToken *token = [[RRToken alloc] initWithUID:service_number];
    
    //set token
    [token setProperty:tokens forKey:@"tokensn"];
    [token setProperty:service_number forKey:@"service_number"];
    
    //write token to local field
    [token saveToFile];
    

    if (is_save)
    {
        [SFHFKeychainUtils storeUsername:service_number andPassword:password forServiceName:@"eluchangtong" updateExisting:YES error:nil];
    }
    
    else
    {
        [SFHFKeychainUtils deleteItemForUsername:service_number andServiceName:@"eluchangtong" error:nil];
    }

    
    if (is_reg)
    {
        is_reg = NO;
        NSString *title = @"申请提示";
        NSString *message = [NSString stringWithFormat:@"恭喜您申请成功!您的服务号是%@",service_number];
        [self applyCustomAlertAppearance];
        AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        alert = _alert;
        [alert setAlertViewStyle:AHAlertViewStyleDefault];
        [alert show];
    }
    
    
    if (delegate && [delegate respondsToSelector:@selector(changeLocalNotification)])
    {
        [delegate performSelector:@selector(changeLocalNotification)];
    }

    [self checkTokenSuccess];
}

- (void) onFail:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    is_reg = NO;
    NSString *title = @"申请提示";
    NSString *message = @"网络链接失败!";
    [self applyCustomAlertAppearance];
    AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
    alert = _alert;
    [alert setAlertViewStyle:AHAlertViewStyleDefault];
    [alert show];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark 全局变量适配ios 6.0/7.0 UINavigationBar

- (void)customizeInterface {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background_tall"]
                                      forBarMetrics:UIBarMetricsDefault];
        [navigationBarAppearance setTintColor:[UIColor whiteColor]];
    } else {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"]
                                      forBarMetrics:UIBarMetricsDefault];
    }
    
    NSDictionary *textAttributes = nil;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0) {
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                           UITextAttributeTextColor: [UIColor whiteColor],
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

@end
