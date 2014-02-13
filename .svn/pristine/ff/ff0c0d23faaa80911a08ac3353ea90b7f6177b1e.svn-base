//
//  MsgListController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-8.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface MsgListController : UITableViewController <UIActionSheetDelegate>
{
    BOOL					 is_more;
    BOOL                     is_loading;
    BOOL                     is_fail;
    NSUInteger               action_type;
    NSString                 *maxid;
    NSString                 *minid;

    NSMutableArray           *buffer;
    UIBarButtonItem          *btn_edit;
    UIBarButtonItem          *btn_clear;
    EGORefreshTableHeaderView *refreshHeaderView;
    EGORefreshTableHeaderView *refreshHeaderView_bottom;


}

- (void) fethNew;

- (void) onFethNew:(NSNotification *)notify;

- (void) onFethFail:(NSNotification *)notify;

- (void) btn_edit_click:(id)sender;

- (void) btn_clear_click:(id)sender;

@end
