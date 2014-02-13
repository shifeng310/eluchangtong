//
//  UsrChangePassViewController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsrChangePassViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField            *tf_old_password;
    IBOutlet UITextField            *tf_new_password;
    IBOutlet UITextField            *tf_certain_password;
    IBOutlet UIButton               *btn_certain;
    NSString                        *server_num;
}

- (IBAction)btn_click:(id)sender;

@end
