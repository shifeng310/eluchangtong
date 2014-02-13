//
//  NavBaseViewController.h
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-5.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BMapKit.h"
#import "BMKMapView.h"
#import "HZAreaPickerView.h"
#import "EGORefreshTableHeaderView.h"

@interface NavBaseViewController : UIViewController<BMKMapViewDelegate,BMKSearchDelegate,UITextFieldDelegate,HZAreaPickerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIAccelerometerDelegate,CLLocationManagerDelegate>
{
    IBOutlet BMKMapView      *map_view;
    IBOutlet UIView          *head_view;
    IBOutlet UIView          *button_view;
    IBOutlet UIView          *bubble_view;
    IBOutlet UIButton        *btn_hot;
    IBOutlet UIButton        *btn_send;
    IBOutlet UIButton        *btn_city;
    IBOutlet UIButton        *btn_search;
    IBOutlet UILabel         *lb_city;
    IBOutlet UILabel         *lb_poi_name;
    IBOutlet UITextField     *tf_poi;
    IBOutlet UIToolbar       *tool_bar;
    IBOutlet UIBarButtonItem        *btn_current_loc;
    IBOutlet UIBarButtonItem        *btn_certain;
    IBOutlet UIButton        *btn_poi;
    IBOutlet UIButton        *btn_save;
    IBOutlet UIButton        *btn_history;
    IBOutlet UIButton        *btn_area;
    IBOutlet UIImageView     *im_save;
    IBOutlet UIImageView     *im_history;
    IBOutlet UIImageView     *im_area;
    IBOutlet UITableView     *poi_tableView;
    IBOutlet UIView          *hot_view;
    IBOutlet UIScrollView    *scroll_View;
    
    IBOutlet UIScrollView    *search_scroll;
    IBOutlet UIView          *search_button_view;
    IBOutlet UIPageControl   *page_ctrl;

    UIBarButtonItem          *btn_list;

    UIBarButtonItem          *btn_edit;
    UIBarButtonItem          *btn_map;
    UIButton                 *btn_show;

    NSInteger                count;
	NSArray                  *titleArray;
	NSInteger                lasterTag;
	BOOL                     scroll_flag;
    NSDictionary             *hot_dict;
    BMKAnnotationView        *selectedAV;
    BMKPointAnnotation      *annotation;
    HZAreaPickerView         *locatePicker;
    CGPoint                  point;
    BMKSearch				 *search;
    CLLocationManager        *lm;
    NSString                 *key_text;
    NSString                 *current_lat;
    NSString                 *current_lng;
    NSString                 *current_poi;
    NSString                 *lat;
    NSString                 *lng;
    NSString                 *gpsLat;
    NSString                 *gpsLng;
    BOOL					 is_more;
    BOOL                     is_fail;
    BOOL                     is_search;
    BOOL                     is_save;
    BOOL                     is_history;
    BOOL                     is_hot;
    BOOL                     is_map_btn;
    BOOL                     is_longPress;
    BOOL                     is_friend;


    NSUInteger               action_type;
    NSUInteger               buffer_count;
    NSUInteger               current_index;
    BOOL					 is_loading;
    BOOL					 is_current;
    BOOL					 is_neaby;
    BOOL					 is_show;
    BOOL                     is_content;
    BOOL                     is_list;
    BOOL                     is_change;
    BOOL                     is_fetchNearby;

    NSMutableArray           *poi_buffer;
    NSDictionary             *poi_dic;
    NSDictionary             *dic_poi;
    UIImageView              *search_bar;
    
    CLLocationDegrees           poi_lat;
    CLLocationDegrees           poi_lng;

    EGORefreshTableHeaderView *refreshHeaderView;


}

@property (nonatomic,strong)BMKMapView *map_view;
@property (nonatomic,strong)UITableView *poi_tableView;
@property (nonatomic,strong)UIToolbar *tool_bar;
@property (nonatomic,strong)UIBarButtonItem *btn_current_loc;
@property (nonatomic,strong)UIBarButtonItem *btn_certain;
@property (nonatomic,strong)UIButton *btn_poi;
@property (nonatomic,strong)UIView *head_view;
@property (nonatomic,strong)UIView *button_view;
@property (nonatomic,strong)UIView *bubble_view;
@property (nonatomic,strong)UIView *hot_view;
@property (nonatomic,strong)UIView *scroll_View;
@property (nonatomic,strong)UIButton *btn_hot;
@property (nonatomic,strong)UIButton *btn_send;
@property (nonatomic,strong)UIButton *btn_city;
@property (nonatomic,strong)UILabel *lb_city;
@property (nonatomic,strong)UILabel *lb_poi_name;
@property (nonatomic,strong)UITextField *tf_poi;
@property (nonatomic,strong)UIButton *btn_save;
@property (nonatomic,strong)UIButton *btn_history;
@property (nonatomic,strong)UIButton *btn_area;
@property (nonatomic,strong)UIButton *btn_search;
@property (nonatomic,strong)UIImageView *im_save;
@property (nonatomic,strong)UIImageView *im_history;
@property (nonatomic,strong)UIImageView *im_area;
@property (nonatomic,strong)UIScrollView *search_scroll;
@property (nonatomic,strong)UIView *search_button_view;

- (IBAction)btn_city_click:(id)sender;

- (IBAction)btn_button_click:(id)sender;

- (IBAction)btn_search_click:(id)sender;

- (IBAction)btn_bubble_click:(id)sender;

- (IBAction)btn_tool_item:(id)sender;

- (void)btn_content_click:(id)sender;

- (IBAction)btn_poi_click:(id)sender;

- (IBAction)btn_list_click:(id)sender;

- (IBAction)btn_item_click:(id)sender;


@end
