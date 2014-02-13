//
//  RWUsrEditCell.h
//  RW
//
//  Created by fang honghao on 12-4-1.
//  Copyright (c) 2012年 roadrover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWUsrEditCell : UITableViewCell
{
	UIImageView				*im_avatar;
	UILabel					*lb_name;
}

@property (nonatomic,strong)IBOutlet UIImageView *im_avatar;
@property (nonatomic,strong)IBOutlet UILabel *lb_name;

- (void) setAvatar:(UIImage *)avatar;

+ (CGFloat) calCellHeight:(NSDictionary *)data;


@end
