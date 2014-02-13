//
//  RemoteViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-19.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "RemoteViewController.h"

@interface RemoteViewController ()

@end

@implementation RemoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"车内遥控器";
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];

    UILabel *lb_no_data = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 44)];
	lb_no_data.font = [UIFont fontWithName:@"Arial" size:25.0f];
	lb_no_data.backgroundColor = [UIColor clearColor];
	lb_no_data.text = @"暂不可用";
	lb_no_data.textColor = [UIColor lightGrayColor];
	lb_no_data.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:lb_no_data];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
