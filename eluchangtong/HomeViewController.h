//
//  HomeViewController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-5.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UIActionSheetDelegate>
{
    IBOutlet UIImageView      *im_bg;
    IBOutlet UILabel          *lb_tips;
    IBOutlet UIButton         *btn_tel;
    IBOutlet UIButton         *btn_nav;
    IBOutlet UIButton         *btn_serv;
    IBOutlet UIButton         *btn_poi;
    IBOutlet UIButton         *btn_note;
    IBOutlet UIButton         *btn_remote;
    IBOutlet UIButton         *btn_msg;
    IBOutlet UIButton         *btn_no;
    IBOutlet UIButton         *btn_set;
    
    IBOutlet UILabel          *lb_tel;
    IBOutlet UILabel          *lb_nav;
    IBOutlet UILabel          *lb_serv;
    IBOutlet UILabel          *lb_poi;
    IBOutlet UILabel          *lb_note;
    IBOutlet UILabel          *lb_remote;
    IBOutlet UILabel          *lb_msg;
    UILabel                   *lb_no;
    BOOL                      is_init;
    NSString                  *tel;
    NSMutableArray            *tips_arr;
    NSMutableArray            *msgs_arr;
    NSMutableArray            *notice_arr;

    NSTimer                   *timer;
    NSUInteger                index;

}

@property(nonatomic,strong)UIImageView *im_bg;
@property(nonatomic,strong)UILabel *lb_tips;
@property(nonatomic,strong)UIButton *btn_tel;
@property(nonatomic,strong)UIButton *btn_nav;
@property(nonatomic,strong)UIButton *btn_serv;
@property(nonatomic,strong)UIButton *btn_poi;
@property(nonatomic,strong)UIButton *btn_note;
@property(nonatomic,strong)UIButton *btn_remote;
@property(nonatomic,strong)UIButton *btn_msg;
@property(nonatomic,strong)UIButton *btn_no;
@property(nonatomic,strong)UIButton *btn_set;
@property(nonatomic,strong)UILabel *lb_tel;
@property(nonatomic,strong)UILabel *lb_nav;
@property(nonatomic,strong)UILabel *lb_serv;
@property(nonatomic,strong)UILabel *lb_poi;
@property(nonatomic,strong)UILabel *lb_note;
@property(nonatomic,strong)UILabel *lb_remote;
@property(nonatomic,strong)UILabel *lb_msg;
@property(nonatomic,copy)NSMutableArray *tips_arr;

- (IBAction)btn_click:(id)sender;

- (IBAction)btn_touch:(id)sender;

- (IBAction)btn_touch_cancl:(id)sender;

- (IBAction)btn_no_click:(id)sender;

- (IBAction)btn_set_click:(id)sender;

- (void)initSystem;

- (void)onInitSystem:(NSNotification *)notify;

- (void)setTipsLable;

- (void) setTipsArr:(NSMutableArray *)arr;

- (void) setMsgsArr:(NSMutableArray *)arr;

@end
