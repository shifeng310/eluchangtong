//
//  DriveRecordListController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "DriveRecordListController.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "RoadRover.h"
#import "RWAlertView.h"
#import "RWShowView.h"

@implementation DriveRecordListController
@synthesize head_view;
@synthesize head_view_bg;
@synthesize im_month_bg;
@synthesize im_today_bg;
@synthesize im_week_bg;
@synthesize im_year_bg;
@synthesize im_yestoday_bg;
@synthesize btn_type;

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
    
    self.title= @"行车里程";
    
    im_today_bg.image = [UIImage imageNamed:@"note_head_bg_highlight.png"];
	[self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_view.png"]]];
    type = @"today";
    
    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele checkToken];
   // self.edgesForExtendedLayout = UIRectEdgeNone;
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
    head_view = nil;
    head_view_bg = nil;
    im_month_bg = nil;
    im_today_bg = nil;
    im_week_bg = nil;
    im_year_bg = nil;
    im_yestoday_bg = nil;
    btn_type = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [RWAlertView closeAlert];
    [RWShowView closeAlert];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [datalist count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([datalist count] == 0)
    {
        return 1;
    }
    
    if (0 == section)
    {
        return 8;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([datalist count] == 0 && is_loading)
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
        cell.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        return cell;
    }
    
    if ([datalist count] == 0 && !is_loading)
    {
        static NSString *cell_id = @"empty_cell";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
        if (nil == cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        
        UIFont *font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.text = @"没有记录";
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    self.tableView.separatorColor = [UIColor lightGrayColor];

    if (0 == indexPath.section)
    {
        CellIdentifier = [NSString stringWithFormat:@"usr_cell%d", [indexPath row]];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = font;
        
        NSString *name_txt = nil;
        NSString *content_txt = nil;
        
        switch (indexPath.row)
        {
            case 0:
                name_txt = @"行驶里程";
                content_txt = [NSString stringWithFormat:@"%@km",[totaldata objectForKey:@"totalmileage"]];
                break;
            case 1:
                name_txt = @"最高时速";
                content_txt = [NSString stringWithFormat:@"%@km/h",[totaldata objectForKey:@"maxspeed"]] ;
                 break;
            case 2:
                name_txt = @"行驶时间";
                content_txt = [NSString stringWithFormat:@"%d小时%d分钟",[[totaldata objectForKey:@"duration"] integerValue]/3600,([[totaldata objectForKey:@"duration"] integerValue]%3600) / 60];
                break;
            case 3:
                name_txt = @"平均耗油";
                content_txt = [NSString stringWithFormat:@"%@升/100km",[totaldata objectForKey:@"avgoilwear"]];
                
                break;
            case 4:
                content_txt = [NSString stringWithFormat:@"%@升",[totaldata objectForKey:@"totaloil"]];
                name_txt = @"总耗油";
                break;
            case 5:
                name_txt = @"平均时速";
                content_txt = [NSString stringWithFormat:@"%@km/h",[totaldata objectForKey:@"avgspeed"]];
                break;
            case 6:
                name_txt = @"总急加速";
                content_txt = [NSString stringWithFormat:@"%@次",[totaldata objectForKey:@"totalaccelerate"]];
                break;
            case 7:
                name_txt = @"总急刹车";
                content_txt = [NSString stringWithFormat:@"%@次",[totaldata objectForKey:@"totalmoderate"]];
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
        if ([cell viewWithTag:indexPath.row*11 + 1])
        {
            [[cell viewWithTag:indexPath.row*11 + 1] removeFromSuperview];
        }
        
        lb_base = [[UILabel alloc] initWithFrame:CGRectMake(content_frm_size.width + 40.0f, 0.0f, 250.0f - content_frm_size.width, 44.0f)];
        lb_base.textColor = [UIColor colorWithRed:95.0f/255.0f green:124.0f/255.0f blue:148.0f/255.0f alpha:1.0f];
        lb_base.textAlignment = UITextAlignmentLeft;
        lb_base.font = [UIFont systemFontOfSize:15.0f];
        lb_base.backgroundColor = [UIColor clearColor];
        lb_base.tag = indexPath.row*11 + 1;
        
        if (!content_txt || (NSNull *)content_txt == [NSNull null])
        {
            if ([totaldata count]!= 0)
            {
                lb_base.text = @"未设置";
            }
            else
            {
                lb_base.text = @"";
            }
        }
        else
        {
            lb_base.text = [NSString stringWithFormat:@"%@",content_txt];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:lb_base];
        return  cell;
    }
    
    else
    {
        NSDictionary *dict = [datalist objectAtIndex:indexPath.section - 1];

        if (0 == indexPath.row)
        {
            CellIdentifier = [NSString stringWithFormat:@"detai_cell%d",[indexPath section]];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:243.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = font;
            
            NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
            if ([type isEqualToString:@"today"] || [type isEqualToString:@"yesterday"])
            {
                [date_formatter setDateFormat:@"hh:mm"];
            }
            else if ([type isEqualToString:@"week"] || [type isEqualToString:@"month"])
            {
                [date_formatter setDateFormat:@"MM/dd hh:mm"];
            }
            else
            {
                [date_formatter setDateFormat:@"MM/dd"];
            }
            NSString *stime = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"stime"] doubleValue]]];
            NSString *etime = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"etime"] doubleValue]]];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %@",stime,etime];
            return cell;
        }
        else
        {
            CellIdentifier = [NSString stringWithFormat:@"detai_cell%d%d", [indexPath row],[indexPath section]];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.detailTextLabel.font = font;
            
            NSString *name_txt = nil;
            NSString *content_txt = nil;
            
            switch (indexPath.row)
            {
                case 1:
                    name_txt = @"行驶里程";
                    content_txt = [NSString stringWithFormat:@"%@km",[dict objectForKey:@"mileage"]];
                    break;
                case 2:
                    name_txt = @"最高时速";
                    content_txt = [NSString stringWithFormat:@"%@km/h",[dict objectForKey:@"maxspeed"]] ;
                    break;
                case 3:
                    name_txt = @"行驶时间";
                    content_txt = [NSString stringWithFormat:@"%d小时%d分钟",[[dict objectForKey:@"duration"] integerValue]/3600,([[dict objectForKey:@"duration"] integerValue]%3600) / 60];
                    
                    break;
                case 4:
                    name_txt = @"平均耗油";
                    content_txt = [NSString stringWithFormat:@"%@升/100km",[dict objectForKey:@"oilwear"]];
                    
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
            if ([cell viewWithTag:indexPath.section *10 + indexPath.row*11 + 1])
            {
                [[cell viewWithTag:indexPath.section *10 + indexPath.row*11 + 1] removeFromSuperview];
            }
            
            lb_msg = [[UILabel alloc] initWithFrame:CGRectMake(content_frm_size.width + 40.0f, 0.0f, 250.0f - content_frm_size.width, 44.0f)];
            lb_msg.textColor = [UIColor colorWithRed:95.0f/255.0f green:124.0f/255.0f blue:148.0f/255.0f alpha:1.0f];
            lb_msg.textAlignment = UITextAlignmentLeft;
            lb_msg.font = [UIFont systemFontOfSize:15.0f];
            lb_msg.backgroundColor = [UIColor clearColor];
            lb_msg.tag = indexPath.section *10 + indexPath.row*11 + 1;
            
            if (!content_txt || (NSNull *)content_txt == [NSNull null])
            {
                if ([totaldata count]!= 0)
                {
                    lb_msg.text = @"未设置";
                }
                else
                {
                    lb_msg.text = @"";
                }
            }
            else
            {
                lb_msg.text = [NSString stringWithFormat:@"%@",content_txt];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:lb_msg];
            return  cell;
        }

    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return head_view;
    }
    return nil;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 45.0f;
    }
    return 0.0f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)loadData
{
    is_loading = YES;
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, DRIVE_RECORD_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:type forKey:@"type"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadData:)];
	[loader loadwithTimer];

}

- (void)onLoadData:(NSNotification *)nofify
{
    is_loading = NO;
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
            [self.tableView reloadData];
            return;
        }
        [RWAlertView show:@"网络链接失败!" ];
        [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
 		return;
	}
    
    NSDictionary *dic = [json objectForKey:@"data"];
    totaldata = [dic objectForKey:@"totaldata"];
    [datalist addObjectsFromArray:[dic objectForKey:@"datalist"]];
    
    [self.tableView reloadData];
    
    
}

- (void)onLoadFail:(NSNotification *)notify
{
    is_loading = NO;
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
}

- (IBAction)btn_click:(id)sender
{
    switch ([sender tag])
    {
        case 21:
            im_today_bg.image = [UIImage imageNamed:@"note_head_bg_highlight.png"];
            im_yestoday_bg.image = nil;
            im_week_bg.image = nil;
            im_month_bg.image = nil;
            im_year_bg.image = nil;
            type = @"today";
            break;
        case 22:
            im_today_bg.image = nil;
            im_yestoday_bg.image = [UIImage imageNamed:@"note_head_bg_highlight.png"];
            im_week_bg.image = nil;
            im_month_bg.image = nil;
            im_year_bg.image = nil;
            type = @"yesterday";

            break;
        case 23:
            im_today_bg.image = nil;
            im_yestoday_bg.image = nil;
            im_week_bg.image = [UIImage imageNamed:@"note_head_bg_highlight.png"];
            im_month_bg.image = nil;
            im_year_bg.image = nil;
            type = @"week";

            break;
        case 24:
            im_today_bg.image = nil;
            im_yestoday_bg.image = nil;
            im_week_bg.image = nil;
            im_month_bg.image = [UIImage imageNamed:@"note_head_bg_highlight.png"];
            im_year_bg.image = nil;
            type = @"month";

            break;
        case 25:
            im_today_bg.image = nil;
            im_yestoday_bg.image = nil;
            im_week_bg.image = nil;
            im_month_bg.image = nil;
            im_year_bg.image = [UIImage imageNamed:@"note_head_bg_highlight.png"];
            type = @"total";
            break;
        default:
            break;
    }
    
    [self checkTokenSuccess];
}

- (void) popToViewController
{
	[self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark check token

- (void) checkTokenSuccess
{
	totaldata = [NSMutableDictionary dictionaryWithCapacity:0];
    datalist = [NSMutableArray arrayWithCapacity:0];
    [self loadData];
}

- (void) alertViewDidCancel
{
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
    
}


@end
