//
//  UsrTelViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-9.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "UsrTelViewController.h"
#import "RoadRover.h"
#import "RRLoader.h"
#import "RRToken.h"
#import "RWCache.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "AppDelegate.h"

@implementation UsrTelViewController
@synthesize tf_tel_4s;
@synthesize tf_tel_baoxian;
@synthesize tf_tel_gongsi;
@synthesize tf_tel_jiaren;
@synthesize tf_tel_jinji;
@synthesize tf_tel_qita;
@synthesize btn_tel;
@synthesize scrollView;
@synthesize bg_view;

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
    
    self.title = @"常用电话";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
    [self.bg_view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
    
    scrollView.frame = CGRectMake(0.0f, 0.0f, 320.0f, [[UIScreen mainScreen]bounds].size.height);
    bg_view.frame = CGRectMake(0.0f, 0.0f, 320.0f, [[UIScreen mainScreen]bounds].size.height);
    [scrollView addSubview:bg_view];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 1.5);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;

    fours = @"点击设置号码";
    baoxian = @"点击设置号码";
    gongsi = @"点击设置号码";
    jiaren = @"点击设置号码";
    jinji = @"点击设置号码";
    qita = @"点击设置号码";

    btn_back_item = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_back_click:) ];
    self.navigationItem.leftBarButtonItem = btn_back_item;
    
    btn_save = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_save_click:)];

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
        tf_tel_4s = nil;
        tf_tel_baoxian = nil;
        tf_tel_gongsi = nil;
        tf_tel_jiaren = nil;
        tf_tel_jinji = nil;
        tf_tel_qita = nil;
        btn_tel = nil;
        scrollView = nil;
        bg_view = nil;
    }
}

- (void)dealloc
{
    tf_tel_4s = nil;
    tf_tel_baoxian = nil;
    tf_tel_gongsi = nil;
    tf_tel_jiaren = nil;
    tf_tel_jinji = nil;
    tf_tel_qita = nil;
    btn_tel = nil;
    scrollView = nil;
    bg_view = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [RWAlertView closeAlert];
    [RWShowView closeAlert];
}

- (void) fethNew
{
    if (is_loading)
	{
		return;
	}
    [RWShowView show:@"loading"];
	is_loading = YES;
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, USR_TEL_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
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
        if ([[json objectForKey:@"errcode"] integerValue] == 601)
        {
            [RWShowView closeAlert];
            [RWAlertView show:@"还没有设置数据!" ];
            return;
        }
        
        [RWAlertView show:@"网络链接失败!" ];
  		return;
	}
    
    NSMutableDictionary *dic = [json objectForKey:@"data"];
    RRToken *token = [RRToken getInstance];
    RWCache *cache = [[RWCache alloc]initWithUID:[token getProperty:@"service_number"] andName:@"tellist"];

    if ([dic count] == 0)
    {
        [RWShowView closeAlert];
        [self setTextField];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithObject:dic];
    [cache setArr:arr WithName:@"tellist"];
    [cache saveToFileWithName:@"tellist"];
    
    if ([[cache getArr] count] > 1)
    {
        [cache deleteFileWithName:@"tellist" Index:0];
    }
    
    [self setTextField];
}

- (void) save
{
    if (is_loading)
	{
		return;
	}
    [RWShowView show:@"loading"];
	is_loading = YES;
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, USR_TEL_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    if (![fours isEqualToString:@"点击设置号码"])
    {
        is_4s = NO;
        [req setParam:fours forKey:@"shop_tel"];
    }
    else
    {
        [req setParam:@"-1" forKey:@"shop_tel"];
    }
    
    if (![baoxian isEqualToString:@"点击设置号码"])
    {
        is_baoxian = NO;
        [req setParam:baoxian forKey:@"insurance_tel"];
    }
    else
    {
        [req setParam:@"-1" forKey:@"insurance_tel"];

    }
    if (![gongsi isEqualToString:@"点击设置号码"])
    {
        is_gongsi = NO;
        [req setParam:gongsi forKey:@"company_tel"];
    }
    else
    {
        [req setParam:@"-1" forKey:@"company_tel"];
    }
    
    if (![jiaren isEqualToString:@"点击设置号码"])
    {
        is_jiaren = NO;
        [req setParam:jiaren forKey:@"home_tel"];
    }
    else
    {
        [req setParam:@"-1" forKey:@"home_tel"];
    }
    
    if (![jinji isEqualToString:@"点击设置号码"])
    {
        is_jinji = NO;
        [req setParam:jinji forKey:@"emergency_tel"];
    }
    else
    {
        [req setParam:@"-1" forKey:@"emergency_tel"];
    }
    
    if (![qita isEqualToString:@"点击设置号码"])
    {
        is_qita = NO;
        [req setParam:qita forKey:@"other_tel"];
    }
    else
    {
        [req setParam:@"-1" forKey:@"other_tel"];
    }

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSave:)];
	[loader loadwithTimer];
    
}

- (void) onSave:(NSNotification *)notify
{
    is_loading = NO;
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
    
    [RWAlertView show:@"保存成功!" ];
    
    RRToken *token = [RRToken getInstance];
    RWCache *cache = [[RWCache alloc]initWithUID:[token getProperty:@"service_number"] andName:@"tellist"];
    NSDictionary *dic = @{ @"shop_tel" : fours,@"insurance_tel":baoxian,@"company_tel":gongsi,@"home_tel":jiaren,@"emergency_tel":jinji,@"other_tel":qita};
    NSMutableArray *arr = [NSMutableArray arrayWithObject:dic];
    [cache setArr:arr WithName:@"tellist"];
    [cache deleteFileWithName:@"tellist" Index:0];
    [cache saveToFileWithName:@"tellist"];
    if ([[cache getArr] count] > 1)
    {
        [cache deleteFileWithName:@"tellist" Index:0];
    }
}

- (void) onLoadFail:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)btn_tel_click:(id)sender
{
    switch ([sender tag])
    {
        case 1:
            if ([tf_tel_4s.text integerValue])
            {
                tel_no = tf_tel_4s.text;
            }
            break;
            
        case 2:
            if ([tf_tel_baoxian.text integerValue])
            {
                tel_no = tf_tel_baoxian.text;
            }
            break;
        case 3:
            if ([tf_tel_jinji.text integerValue])
            {
                tel_no = tf_tel_jinji.text;
            }
            break;
        case 4:
            if ([tf_tel_gongsi.text integerValue])
            {
                tel_no = tf_tel_gongsi.text;
            }
            break;
        case 5:
            if ([tf_tel_jiaren.text integerValue])
            {
                tel_no = tf_tel_jiaren.text;
            }
            break;
        case 6:
            if ([tf_tel_qita.text integerValue])
            {
                tel_no = tf_tel_qita.text;
            }
            break;
        default:
            break;
    }
    
    if (![tel_no integerValue])
    {
        [RWAlertView show:@"还没有设置号码!"];
        return;
    }
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"确定拨打？"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:tel_no
                                           otherButtonTitles:nil];
    as.tag = 101;
    [as showInView:self.view];

}

- (void)btn_back_click:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)btn_save_click:(id)sender
{
    [active_field resignFirstResponder];
    scrollView.scrollEnabled = NO;
    CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, [[UIScreen mainScreen] bounds].size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.20];
    [UIView setAnimationDelegate:self];
    [scrollView scrollRectToVisible:frame animated:YES];
    [UIView commitAnimations];
    [self save];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (actionSheet.tag == 101 && buttonIndex == 0)
	{
		NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel_no]];
		
		if (![[UIApplication sharedApplication] canOpenURL:phoneNumberURL])
		{
			[self alertWithTitle:nil msg:@"设备没有电话功能"];
			return;
		}
		[[UIApplication sharedApplication] openURL:phoneNumberURL];
		return;
	}
	
	else if (actionSheet.tag == 101 && buttonIndex == 1)
	{
		return;
	}
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark check token

- (void) checkTokenSuccess
{

    [self setTextField];
    [self fethNew];

}

- (void) alertViewDidCancel
{
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
    
}

- (void) popToViewController
{
	[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)setTextField
{
    RWCache *cache = [RWCache getInstanceWithName:@"tellist"];
    if ([cache getCount])
    {
        NSDictionary *dic = [[cache getArr] objectAtIndex:0];
        
        if ([dic objectForKey:@"company_tel"])
        {
            tf_tel_gongsi.text = [dic objectForKey:@"company_tel" ];
            gongsi = [dic objectForKey:@"company_tel" ];
        }
        if ([dic objectForKey:@"emergency_tel"])
        {
            tf_tel_jinji.text = [dic objectForKey:@"emergency_tel" ];
            jinji = [dic objectForKey:@"emergency_tel" ];
        }
        if ([dic objectForKey:@"home_tel"])
        {
            tf_tel_jiaren.text = [dic objectForKey:@"home_tel" ];
            jiaren = [dic objectForKey:@"home_tel" ];
        }
        if ([dic objectForKey:@"insurance_tel"])
        {
            tf_tel_baoxian.text = [dic objectForKey:@"insurance_tel" ];
            baoxian = [dic objectForKey:@"insurance_tel" ];
        }
        if ([dic objectForKey:@"other_tel"])
        {
            tf_tel_qita.text = [dic objectForKey:@"other_tel" ];
            qita = [dic objectForKey:@"other_tel" ];
        }
        if ([dic objectForKey:@"shop_tel"])
        {
            tf_tel_4s.text = [dic objectForKey:@"shop_tel"];
            fours  = [dic objectForKey:@"shop_tel" ];
        }
    }
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *back_tf = (UITextField *)[self.bg_view viewWithTag:textField.tag+1];
	[textField resignFirstResponder];
    if (textField.tag < 16)
    {
        [back_tf becomeFirstResponder];
    }
    
    else
    {
        scrollView.scrollEnabled = NO;
        CGRect frame = CGRectMake(0.0f, 0.0f, 320.0f, [[UIScreen mainScreen] bounds].size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationDelegate:self];
        [scrollView scrollRectToVisible:frame animated:YES];
        [UIView commitAnimations];
    }


	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	active_field = textField;
    self.navigationItem.rightBarButtonItem = btn_save;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        if ([textField tag] >= 14)
        {
            scrollView.scrollEnabled = YES;
            
            float ext_height = textField.frame.origin.y - 50;
            CGRect frame = CGRectMake(0.0f, ext_height, 320.0f, [[UIScreen mainScreen] bounds].size.height);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.20];
            [UIView setAnimationDelegate:self];
            [scrollView scrollRectToVisible:frame animated:YES];
            [UIView commitAnimations];
        }

    }
    
    else if ([textField tag] >= 12)
    {
        scrollView.scrollEnabled = YES;

        float ext_height = textField.frame.origin.y - 50;
        CGRect frame = CGRectMake(0.0f, ext_height, 320.0f, [[UIScreen mainScreen] bounds].size.height);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.20];
        [UIView setAnimationDelegate:self];
        [scrollView scrollRectToVisible:frame animated:YES];
        [UIView commitAnimations];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] == 0)
    {
        return;
    }
    
    switch ([textField tag]) {
        case 11:
            is_4s = YES;
            fours = textField.text;
            break;
        case 12:
            is_baoxian = YES;
            baoxian = textField.text;
            break;
        case 13:
            is_jinji = YES;
            jinji = textField.text;
            break;
        case 14:
            is_gongsi = YES;
            gongsi = textField.text;
            break;
        case 15:
            is_jiaren = YES;
            jiaren = textField.text;
            break;
        case 16:
            is_qita = YES;
            qita = textField.text;
            break;
        default:
            break;
    }
}


@end
