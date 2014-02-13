//
//  UsrProfileListController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-12.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsrProfileListController : UITableViewController
{
    IBOutlet UIView                 *head_view;
    IBOutlet UIImageView            *im_avatar;
    IBOutlet UILabel                *lb_name;
    IBOutlet UILabel                *lb_server_no;
    IBOutlet UILabel                *lb_district;
    IBOutlet UIButton               *btn_change;
    
    UIBarButtonItem                 *btn_edit;
    UIBarButtonItem                 *btn_back;

    UIButton                        *btn_fold;
    UIImageView                     *im_fold;
    NSMutableArray                  *buffer;
    NSMutableDictionary             *dict;
    
    UIImageView                     *iv_usr_bg;
    UIImageView                     *iv_car_bg;
    UILabel                         *lb_car_detail;
    UILabel                         *lb_usr_detail;
    
    BOOL                            is_loading;
    BOOL                            is_check;
    
    BOOL                            is_logout;

    BOOL                            is_usr_fold;
    BOOL                            is_car_fold;
    BOOL                            is_app_fold;


}

@property(nonatomic,strong)UIView *head_view;
@property(nonatomic,strong)UIImageView *im_avatar;
@property(nonatomic,strong)UILabel *lb_name;
@property(nonatomic,strong)UILabel *lb_server_no;
@property(nonatomic,strong)UILabel *lb_district;
@property(nonatomic,strong)UIButton *btn_change;

- (IBAction)btn_change_click:(id)sender;

- (void)btn_edit_click:(id)sender;

- (void)btn_back_click:(id)sender;

- (void)btn_fold_click:(id)sender;

- (void)loadData;

- (void)onLoadData:(NSNotification *)notify;

- (void)onLoadFail:(NSNotification *)notify;

@end
