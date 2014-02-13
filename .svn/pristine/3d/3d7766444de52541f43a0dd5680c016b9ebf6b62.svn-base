//
//  UsrProfileEditController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-12.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsrProfileEditController : UITableViewController<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UIActionSheetDelegate>
{
    NSMutableDictionary             *dict;
    UIImageView                     *im_xingbie;
    UIButton                        *btn_xingbie;
    UITextField                     *tf_usr;
    UITextField                     *tf_car;
    UITextField                     *active_field;

    UIBarButtonItem                 *btn_save;
    UIBarButtonItem                 *btn_back;
    UIImage                         *im_avatar;
    UIButton                        *btn_gg;
	UIButton                        *btn_mm;
	UIImageView                     *iv_man;
	UIImageView                     *iv_woman;
    UILabel                         *lb_gg;
    UILabel                         *lb_mm;
    BOOL                            is_txt_change;
    BOOL                            is_change;
    BOOL                            is_birthday;
    BOOL                            is_cancel;
    NSData                          *data_avatar;
    NSString                        *nickname;
    NSString                        *sex;
    NSString                        *tel_num;
    NSString                        *email;
    NSString                        *birthday;
    NSString                        *birthday_tmp;
    NSString                        *address;
    NSString                        *chepai;
    NSString                        *pingpai;
    NSString                        *pailiang;
    NSString                        *shebeihao;
    NSString                        *chejiahao;
    NSString                        *goumairiqi;
    NSString                        *goumairiqi_tmp;
    NSString                        *yanse;
    NSString                        *name;
    UIActionSheet                   *actionSheet;
    
    UIToolbar                       *tool_bar;
    UIBarButtonItem                 *btn_certain;
    UIBarButtonItem                 *btn_cancel;
    UIBarButtonItem                 *btn_title;



}

@property(nonatomic,copy)NSMutableDictionary *dict;

- (void)saveData;

- (void)onSaveData:(NSNotification *)notify;

- (void)btn_save_click:(id)sender;

- (void)btn_back_click:(id)sender;

- (void)btn_certain_click:(id)sender;

- (void)btn_cancel_click:(id)sender;

- (void) setUserProfile:(NSDictionary *)data;

@end
