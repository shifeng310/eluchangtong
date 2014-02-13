//
//  RWTrafficDetailController.m
//  RW
//
//  Created by Xiuhu Fu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RWTrafficDetailController.h"
#import "RWShowView.h"
#import "RWAlertView.h"

#define driveSpeed 60
#define busSpeed 20
#define walkSpeed 5

static CGFloat INTRODUCE_FONT_SIZE = 13.0f;
static CGFloat INTRODUCE_LABEL_WIDTH = 250.0F;
@implementation RWTrafficDetailController
@synthesize start;
@synthesize end;
@synthesize transitRoute_plan;
@synthesize drive_plan;
@synthesize walk_plan;
@synthesize saddr;
@synthesize daddr;
@synthesize delegate;
@synthesize city_name;

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
	
	drive_line = [NSMutableArray arrayWithCapacity:0];
	walk_line = [NSMutableArray arrayWithCapacity:0];
	transit_line = [NSMutableArray arrayWithCapacity:0];
	transit_detail = [NSMutableArray arrayWithCapacity:0];
	src_type = 0;
	policy_type = 0;

	search = [[BMKSearch alloc]init];
	search.delegate = self;

	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorColor = [UIColor colorWithRed:216.0f/255.0f green:212.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_view.png"]]];

	sg_switch = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"自驾", @"公交", @"步行",nil]];
	sg_switch.segmentedControlStyle = UISegmentedControlStyleBar;
	[sg_switch addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
	sg_switch.frame = CGRectMake(0, 0, 150, 30);
	sg_switch.selectedSegmentIndex = 0;
	self.navigationItem.titleView = sg_switch;
	
	btn_sort = [[UIBarButtonItem alloc]initWithTitle:@"排序" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_sort_click:)];
	self.navigationItem.rightBarButtonItem = btn_sort;

	btn_cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
	btn_certain = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btn_certain_click:)];
	
	UIBarButtonItem *middle_item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	NSArray *tool_item = [NSArray arrayWithObjects:btn_cancel,middle_item,btn_certain, nil];
	tool_bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	[tool_bar setItems:tool_item];
	tool_bar.barStyle = UIBarStyleBlackTranslucent;
	
	btn_back = [[UIBarButtonItem alloc]initWithTitle:@"查看地图" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_back_click:)];
	self.navigationItem.leftBarButtonItem = btn_back;
	
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	[self setDriveData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        tool_bar = nil;
        btn_back = nil;
    }
}

- (void)dealloc
{
    self.delegate = nil;
	search = nil;
	start = nil;
	end = nil;
    nav = nil;
	sg_switch = nil;
	transitRoute_plan = nil;
	drive_plan = nil;
	walk_plan = nil;
	drive_line = nil;
	walk_line = nil;
	transit_line = nil;
	transit_detail = nil;
	lb_saddr = nil;
	lb_daddr = nil;
	tool_bar = nil;
	btn_cancel = nil;
	btn_certain = nil;
	btn_sort = nil;
	btn_back = nil;
	actionSheet = nil;
	delegate = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	switch (src_type) 
	{
		case 0:
			return [drive_plan count] + 1;
			break;
		case 1:
			return [transitRoute_plan count] + 1;
			break;
		case 2:
			return [walk_plan count] + 1;;
			break;
	}
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (0 == section)
	{
		return 2;
	}
	else 
	{
		switch (src_type) 
		{
			case 0:
				return [drive_line count];
				break;
			case 1:
				return 1;
				break;
			case 2:
				return [walk_line count];
				break;
		}
	}
	
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (0 == indexPath.section)
	{
		CellIdentifier = [NSString stringWithFormat:@"head_cell%d", [indexPath section]];
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		switch (indexPath.row) 
		{
			case 0:
				cell.textLabel.text = @"出发地:";
				cell.textLabel.textColor = [UIColor darkGrayColor];
				if (lb_saddr)
				{
					[lb_saddr removeFromSuperview];
				}
				lb_saddr = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 0.0f, 220.0f, 44.0f)];
				lb_saddr.textColor = [UIColor colorWithRed:99.0f/255.0f green:99.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
				lb_saddr.textAlignment = NSTextAlignmentLeft;
				lb_saddr.font = [UIFont systemFontOfSize:13.0f];
				lb_saddr.backgroundColor = [UIColor clearColor];
				lb_saddr.text = self.saddr;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell addSubview:lb_saddr];
				break;
			case 1:
				cell.textLabel.text = @"目的地:";
				cell.textLabel.textColor = [UIColor darkGrayColor];
				if (lb_daddr)
				{
					[lb_daddr removeFromSuperview];
				}
				lb_daddr = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, 0.0f, 220.0f, 44.0f)];
				lb_daddr.textColor = [UIColor colorWithRed:99.0f/255.0f green:99.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
				lb_daddr.textAlignment = NSTextAlignmentLeft;
				lb_daddr.font = [UIFont systemFontOfSize:13.0f];
				lb_daddr.backgroundColor = [UIColor clearColor];
				lb_daddr.text = self.daddr;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell addSubview:lb_daddr];
				break;
			default:
				break;
		}

	}
    
	else 
	{
		CellIdentifier = @"detail_cell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}

		switch (src_type) 
		{
			case 0:
            {
				if (![drive_line count])
				{
					static NSString *cell_id = @"empty_cell";
					
					UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
					if (nil == cell)
					{
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
					}
					
					UIFont *font = [UIFont systemFontOfSize:13.0f];
					cell.textLabel.font = font;
					cell.textLabel.text = @"未找到自驾路线,试一下其他方式吧";
					cell.textLabel.textAlignment = NSTextAlignmentLeft;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					return cell;
				}

				cell.textLabel.text = [drive_line objectAtIndex:indexPath.row];
				cell.textLabel.textColor = [UIColor colorWithRed:99.0f/255.0f green:99.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imageView.frame = CGRectMake(0.0f, 0.0f, 27.0f, 27.0f);
                NSString *str = [drive_line objectAtIndex:indexPath.row];
                NSRange searchResult1 = [str rangeOfString:@"直行"];
                NSRange searchResult2 = [str rangeOfString:@"右前方"];
                NSRange searchResult3 = [str rangeOfString:@"左前方"];
                NSRange searchResult4 = [str rangeOfString:@"调头"];
                NSRange searchResult5 = [str rangeOfString:@"右转"];
                NSRange searchResult6 = [str rangeOfString:@"左转"];
                NSRange searchResult7 = [str rangeOfString:@"终点"];
                if(searchResult1.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"zhixing.png"];
                }
                else if(searchResult2.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"youqianfang.png"];
                }
                else if(searchResult3.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"zuoqianfang.png"];
                }
                else if(searchResult4.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"diaotou.png"];
                }
                else if(searchResult5.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"youzhuan.png"];
                }
                else if(searchResult6.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"zuozhuan.png"];
                }
                else if(searchResult7.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"car_poi.png"];
                }
                else
                {
                    cell.imageView.image = [UIImage imageNamed:@"zhixing.png"];
                }

				break;
            }
			case 1:
			{
				CellIdentifier = [NSString stringWithFormat:@"introduce_cell%d", [indexPath section]];
				cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				UIFont *font = [UIFont fontWithName:@"Arial" size:INTRODUCE_FONT_SIZE];
				if (cell == nil)
				{
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
				}
				
				if (![transit_line count])
				{
					static NSString *cell_id = @"empty_cell";
					
					UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
					if (nil == cell)
					{
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
					}
					
					UIFont *font = [UIFont systemFontOfSize:13.0f];
					cell.textLabel.font = font;
					cell.textLabel.text = @"未找到公交路线,试一下其他方式吧";
					cell.textLabel.textAlignment = NSTextAlignmentLeft;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					return cell;
				}
				
				cell.textLabel.text = [NSString stringWithFormat:@"方案%d:%@",[indexPath section],[transit_line objectAtIndex:indexPath.section -1]];
				cell.textLabel.numberOfLines = 0;
				cell.textLabel.backgroundColor = [UIColor clearColor];
				cell.textLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:158.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
				cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				cell.detailTextLabel.font = font;
				cell.detailTextLabel.backgroundColor = [UIColor clearColor];
				NSString *intro_txt = [transit_detail objectAtIndex:indexPath.section - 1];
				
				CGSize containt_size;
				CGSize intro_frm_size;
				
				if (current_section != indexPath.section)
				{
					cell.detailTextLabel.numberOfLines = 1;
					containt_size = CGSizeMake(INTRODUCE_LABEL_WIDTH, INTRODUCE_FONT_SIZE * 1);
					intro_frm_size = [intro_txt sizeWithFont:font
										   constrainedToSize:containt_size
											   lineBreakMode:NSLineBreakByWordWrapping];
				}
				else if (current_section == indexPath.section && is_info_cell_expanded)
				{
					containt_size = CGSizeMake(INTRODUCE_LABEL_WIDTH, 1000.0f);
					intro_frm_size = [intro_txt sizeWithFont:font
										   constrainedToSize:containt_size
											   lineBreakMode:NSLineBreakByWordWrapping];
					
					cell.detailTextLabel.numberOfLines = intro_frm_size.height / INTRODUCE_FONT_SIZE;
				}
				
				else 
				{
					cell.detailTextLabel.numberOfLines = 1;
					containt_size = CGSizeMake(INTRODUCE_LABEL_WIDTH, INTRODUCE_FONT_SIZE * 1);
					intro_frm_size = [intro_txt sizeWithFont:font
										   constrainedToSize:containt_size
											   lineBreakMode:NSLineBreakByWordWrapping];
				}
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",intro_txt ];
				cell.detailTextLabel.textColor = [UIColor colorWithRed:99.0f/255.0f green:99.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
				return cell;
				break;
			}
			case 2:
				if (![walk_line count])
				{
					static NSString *cell_id = @"empty_cell";
					
					UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
					if (nil == cell)
					{
						cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
					}
					
					UIFont *font = [UIFont systemFontOfSize:13.0f];
					cell.textLabel.font = font;
					cell.textLabel.text = @"未找到步行路线,试一下其他方式吧";
					cell.textLabel.textAlignment = NSTextAlignmentCenter;
					cell.selectionStyle = UITableViewCellSelectionStyleNone;
					return cell;
				}

				cell.textLabel.text = [walk_line objectAtIndex:indexPath.row];
				cell.textLabel.textColor = [UIColor colorWithRed:99.0f/255.0f green:99.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSString *str = [walk_line objectAtIndex:indexPath.row];
                NSRange searchResult1 = [str rangeOfString:@"直行"];
                NSRange searchResult2 = [str rangeOfString:@"右前方"];
                NSRange searchResult3 = [str rangeOfString:@"左前方"];
                NSRange searchResult4 = [str rangeOfString:@"调头"];
                NSRange searchResult5 = [str rangeOfString:@"右转"];
                NSRange searchResult6 = [str rangeOfString:@"左转"];
                NSRange searchResult7 = [str rangeOfString:@"终点"];
                if(searchResult1.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"zhixing.png"];
                }
                else if(searchResult2.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"youqianfang.png"];
                }
                else if(searchResult3.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"zuoqianfang.png"];
                }
                else if(searchResult4.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"diaotou.png"];
                }
                else if(searchResult5.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"youzhuan.png"];
                }
                else if(searchResult6.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"zuozhuan.png"];
                }
                else if(searchResult7.location != NSNotFound)
                {
                    cell.imageView.image = [UIImage imageNamed:@"car_poi.png"];
                }
                else
                {
                    cell.imageView.image = [UIImage imageNamed:@"zhixing.png"];
                }
				break;
		}
	}
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	current_section = indexPath.section;
	if (0 < indexPath.section && src_type == 1)
	{
		NSString *intro_txt = [transit_detail objectAtIndex:indexPath.section - 1];
		
		if (!intro_txt || 0 == [intro_txt length])
		{
			return;
		}
		
		is_info_cell_expanded = !is_info_cell_expanded;
		NSArray *arr = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
		[tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView reloadData];
		return;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 < indexPath.section && src_type == 1)
	{
		NSString *intro_txt = [transit_detail objectAtIndex:indexPath.section - 1];
		
		UIFont *font = [UIFont systemFontOfSize:INTRODUCE_FONT_SIZE];
		CGSize containt_size;
		CGSize intro_frm_size;
		
		if (current_section != indexPath.section )
		{
			containt_size = CGSizeMake(INTRODUCE_LABEL_WIDTH, INTRODUCE_FONT_SIZE * 1);
		}

		else if (current_section == indexPath.section && is_info_cell_expanded)
		{
			containt_size = CGSizeMake(INTRODUCE_LABEL_WIDTH, 1000.0f);
		}
		
		else 
		{
			containt_size = CGSizeMake(INTRODUCE_LABEL_WIDTH, INTRODUCE_FONT_SIZE * 1);
		}

		CGSize containt_size_tmp = CGSizeMake(INTRODUCE_LABEL_WIDTH, 1000.0f);;
		intro_frm_size = [intro_txt sizeWithFont:font
							   constrainedToSize:containt_size
								   lineBreakMode:NSLineBreakByWordWrapping];
		
		NSString *line_tx = [transit_line objectAtIndex:indexPath.section -1];
	    CGSize line_frm_size = [line_tx sizeWithFont:[UIFont systemFontOfSize:14.0f]
							   constrainedToSize:containt_size_tmp
								   lineBreakMode:NSLineBreakByWordWrapping];

		if (44.0f > intro_frm_size.height + line_frm_size.height)
		{
			return 44.0f + 20.0f;
		}
		else
		{
			return intro_frm_size.height +line_frm_size.height + 10.0f;
		}
	}
	
	else 
	{
		return 44.0f;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel *lb_head = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 44.0f)];
	lb_head.textColor = [UIColor colorWithRed:99.0f/255.0f green:99.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
	lb_head.font = [UIFont systemFontOfSize:14.0f];
	lb_head.backgroundColor = [UIColor clearColor];
	if (1 == section && src_type == 0)
	{
		switch (policy_type) 
		{
			case BMKCarTimeFirst:
				lb_head.text = [NSString stringWithFormat:@"   排序方式: 时间优先 %@",driveTips];
				break;
			case BMKCarDisFirst:
				lb_head.text = [NSString stringWithFormat:@"   排序方式: 最短距离 %@",driveTips];
				break;
			case BMKCarFeeFirst:
				lb_head.text =  [NSString stringWithFormat:@"   排序方式: 较少费用 %@",driveTips];
				break;
			default:
				break;
		}	
	}
	
	if (1 == section && src_type == 1)
	{
		switch (policy_type) 
		{
			case BMKBusTimeFirst:
				lb_head.text =  @"   排序方式: 时间优先";
				break;
			case BMKBusTransferFirst:
				lb_head.text =  @"   排序方式: 最少换乘";
				break;
			case BMKBusWalkFirst:
				lb_head.text =  @"   排序方式: 最小步行距离";
				break;
			case BMKBusNoSubway:
				lb_head.text =  @"   排序方式: 不含地铁";
				break;
			default:
				break;
		}	
	}
	
	if (1 == section && src_type == 2)
	{
		lb_head.text = [NSString stringWithFormat:@"   %@",walkTips ];
	}
	
	return lb_head;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (1 == section)
	{
		return 44.0f;
	}
	
	return 0;
}


#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	switch (src_type) 
	{
		case 0:
			return 3;
			break;
		case 1:
			return 4;
			break;
		default:
			break;
	}
	
	return 1;
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	switch (src_type) 
	{
		case 0:
			switch (row) 
		{
			case 0:
				return @"时间优先";
				break;
			case 1:
				return @"最短距离";
				break;
			case 2:
				return @"较少费用";
				break;
			default:
				break;
		}
		case 1:
		{
			switch (row) 
			{
				case 0:
					return @"时间优先";
					break;
				case 1:
					return @"最少换乘";
					break;
				case 2:
					return @"最小步行距离";
					break;
				case 3:
					return @"不含地铁";
					break;
				default:
					break;
		     }
	     }
		default:
			break;
	}
	return @"";
}


#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)ActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


- (void) segmentedControlChange:(id)sender
{
	UISegmentedControl *sg = (UISegmentedControl *)sender;
	if (0 == sg.selectedSegmentIndex)
	{
		src_type = 0;
		[RWAlertView closeAlert];
		self.navigationItem.rightBarButtonItem = btn_sort;
		if ([drive_plan count])
		{
			policy_type =  search.drivingPolicy;
			[self setDriveData];
			return;
		}
		[self searchDriveData];
	}
	
	if (1 == sg.selectedSegmentIndex)
	{
		src_type = 1;
		[RWAlertView closeAlert];
		self.navigationItem.rightBarButtonItem = btn_sort;
		if ([transitRoute_plan count])
		{
			policy_type =  search.transitPolicy;
			[self setTransitData];
			return;
		}
		[self searchTransitData];

	}
	
	if (2 == sg.selectedSegmentIndex)
	{
		src_type = 2;
		[RWAlertView closeAlert];
		self.navigationItem.rightBarButtonItem = nil;
		if ([walk_plan count])
		{
			[self setWalkData];
			return;
		}
		
		[self searchWalkData];
	}
	
}

- (void) searchTransitData
{
	if (policy_type <=2)
	{
		policy_type = 3;
	}
	
	[RWShowView show:@"loading"];
	search.transitPolicy = policy_type;
	BOOL flag = [search transitSearch:city_name startNode:start endNode:end];
	if (!flag) {
		NSLog(@"search failed");
        [RWShowView closeAlert];
        [RWAlertView show:@"未找到公交路线!"];
	}
}

- (void) searchDriveData
{
	if (policy_type > 3)
	{
		policy_type = 1;
	}
	[RWShowView show:@"loading"];
	search.drivingPolicy = policy_type;
	BOOL flag = [search drivingSearch:start.name startNode:start endCity:end.name endNode:end];
	if (!flag)
	{
		NSLog(@"search failed");
        [RWShowView closeAlert];
        [RWAlertView show:@"未找到自驾路线!"];

	}

}

- (void) searchWalkData
{
	[RWShowView show:@"loading"];
	BOOL flag = [search walkingSearch:start.name startNode:start endCity:end.name endNode:end];
	if (!flag) 
	{
		NSLog(@"search failed");
        [RWShowView closeAlert];
        [RWAlertView show:@"未找到步行路线!"];
	}
}

- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
	[RWShowView closeAlert];
	if (error == BMKErrorOk) 
	{
		if ([self.transitRoute_plan count])
		{
			transitRoute_plan = nil;
		}
		self.transitRoute_plan = [NSMutableArray arrayWithArray:result.plans];
		[self setTransitData];
	}
	
	else 
	{
			[RWAlertView show:@"未找到公交路线,试一下其他方式吧!"];
			[self.tableView reloadData];
			return;
	}
}
- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
	[RWShowView closeAlert];
	if (error == BMKErrorOk) 
	{
		if ([self.drive_plan count])
		{
			drive_plan = nil;
		}
		self.drive_plan = [NSMutableArray arrayWithArray:result.plans];
		[self setDriveData];
	}	
	
	else 
	{
		[RWAlertView show:@"未找到自驾路线,试一下其他方式吧!"];
		[self.tableView reloadData];
		return;
	}
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
	[RWShowView closeAlert];
	if (error == BMKErrorOk) 
	{
		if ([self.walk_plan count])
		{
			[walk_plan removeAllObjects];
			walk_plan = nil;
		}
		self.walk_plan = [NSMutableArray arrayWithArray:result.plans];
		[self setWalkData];
	}
	else 
	{
		[RWAlertView show:@"未找到步行路线,试一下其他方式吧!"];
		[self.tableView reloadData];
		return;
	}
}

- (void) setTransitData
{
	if (![transitRoute_plan count])
	{
		return;
	}
	
	if ([transit_line count])
	{
		[transit_line removeAllObjects];
	}

	if ([transit_detail count])
	{
		[transit_detail removeAllObjects];
	}

	for (int i = 0; i < [transitRoute_plan count]; i++) 
	{
		BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[transitRoute_plan objectAtIndex:i];
		
		int distance = plan.distance/1000;
		int hour = distance/busSpeed;
		int min = ((distance%busSpeed) *60)/busSpeed;
		int mine = (((plan.distance/100)%walkSpeed) *60)/walkSpeed;

		NSString *distanceAndTime = nil;
		if (plan.distance/1000 == 0)
		{
			distanceAndTime = [NSString stringWithFormat:@"约:%d00米/%d分钟",plan.distance/100,mine];
		}
		else 
		{
			distanceAndTime = [NSString stringWithFormat:@"约:%d公里/%d小时%d分钟",distance,hour,min];
		}

		int size = [plan.lines count];
		int index = 0;
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			index += line.pointsCount;
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					index += len;
				}
				break;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
		NSMutableArray *arr_tmp = [NSMutableArray arrayWithCapacity:0];

		for (int i = 0; i < size; i++) 
		{
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			[arr addObject:line.title];
			memcpy(points + index, line.points, line.pointsCount * sizeof(BMKMapPoint));
			index += line.pointsCount;
			[arr_tmp addObject:line.tip];			
			route = [plan.routes objectAtIndex:i+1];
			[arr_tmp addObject:route.tip];			
	  }
		NSMutableString *str = [NSMutableString stringWithCapacity:0];
		NSMutableString *str_tmp = [NSMutableString stringWithCapacity:0];

		for (int i = 0; i < [arr count]; i++) 
		{
			if (i == [arr count]- 1)
			{
				[str appendFormat:@"%@  %@",[arr objectAtIndex:i],distanceAndTime];
			}
			else 
			{
				[str appendFormat:@"%@ -->",[arr objectAtIndex:i]];
			}
		}
		[transit_line addObject:str];
		
		for (int i = 0; i < [arr_tmp count]; i++) 
		{
			if (i == [arr_tmp count]- 1)
			{
				[str_tmp appendFormat:@"%@",[arr_tmp objectAtIndex:i]];
			}
			else 
			{
				[str_tmp appendFormat:@"%@,",[arr_tmp objectAtIndex:i]];
			}
		}
		[transit_detail addObject:str_tmp];
   }
	
	[self.tableView reloadData];
}
- (void) setDriveData
{
	if (![drive_plan count])
	{
		return;
	}
	
	if ([drive_line count])
	{
		[drive_line removeAllObjects];
	}
	BMKRoutePlan* plan = (BMKRoutePlan*)[drive_plan objectAtIndex:0];
	
	int distance = plan.distance/1000;
	int hour = distance/driveSpeed;
	int min = ((distance%driveSpeed) *60)/driveSpeed;
	int mine = (((plan.distance/100)%walkSpeed) *60)/walkSpeed;

	if (plan.distance/1000 == 0)
	{
        if (plan.distance/100 == 0)
        {
            driveTips = [NSString stringWithFormat:@"约:%d0米/少于1分钟",plan.distance/10];
        }
        else
        {
            driveTips = [NSString stringWithFormat:@"约:%d00米/%d分钟",plan.distance/100,mine];
        }

	}
	else
	{
		driveTips = [NSString stringWithFormat:@"约:%d公里/%d小时%d分钟",distance,hour,min];
	}

	int index = 0;
	int size = [plan.routes count];
	for (int i = 0; i < 1; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			index += len;
		}
	}
	
	BMKMapPoint* points = new BMKMapPoint[index];
	index = 0;
	
	for (int i = 0; i < 1; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
			memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
			index += len;
		}
		size = route.steps.count;
		for (int j = 0; j < size - 1; j++) {
			BMKStep* step = [route.steps objectAtIndex:j];
			[drive_line addObject:step.content];
		}
	}
	delete []points;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView reloadData];
}

- (void) setWalkData
{
	if (![walk_plan count])
	{
		return;
	}
    
    if ([walk_line count])
	{
		[walk_line removeAllObjects];
	}

	BMKRoutePlan* plan = (BMKRoutePlan*)[walk_plan objectAtIndex:0];
	

	int distance = plan.distance/1000;
	int hour = distance/walkSpeed;
	int min = ((distance%walkSpeed) *60)/walkSpeed;
	int mine = (((plan.distance/100)%walkSpeed) *60)/walkSpeed;
    
	if (plan.distance/1000 == 0)
	{
        if (plan.distance/100 == 0)
        {
            walkTips = [NSString stringWithFormat:@"约:%d0米/少于1分钟",plan.distance/10];
        }
        else
        {
            walkTips = [NSString stringWithFormat:@"约:%d00米/%d分钟",plan.distance/100,mine];
        }
	}
	else 
	{
		walkTips = [NSString stringWithFormat:@"约:%d公里/%d小时%d分钟",distance,hour,min];
	}

	int index = 0;
	int size = [plan.routes count];
	for (int i = 0; i < 1; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			index += len;
		}
	}
	
	BMKMapPoint* points = new BMKMapPoint[index];
	index = 0;
	
	for (int i = 0; i < 1; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
			memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
			index += len;
		}
		size = route.steps.count;
		for (int j = 0; j < size - 1; j++) {
			BMKStep* step = [route.steps objectAtIndex:j];
			[walk_line addObject:step.content];
		}
		
	}
	delete []points;
	[self.tableView reloadData];
}

- (void) btn_cancel_click:(id)sender
{
	[self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
}

- (void) btn_certain_click:(id)sender
{
	UIPickerView *pickerView = (UIPickerView *)[actionSheet viewWithTag:102];
	[self performSelector:@selector(actionSheet:clickedButtonAtIndex:) withObject:0];
	
	switch (src_type) 
	{
		case 0:
			policy_type = [pickerView selectedRowInComponent:0];
			[self searchDriveData];
			break;
		case 1:
		{
			switch ([pickerView selectedRowInComponent:0]) 
			{
				case 0:
					policy_type = 3;
					break;
				case 1:
					policy_type = 4;
					break;
				case 2:
					policy_type = 5;
					break;
				case 3:
					policy_type = 6;
					break;
				default:
					break;
			}
			[self searchTransitData];
		}
	}
}

- (void) btn_sort_click:(id)sender
{
	NSString *title =  @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
	actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	actionSheet.tag = 103;
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tableView];
	UIPickerView *pickerView = [[UIPickerView alloc] init];
	pickerView.frame = CGRectMake(20.0f,50.0f, 280.0f, 216.0f);
	pickerView.tag = 102;
	pickerView.delegate = self;
	pickerView.dataSource = self;
	pickerView.showsSelectionIndicator = YES;
	[actionSheet addSubview:pickerView];
	[actionSheet addSubview:tool_bar];
}

- (void) btn_back_click:(id)sender
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];

    if (!start)
    {
        if (delegate && [delegate respondsToSelector:@selector(didFinishSortWithDictionary:)])
        {
            [delegate performSelector:@selector(didFinishSortWithDictionary:) withObject:dict];
        }
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 5.0)
        {
            [self dismissModalViewControllerAnimated:YES];
        }
        else
        {
            [self.parentViewController dismissModalViewControllerAnimated:YES];
        }

        return;
    }
	NSString *type = [NSString stringWithFormat:@"%d",src_type ];
	if (self.drive_plan)
	{
		[dict setObject:[self.drive_plan objectAtIndex:0] forKey:@"drive_plan"];
	}
	if (self.transitRoute_plan)
	{
		[dict setObject:self.transitRoute_plan  forKey:@"transitRoute_plan"];
	}
	if (self.walk_plan)
	{
		[dict setObject:[self.walk_plan objectAtIndex:0] forKey:@"walk_plan"];
	}
	[dict setObject:type forKey:@"src_type"];
	[dict setObject:self.start forKey:@"start"];
	[dict setObject:[NSString stringWithFormat:@"%d",search.drivingPolicy ] forKey:@"drivingPolicy"];
	[dict setObject:[NSString stringWithFormat:@"%d",search.transitPolicy ] forKey:@"transitPolicy"];

	if (delegate && [delegate respondsToSelector:@selector(didFinishSortWithDictionary:)])
	{
		[delegate performSelector:@selector(didFinishSortWithDictionary:) withObject:dict];
	}
	
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 5.0)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self.parentViewController dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark RWLocationSelectContollerDelegate

- (void)locationDidSelectWithDic:(NSMutableDictionary *)dic
{
	self.start.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
	CLLocationCoordinate2D startPt = (CLLocationCoordinate2D){0, 0};
	startPt = (CLLocationCoordinate2D){[[dic objectForKey:@"lat"] floatValue], [[dic objectForKey:@"lng"] floatValue]};
    self.start.pt = startPt;
	self.saddr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
	
	switch (src_type) 
	{
		case 0:
			[self performSelector:@selector(searchDriveData) withObject:nil afterDelay:0.5];
			break;
		case 1:
			[self performSelector:@selector(searchTransitData) withObject:nil afterDelay:0.5];
			break;
		case 2:
			[self performSelector:@selector(searchWalkData) withObject:nil afterDelay:0.5];
			break;
		default:
			break;
	}
}

@end
