//
//  UsrProfileEditController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-12.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "UsrProfileEditController.h"
#import "RoadRover.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "RRToken.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "RRLoader.h"
#import "RWUsrEditCell.h"
#import "RegexKitLite.h"
#import "NSDate+Helper.h"
#import "UsrChangePassViewController.h"

static CGFloat INTRODUCE_FONT_SIZE = 15.0f;

@implementation UsrProfileEditController
@synthesize dict;

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
    
    self.title = @"个人设置";
    
    btn_save = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_save_click:)];
    self.navigationItem.rightBarButtonItem = btn_save;
    
    btn_back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_back_click:)];
    self.navigationItem.leftBarButtonItem = btn_back;
    
    btn_save.enabled = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIImage *avatar_im = [RRImageBuffer readFromFile:[NSString stringWithFormat:@"%@%@",BASE_URL,[dict objectForKey:@"iconimg"] ]];
	if (avatar_im)
	{
		im_avatar = avatar_im;
	}
    else
    {
        im_avatar = [UIImage imageNamed:@"avatar.png"];
    }
	
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_view.png"]]];
    
    btn_certain = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btn_certain_click:)];
    btn_cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
    btn_title = [[UIBarButtonItem alloc]initWithTitle:@"选择购买日期" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *arr = @[btn_cancel,flex,btn_title,flex,btn_certain];
    tool_bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    tool_bar.barStyle = UIBarStyleBlack;
    tool_bar.translucent = YES;
    [tool_bar setItems:arr animated:NO];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [RWAlertView closeAlert];
    [RWShowView closeAlert];
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
    dict = nil;
    im_xingbie = nil;
    btn_xingbie = nil;
    tf_usr = nil;
    tf_car = nil;
    active_field = nil;
    btn_save = nil;
    btn_back = nil;
    im_avatar = nil;
    btn_gg = nil;
	btn_mm = nil;
	iv_man = nil;
	iv_woman = nil;
    lb_gg = nil;
    lb_mm = nil;
    data_avatar = nil;
    actionSheet = nil;
    tool_bar = nil;
    btn_certain = nil;
    btn_cancel = nil;
    btn_title = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(0 == section)
    {
        return 9;
    }
    
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:244.0f/255.0f alpha:1.0f];;
    UIFont *font = [UIFont fontWithName:@"Arial" size:INTRODUCE_FONT_SIZE];

 	if (0 == indexPath.section)
	{
        if (0 == indexPath.row)
        {
            static NSString *CellIdentifier = @"RWUsrEditCell";
            RWUsrEditCell *cell_1 = (RWUsrEditCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (nil == cell_1)
            {
                UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
                
                cell_1 = (RWUsrEditCell *)uc.view;
                [cell_1 setAvatar:im_avatar];
            }
            
            cell_1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell_1.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell_1;
            
        }
        else if (1 == indexPath.row)
        {
            CellIdentifier = @"pass_cell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.font = font;
            cell.textLabel.text = @"修改密码";
            return cell;

        }
        
        else if (2 == indexPath.row)
        {
            UITableViewCell *cell_3 = [tableView dequeueReusableCellWithIdentifier:@"cell_3"];
            if (cell_3 == nil)
            {
                cell_3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_3"];
            }
            
            
            cell_3.textLabel.text = @"性别";
            cell_3.textLabel.font = font;
            btn_gg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn_gg.frame = CGRectMake(70.0f, 7.0f, 28.0f, 28.0f);
            [btn_gg addTarget:self action:@selector(btn_gg_click:) forControlEvents:UIControlEventTouchUpInside];
            [cell_3 addSubview:btn_gg];
            if (iv_man)
            {
                [iv_man removeFromSuperview];
            }
            iv_man = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 28.0f, 28.0f)];
            if ([[dict objectForKey:@"gender"]integerValue] == 1)
            {
                iv_man.image = [UIImage imageNamed:@"profile_select.png"];
            }
            
            else
            {
                iv_man.image = [UIImage imageNamed:@"profile_unselect.png"];
            }
            
            [btn_gg addSubview:iv_man];
            
            if (lb_gg)
            {
                [lb_gg removeFromSuperview];
            }
            lb_gg =[[UILabel alloc] initWithFrame:CGRectMake(110.0f, 0.0f, 30.0f, 44.0f)];
            lb_gg.text = @"男";
            lb_gg.textColor = [UIColor darkGrayColor];
            lb_gg.font = font;
            lb_gg.textAlignment = UITextAlignmentLeft;
            lb_gg.backgroundColor = [UIColor clearColor];
            [cell_3 addSubview:lb_gg];
            
            btn_mm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn_mm.frame = CGRectMake(200.0f, 7.0f, 28.0f, 28.0f);
            [btn_mm addTarget:self action:@selector(btn_mm_click:) forControlEvents:UIControlEventTouchUpInside];
            [cell_3 addSubview:btn_mm];
            
            if (iv_woman)
            {
                [iv_woman removeFromSuperview];
            }
            iv_woman = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 28.0f, 28.0f)];
            if ([[dict objectForKey:@"gender"]integerValue] == 2)
            {
                iv_woman.image = [UIImage imageNamed:@"profile_select.png"];
            }
            
            else
            {
                iv_woman.image = [UIImage imageNamed:@"profile_unselect.png"];
            }
            
            [btn_mm addSubview:iv_woman];
            
            if (lb_mm)
            {
                [lb_mm removeFromSuperview];
            }
            
            lb_mm =[[UILabel alloc] initWithFrame:CGRectMake(240.0f, 0.0f, 30.0f, 44.0f)];
            lb_mm.text = @"女";
            lb_mm.textColor = [UIColor darkGrayColor];
            lb_mm.font = font;
            lb_mm.textAlignment = UITextAlignmentLeft;
            lb_mm.backgroundColor = [UIColor clearColor];
            [cell_3 addSubview:lb_mm];
            cell_3.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell_3;
        }

        else 
        {
            CellIdentifier = [NSString stringWithFormat:@"usr_cell%d", [indexPath row]];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIFont *font = [UIFont fontWithName:@"Arial" size:INTRODUCE_FONT_SIZE];
            cell.detailTextLabel.font = font;
            
            NSString *name_txt = nil;
            NSString *content_txt = nil;
            
            switch (indexPath.row)
            {
                case 3:
                    name_txt = @"昵称";
                    content_txt = [dict objectForKey:@"nickname"];
                    break;
                case 4:
                    name_txt = @"姓名";
                    content_txt = [dict objectForKey:@"name"];
                    break;
                case 5:
                    name_txt = @"手机";
                    content_txt = [dict objectForKey:@"telnumber"];
                    break;
                case 6:
                    name_txt = @"邮箱";
                    content_txt = [dict objectForKey:@"email"];
                    
                    break;
                case 7:
                {
                    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
                    [date_formatter setDateFormat:@"yyyy-MM-dd"];
                     NSString *post_date = nil;
                    if ([[dict objectForKey:@"birthday"] length] && (NSNull *)[dict objectForKey:@"birthday"] != [NSNull null])
                    {
                        post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"birthday"] doubleValue]]];
                    }
                    content_txt = post_date;
                    name_txt = @"出生日期";
                    break;
                }
                case 8:
                    name_txt = @"住址";
                    content_txt = [dict objectForKey:@"address"];
                    break;
                default:
                    break;
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@:",name_txt];
            cell.textLabel.textColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
            CGSize containt_size = CGSizeMake(180.0f, 33.0f);
            CGSize content_frm_size = [cell.textLabel.text sizeWithFont:font
                                                      constrainedToSize:containt_size
                                                          lineBreakMode:UILineBreakModeWordWrap];
            
            tf_usr = [[UITextField alloc] initWithFrame:CGRectMake(content_frm_size.width + 35.0f,12.0f, 250.0f - content_frm_size.width, 30.0f)];
            
            tf_usr.borderStyle =  UITextBorderStyleNone;
            
            tf_usr.textColor = [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
            tf_usr.textAlignment = UITextAlignmentLeft;
            tf_usr.font = [UIFont systemFontOfSize:15.0f];
            tf_usr.backgroundColor = [UIColor clearColor];
            tf_usr.delegate = self;
            tf_usr.returnKeyType =  UIReturnKeyDone;
            tf_usr.tag = indexPath.row*100 + 1;
            tf_car.clearsOnBeginEditing = YES;
            cell.tag = indexPath.row*100 + 3;
            
            if (!content_txt || (NSNull *)content_txt == [NSNull null])
            {
                if ([dict count]!= 0)
                {
                    tf_usr.text = @"未设置";
                }
                else
                {
                    tf_usr.text = @"";
                }
            }
            else
            {
                tf_usr.text = [NSString stringWithFormat:@"%@",content_txt];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell viewWithTag:indexPath.row*100 + 1])
            {
                [cell addSubview:tf_usr];
            }
            cell.textLabel.font = font;
            return  cell;
            
 		}
    }
	if (1 == indexPath.section)
	{
        if (0 == indexPath.row)
        {
            static NSString *cell_id = @"base_car_cell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:243.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"汽车信息";
            cell.tag = 1201;
             
            return cell;
        }
        else
        {
            CellIdentifier = [NSString stringWithFormat:@"car_cell%d", [indexPath row]];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIFont *font = [UIFont fontWithName:@"Arial" size:INTRODUCE_FONT_SIZE];
            cell.detailTextLabel.font = font;
            
            NSString *name_txt = nil;
            NSString *content_txt = nil;
            
            switch (indexPath.row)
            {
                case 1:
                    name_txt = @"车牌号";
                    content_txt = [dict objectForKey:@"vehicleno"];
                    break;
                case 2:
                    name_txt = @"品牌";
                    content_txt = [dict objectForKey:@"brand_name"];
                    break;
                case 3:
                    name_txt = @"排量";
                    content_txt = [dict objectForKey:@"arrangement"];
                    
                    break;
                case 4:
                    name_txt = @"设备号";
                    content_txt = [dict objectForKey:@"equid"];
                    
                    break;
                case 5:
                    name_txt = @"颜色";
                    content_txt = [dict objectForKey:@"color"];
                    
                    break;
                case 6:
                    name_txt = @"车架号";
                    content_txt = [dict objectForKey:@"vin"];
                    break;
                case 7:
                {
                    name_txt = @"购买日期";
                    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
                    [date_formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *post_date = nil;
                    if ([[dict objectForKey:@"buytime"] length] && (NSNull *)[dict objectForKey:@"buytime"] != [NSNull null])
                    {
                        post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"buytime"] doubleValue]]];
                    }
                    content_txt = post_date;
                    break;
                }
                default:
                    break;
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@:",name_txt];
            cell.textLabel.textColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
            CGSize containt_size = CGSizeMake(180.0f, 33.0f);
            CGSize content_frm_size = [cell.textLabel.text sizeWithFont:font
                                                      constrainedToSize:containt_size
                                                          lineBreakMode:UILineBreakModeWordWrap];
            
            tf_car = [[UITextField alloc] initWithFrame:CGRectMake(content_frm_size.width + 35.0f,12.0f, 250.0f - content_frm_size.width, 30.0f)];
            
            tf_car.borderStyle =  UITextBorderStyleNone;
            
            tf_car.textColor = [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
            tf_car.textAlignment = UITextAlignmentLeft;
            tf_car.font = [UIFont systemFontOfSize:15.0f];
            tf_car.backgroundColor = [UIColor clearColor];
            tf_car.delegate = self;
            tf_car.returnKeyType =  UIReturnKeyDone;
            tf_car.tag = indexPath.row*200 + 2;
            tf_car.clearsOnBeginEditing = YES;
            cell.tag = indexPath.row*200 + 3;

            if (!content_txt || (NSNull *)content_txt == [NSNull null])
            {
                if ([dict count]!= 0)
                {
                    tf_car.text = @"未设置";
                }
                else
                {
                    tf_car.text = @"";
                }
            }
            else
            {
                tf_car.text = [NSString stringWithFormat:@"%@",content_txt];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell viewWithTag:indexPath.row*200 + 2])
            {
                [cell addSubview:tf_car];
            }
            cell.textLabel.font = font;
            return  cell;
 		}
	}
    
    return  cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
 	if (0 == indexPath.row && 0 == indexPath.section)
	{
		UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
														delegate:self
											   cancelButtonTitle:@"取消"
										  destructiveButtonTitle:nil
											   otherButtonTitles:@"拍照", @"选取照片", nil];
		
		[as showInView:self.tableView];
        
	}
    
    if (1 == indexPath.row && 0 == indexPath.section)
    {
        UsrChangePassViewController *ctrl = [[UsrChangePassViewController alloc]initWithNibName:@"UsrChangePassViewController" bundle:nil];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)ActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (2 == buttonIndex || is_cancel)
    {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }

    else
    {
        UIImagePickerController *ctrl_img_picker = [[UIImagePickerController alloc] init];
        ctrl_img_picker.delegate = self;
        ctrl_img_picker.allowsEditing = NO;
        
        if (1 == buttonIndex)
        {
            ctrl_img_picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            ctrl_img_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            ctrl_img_picker.allowsEditing = YES;
            
        }
        else
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
            {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"无法使用相机。可能此机器没有配备照相设备。"
                                                            delegate:self
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
                [av show];
                return;
            }
            
            ctrl_img_picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            ctrl_img_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            ctrl_img_picker.allowsEditing = YES;
        }
        
        [self presentModalViewController:ctrl_img_picker animated:YES];

    }
	
}

#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 5.0)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	is_change = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	UIImage *img = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
	
	if (UIImagePickerControllerSourceTypeCamera == picker.sourceType)
	{
		UIImageWriteToSavedPhotosAlbum(img, nil, nil , nil);
	}
	
	CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
	CGFloat scale = 1.0f;
	
	if (rect.size.width > 54.0f || rect.size.height > 54.0f)
	{
		if (rect.size.width > rect.size.height)
		{
			scale = 54.0f / rect.size.width;
		}
		else
		{
			scale = 54.0f / rect.size.height;
		}
	}
	
	UIGraphicsBeginImageContext(rect.size);
	UIGraphicsBeginImageContextWithOptions(rect.size, YES, scale);
	[img drawInRect:rect];
	UIImage *new_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	if (im_avatar)
	{
		im_avatar = nil;
	}
    
	im_avatar = new_img;
	data_avatar = UIImageJPEGRepresentation(new_img, 0.5f);
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[self.tableView reloadData];
    
}

#pragma mark - event handle

- (void)btn_certain_click:(id)sender
{
    is_cancel = YES;
	[self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if (actionSheet.tag == 50 )
    {
        active_field.text = [formatter stringFromDate:datePicker.date];
        birthday_tmp = active_field.text;
    }
    
    else if (actionSheet.tag == 51)
    {
        active_field.text  =[formatter stringFromDate:datePicker.date];
        goumairiqi_tmp = active_field.text;
    }

}

- (void)btn_cancel_click:(id)sender
{
    is_cancel = YES;
    [self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];

}

- (void) setUserProfile:(NSDictionary *)data
{
	dict = [[NSMutableDictionary alloc] initWithDictionary:data];
}

- (void) btn_gg_click:(id)sender
{
	is_txt_change = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	sex =  @"1";
	[dict setObject:@"1" forKey:@"gender"];
	[self.tableView reloadData];
    
}

- (void) btn_mm_click:(id)sender
{
	is_txt_change = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
	sex = @"2";
	[dict setObject:@"2" forKey:@"gender"];
	[self.tableView reloadData];
    
}


- (void)saveData
{
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, USR_PROFILE_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    
    if (nickname)
    {
        [req setParam:nickname forKey:@"nickname"];

    }
    if (name)
    {
        [req setParam:name forKey:@"name"];
    }

    if (tel_num)
    {
        [req setParam:tel_num forKey:@"telnumber"];
        
    }
    if (email)
    {
        [req setParam:email forKey:@"email"];
        
    }
    if (birthday)
    {
        [req setParam:birthday forKey:@"birthday"];
        
    }
    if (address)
    {
        [req setParam:address forKey:@"address"];
        
    }
    if (chepai)
    {
        [req setParam:chepai forKey:@"vehicleno"];
        
    }
    if (pingpai)
    {
        [req setParam:pingpai forKey:@"brand_name"];
        
    }
    if (shebeihao)
    {
        [req setParam:shebeihao forKey:@"equid"];
        
    }
    if (yanse)
    {
        [req setParam:yanse forKey:@"color"];
        
    }
    if (chejiahao)
    {
        [req setParam:chejiahao forKey:@"vin"];
        
    }
    if (goumairiqi)
    {
        [req setParam:goumairiqi forKey:@"buytime"];
    }
    
    if (sex)
    {
        [req setParam:sex forKey:@"gender"];
    }
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSaveData:)];
	[loader loadwithTimer];

}

- (void)onSaveData:(NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        [RWShowView closeAlert];
        [RWAlertView show:@"网络链接失败!" ];
        [self performSelector:@selector(btn_back_click:) withObject:nil afterDelay:1.0f];
 		return;
	}
    
    if (!data_avatar)
    {
        [RWShowView closeAlert];
        [RWAlertView show:@"保存成功!" ];
    }
    else
    {
        [self saveAvatar];
    }
}

- (void)saveAvatar
{
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, CHANGE_ICON_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    if (data_avatar)
	{
		[req setData: data_avatar forKey:@"file"];
	}

 	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSaveAvatar:)];
	[loader loadwithTimer];

}

- (void)onSaveAvatar:(NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        [RWShowView closeAlert];
        [RWAlertView show:@"网络链接失败!" ];
        [self performSelector:@selector(btn_back_click:) withObject:nil afterDelay:1.0f];
 		return;
	}
    
    [RWShowView closeAlert];
    [RWAlertView show:@"保存成功!" ];
}

- (void)onFetchFail:(NSNotification *)notify
{
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
}

- (void)btn_save_click:(id)sender
{
 	if (nickname)
	{
		NSRange r;
		NSString *regEx = @"^\\w{2,16}$";
		r = [nickname rangeOfString:regEx options:NSRegularExpressionSearch];
		
		if (NSNotFound == r.location)
		{
			[RWAlertView show:@"昵称请控制在2~16个字符！"];
			
			return;
		}
	}
    
    if (email)
    {
        NSRange r;
        NSString *regEx = @"^\\w+[\\.\\w]*@\\w+(\\.\\w+)+$";
        r = [email rangeOfString:regEx options:NSRegularExpressionSearch];
        
        if (NSNotFound == r.location)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"邮箱格式不正确！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            
            [av show];
            
            return;
        }

    }
    
    if (birthday_tmp)
    {
         
        birthday = [self stringToTimeStamp:birthday_tmp];
        
        if (!birthday)
        {
            return;
        }
    }
    
    if (goumairiqi_tmp)
    {
        goumairiqi = [self stringToTimeStamp:goumairiqi_tmp];
        
        if (!goumairiqi)
        {
            return;
        }
    }

    if (!is_txt_change && is_change)
    {
        [self saveAvatar];
        return;
    }
    [self saveData];
}

- (void)btn_back_click:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)stringToTimeStamp:(NSString *)type
{
    NSString *birth_day = [NSString stringWithFormat:@"%@ 00:00:00",type];
    NSDate *date = [NSDate dateFromString:birth_day];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",a];

    if ([timeString integerValue] == 0)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"日期格式不正确！"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        
        [av show];
        return nil;
    }
    
    return timeString;
}

- (void)showDatePicker
{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n\n" ;
    actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if (is_birthday)
    {
        actionSheet.tag = 50;
        btn_title.title = @"选择生日";
    }
    else
    {
        actionSheet.tag = 51;
        btn_title.title = @"选择购买日期";

    }
    [actionSheet showInView:self.view.window];
    UIDatePicker *datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f,44.0f,320.0f, 200.0f)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"LocaleIdentifier", @"")];
    datePicker.tag = 101;
    datePicker.datePickerMode = 1;
    
    [actionSheet addSubview:datePicker];
    [actionSheet addSubview:tool_bar];
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	active_field = textField;
    is_txt_change = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    if ((textField.tag % 100 == 1 && textField.tag / 100 == 6) || (textField.tag % 100 == 2 && textField.tag / 100 == 14))
    {
        [textField resignFirstResponder];
        if (textField.tag % 100 == 1 && textField.tag / 100 == 6)
        {
            is_birthday = YES;
        }
        else
        {
            is_birthday = NO;
        }
        
        [self showDatePicker];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] == 0)
    {
        return;
    }
    
    if (textField.tag % 100 == 1)
    {
        switch (textField.tag / 100) {
            case 3:
                nickname = textField.text;
                break;
            case 4:
                name = textField.text;
                break;
            case 5:
                tel_num = textField.text;
                break;
            case 6:
                email = textField.text;
                break;
            case 7:
                birthday = textField.text;
                break;
            case 8:
                address = textField.text;
                break;
            default:
                break;
        }
    }
    
    else if (textField.tag % 100 == 2)
    {
        switch (textField.tag / 100) {
            case 2:
                chepai = textField.text;
                break;
            case 4:
                pingpai = textField.text;
                break;
            case 6:
                pailiang = textField.text;
                break;
            case 8:
                shebeihao = textField.text;
                break;
            case 10:
                yanse = textField.text;
                break;
            case 12:
                chejiahao = textField.text;
                break;
            case 14:
                goumairiqi = textField.text;
                break;
            default:
                break;
        }
    }
}

@end
