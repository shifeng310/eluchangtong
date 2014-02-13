//
//  UsrChangePassViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "UsrChangePassViewController.h"
#import "RoadRover.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "SFHFKeychainUtils.h"

@implementation UsrChangePassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        tf_certain_password = nil;
        tf_new_password = nil;
        tf_old_password = nil;
        btn_certain = nil;
    }
}

- (void)dealloc
{
    tf_certain_password = nil;
    tf_new_password = nil;
    tf_old_password = nil;
    btn_certain = nil;
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([tf_old_password isFirstResponder])
    {
        [tf_new_password becomeFirstResponder];
    }
    else if ([tf_new_password isFirstResponder])
    {
        [tf_certain_password becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
	
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (IBAction)btn_click:(id)sender
{
    if (!tf_old_password.text)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"原密码不能为空！"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        
        [av show];
        return;

    }
    
    if (tf_old_password.text)
    {
        RRToken *token = [RRToken getInstance];
        server_num = [token getProperty:@"service_number"];
        NSString *passWord = [SFHFKeychainUtils getPasswordForUsername:server_num andServiceName:@"eluchangtong" error:nil];
        if (![tf_old_password.text isEqualToString:passWord])
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"原密码不正确！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            
            [av show];
            return;
        }
    }
    
    if (!tf_certain_password.text)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请确认密码！"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        
        [av show];
        return;
    }
    if (!tf_new_password.text)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"请输入新密码！"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        
        [av show];
        return;
    }
    
    if (![tf_certain_password.text isEqualToString:tf_new_password.text])
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"两次密码输入不一致！"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        
        [av show];
        return;
    }
    
    [self savePassWord];

}

- (void)savePassWord
{
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, CHANGE_PASS_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:tf_new_password.text forKey:@"newpwd"];
    [req setParam:tf_old_password.text forKey:@"oldpwd"];
 	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSavePassWord:)];
	[loader loadwithTimer];
    
}

- (void)onSavePassWord:(NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        [RWShowView closeAlert];
        if ([[json objectForKey:@"data"] length])
        {
            [RWAlertView show:[json objectForKey:@"data"]];
        }
        else
        {
            [RWAlertView show:@"网络连接错误!"];
        }
 		return;
	}
    
    [RWShowView closeAlert];
    [RWAlertView show:@"保存成功!" ];
    
    RRToken *token = [RRToken getInstance];
    [RRToken removeTokenForUID:[token getProperty:@"uid"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_login_uid"];
    
    [SFHFKeychainUtils storeUsername:server_num andPassword:tf_new_password.text forServiceName:@"eluchangtong" updateExisting:YES error:nil];

    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele checkToken];

}

- (void)onFetchFail:(NSNotification *)notify
{
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
}

#pragma mark check token

- (void) checkTokenSuccess
{
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
}

- (void) alertViewDidCancel
{
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
    
}

- (void) popToViewController
{
	[self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
