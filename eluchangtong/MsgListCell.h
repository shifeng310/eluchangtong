//
//  MsgListCell.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-8.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgListCell : UITableViewCell
{
    IBOutlet UILabel             *lb_title;
    IBOutlet UILabel             *lb_time;
    IBOutlet UILabel             *lb_content;
}

@property (nonatomic,strong)UILabel *lb_title;
@property (nonatomic,strong)UILabel *lb_time;
@property (nonatomic,strong)UILabel *lb_content;

+ (CGFloat) calCellHeight:(NSDictionary *)data;

- (void) setContent:(NSDictionary *)data;

@end
