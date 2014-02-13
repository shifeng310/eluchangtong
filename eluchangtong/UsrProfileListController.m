//
//  UsrProfileListController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-12.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "UsrProfileListController.h"
#import "RoadRover.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRImageBuffer.h"
#import "RRImageLoader.h"
#import "RRRemoteImage.h"
#import "RRLoader.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "NavController.h"
#import "UsrProfileEditController.h"

static CGFloat INTRODUCE_FONT_SIZE = 15.0f;

@implementation UsrProfileListController
@synthesize head_view;
@synthesize im_avatar;
@synthesize lb_district;
@synthesize lb_name;
@synthesize lb_server_no;
@synthesize btn_change;

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
    is_usr_fold = YES;
    is_car_fold = YES;
    is_app_fold = NO;
    btn_back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_back_click:)];
    self.navigationItem.leftBarButtonItem = btn_back;
    
    btn_edit = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_edit_click:)];
    self.navigationItem.rightBarButtonItem = btn_edit;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_view.png"]]];
    
    self.tableView.contentInset = UIEdgeInsetsMake(90.0f, 0.0f, 0.0f, 0.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        head_view = nil;
        im_avatar = nil;
        lb_district = nil;
        lb_name = nil;
        lb_server_no = nil;
        btn_change = nil;
    }
}

- (void)dealloc
{
    head_view = nil;
    im_avatar = nil;
    lb_name = nil;
    lb_server_no = nil;
    lb_district = nil;
    btn_change = nil;
    btn_edit = nil;
    btn_back = nil;
    btn_fold = nil;
    im_fold = nil;
    buffer = nil;
    dict = nil;
    iv_usr_bg = nil;
    iv_car_bg = nil;
    lb_car_detail = nil;
    lb_usr_detail = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele checkToken];
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && !is_loading && !is_usr_fold)
    {
        return 8;
    }
    
    else if(section == 0 && (is_loading || is_usr_fold))
    {
        return 1;
    }
    
    else if (section == 1 && !is_loading && !is_car_fold)
    {
        return 8;
    }
    
    else if (section == 1 && (is_loading || is_car_fold ))
    {
        return 1;
    }

    else if (section == 2 && !is_loading && !is_app_fold)
    {
        return 4;
    }
    
    else if (section == 2 && (is_loading || is_app_fold ))
    {
        return 1;
    }

    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:244.0f/255.0f alpha:1.0f];;
    
 	if (0 == indexPath.section)
	{
        if (0 == indexPath.row)
        {
            static NSString *cell_id = @"base_msg_cell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:243.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"基本资料";
            cell.tag = 1200;
            if ([cell viewWithTag:1000])
            {
                [[cell viewWithTag:1000] removeFromSuperview];
            }
            btn_fold = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn_fold addTarget:self action:@selector(btn_fold_click:) forControlEvents:UIControlEventTouchUpInside];
            [btn_fold setFrame:CGRectMake(250.0f, 18.0f, 36, 10.0f)];
            btn_fold.tag = 1000;
            if (is_usr_fold)
            {
                im_fold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                im_fold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }
            im_fold.tag = 1100;
            im_fold.frame = CGRectMake(0.0f, 0.0f, 36.0f, 10.0f);
            [btn_fold addSubview:im_fold];
            [cell addSubview:btn_fold];
            return cell;
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
                case 1:
                    name_txt = @"会员";
                    content_txt = [dict objectForKey:@"type"];
                    break;
                case 2:
                    name_txt = @"姓名";
                    content_txt = [dict objectForKey:@"name"];
                    break;
                case 3:
                    name_txt = @"性别";
                    if ([[dict objectForKey:@"gender"] integerValue] == 1)
                    {
                        content_txt = @"男";
                    }
                    else if ([[dict objectForKey:@"gender"] integerValue] == 2)
                    {
                        content_txt = @"女";
                    }
                    else
                    {
                        content_txt = @"";
                    }
                    break;
                case 4:
                    name_txt = @"手机";
                    content_txt = [dict objectForKey:@"telnumber"];

                    break;
                case 5:
                    name_txt = @"邮箱";
                    content_txt = [dict objectForKey:@"email"];

                    break;
                case 6:
                {
                    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
                    [date_formatter setDateFormat:@"yyyy/MM/dd"];
                    if ([[dict objectForKey:@"birthday"] length] && (NSNull *)[dict objectForKey:@"birthday"] != [NSNull null])
                    {
                        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"birthday"] doubleValue]]];
                        content_txt = post_date;
                    }
                    else
                    {
                        content_txt = @"";
                    }

                    name_txt = @"出生日期";
                    break;
                }
                case 7:
                    name_txt = @"住址";
                    content_txt = [dict objectForKey:@"address"];
                    break;
                default:
                    break;
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@:",name_txt];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            CGSize containt_size = CGSizeMake(180.0f, 33.0f);
            CGSize content_frm_size = [cell.textLabel.text sizeWithFont:font
                                                      constrainedToSize:containt_size
                                                          lineBreakMode:UILineBreakModeWordWrap];
            if ([cell viewWithTag:indexPath.row*11 + 1])
            {
                [[cell viewWithTag:indexPath.row*11 + 1] removeFromSuperview];
            }
            
            lb_usr_detail = [[UILabel alloc] initWithFrame:CGRectMake(content_frm_size.width + 35.0f, 0.0f, 250.0f - content_frm_size.width, 44.0f)];
            lb_usr_detail.textColor = [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
            lb_usr_detail.textAlignment = UITextAlignmentLeft;
            lb_usr_detail.font = [UIFont systemFontOfSize:15.0f];
            lb_usr_detail.backgroundColor = [UIColor clearColor];
            lb_usr_detail.tag = indexPath.row*11 + 1;
            
            if (!content_txt || (NSNull *)content_txt == [NSNull null])
            {
                lb_usr_detail.text = @"";
            }
            else
            {
                lb_usr_detail.text = [NSString stringWithFormat:@"%@",content_txt];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:lb_usr_detail];
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

            if ([cell viewWithTag:1001])
            {
                [[cell viewWithTag:1001] removeFromSuperview];
            }
            btn_fold = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn_fold addTarget:self action:@selector(btn_fold_click:) forControlEvents:UIControlEventTouchUpInside];
            [btn_fold setFrame:CGRectMake(250.0f, 18.0f, 36, 10.0f)];
            btn_fold.tag = 1001;
            if (is_car_fold)
            {
                im_fold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                im_fold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }
            im_fold.tag = 1101;
            im_fold.frame = CGRectMake(0.0f, 0.0f, 36.0f, 10.0f);
            [btn_fold addSubview:im_fold];
            [cell addSubview:btn_fold];

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
                    if ([[dict objectForKey:@"buytime"] length] && (NSNull *)[dict objectForKey:@"buytime"] != [NSNull null])
                    {
                        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"buytime"] doubleValue]]];
                        content_txt = post_date;
                    }
                    else
                    {
                        content_txt = @"";
                    }
                    break;
                }       
                default:
                    break;
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@:",name_txt];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            CGSize containt_size = CGSizeMake(180.0f, 33.0f);
            CGSize content_frm_size = [cell.textLabel.text sizeWithFont:font
                                                      constrainedToSize:containt_size
                                                          lineBreakMode:UILineBreakModeWordWrap];
            if ([cell viewWithTag:indexPath.row*100 + 1])
            {
                [[cell viewWithTag:indexPath.row*100 + 1] removeFromSuperview];
            }
            
            lb_car_detail = [[UILabel alloc] initWithFrame:CGRectMake(content_frm_size.width + 35.0f, 0.0f, 250.0f - content_frm_size.width, 44.0f)];
            lb_car_detail.textColor = [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
            lb_car_detail.textAlignment = UITextAlignmentLeft;
            lb_car_detail.font = [UIFont systemFontOfSize:15.0f];
            lb_car_detail.backgroundColor = [UIColor clearColor];
            lb_car_detail.tag = indexPath.row*100 + 1;
            
            if (!content_txt || (NSNull *)content_txt == [NSNull null])
            {
                lb_car_detail.text = @"";
            }
            else
            {
                lb_car_detail.text = [NSString stringWithFormat:@"%@",content_txt];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:lb_car_detail];
            return  cell;
 		}
	}
    
    if (2 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            static NSString *cell_id = @"base_app_cell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:243.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = @"关于汽车助手";
            cell.tag = 1202;
            
            if ([cell viewWithTag:1002])
            {
                [[cell viewWithTag:1002] removeFromSuperview];
            }
            btn_fold = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn_fold addTarget:self action:@selector(btn_fold_click:) forControlEvents:UIControlEventTouchUpInside];
            [btn_fold setFrame:CGRectMake(250.0f, 18.0f, 36, 10.0f)];
            btn_fold.tag = 1002;
            if (is_app_fold)
            {
                im_fold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                im_fold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }
            im_fold.tag = 1102;
            im_fold.frame = CGRectMake(0.0f, 0.0f, 36.0f, 10.0f);
            [btn_fold addSubview:im_fold];
            [cell addSubview:btn_fold];
            
            return cell;
        }
        else
        {
            CellIdentifier = [NSString stringWithFormat:@"app_cell%d", [indexPath row]];
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
                    name_txt = @"版本";
                    cell.textLabel.text = [NSString stringWithFormat:@"%@:",name_txt];
                    content_txt = CURRENT_VERSION_CHAR;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 2:
                    name_txt = @"查看新版本";
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",name_txt];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 3:
                    name_txt = @"退出登录";
                    cell.textLabel.text = [NSString stringWithFormat:@"%@",name_txt];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            
            cell.textLabel.textColor = [UIColor lightGrayColor];
            CGSize containt_size = CGSizeMake(180.0f, 33.0f);
            CGSize content_frm_size = [cell.textLabel.text sizeWithFont:font
                                                      constrainedToSize:containt_size
                                                          lineBreakMode:UILineBreakModeWordWrap];
            if ([cell viewWithTag:indexPath.row*111 + 1])
            {
                [[cell viewWithTag:indexPath.row*111 + 1] removeFromSuperview];
            }
            
            lb_car_detail = [[UILabel alloc] initWithFrame:CGRectMake(content_frm_size.width + 35.0f, 0.0f, 250.0f - content_frm_size.width, 44.0f)];
            lb_car_detail.textColor = [UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
            lb_car_detail.textAlignment = UITextAlignmentLeft;
            lb_car_detail.font = [UIFont systemFontOfSize:15.0f];
            lb_car_detail.backgroundColor = [UIColor clearColor];
            lb_car_detail.tag = indexPath.row*111 + 1;
            
            if (!content_txt || (NSNull *)content_txt == [NSNull null])
            {
                lb_car_detail.text = @"";
            }
            else
            {
                lb_car_detail.text = [NSString stringWithFormat:@"%@",content_txt];
            }
            [cell addSubview:lb_car_detail];
            return  cell;

        }

    }
     return cell;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (2 == indexPath.section && 2 == indexPath.row)
    {
        [self fetchVer];
        return;
    }
    else if (2 == indexPath.section && 3 == indexPath.row)
    {
        [self applyCustomAlertAppearance];
        is_logout = YES;
        NSString *title = @"是否要退出当前用户？";
        NSString *message = @"当前账户的提醒设置可能会被清除,如果只是暂时退出可使用HOME键。";
        AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        __weak AHAlertView *alert =_alert;
        [alert setCancelButtonTitle:@"是" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleFade;
        }];
        [alert addButtonWithTitle:@"否" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
        }];
        
        [alert setAlertViewStyle:AHAlertViewStyleDefault];
        [alert show];
        return;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self btn_fold_click:cell];
}

#pragma mark event handle

- (void)btn_back_click:(id)sender
{
    [self popToViewController];
}

- (IBAction)btn_change_click:(id)sender
{
    [self applyCustomAlertAppearance];
    is_logout = YES;
    NSString *title = @"是否要退出当前用户？";
    NSString *message = @"当前账户的提醒设置可能会被清除,如果只是暂时退出可使用HOME键。";
    AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
    __weak AHAlertView *alert =_alert;
    [alert setCancelButtonTitle:@"是" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleFade;
    }];
    [alert addButtonWithTitle:@"否" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
    }];
    
    [alert setAlertViewStyle:AHAlertViewStyleDefault];
    [alert show];
}

- (void)btn_edit_click:(id)sender
{
	UsrProfileEditController *ctrl = [[UsrProfileEditController alloc] initWithStyle:UITableViewStyleGrouped];
    [ctrl setUserProfile:dict];
	NavController *nav = [[NavController alloc]initWithRootViewController:ctrl];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setTintColor:[UIColor colorWithRed:71.0f/255.0f green:158.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
	[nav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self.navigationController presentModalViewController:nav animated:YES];

}

- (void)btn_fold_click:(id)sender
{
    UITableViewCell *cell = nil;
    UIImageView *iv = nil;
    switch ([sender tag])
    {
        case 1000:
        case 1200:

            cell = (UITableViewCell *)[self.tableView viewWithTag:1200];
            iv = (UIImageView *)[cell viewWithTag:1100];
            is_usr_fold = !is_usr_fold;
            if (is_usr_fold)
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }

            break;
        case 1001:
        case 1201:

            cell = (UITableViewCell *)[self.tableView viewWithTag:1201];
            iv = (UIImageView *)[cell viewWithTag:1101];
            is_car_fold = !is_car_fold;
            if (is_car_fold)
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }
            break;
        case 1002:
        case 1202:
            cell = (UITableViewCell *)[self.tableView viewWithTag:1202];
            iv = (UIImageView *)[cell viewWithTag:1102];
            is_app_fold = !is_app_fold;
            if (is_app_fold)
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }
            break;

        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)setFoldWithIndex:(NSUInteger)index
{
    UITableViewCell *cell = nil;
    UIImageView *iv = nil;
    
    switch (index)
    {
        case 0:
            cell = (UITableViewCell *)[self.tableView viewWithTag:1200];
            iv = (UIImageView *)[cell viewWithTag:1100];
            is_usr_fold = !is_usr_fold;
            if (is_usr_fold)
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }
            
            break;
        case 1:
            cell = (UITableViewCell *)[self.tableView viewWithTag:1201];
            iv = (UIImageView *)[cell viewWithTag:1101];
            is_car_fold = !is_car_fold;
            if (is_car_fold)
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_fold.png"]];
            }
            else
            {
                [iv setImage:[UIImage imageNamed:@"usr_set_unfold.png"]];
            }
            break;
        default:
            break;
    }

}

- (void)loadData
{
    is_loading = YES;
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, USR_PROFILE_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadData:)];
	[loader loadwithTimer];

}

- (void)onLoadData:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        if ([[json objectForKey:@"errcode"] integerValue] == 600)
        {
            [RWAlertView show:@"登录指令失效,请重新登录!"];
            RRToken *token = [RRToken getInstance];
            [RRToken removeTokenForUID:[token getProperty:@"uid"]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_login_uid"];
            
            AppDelegate *dele = [AppDelegate getInstance];
            dele.delegate = self;
            [dele checkToken];
            return;
        }
        
        [RWAlertView show:@"网络链接失败!"];
        [self setHeadView];
 		return;
	}
    
    dict = [json objectForKey:@"data"];
    [self setHeadView];
}

- (void)fetchVer
{
    is_loading = YES;
    [RWShowView show:@"loading"];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GET_VER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onGetVer:)];
	[loader loadwithTimer];
}

- (void)onGetVer:(NSNotification *)notify
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
    
    NSString *verno = [[json objectForKey:@"data"] objectForKey:@"verno"];
    [self applyCustomAlertAppearance];
    is_check = YES;

    if ([verno isEqualToString:CURRENT_VERSION_CHAR])
	{
        NSString *title = @"新版本提示";
        NSString *message = @"当前已是最新版本";
        AHAlertView *alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        [alert setAlertViewStyle:AHAlertViewStyleDefault];
        [alert show];

		return;
	}
	
	NSString *desc = [[json objectForKey:@"data"] objectForKey:@"description"];
    NSString *title = @"新版本提示";
    AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:desc andDelegate:self];
    __weak AHAlertView *alert =_alert;
    [alert setCancelButtonTitle:@"现在升级" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleFade;
    }];
    [alert addButtonWithTitle:@"以后再说" block:^{
        alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
    }];
    
    [alert setAlertViewStyle:AHAlertViewStyleDefault];
    [alert show];
    
    return;


}


- (void)onLoadFail:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setHeadView];


}

- (void)setHeadView
{
    head_view.frame = CGRectMake(0.0f, -90.0f, 320.0f, 92.5f);
	head_view.backgroundColor = [UIColor clearColor];
	[self.tableView addSubview:head_view];
    
    if ([[dict objectForKey:@"nickname"] length] && (NSNull *)[dict objectForKey:@"nickname"] != [NSNull null])
    {
        lb_name.text = [dict objectForKey:@"nickname"];
    }
    else
    {
        lb_name.text = @"昵称未设置";
    }
    
    if ([dict objectForKey:@"district"] && (NSNull *)[dict objectForKey:@"district"] != [NSNull null])
    {
        lb_district.text = [dict objectForKey:@"district"];
    }
    else
    {
        lb_district.text = @"";
    }

    RRToken *token = [RRToken getInstance];
    lb_server_no.text = [token getProperty:@"service_number"];
    if ([[dict objectForKey:@"iconimg"] length])
    {
        NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL,[dict objectForKey:@"iconimg"]];
        UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
        if (avatar_im)
        {
            [self.im_avatar setImage:avatar_im];
        }
        else
        {
            RRRemoteImage *remote_img = [[RRRemoteImage alloc] initWithURLString:avatar_url  parentView:self.im_avatar delegate:self defaultImageName:@"avatar.png"];
            [self.im_avatar setImage:remote_img];
        }
    }
    else
    {
        [self.im_avatar setImage:[UIImage imageNamed:@"avatar.png"]];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    [self.tableView reloadData];
  
}

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage
{
	[self.im_avatar setImage:[UIImage imageNamed:@"avatar.png"]];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
	UIImageView *btn = (UIImageView *)remoteImage.parent_view;
	[btn setImage:newImage];
	
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}

#pragma mark check token

- (void) checkTokenSuccess
{
    buffer = [NSMutableArray arrayWithCapacity:0];
    is_loading = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadData];
}

- (void) alertViewDidCancel
{
    if (is_check || is_logout)
    {
        is_check = NO;
        is_logout = NO;
        return;
    }

    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
    
}

- (void) popToViewController
{
	[self dismissModalViewControllerAnimated:YES];
    
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

- (void)btn_did_click:(id)sender
{
    if (101 == [sender tag])
    {
        if (is_logout)
        {
            is_logout = NO;
            [self logout];
        }
        else
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/e-lu-chang-tong/id582153447?mt=8"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/e-lu-chang-tong/id582153447?mt=8"]];
            }
        }

    }
    else
    {
        if (is_logout)
        {
            is_logout = NO;
        }
        else
        {
        }

    }
}

- (void)logout
{
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGOUT_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    RRToken *token = [RRToken getInstance];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    
    AppDelegate *delegate = [AppDelegate getInstance];
    if ([delegate.pushToken length])
    {
        [req setParam:delegate.pushToken forKey:@"devicetoken"];
    }
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLogout:)];
	[loader loadwithTimer];
}

- (void)onLogout:(NSNotification *)notify
{
    RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        if ([[json objectForKey:@"errcode"] integerValue] == 600)
        {
            [RWAlertView show:@"登录指令失效,请重新登录!"];
            RRToken *token = [RRToken getInstance];
            [RRToken removeTokenForUID:[token getProperty:@"uid"]];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_login_uid"];
            
            AppDelegate *dele = [AppDelegate getInstance];
            dele.delegate = self;
            [dele checkToken];
            return;
        }
        
        [RWAlertView show:@"网络链接失败!"];
        [self setHeadView];
 		return;
	}

    RRToken *token = [RRToken getInstance];
    [RRToken removeTokenForUID:[token getProperty:@"uid"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_login_uid"];
    [dict removeAllObjects];
    [self.tableView reloadData];
    
    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele performSelector:@selector(checkToken) withObject:nil afterDelay:0.5];
}
@end
