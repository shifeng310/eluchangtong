//
//  RWTrafficDetailController.h
//  RW
//
//  Created by Xiuhu Fu on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "NavController.h"
@interface RWTrafficDetailController : UITableViewController<BMKSearchDelegate,UIActionSheetDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
{
	BMKSearch					*search;
	BMKPlanNode					*start;
	BMKPlanNode					*end;
    NavController               *nav;
	UISegmentedControl		    *sg_switch;
	NSMutableArray			    *transitRoute_plan;
	NSMutableArray				*drive_plan;
	NSMutableArray				*walk_plan;
	NSMutableArray				*drive_line;
	NSMutableArray				*walk_line;
	NSMutableArray				*transit_line;
	NSMutableArray				*transit_detail;
	NSString					*saddr;
	NSString					*daddr;
	NSString					*city_name;
	NSUInteger					src_type;
	NSUInteger					policy_type;
	NSUInteger					current_section;
	UILabel						*lb_saddr;
	UILabel						*lb_daddr;
	UIToolbar					*tool_bar;
	UIBarButtonItem				*btn_cancel;
	UIBarButtonItem				*btn_certain;
	UIBarButtonItem				*btn_sort;
	UIBarButtonItem				*btn_back;
	UIActionSheet               *actionSheet;
	NSString					*driveTips;
	NSString					*walkTips;

	id							__unsafe_unretained delegate;
	BOOL					    is_info_cell_expanded;
}

@property (nonatomic, strong) BMKPlanNode *start;
@property (nonatomic, strong) BMKPlanNode *end;
@property (nonatomic, strong) NSMutableArray *transitRoute_plan;
@property (nonatomic, strong) NSMutableArray *drive_plan;
@property (nonatomic, strong) NSMutableArray *walk_plan;
@property (nonatomic, copy) NSString *saddr;
@property (nonatomic, copy) NSString *daddr;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, unsafe_unretained) id delegate;

- (void) setTransitData;

- (void) setDriveData;

- (void) setWalkData;

- (void) searchTransitData;

- (void) searchDriveData;

- (void) searchWalkData;

- (void) btn_cancel_click:(id)sender;

- (void) btn_certain_click:(id)sender;

- (void) btn_back_click:(id)sender;

@end
