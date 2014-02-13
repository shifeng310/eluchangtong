//
//  PoiListViewController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoiListViewController : UITableViewController
{
    BOOL					 is_more;
    BOOL                     is_loading;
    BOOL                     is_fail;
    BOOL                     is_select;

    NSUInteger               action_type;
    NSUInteger               page;
    NSMutableArray           *buffer;
    NSString                 *stime;
    NSString                 *etime;
    NSString                 *mintime;
    NSString                 *maxtime;

    NSString                 *detail_date;

    UIBarButtonItem          *btn_select;

    id					    __unsafe_unretained delegate;

}

@property (nonatomic, unsafe_unretained) id delegate;

- (void) fethNew;

- (void) onFethNew:(NSNotification *)notify;

- (void) fethDetail;

- (void) onFethDetail:(NSNotification *)notify;

- (void) btn_select_click:(id)sender;


@end
