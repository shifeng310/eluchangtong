//
//  PoiViewController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "BMKMapView.h"
#import "NavController.h"

@interface PoiViewController : UIViewController <BMKMapViewDelegate,BMKSearchDelegate,UIActionSheetDelegate>
{
    IBOutlet BMKMapView      *map_view;
    IBOutlet UIButton        *btn_poi;

    NSMutableArray           *poi_buffer;
    CLLocationDegrees		 latitude;
	CLLocationDegrees		 longitude;
    BMKPointAnnotation       *annotation;
    BOOL                     is_loading;
    BOOL                     is_ploy;
    BOOL                     is_car_poi;
    BOOL                     is_send;
    BOOL                     is_friend;

    NSTimer                  *timer;
    UIBarButtonItem          *btn_history;
    
    UISegmentedControl       *sg_ctrl;
    IBOutlet UILabel         *lb_poi;
	IBOutlet UILabel		 *lb_des;
    IBOutlet UIView		     *head_view;

    IBOutlet UILabel         *lb_car_poi;
    IBOutlet UIButton        *btn_send;
    
    IBOutlet UIView          *bubble_view;
    IBOutlet UIImageView     *seg_view;

    BMKPlanNode				 *start;
	BMKPlanNode				 *end;
    BMKSearch				 *search;
    BMKAnnotationView        *selectedAV;
    CGPoint                  point;
    NavController            *nav;
	NSUInteger					policy_type;
	NSMutableArray			    *transitRoute_plan;
	NSMutableArray				*drive_plan;
	NSMutableArray				*walk_plan;
	NSString					*current_lat;
	NSString					*current_lng;
	NSString					*saddr;
	NSString					*daddr;
    NSString					*car_poi;
	NSString					*car_city_name;
    NSString					*current_city_name;
	NSString					*annotation_title;

    

}

@property(nonatomic,strong)BMKMapView *map_view;
@property(nonatomic,strong)UIButton *btn_poi;
@property(nonatomic,strong)UILabel *lb_poi;
@property(nonatomic,strong)UILabel *lb_des;
@property(nonatomic,strong)UIView *head_view;

@property(nonatomic,strong)UILabel *lb_car_poi;
@property(nonatomic,strong)UIButton *btn_send;
@property(nonatomic,strong)UIView *bubble_view;
@property(nonatomic,strong)UIImageView *seg_view;
    
@property (nonatomic, strong) BMKPlanNode *start;
@property (nonatomic, strong) BMKPlanNode *end;
@property (nonatomic, strong) NSMutableArray *transitRoute_plan;
@property (nonatomic, strong) NSMutableArray *drive_plan;
@property (nonatomic, strong) NSMutableArray *walk_plan;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *saddr;
@property (nonatomic, copy) NSString *daddr;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *current_lat;
@property (nonatomic, copy) NSString *current_lng;

- (void)loadData;

- (void)onLoadData:(NSNotification *)notify;

- (void)btn_history_click:(id)sender;

- (IBAction)btn_send_click:(id)sender;

@end
