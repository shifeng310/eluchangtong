//
//  DriveRecordListController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriveRecordListController : UITableViewController
{
    IBOutlet UIButton               *btn_type;
    IBOutlet UIImageView            *im_today_bg;
    IBOutlet UIImageView            *im_yestoday_bg;
    IBOutlet UIImageView            *im_week_bg;
    IBOutlet UIImageView            *im_month_bg;
    IBOutlet UIImageView            *im_year_bg;

    IBOutlet UIView                 *head_view;
    IBOutlet UIImageView            *head_view_bg;
    NSMutableDictionary             *totaldata;
    NSMutableArray                  *datalist;
    UILabel                         *lb_base;
    UILabel                         *lb_msg;
    BOOL                            is_loading;
    NSString                        *type;
}

@property(nonatomic,strong)UIButton *btn_type;
@property(nonatomic,strong)UIImageView *im_today_bg;
@property(nonatomic,strong)UIImageView *im_yestoday_bg;
@property(nonatomic,strong)UIImageView *im_week_bg;
@property(nonatomic,strong)UIImageView *im_month_bg;
@property(nonatomic,strong)UIImageView *im_year_bg;
@property(nonatomic,strong)UIImageView *head_view_bg;
@property(nonatomic,strong)UIView *head_view;

- (void)loadData;

- (void)onLoadData:(NSNotification *)nofify;

- (IBAction)btn_click:(id)sender;

@end
