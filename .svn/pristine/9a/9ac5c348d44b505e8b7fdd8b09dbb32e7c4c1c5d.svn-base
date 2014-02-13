//
//  PoiListCell.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-6.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoiListCell : UITableViewCell<UIActionSheetDelegate>
{
    IBOutlet  UIImageView       *im_poi;
    IBOutlet  UILabel           *lb_poi;
    IBOutlet  UILabel           *lb_name;
    IBOutlet  UILabel           *lb_addr;
    IBOutlet  UIButton          *btn_send;
    IBOutlet  UIButton          *btn_save;
    NSMutableArray              *arr;
    NSMutableDictionary         *dic;
    
}

@property (nonatomic, strong) UIImageView *im_poi;;
@property (nonatomic, strong) UILabel *lb_poi;
@property (nonatomic, strong) UILabel *lb_name;
@property (nonatomic, strong) UILabel *lb_addr;
@property (nonatomic, strong) UIButton *btn_send;
@property (nonatomic, strong) UIButton *btn_save;

+ (CGFloat) calCellHeight:(NSDictionary *)data;

- (void) setContent:(NSDictionary *)data;

- (void) setBuffer:(NSMutableArray *)buffer;

- (IBAction)btn_send_click:(id)sender;

- (IBAction)btn_save_click:(id)sender;


@end
