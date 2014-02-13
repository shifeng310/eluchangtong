//
//  ServiceBaseViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-15.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "NSDate+Helper.h"
#import "ServiceBaseViewController.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "RoadRover.h"
#import "RWAlertView.h"
#import "RWShowView.h"

#define isRetina ([[UIScreen mainScreen] currentMode].size.height > 480 ? 1 : 0)

typedef void (^AHAnimationCompletionBlock)(BOOL);
typedef void (^AHAnimationBlock)();

static CGFloat CGAffineTransformGetAbsoluteRotationAngleDifference(CGAffineTransform t1, CGAffineTransform t2)
{
	CGFloat dot = t1.a * t2.a + t1.c * t2.c;
	CGFloat n1 = sqrtf(t1.a * t1.a + t1.c * t1.c);
	CGFloat n2 = sqrtf(t2.a * t2.a + t2.c * t2.c);
	return acosf(dot / (n1 * n2));
}

@implementation ServiceBaseViewController
@synthesize btn_type;
@synthesize btn_select;
@synthesize im_baoxian_bg;
@synthesize im_baoyang_bg;
@synthesize im_chaosu_bg;
@synthesize im_nianjian_bg;
@synthesize head_view;
@synthesize head_view_bg;
@synthesize baoyang_view;
@synthesize lb_baoyang_time;
@synthesize lb_current_mile;
@synthesize lb_next_mile;
@synthesize btn_baoxian_gouxuan_bg;
@synthesize btn_baoyang_gouxuan_bg;
@synthesize btn_chaosu_gouxuan_bg;
@synthesize btn_nianjian_gouxuan_bg;
@synthesize btn_baoxian_save;
@synthesize btn_chaosu_save;
@synthesize btn_nianjian_save;
@synthesize btn_yibaoyang;
@synthesize baoxian_view;
@synthesize tf_company;
@synthesize tf_time;
@synthesize nianjian_view;
@synthesize tf_buytime;
@synthesize lb_next_time;
@synthesize tf_speed;
@synthesize chaosu_view;
@synthesize lb_curr_data;
@synthesize tf_curr_mileage;
@synthesize lb_maintain_spacing;
@synthesize tf_mileage_spacing;
@synthesize alert_bg_im;
@synthesize alert_view;
@synthesize pickerView;
@synthesize lb_error;
@synthesize btn_certain;
@synthesize tool_bar;

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
    self.title = @"爱车服务";
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
    
    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele checkToken];
    
    btn_certain_tmp = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btn_certain_tmp_click:)];
    btn_cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
    btn_title = [[UIBarButtonItem alloc]initWithTitle:@"选择本次保养时间" style:UIBarButtonItemStylePlain target:self action:nil];

    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *arr = @[btn_cancel,flex,btn_title,flex,btn_certain_tmp];
    tool_bar_tmp = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    tool_bar_tmp.barStyle = UIBarStyleBlack;
    tool_bar_tmp.translucent = YES;
    [tool_bar_tmp setItems:arr animated:NO];

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
    btn_type = nil;
    btn_select = nil;
    im_baoxian_bg = nil;
    im_baoyang_bg = nil;
    im_chaosu_bg = nil;
    im_nianjian_bg = nil;
    head_view = nil;
    head_view_bg = nil;
    baoyang_view = nil;
    lb_baoyang_time = nil;
    lb_current_mile = nil;
    lb_next_mile = nil;
    btn_baoxian_gouxuan_bg = nil;
    btn_baoyang_gouxuan_bg = nil;
    btn_chaosu_gouxuan_bg = nil;
    btn_nianjian_gouxuan_bg = nil;
    btn_baoxian_save = nil;
    btn_chaosu_save = nil;
    btn_nianjian_save = nil;
    btn_yibaoyang = nil;
    baoxian_view = nil;
    tf_company = nil;
    tf_time = nil;
    nianjian_view = nil;
    tf_buytime = nil;
    lb_next_time = nil;
    tf_speed = nil;
    chaosu_view = nil;
    lb_curr_data = nil;
    tf_curr_mileage = nil;
    lb_maintain_spacing = nil;
    tf_mileage_spacing = nil;
    alert_bg_im = nil;
    alert_view = nil;
    pickerView = nil;
    lb_error = nil;
    btn_certain = nil;
    tool_bar = nil;
}

- (IBAction)btn_click:(id)sender
{
    switch ([sender tag])
    {
        case 21:
        {
            if (type == 1)
            {
                break;
            }
            im_baoyang_bg.image = [UIImage imageNamed:@"service_bg_highlight.png"];
            im_baoxian_bg.image = nil;
            im_nianjian_bg.image = nil;
            im_chaosu_bg.image = nil;
            [baoxian_view removeFromSuperview];
            [nianjian_view removeFromSuperview];
            [chaosu_view removeFromSuperview];
            [self addBaoYangView];
            type = 1;
            break;
        }
        case 22:
            if (type == 2)
            {
                break;
            }
            im_baoyang_bg.image = nil;
            im_baoxian_bg.image = [UIImage imageNamed:@"service_bg_highlight.png"];
            im_nianjian_bg.image = nil;
            im_chaosu_bg.image = nil;
            [baoyang_view removeFromSuperview];
            [nianjian_view removeFromSuperview];
            [chaosu_view removeFromSuperview];
            [self addBaoXianView];
            type = 2;
            break;
        case 23:
            if (type == 3)
            {
                break;
            }
            im_baoyang_bg.image = nil;
            im_baoxian_bg.image = nil;
            im_nianjian_bg.image = [UIImage imageNamed:@"service_bg_highlight.png"];
            im_chaosu_bg.image = nil;
            [baoyang_view removeFromSuperview];
            [baoxian_view removeFromSuperview];
            [chaosu_view removeFromSuperview];
            [self addNianjianView];
            type = 3;
            break;
        case 24:
            if (type == 4)
            {
                break;
            }
            im_baoyang_bg.image = nil;
            im_baoxian_bg.image = nil;
            im_nianjian_bg.image = nil;
            im_chaosu_bg.image = [UIImage imageNamed:@"service_bg_highlight.png"];
            [baoyang_view removeFromSuperview];
            [baoxian_view removeFromSuperview];
            [nianjian_view removeFromSuperview];
            [self addChaosuView];
            type = 4;
            break;
         default:
            break;
    }

}

- (IBAction)btn_notice_click:(id)sender
{
    switch ([sender tag])
    {
        case 11:
            if (is_baoyang_notice)
            {
                btn_baoyang_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            }
            else
            {
                btn_baoyang_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];

            }
            is_baoyang_notice = !is_baoyang_notice;
            [self setAlertView];
            break;
        case 12:
        {
            if (is_baoxian_notice)
            {
                btn_baoxian_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            }
            else
            {
                btn_baoxian_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];
                
            }
            is_baoxian_notice = !is_baoxian_notice;
            
            NSString *stime = [NSString stringWithFormat:@"%@ 00:00:00",self.tf_time.text];
            NSDate *date = [NSDate dateFromString:stime];
            NSTimeInterval a=[date timeIntervalSince1970];
            NSString *stimeString = [NSString stringWithFormat:@"%0.0f",a];
            if ([stimeString integerValue] == 0)
            {
                [RWAlertView show:@"到期时间格式设置错误!"];
                return;
            }
            
            insurance_company = tf_company.text;
            insurance_date = stimeString;
            if (is_baoxian_notice)
            {
                insurance_tag = @"1";
            }
            else
            {
                insurance_tag = @"2";
            }
            
            //[self saveData];
            break;
        }
        case 13:
        {
            if (is_nianjian_notice)
            {
                btn_nianjian_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            }
            else
            {
                btn_nianjian_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];
                
            }
            is_nianjian_notice = !is_nianjian_notice;
            NSString *stime = [NSString stringWithFormat:@"%@ 00:00:00",self.tf_buytime.text];
            NSDate *date = [NSDate dateFromString:stime];
            NSTimeInterval a=[date timeIntervalSince1970];
            NSString *stimeString = [NSString stringWithFormat:@"%0.0f",a];
            if ([stimeString integerValue] == 0)
            {
                [RWAlertView show:@"购买时间格式设置错误!"];
                return;
            }
            
            if ([stimeString integerValue] > [[self getCurrentTime] integerValue])
            {
                [RWAlertView show:@"购买时间大于当前时间!"];
                return;
            }
            check_date = stimeString;
            if (is_nianjian_notice)
            {
                check_tag = @"1";
            }
            else
            {
                check_tag = @"2";
            }
            
            //[self saveData];
            break;
        }
        case 14:
        {
            if (is_chaosu_notice)
            {
                btn_chaosu_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            }
            else
            {
                btn_chaosu_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];
            }
            is_chaosu_notice = !is_chaosu_notice;
            hypervelocity =  tf_speed.text;
            if (is_chaosu_notice)
            {
                hypervelocity_tag = @"1";
                [RWAlertView show:@"超速提醒设置后将会在车机上进行提醒!"];
            }
            else
            {
                hypervelocity_tag = @"2";
            }
            
           // [self saveData];
        }
        default:
            break;
    }

}

- (IBAction)btn_save_click:(id)sender
{
    switch ([sender tag])
    {
        case 31:
            [self setAlertView];
            break;
        case 32:
        {
            NSString *stime = [NSString stringWithFormat:@"%@ 00:00:00",self.tf_time.text];
            NSDate *date = [NSDate dateFromString:stime];
            NSTimeInterval a=[date timeIntervalSince1970];
            NSString *stimeString = [NSString stringWithFormat:@"%0.0f",a];
            if ([stimeString integerValue] == 0)
            {
                [RWAlertView show:@"到期时间格式设置错误!"];
                return;
            }
            
            insurance_company = tf_company.text;
            insurance_date = stimeString;
            if (is_baoxian_notice)
            {
                insurance_tag = @"1";
            }
            else
            {
                insurance_tag = @"2";
            }

            [self saveData];
            break;
        }
        case 33:
        {
            NSString *stime = [NSString stringWithFormat:@"%@ 00:00:00",self.tf_buytime.text];
            NSDate *date = [NSDate dateFromString:stime];
            NSTimeInterval a=[date timeIntervalSince1970];
            NSString *stimeString = [NSString stringWithFormat:@"%0.0f",a];
            if ([stimeString integerValue] == 0)
            {
                [RWAlertView show:@"购买时间格式设置错误!"];
                return;
            }
            
            if ([stimeString integerValue] > [[self getCurrentTime] integerValue])
            {
                [RWAlertView show:@"购买时间大于当前时间!"];
                return;
            }
            check_date = stimeString;
            if (is_nianjian_notice)
            {
                check_tag = @"1";
            }
            else
            {
                check_tag = @"2";
            }
            
            [self saveData];
        }
        case 34:
        {
            hypervelocity =  tf_speed.text;
            if (is_chaosu_notice)
            {
                hypervelocity_tag = @"1";
            }
            else
            {
                hypervelocity_tag = @"2";
            }
            
            [self saveData];
            break;
        }
        default:
            [self saveData];
            break;
    }
}

- (IBAction)btn_alert_click:(id)sender
{
    if ([sender tag] == 2)
    {
        [self setData];
        [self performDismissalAnimation];
        return;
    }
    
    NSString *stime = [NSString stringWithFormat:@"%@ 00:00:00",self.lb_curr_data.text];
    NSDate *date = [NSDate dateFromString:stime];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString *stimeString = [NSString stringWithFormat:@"%0.0f",a];
    if ([stimeString integerValue] == 0)
    {
        lb_error.text = @"本次保养时间格式不正确!";
        return;
    }
    
    else if ([tf_curr_mileage.text length] == 0)
    {
        lb_error.text = @"当前里程没有设置!";
        return;
    }
    
    else if ([tf_mileage_spacing.text length] == 0)
    {
        lb_error.text = @"保养间隔里程没有设置!";
        return;
    }
    else if ([lb_maintain_spacing.text length] == 0)
    {
        lb_error.text = @"保养间隔没有选择!";
        return;
    }
    
    curr_mileage = tf_curr_mileage.text;
    mileage_spacing  = tf_mileage_spacing.text;
    maintain_data = stimeString;
    if (is_baoyang_notice)
    {
        maintain_tag = @"1";
    }
    else
    {
        maintain_tag = @"2";
    }
    
    [self saveData];
    [self performDismissalAnimation];

}

- (IBAction)btn_select_click:(id)sender
{
    if (2 == [sender tag])
    {
        [self action];
        return;
    }
    [active_textField resignFirstResponder];
    [self showPicker];
}

- (IBAction)btn_cancel_click:(id)sender
{
    [self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
}


- (void)btn_certain_tmp_click:(id)sender
{
    [self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if (actionSheet.tag == 51)
    {
        lb_curr_data.text  =[formatter stringFromDate:datePicker.date];
        [active_textField resignFirstResponder];
    }
    
    if (actionSheet.tag == 52)
    {
        tf_time.text  =[formatter stringFromDate:datePicker.date];
    }
    
    if (actionSheet.tag == 53)
    {
        tf_buytime.text  =[formatter stringFromDate:datePicker.date];
        NSUInteger  secendPerYear = 31536000;
        NSString *timeString = [self getTimeStringWithDate:datePicker.date];
        NSUInteger  secend_spacing = [[self getCurrentTime] integerValue] - [timeString integerValue];
        //6年以内每2年检验1次
        if (secend_spacing <= 189216000)
        {
            switch (secend_spacing / secendPerYear)
            {
                case 0:
                case 1:
                    nextCheckDate = [timeString integerValue] + secendPerYear*2;
                    break;
                case 2:
                case 3:
                    nextCheckDate = [timeString integerValue] + secendPerYear*4;
                    break;
                case 4:
                case 5:
                    nextCheckDate = [timeString integerValue] + secendPerYear*6;
                    break;
                default:
                    break;
            }
        }
        //超过6年，每年检验1次
        else if (secend_spacing > 189216000  && secend_spacing <= 473040000)
        {
            nextCheckDate = [timeString integerValue] + secendPerYear*((secend_spacing / secendPerYear) + 1);
        }
        
        //超过15年，每年检验2次
        else if ( secend_spacing > 473040000)
        {
            nextCheckDate = [timeString integerValue] + (secendPerYear / 2)*((secend_spacing / (secendPerYear/2)) + 1);
        }
        
        NSString *spost_date = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nextCheckDate]];
        lb_next_time.text = spost_date;
    }
}

- (IBAction)btn_certain_click:(id)sender
{
	UIPickerView *picker_View = (UIPickerView *)[actionSheet viewWithTag:102];
    
    switch ([picker_View selectedRowInComponent:0])
    {
        case 0:
            tf_company.text = @"太平洋车险";
            insurance_company = @"太平洋车险";
            break;
        case 1:
            tf_company.text = @"太平车险";
            insurance_company = @"太平车险";

            break;
        case 2:
            tf_company.text = @"平安车险";
            insurance_company = @"平安车险";

            break;
        case 3:
            tf_company.text = @"中华联合车险";
            insurance_company = @"中华联合车险";

            break;
        case 4:
            tf_company.text = @"大地车险";
            insurance_company = @"大地车险";

            break;
        case 5:
            tf_company.text = @"天安车险";
            insurance_company = @"天安车险";

            break;
        case 6:
            tf_company.text = @"永安车险";
            insurance_company = @"永安车险";

            break;
        case 7:
            tf_company.text = @"阳光车险";
            insurance_company = @"阳光车险";

            break;
        case 8:
            tf_company.text = @"安邦车险";
            insurance_company = @"安邦车险";

            break;
        case 9:
            [tf_company becomeFirstResponder];
            break;
        default:
            break;
    }

	[self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
    
    
}

- (void) action
{
	NSString *title =  @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	actionSheet.tag = 103;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
	UIPickerView *picker_View = [[UIPickerView alloc] init];
	picker_View.frame = CGRectMake(20.0f,50.0f, 280.0f, 216.0f);
	picker_View.tag = 102;
	picker_View.delegate = self;
	picker_View.dataSource = self;
	picker_View.showsSelectionIndicator = YES;
	[actionSheet addSubview:picker_View];
	[actionSheet addSubview:tool_bar];
}

- (void)showPicker
{
    self.pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
     
    [alertWindow addSubview:self.pickerView];
    keyboardHeight = pickerView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(0, self.view.frame.size.height - self.pickerView.frame.size.height + 80.0f, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
    }];
    [self reposition];

}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.pickerView.frame = CGRectMake(0, self.pickerView.frame.origin.y+self.pickerView.frame.size.height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self.pickerView removeFromSuperview];
                         
                     }];
    
    if (1 == type)
    {
        keyboardHeight = 0;
        [self reposition];
    }
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

- (NSString *)getTimeStringWithDate:(NSDate *)date
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:date];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval b =[theDate timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",b];
    return timeString;
}

- (void)addBaoYangView
{
    baoyang_view.frame = CGRectMake(0.0f, 35.0f, baoyang_view.frame.size.width, baoyang_view.frame.size.height);
    [self.view addSubview: baoyang_view];
}

- (void)addBaoXianView
{
    baoxian_view.frame = CGRectMake(0.0f, 35.0f, baoxian_view.frame.size.width, baoxian_view.frame.size.height);
    [self.view addSubview: baoxian_view];
}

- (void)addNianjianView
{
    nianjian_view.frame = CGRectMake(0.0f, 35.0f, nianjian_view.frame.size.width, nianjian_view.frame.size.height) ;
    [self.view addSubview: nianjian_view];
}

- (void)addChaosuView
{
    chaosu_view.frame = CGRectMake(0.0f, 35.0f, chaosu_view.frame.size.width, chaosu_view.frame.size.height);
    [self.view addSubview: chaosu_view];
}
- (void)showDatePicker
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n\n" ;
    actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    actionSheet.tag = 50 + type;
    switch (type)
    {
        case 1:
            btn_title.title = @"选择本次保养时间";
            break;
        case 2:
            btn_title.title = @"选择保险到期时间";
            break;
        case 3:
            btn_title.title = @"选择购车时间";
            break;

        default:
            break;
    }
    [actionSheet showInView:self.view.window];
    UIDatePicker *datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f,44.0f,320.0f, 200.0f)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"LocaleIdentifier", @"")];
    datePicker.tag = 101;
    datePicker.datePickerMode = 1;
    [actionSheet addSubview:datePicker];
    [actionSheet addSubview:tool_bar_tmp];

}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)ActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
 }


#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 10;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (2 == type)
    {
        return;
    }
    switch (row)
    {
        case 0:
            lb_maintain_spacing.text = @"3个月";
            maintain_spacing = @"3";
            break;
        case 1:
            lb_maintain_spacing.text = @"4个月";
            maintain_spacing = @"4";
            break;
        case 2:
            lb_maintain_spacing.text = @"5个月";
            maintain_spacing = @"5";
            break;
        case 3:
            lb_maintain_spacing.text = @"6个月";
            maintain_spacing = @"6";
            break;
        case 4:
            lb_maintain_spacing.text = @"7个月";
            maintain_spacing = @"7";
            break;
        case 5:
            lb_maintain_spacing.text = @"8个月";
            maintain_spacing = @"8";
            break;
        case 6:
            lb_maintain_spacing.text = @"9个月";
            maintain_spacing = @"9";
            break;
        case 7:
            lb_maintain_spacing.text = @"10个月";
            maintain_spacing = @"10";
            break;
        case 8:
            lb_maintain_spacing.text = @"11个月";
            maintain_spacing = @"11";
            break;
        case 9:
            lb_maintain_spacing.text = @"12个月";
            maintain_spacing = @"12";
            break;
        default:
            break;
    }
    [self cancelPicker];
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (1 == type)
    {
        switch (row)
        {
            case 0:
                return @"3个月";
                break;
            case 1:
                return @"4个月";
                break;
            case 2:
                return @"5个月";
                break;
            case 3:
                return @"6个月";
                break;
            case 4:
                return @"7个月";
                break;
            case 5:
                return @"8个月";
                break;
            case 6:
                return @"9个月";
                break;
            case 7:
                return @"10个月";
                break;
            case 8:
                return @"11个月";
                break;
            case 9:
                return @"12个月";
                break;
            default:
                break;
        }
    }
    else if (2 == type)
    {
        switch (row)
        {
            case 0:
                return @"太平洋车险";
                break;
            case 1:
                return @"太平车险";
                break;
            case 2:
                return @"平安车险";
                break;
            case 3:
                return @"中华联合车险";
                break;
            case 4:
                return @"大地车险";
                break;
            case 5:
                return @"天安车险";
                break;
            case 6:
                return @"永安车险";
                break;
            case 7:
                return @"阳光车险";
                break;
            case 8:
                return @"安邦车险";
                break;
            case 9:
                return @"其他车险";
                break;
            default:
                break;
        }

    }
	return @"";
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (type == 1)
    {
        if ([tf_curr_mileage isFirstResponder])
        {
            [tf_mileage_spacing becomeFirstResponder];
        }
        
        else if ([tf_mileage_spacing isFirstResponder])
        {
            [textField resignFirstResponder];
            [self showDatePicker ];
        }
        
     }
    
    else if (2 == type)
    {
        if ([tf_company isFirstResponder])
        {
            [textField resignFirstResponder];
            [self showDatePicker ];
        }
        
    }
    
    else if (3 == type || 4 == type)
    {
        [textField resignFirstResponder];
    }

	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (type == 0)
    {
        lb_error.text = @"";
    }
    
    if ([tf_time isFirstResponder])
    {
        [textField resignFirstResponder];
        [self showDatePicker];
    }
    
    if ([tf_buytime isFirstResponder])
    {
        [textField resignFirstResponder];
        [self showDatePicker];
    }

    active_textField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] == 0)
    {
        return;
    }
    
}


#pragma mark -
#pragma mark Local Notifications
- (void)removeLocalNotifyWithIndex:(NSUInteger)row
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if (0 < [oldNotifications count])
    {
        for (UILocalNotification *notification in oldNotifications)
        {
            if (((NSNumber *)[notification.userInfo objectForKey:@"type"]).integerValue == row)
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
    
}
- (void)scheduleAlarmForBody:(NSDictionary *)usrInfo
{
    RRToken *token = [RRToken getInstance];
    if ([[usrInfo objectForKey:@"type"] integerValue] == 1)
    {
        if (!is_change && [[token getProperty:@"is_baoyang_notice_change"] integerValue])
        {
            return;
        }
    }
    else if ([[usrInfo objectForKey:@"type"] integerValue] == 2)
    {
        if (!is_change && [[token getProperty:@"is_baoxian_notice_change"] integerValue])
        {
            return;
        }
    }
   else if ([[usrInfo objectForKey:@"type"] integerValue] == 3)
    {
        if (!is_change && [[token getProperty:@"is_nianjian_notice_change"] integerValue])
        {
            return;
        }
    }

	UIApplication *app = [UIApplication sharedApplication];
	NSArray *oldNotifications = [app scheduledLocalNotifications];
	// Clear out the old notification before scheduling a new one.
	if (0 < [oldNotifications count])
    {
        for (UILocalNotification *notification in oldNotifications)
        {
            //[[UIApplication sharedApplication] cancelLocalNotification:notification];
            if (((NSNumber *)[notification.userInfo objectForKey:@"type"]).integerValue == [[usrInfo objectForKey:@"type"] integerValue])
            {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
            }
        }
	}
	
	// Create a new notification
	UILocalNotification *alarm = [[UILocalNotification alloc] init];
	if (alarm)
    {
		alarm.fireDate = [NSDate dateWithTimeIntervalSince1970:[[usrInfo objectForKey:@"date"] doubleValue]];
		alarm.timeZone = [NSTimeZone defaultTimeZone];
		alarm.repeatInterval = NSWeekCalendarUnit;
		alarm.soundName = @"ping.caf";
		alarm.alertBody = [usrInfo objectForKey:@"msg"],
        alarm.userInfo = usrInfo;
        alarm.applicationIconBadgeNumber = 1;
		[app scheduleLocalNotification:alarm];
	}
}

#pragma mark check token

- (void) checkTokenSuccess
{
    im_baoyang_bg.image = [UIImage imageNamed:@"service_bg_highlight.png"];
    [self addBaoYangView];
    type = 1;
    btn_baoyang_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
    [self loadData];
}

- (void) alertViewDidCancel
{
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
    
}

- (void) popToViewController
{
	[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)loadData
{
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, NOTICE_MSG_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadData:)];
	[loader loadwithTimer];
    
}

- (void)onLoadData:(NSNotification *)nofify
{
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[nofify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	if (![[json objectForKey:@"success"] boolValue])
	{
        [RWShowView closeAlert];

        if ([[json objectForKey:@"errcode"] integerValue] == 601)
        {
            [self setAlertView];
            return;
        }
        
        [RWAlertView show:@"网络链接失败!" ];
        [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
 		return;
	}
    
    serv_data = [json objectForKey:@"data"];
    [self setData];

}

- (void)onLoadFail:(NSNotification *)notify
{
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
}

- (void)saveData
{
    [RWShowView show:@"loading"];
    is_change = YES;
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, NOTICE_MSG_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    
    if (insurance_company)
    {
        [req setParam:insurance_company forKey:@"insurance_company"];
        
    }
    if (insurance_date)
    {
        [req setParam:insurance_date forKey:@"insurance_date"];
        
    }
    if (insurance_tag)
    {
        [req setParam:insurance_tag forKey:@"insurance_tag"];
        
    }
    if (check_date)
    {
        [req setParam:check_date forKey:@"check_date"];
        
    }
    if (check_tag)
    {
        [req setParam:check_tag forKey:@"check_tag"];
        
    }
    if (check_date)
    {
        [req setParam:check_date forKey:@"check_date"];
        
    }
    if (hypervelocity)
    {
        [req setParam:hypervelocity forKey:@"hypervelocity"];
        
    }
    if (hypervelocity_tag)
    {
        [req setParam:hypervelocity_tag forKey:@"hypervelocity_tag"];
        
    }
    if (curr_mileage)
    {
        [req setParam:curr_mileage forKey:@"curr_mileage"];
        
    }
    if (mileage_spacing)
    {
        [req setParam:mileage_spacing forKey:@"mileage_spacing"];
        
    }
    if (maintain_data)
    {
        [req setParam:maintain_data forKey:@"maintain_data"];
        
    }
    if (maintain_spacing)
    {
        [req setParam:maintain_spacing forKey:@"maintain_spacing"];
        
    }
    if (maintain_tag)
    {
        [req setParam:maintain_tag forKey:@"maintain_tag"];
        
    }
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSaveData:)];
	[loader loadwithTimer];
    
}

- (void)onSaveData:(NSNotification *)notify
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
    
    [RWAlertView show:@"保存成功!"];
    [self loadData];
}

- (void)setData
{
    if ([serv_data objectForKey:@"curr_mileage"])
    {
        curr_mileage = [serv_data objectForKey:@"curr_mileage"];
        lb_current_mile.text = [NSString stringWithFormat:@"%@KM",curr_mileage ];
    }
    
    if ([serv_data objectForKey:@"mileage_spacing"])
    {
        mileage_spacing = [serv_data objectForKey:@"mileage_spacing"];
        lb_next_mile.text = [NSString stringWithFormat:@"%dKM",[curr_mileage integerValue] + [mileage_spacing integerValue]];
    }
    
    if ([serv_data objectForKey:@"maintain_data"])
    {
        maintain_data = [serv_data objectForKey:@"maintain_data"];
        maintain_spacing = [serv_data objectForKey:@"maintain_spacing"];
        maintain_data = [NSString stringWithFormat:@"%d",[maintain_data integerValue] + [maintain_spacing integerValue]*2592000];
        NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
        [date_formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[maintain_data doubleValue]]];
        lb_baoyang_time.text = post_date;
    }
    
    if ([serv_data objectForKey:@"maintain_tag"])
    {
        maintain_tag = [serv_data objectForKey:@"maintain_tag"];
        if ([maintain_tag integerValue] == 2)
        {
            btn_baoyang_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            is_baoyang_notice = NO;
            [self removeLocalNotifyWithIndex:1];
        }
        else if ([maintain_tag integerValue] == 1)
        {
            btn_baoyang_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];
            is_baoyang_notice = YES;
            
            if (maintain_data)
            {
                maintain_data = [NSString stringWithFormat:@"%d",[maintain_data integerValue] - 7*24*3600];
                NSDictionary *maintain_dic = @{@"date" : maintain_data,@"type":@"1",@"msg":[NSString stringWithFormat:@"您爱车的下次保养时间为%@,请及时保养!",lb_baoyang_time.text],@"title":@"保养提醒",@"fireDate":[serv_data objectForKey:@"maintain_data"]};
                [self scheduleAlarmForBody:maintain_dic];
            }
        }
     }
    
    if ([serv_data objectForKey:@"insurance_company"] && (NSNull *)[serv_data objectForKey:@"insurance_company"] != [NSNull null])
    {
        insurance_company = [serv_data objectForKey:@"insurance_company"];
        tf_company.text = insurance_company;
    }
    
    if ([serv_data objectForKey:@"insurance_date"] && (NSNull *)[serv_data objectForKey:@"insurance_date"] != [NSNull null])
    {
        insurance_date = [serv_data objectForKey:@"insurance_date"];
        NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
        [date_formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[insurance_date doubleValue]]];
        tf_time.text = post_date;
    }
    
    if ([serv_data objectForKey:@"insurance_tag"])
    {
        insurance_tag = [serv_data objectForKey:@"insurance_tag"];
        
        if ([insurance_tag integerValue] == 2)
        {
            btn_baoxian_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            is_baoxian_notice = NO;
            [self removeLocalNotifyWithIndex:2];
        }
        else if ([insurance_tag integerValue] == 1)
        {
            btn_baoxian_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];
            is_baoxian_notice = YES;
            
            insurance_date = [NSString stringWithFormat:@"%d",[insurance_date integerValue] - 2*30*24*3600];
            NSDictionary *insurance_dic = @{@"date" : insurance_date,@"type":@"2",@"msg":[NSString stringWithFormat:@"您的保险将于%@到期,请及时续费!",tf_time.text],@"title":@"保险提醒",@"fireDate":[serv_data objectForKey:@"insurance_date"]};
            [self scheduleAlarmForBody:insurance_dic];

        }
    }
    
    if ([serv_data objectForKey:@"check_date"] && (NSNull *)[serv_data objectForKey:@"check_date"] != [NSNull null])
    {
        check_date = [serv_data objectForKey:@"check_date"];
        NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
        [date_formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[check_date doubleValue]]];
        tf_buytime.text = post_date;
        
        NSUInteger  secendPerYear = 31536000;
        NSUInteger  secend_spacing = [[self getCurrentTime] integerValue] - [check_date integerValue];
        //6年以内每2年检验1次
        if (secend_spacing <= 189216000)
        {
            switch (secend_spacing / secendPerYear)
            {
                case 0:
                case 1:
                    nextCheckDate = [check_date integerValue] + secendPerYear*2;
                    break;
                case 2:
                case 3:
                    nextCheckDate = [check_date integerValue] + secendPerYear*4;
                    break;
                case 4:
                case 5:
                    nextCheckDate = [check_date integerValue] + secendPerYear*6;
                    break;
                default:
                    break;
            }
        }
        //超过6年，每年检验1次
        else if (secend_spacing > 189216000  && secend_spacing <= 473040000)
        {
            nextCheckDate = [check_date integerValue] + secendPerYear*((secend_spacing / secendPerYear) + 1);
        }

        //超过15年，每年检验2次
        else if ( secend_spacing > 473040000)
        {
            nextCheckDate = [check_date integerValue] + (secendPerYear / 2)*((secend_spacing / (secendPerYear/2)) + 1);
        }
        
        NSString *spost_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:nextCheckDate]];
        lb_next_time.text = spost_date;

    }
    
    if ([serv_data objectForKey:@"check_tag"])
    {
        check_tag = [serv_data objectForKey:@"check_tag"];
        
        if ([check_tag integerValue] == 2)
        {
            btn_nianjian_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            is_nianjian_notice = NO;
            [self removeLocalNotifyWithIndex:3];
        }
        else if ([check_tag integerValue] == 1)
        {
            btn_nianjian_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];
            is_nianjian_notice = YES;
            nextCheckDate = nextCheckDate - 2*30*24*3600;
            NSDictionary *insurance_dic = @{@"date" : [NSString stringWithFormat:@"%d",nextCheckDate ],@"type":@"3",@"msg":[NSString stringWithFormat:@"您的爱车下次年检时间为%@,请及时年检!",lb_next_time.text],@"title":@"年检提醒",@"fireDate":[NSString stringWithFormat:@"%d",nextCheckDate + 2*30*24*3600]};
            [self scheduleAlarmForBody:insurance_dic];

        }
    }
    
    if ([serv_data objectForKey:@"hypervelocity_tag"])
    {
        hypervelocity_tag = [serv_data objectForKey:@"hypervelocity_tag"];
        
        if ([hypervelocity_tag integerValue] == 2)
        {
            btn_chaosu_gouxuan_bg.image = [UIImage imageNamed:@"custom-weixuan.png"];
            is_chaosu_notice = NO;
        }
        else if ([check_tag integerValue] == 1)
        {
            btn_chaosu_gouxuan_bg.image = [UIImage imageNamed:@"custom-gouxuan.png"];
            is_chaosu_notice = YES;
        }
    }

    if ([serv_data objectForKey:@"hypervelocity"] && (NSNull *)[serv_data objectForKey:@"hypervelocity"] != [NSNull null])
    {
        hypervelocity = [serv_data objectForKey:@"hypervelocity"];
        tf_speed.text = hypervelocity;
    }

}


- (void)setAlertView
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChanged:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameChanged:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if (curr_mileage)
    {
        tf_curr_mileage.text = curr_mileage;
    }
    if (!mileage_spacing)
    {
        tf_mileage_spacing.text = @"5000";
    }
    else
    {
        tf_mileage_spacing.text = mileage_spacing;
    }
    
    if (!maintain_spacing)
    {
        lb_maintain_spacing.text = @"3个月";
        maintain_spacing = @"3";
    }
    else
    {
        lb_maintain_spacing.text = [NSString stringWithFormat:@"%@个月",maintain_spacing ];

    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:date];
    maintain_data = [self getCurrentTime];
    lb_curr_data.text = curTime;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
	alertWindow = [[UIWindow alloc] initWithFrame:screenBounds];
	alertWindow.windowLevel = UIWindowLevelAlert;
	previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
	[alertWindow makeKeyAndVisible];
    
    UIImageView *dimView = [[UIImageView alloc] initWithFrame:alertWindow.bounds];
	dimView.image = [self backgroundGradientImageWithSize:alertWindow.bounds.size];
	dimView.userInteractionEnabled = YES;
	
	[alertWindow addSubview:dimView];
	[dimView addSubview:self.alert_view];
    
    if (isRetina)
    {
        self.btn_select.frame = CGRectMake(237,227,37,37);
    }
    
    lb_curr_data.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDatePicker)];
    [lb_curr_data addGestureRecognizer:singleTap];
    [self performPresentationAnimation];
}

- (void)performPresentationAnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.3;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.01],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    [self.alert_view.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    
    // While the alert view pops in, the background overlay fades in
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animation];
    fadeInAnimation.duration = 0.3;
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1];
    [self.view.layer addAnimation:fadeInAnimation forKey:@"opacity"];
    [self reposition];

}

- (void)performDismissalAnimation
{
    keyboardHeight = 0.0f;
	// This block is called at the completion of the dismissal animations.
	AHAnimationCompletionBlock completionBlock = ^(BOOL finished)
	{
		// Remove relevant views.
		[self.alert_view.superview removeFromSuperview];
		[self.alert_view removeFromSuperview];
        
		// Restore previous key window and tear down our own window
		[previousKeyWindow makeKeyWindow];
		alertWindow = nil;
		previousKeyWindow = nil;
	};
		// This animation subtly fades out the alert view over a short period.
		[UIView animateWithDuration:0.25
							  delay:0.0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^
		 {
			 self.alert_view.superview.alpha = 0;
		 }
						 completion:completionBlock];
}

#pragma mark - Keyboard helpers

- (void)keyboardFrameChanged:(NSNotification *)notification
{
	// Toggle keyboard visibility flag based on which notification we're receiving.
	keyboardIsVisible = ![notification.name isEqualToString:UIKeyboardWillHideNotification];
    
	// Retrieve keyboard frame in screen space and transform it to window space.
	CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGRect transformedFrame = CGRectApplyAffineTransform(keyboardFrame, [self transformForCurrentOrientation]);
	keyboardHeight = transformedFrame.size.height;
    
	// If the keyboard will soon be invisible, zero-out the stored height.
	if(!keyboardIsVisible)
		keyboardHeight = 0.0;
    [self reposition];
}


- (CGAffineTransform)transformForCurrentOrientation
{
	// Calculate a rotation transform that matches the current interface orientation.
	CGAffineTransform transform = CGAffineTransformIdentity;
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if(orientation == UIInterfaceOrientationPortraitUpsideDown)
		transform = CGAffineTransformMakeRotation(M_PI);
	else if(orientation == UIInterfaceOrientationLandscapeLeft)
		transform = CGAffineTransformMakeRotation(-M_PI_2);
	else if(orientation == UIInterfaceOrientationLandscapeRight)
		transform = CGAffineTransformMakeRotation(M_PI_2);
	
	return transform;
}

- (void)reposition
{
	CGAffineTransform baseTransform = [self transformForCurrentOrientation];
    
	// This block contains all of the logic for how we position ourselves to account for the
	// presence of the keyboard and the current interface orientation.
	AHAnimationBlock layoutBlock = ^
	{
		self.alert_view.transform = baseTransform;
        
 		// Try to center ourselves in the space above the keyboard.
		CGPoint keyboardOffset = CGPointMake(0, -keyboardHeight);
		keyboardOffset = CGPointApplyAffineTransform(keyboardOffset, self.alert_view.transform);
		CGRect superviewBounds = self.alert_view.superview.bounds;
		superviewBounds.size.width += keyboardOffset.x;
		superviewBounds.size.height += keyboardOffset.y - 55;
		CGPoint newCenter = CGPointMake(superviewBounds.size.width * 0.5, superviewBounds.size.height * 0.5);
		self.alert_view.center = newCenter;
	};
    
	// Determine if the rotation we're about to undergo is 90 degrees or 180 degrees.
	CGFloat delta = CGAffineTransformGetAbsoluteRotationAngleDifference(self.alert_view.transform, baseTransform);
	const CGFloat HALF_PI = 1.581; // Don't use M_PI_2 here; precision errors will cause incorrect results below.
	BOOL isDoubleRotation = (delta > HALF_PI);
    
	// If we've layed out before, we should rotate to the new orientation.
	if(hasLayedOut)
	{
		// Use the system rotation duration.
		CGFloat duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];
        
		// Egregious hax. iPad lies about its rotation duration.
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			duration = 0.4;
        
		// Simply double the animation duration if we're rotating a full 180 degrees.
		if(isDoubleRotation)
			duration *= 2;
        
		[UIView animateWithDuration:duration animations:layoutBlock];
	}
	else
	{
		// We've never layed out before, so we should do it without animating, to prevent weird rotations.
		layoutBlock();
	}
    
	hasLayedOut = YES;
}

- (UIImage *)backgroundGradientImageWithSize:(CGSize)size
{
	CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
	CGFloat innerRadius = 0;
    CGFloat outerRadius = sqrtf(size.width * size.width + size.height * size.height) * 0.5;
    
	BOOL opaque = NO;
    UIGraphicsBeginImageContextWithOptions(size, opaque, [[UIScreen mainScreen] scale]);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    const size_t locationCount = 2;
    CGFloat locations[locationCount] = { 0.0, 1.0 };
    CGFloat components[locationCount * 4] = {
		0.0, 0.0, 0.0, 0.1, // More transparent black
		0.0, 0.0, 0.0, 0.7  // More opaque black
	};
	
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, locationCount);
	
    CGContextDrawRadialGradient(context, gradient, center, innerRadius, center, outerRadius, 0);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
	
    return image;
}



@end
