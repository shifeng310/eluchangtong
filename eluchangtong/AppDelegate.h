//
//  AppDelegate.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-5.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "AHAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{
    BOOL                      is_save;
    BOOL                      is_active;

    BOOL                      is_reg;
    BOOL                      is_loading;
    NSString                  *password;
    NSString                  *service_no;
    NSString                  *service_number;
    NSMutableArray            *tips_arr;
    NSString                  *pushToken;
    NSMutableArray            *arr;
    __weak AHAlertView               *alert;
    id					    __unsafe_unretained delegate;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *pushToken;
@property (nonatomic, unsafe_unretained) id delegate;

+ (AppDelegate *) getInstance;

- (void) checkToken;

- (void) reg;

- (void) onReg:(NSNotification *)notify;

- (void) login;

- (void) onLogin:(NSNotification *)notify;

- (void) onFail:(NSNotification *)notify;

- (void)applyCustomAlertAppearance;


@end
