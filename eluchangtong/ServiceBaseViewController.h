//
//  ServiceBaseViewController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-15.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceBaseViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIButton               *btn_type;
    IBOutlet UIButton               *btn_select;
    IBOutlet UIImageView            *im_baoyang_bg;
    IBOutlet UIImageView            *im_baoxian_bg;
    IBOutlet UIImageView            *im_nianjian_bg;
    IBOutlet UIImageView            *im_chaosu_bg;
    IBOutlet UIView                 *head_view;
    IBOutlet UIImageView            *head_view_bg;
    IBOutlet UIImageView            *btn_baoyang_gouxuan_bg;
    IBOutlet UIImageView            *btn_baoxian_gouxuan_bg;
    IBOutlet UIImageView            *btn_nianjian_gouxuan_bg;
    IBOutlet UIImageView            *btn_chaosu_gouxuan_bg;
    IBOutlet UIView                 *baoyang_view;
    IBOutlet UILabel                *lb_current_mile;
    IBOutlet UILabel                *lb_next_mile;
    IBOutlet UILabel                *lb_baoyang_time;
    IBOutlet UILabel                *lb_error;

    IBOutlet UIButton                *btn_yibaoyang;
    IBOutlet UIButton                *btn_baoxian_save;
    IBOutlet UIButton                *btn_nianjian_save;
    IBOutlet UIButton                *btn_chaosu_save;
    
    IBOutlet UITextField             *tf_company;
    IBOutlet UITextField             *tf_time;
    IBOutlet UIView                  *baoxian_view;
    
    IBOutlet UILabel                 *lb_next_time;
    IBOutlet UITextField             *tf_buytime;
    IBOutlet UIView                  *nianjian_view;
    
    IBOutlet UITextField             *tf_speed;
    IBOutlet UIView                  *chaosu_view;
    
    IBOutlet UIPickerView            *pickerView;
    
    IBOutlet UIToolbar               *tool_bar;
    IBOutlet UIBarButtonItem         *btn_certain;

    
    NSUInteger                         type;
    NSString                         *insurance_company;
    NSString                         *insurance_date;
    NSString                         *insurance_tag;
    NSString                         *check_date;
    NSString                         *check_tag;
    NSString                         *hypervelocity;
    NSString                         *hypervelocity_tag;
    NSString                         *curr_mileage;
    NSString                         *mileage_spacing;
    NSString                         *maintain_data;
    NSString                         *maintain_spacing;
    NSString                         *maintain_tag;
    NSString                         *updatetime;
    NSUInteger                       nextCheckDate;
    UITextField                      *active_textField;
    
    
    IBOutlet UIView                  *alert_view;
    IBOutlet UITextField             *tf_curr_mileage;
    IBOutlet UITextField             *tf_mileage_spacing;
    IBOutlet UILabel                 *lb_curr_data;
    IBOutlet UILabel                 *lb_maintain_spacing;
    IBOutlet UIImageView             *alert_bg_im;
    UIWindow                         *alertWindow;
    UIWindow                         *previousKeyWindow;
    BOOL                             hasLayedOut;
    BOOL                             keyboardIsVisible;
	BOOL                             isDismissing;
    BOOL                             is_change;
    BOOL                             is_baoyang_notice;
    BOOL                             is_baoxian_notice;
    BOOL                             is_chaosu_notice;
    BOOL                             is_nianjian_notice;
	CGFloat                          keyboardHeight;
    
    NSDictionary                    *serv_data;
    UIActionSheet                   *actionSheet;
    
    UIToolbar                       *tool_bar_tmp;
    UIBarButtonItem                 *btn_certain_tmp;
    UIBarButtonItem                 *btn_cancel;
    UIBarButtonItem                 *btn_title;




}

@property(nonatomic,strong)UIToolbar *tool_bar;
@property(nonatomic,strong)UIBarButtonItem *btn_certain;
@property(nonatomic,strong)UIButton *btn_type;
@property(nonatomic,strong)UIButton *btn_select;
@property(nonatomic,strong)UIButton *btn_yibaoyang;
@property(nonatomic,strong)UIButton *btn_baoxian_save;
@property(nonatomic,strong)UIButton *btn_nianjian_save;
@property(nonatomic,strong)UIButton *btn_chaosu_save;
@property(nonatomic,strong)UIImageView *im_baoyang_bg;
@property(nonatomic,strong)UIImageView *im_baoxian_bg;
@property(nonatomic,strong)UIImageView *im_nianjian_bg;
@property(nonatomic,strong)UIImageView *im_chaosu_bg;
@property(nonatomic,strong)UIImageView *head_view_bg;
@property(nonatomic,strong)UIImageView *btn_baoyang_gouxuan_bg;
@property(nonatomic,strong)UIImageView *btn_baoxian_gouxuan_bg;
@property(nonatomic,strong)UIImageView *btn_nianjian_gouxuan_bg;
@property(nonatomic,strong)UIImageView *btn_chaosu_gouxuan_bg;

@property(nonatomic,strong)UIView *head_view;

@property(nonatomic,strong)UIView *baoyang_view;
@property(nonatomic,strong)UILabel *lb_current_mile;
@property(nonatomic,strong)UILabel *lb_next_mile;
@property(nonatomic,strong)UILabel *lb_baoyang_time;
@property(nonatomic,strong)UILabel *lb_error;

@property(nonatomic,strong)UIView *baoxian_view;
@property(nonatomic,strong)UITextField *tf_time;
@property(nonatomic,strong)UITextField *tf_company;

@property(nonatomic,strong)UIView *nianjian_view;
@property(nonatomic,strong)UILabel *lb_next_time;
@property(nonatomic,strong)UITextField *tf_buytime;

@property(nonatomic,strong)UIView *chaosu_view;
@property(nonatomic,strong)UITextField *tf_speed;

@property(nonatomic,strong)UIView *alert_view;
@property(nonatomic,strong)UITextField *tf_curr_mileage;
@property(nonatomic,strong)UITextField *tf_mileage_spacing;
@property(nonatomic,strong)UIImageView *alert_bg_im;
@property(nonatomic,strong)UILabel *lb_maintain_spacing;
@property(nonatomic,strong)UILabel *lb_curr_data;
@property(nonatomic,strong)UIPickerView *pickerView;

- (IBAction)btn_click:(id)sender;

- (IBAction)btn_certain_click:(id)sender;

- (IBAction)btn_notice_click:(id)sender;

- (IBAction)btn_save_click:(id)sender;

- (IBAction)btn_alert_click:(id)sender;

- (IBAction)btn_select_click:(id)sender;

@end
