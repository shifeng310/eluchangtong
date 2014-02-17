//
//  UsrTelViewController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-9.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsrTelViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UITextField         *tf_tel_4s;
    IBOutlet UITextField         *tf_tel_baoxian;
    IBOutlet UITextField         *tf_tel_jinji;
    IBOutlet UITextField         *tf_tel_gongsi;
    IBOutlet UITextField         *tf_tel_jiaren;
    IBOutlet UITextField         *tf_tel_qita;
 //   IBOutlet UIScrollView        *scrollView;
    IBOutlet UIView              *bg_view;


    UITextField                  *active_field;

    IBOutlet UIButton            *btn_tel;
    BOOL                         is_loading;
    BOOL                         is_4s;
    BOOL                         is_baoxian;
    BOOL                         is_jinji;
    BOOL                         is_gongsi;
    BOOL                         is_jiaren;
    BOOL                         is_qita;
    
    NSString                     *fours;
    NSString                     *baoxian;
    NSString                     *jinji;
    NSString                     *gongsi;
    NSString                     *jiaren;
    NSString                     *qita;
    NSString                     *tel_no;
    
    


    NSMutableArray               *buffer;
    UIBarButtonItem              *btn_back_item;
    UIBarButtonItem              *btn_save;
}

@property(nonatomic,strong)UITextField *tf_tel_4s;
@property(nonatomic,strong)UITextField *tf_tel_baoxian;
@property(nonatomic,strong)UITextField *tf_tel_jinji;
@property(nonatomic,strong)UITextField *tf_tel_gongsi;
@property(nonatomic,strong)UITextField *tf_tel_jiaren;
@property(nonatomic,strong)UITextField *tf_tel_qita;
@property(nonatomic,strong)UIButton *btn_tel;
//@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *bg_view;


- (void) fethNew;

- (void) onFethNew:(NSNotification *)notify;

- (IBAction)btn_tel_click:(id)sender;

- (void)btn_back_click:(id)sender;

- (void)btn_save_click:(id)sender;

@end
