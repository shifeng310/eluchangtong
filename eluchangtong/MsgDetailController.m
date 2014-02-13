//
//  MsgDetailController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-9.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "MsgDetailController.h"
#import "MsgDetailCell.h"

@implementation MsgDetailController
@synthesize dic;

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
    self.title = @"消息详情";
	[self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background_view.png"]]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor lightGrayColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [dic count])
	{
		static NSString *cell_id = @"empty_cell";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
		if (nil == cell)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
		}
		
		UIFont *font = [UIFont systemFontOfSize:15.0f];
		cell.textLabel.text = @"暂无数据";
		cell.textLabel.font = font;
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}

    static NSString *CellIdentifier = @"MsgDetailCell";
    MsgDetailCell *cell = (MsgDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        
        cell = (MsgDetailCell *)uc.view;
        [cell setContent:dic];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([dic count] == 0)
	{
		return  44.0f;
	}
	return [MsgDetailCell calCellHeight:dic];
}

@end
