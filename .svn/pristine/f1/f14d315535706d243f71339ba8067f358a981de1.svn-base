//
//  NavBaseViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-5.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NavBaseViewController.h"
#import "HZAreaPickerView.h"
#import "PoiListCell.h"
#import "RWShowView.h"
#import "RWAlertView.h"
#import "sqlService.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "RoadRover.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "AHAlertView.h"

@implementation NavBaseViewController
@synthesize map_view;
@synthesize btn_area;
@synthesize btn_city;
@synthesize btn_history;
@synthesize btn_save;
@synthesize lb_city;
@synthesize head_view;
@synthesize tf_poi;
@synthesize btn_search;
@synthesize im_area;
@synthesize im_history;
@synthesize im_save;
@synthesize button_view;
@synthesize bubble_view;
@synthesize btn_hot;
@synthesize btn_send;
@synthesize lb_poi_name;
@synthesize tool_bar;
@synthesize btn_certain;
@synthesize btn_current_loc;
@synthesize poi_tableView;
@synthesize hot_view;
@synthesize scroll_View;
@synthesize btn_poi;
@synthesize search_scroll;
@synthesize search_button_view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"导航目的地";
    
    poi_buffer = [NSMutableArray arrayWithCapacity:0];
    poi_dic = [NSDictionary dictionary];
    
    
     CGRect src_bounds = [UIScreen mainScreen].bounds;
    
    if (src_bounds.size.height == 568.0f)
    {
        button_view.frame = CGRectMake(0,458.0f,320,49);
        map_view.frame = CGRectMake(0.0f, 0.0f, 320.0f, map_view.frame.size.height + 87.0f);
        poi_tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, poi_tableView.frame.size.height + 87.0f);
        hot_view.frame = CGRectMake(0.0f, 0.0f, 320.0f, hot_view.frame.size.height + 87.0f);
        btn_poi.frame = CGRectMake(258.0f, 370, 48, 48);
    }
    
    else
    {
        button_view.frame = CGRectMake(0,370.0f,320,49);
    }
    
	[self.poi_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
    [self.view addSubview:button_view];
    
    CGRect top_rect = CGRectMake(0.0f, 0.0f - self.poi_tableView.bounds.size.height, 320.0f, self.poi_tableView.bounds.size.height);
	refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:top_rect];
	refreshHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]];
	[self.poi_tableView addSubview:refreshHeaderView];

    [self addMapView];
    
    search_bar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_bar_bg.png"]];
    search_bar.userInteractionEnabled = YES;
    search_bar.frame = CGRectMake(60.0f, 6.0f, 201.0f, 31);
    UITapGestureRecognizer *single_Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
    [search_bar addGestureRecognizer:single_Tap];
    [self.navigationController.navigationBar addSubview:search_bar];
    
    search_bar.layer.shadowOffset = CGSizeMake(1, -1);
    search_bar.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    search_bar.layer.shadowOpacity = 0.6;

    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(25.0f, 0.0f, 180.0f, 31.0f)];
    lb.text = @"请输入地址";
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor lightGrayColor];
    lb.font = [UIFont systemFontOfSize:14.0f];
    [search_bar addSubview:lb];

    map_view.delegate = self;
    map_view.showsUserLocation = YES;
    lb_city.text = @"定位中";
    is_current = YES;
    
    btn_edit = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_edit_click:)];
    
    btn_map = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_map_click:)];

    btn_list = [[UIBarButtonItem alloc]initWithTitle:@"列表" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_list_click:)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        map_view = nil;
        btn_area = nil;
        btn_city = nil;
        btn_history = nil;
        btn_save = nil;
        lb_city = nil;
        head_view = nil;
        tf_poi = nil;
        btn_search = nil;
        im_area = nil;
        im_history = nil;
        im_save = nil;
        button_view = nil;
        bubble_view = nil;
        btn_hot = nil;
        btn_send = nil;
        lb_poi_name = nil;
        tool_bar = nil;
        btn_certain = nil;
        btn_current_loc = nil;
        poi_tableView = nil;
        hot_view = nil;
        scroll_View = nil;
        btn_poi = nil;
        btn_list = nil;
    }
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [btn_show removeFromSuperview];
    [search_bar removeFromSuperview];
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shake" object:nil];
    if (lm)
    {
        lm.delegate = nil;
        lm = nil;
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [button_view removeFromSuperview];
    button_view = nil;
}

- (void)dealloc
{
    map_view.delegate = nil;
    search.delegate = nil;
    map_view = nil;
    head_view = nil;
    button_view = nil;
    bubble_view = nil;
    btn_hot = nil;
    btn_send = nil;
    btn_city = nil;
    btn_search = nil;
    lb_city = nil;
    lb_poi_name = nil;
    tf_poi = nil;
    tool_bar = nil;
    btn_current_loc = nil;
    btn_certain = nil;
    btn_poi = nil;
    btn_save = nil;
    btn_history = nil;
    btn_area = nil;
    im_save = nil;
    im_history = nil;
    im_area = nil;
    poi_tableView = nil;
    hot_view = nil;
    scroll_View = nil;
    btn_list = nil;
    btn_edit = nil;
    btn_map = nil;
    btn_show = nil;
	titleArray = nil;
    hot_dict = nil;
    selectedAV = nil;
    annotation = nil;
    locatePicker = nil;
    search = nil;
    poi_buffer = nil;
    poi_dic = nil;
    dic_poi = nil;
    search_bar = nil;
    refreshHeaderView = nil;
}

#pragma mark BMKMapDelegate
- (void)mapView:(BMKMapView *)MapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation != nil)
	{
		current_lat = [NSString stringWithFormat:@"%g",userLocation.location.coordinate.latitude];
		current_lng = [NSString stringWithFormat:@"%g",userLocation.location.coordinate.longitude];
		
		CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        if (!search)
        {
            search = [[BMKSearch alloc]init];
        }
		search.delegate = self;
		[search reverseGeocode:pt];
	}
	
    map_view.showsUserLocation = NO;
}

- (void)mapView:(BMKMapView *)MapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"fail");
    map_view.showsUserLocation = YES;

}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    if (error == 0)
    {
        NSArray* array = [NSArray arrayWithArray:map_view.annotations];
        [map_view removeAnnotations:array];
        array = [NSArray arrayWithArray:map_view.overlays];
        [map_view removeOverlays:array];
        
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
        if (is_longPress)
        {
            is_longPress = NO;
            if (result.strAddr)
            {
                item.title = result.strAddr;
            }
            else
            {
                item.title = @"未找到该点地址";
            }
        }
        else
        {
            item.title = @"当前位置";
        }
		[map_view addAnnotation:item];
        
        lb_city.text = result.addressComponent.city;
        current_poi = result.addressComponent.city;

        [map_view setCenterCoordinate:result.geoPt animated:YES];
		BMKCoordinateRegion region;
		region.center.latitude  = result.geoPt.latitude;
		region.center.longitude = result.geoPt.longitude;
		map_view.region   = region;
    
        if (result.addressComponent.streetName)
        {
                dic_poi = @{@"name" :result.addressComponent.streetName ,@"addr":result.strAddr,@"lat":[NSString stringWithFormat:@"%g",result.geoPt.latitude],@"lng":[NSString stringWithFormat:@"%g",result.geoPt.longitude],@"city":current_poi};
        }
        else
        {
                dic_poi = @{@"name" :result.addressComponent.city ,@"addr":result.strAddr,@"lat":[NSString stringWithFormat:@"%g",result.geoPt.latitude],@"lng":[NSString stringWithFormat:@"%g",result.geoPt.longitude],@"city":current_poi};
        }
        
        if ([dic_poi count])
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocation) name:@"shake" object:nil];
        }
	}
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (BMKPinAnnotationView *mkaview in views)
	{
        if ([mkaview.annotation.subtitle integerValue] == current_index)
        {
            point = [mapView convertCoordinate:mkaview.annotation.coordinate toPointToView:mapView];
            selectedAV = mkaview;
            lb_poi_name.text = mkaview.annotation.title;
            lb_poi_name.numberOfLines = 2;
            [self showBubble];
        }
	}

}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view isKindOfClass:[BMKPinAnnotationView class]])
    {
        point = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView];
        selectedAV = view;
        lb_poi_name.text = view.annotation.title;
        lb_poi_name.numberOfLines = 2;
        current_index = [view.annotation.subtitle integerValue];
        [self showBubble];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)Annotation
{
    NSArray *index_arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];

    if ([Annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:Annotation reuseIdentifier:@"myAnnotation"];
        newAnnotation.pinColor = BMKPinAnnotationColorRed;
        UILabel *no = [[UILabel alloc]initWithFrame:CGRectMake(11.0f, 5.0f, 10.0f, 10.0f)];
        no.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
        no.textColor = [UIColor whiteColor];
        no.backgroundColor = [UIColor clearColor];
        no.text = [index_arr objectAtIndex:[Annotation.subtitle integerValue]];
        [newAnnotation addSubview:no];
		newAnnotation.animatesDrop = NO;
		newAnnotation.draggable = NO;
        newAnnotation.canShowCallout = NO;
		return newAnnotation;
	}
	return nil;
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if (selectedAV)
    {
        point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:mapView];
        if (bubble_view)
        {
            [bubble_view removeFromSuperview];
        }
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    if (selectedAV)
    {
        point = [mapView convertCoordinate:selectedAV.annotation.coordinate toPointToView:mapView];
        if (point.y >=128.0f && point.y <= 387.0f)
        {
            [self showBubble];
        }
    }
}

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    [RWShowView closeAlert];
    is_loading = NO;
	if (error == BMKErrorOk)
    {
        [poi_buffer removeAllObjects];
        action_type = 1;
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
        [poi_buffer removeAllObjects];
        if (result.totalPoiNum > result.currPoiNum)
        {
            is_more = YES;
        }
        else
        {
            is_more = NO;
        }
        
		for (int i = 0; i < result.poiInfoList.count; i++)
        {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            poi_dic = [NSDictionary dictionary];
            if (poi.address)
            {
                if (poi.city)
                {
                    poi_dic = @{@"name" : poi.name,@"addr":poi.address,@"lat":[NSString stringWithFormat:@"%g",poi.pt.latitude],@"lng":[NSString stringWithFormat:@"%g",poi.pt.longitude],@"city":poi.city};
                }
                else
                {
                    poi_dic = @{@"name" : poi.name,@"addr":poi.address,@"lat":[NSString stringWithFormat:@"%g",poi.pt.latitude],@"lng":[NSString stringWithFormat:@"%g",poi.pt.longitude],@"city":lb_city.text};
                }
            }
            else
            {
                if (poi.city)
                {
                    poi_dic = @{@"name" : poi.name,@"addr":poi.city,@"lat":[NSString stringWithFormat:@"%g",poi.pt.latitude],@"lng":[NSString stringWithFormat:@"%g",poi.pt.longitude],@"city":poi.city};
                }
                else
                {
                    poi_dic = @{@"name" : poi.name,@"addr":lb_city.text,@"lat":[NSString stringWithFormat:@"%g",poi.pt.latitude],@"lng":[NSString stringWithFormat:@"%g",poi.pt.longitude],@"city":lb_city.text};
                }
            }
             [poi_buffer addObject:poi_dic];
		}
	}
    
    [self updateTableView];

}

- (void) updateTableView
{
    [refreshHeaderView setState:EGOOPullRefreshNormal];
    action_type = 1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    self.poi_tableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
    [self.poi_tableView reloadData];
}

- (void)showBubble
{
    if (bubble_view)
    {
        [bubble_view removeFromSuperview];
    }
    
    bubble_view.frame = CGRectMake(point.x - bubble_view.frame.size.width *0.5 - 3, point.y - bubble_view.frame.size.height - 28.0f, bubble_view.frame.size.width, bubble_view.frame.size.height);
    [self.map_view addSubview:bubble_view];
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGRect frame = search_scroll.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    [self.search_scroll setContentOffset:CGPointMake(frame.origin.x,  frame.origin.y) animated:NO];
	[tf_poi resignFirstResponder];
    key_text = tf_poi.text;
    is_search = YES;
    [self searchNearBy];
	return YES;
} 

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //active_field = nil;
}

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (IBAction)editingChanged:(id)sender
{
    CGRect frame = search_scroll.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    [self.search_scroll setContentOffset:CGPointMake(frame.origin.x,  frame.origin.y) animated:NO];

    UITextField *tmpTextField = (UITextField *)sender;
    NSString *newString = [tmpTextField text];
    is_search = YES;
    key_text = newString;
    [self searchNearBy];
}

#pragma mark EventHandle

- (IBAction)btn_item_click:(id)sender
{
    switch ([sender tag])
    {
        case 1000:
            is_search = NO;
            [head_view removeFromSuperview];
            [search_scroll removeFromSuperview];
            poi_tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372);
            self.navigationItem.leftBarButtonItem = btn_map;
            self.navigationItem.rightBarButtonItem = nil;
            [self removeMapView];
            [self.search_scroll removeFromSuperview];
            [self removeHotView];
            [self setHotView];
            return;
            break;
        case 1001:
            tf_poi.text = @"美食";
            break;
        case 1002:
            tf_poi.text = @"小吃快餐";
            break;
        case 1003:
            tf_poi.text = @"快捷酒店";
            break;
        case 1004:
            tf_poi.text = @"星级酒店";
            break;
        case 1005:
            tf_poi.text = @"公交站";
            break;
        case 1006:
            tf_poi.text = @"银行";
            break;
        case 1007:
            tf_poi.text = @"加油站";
            break;
        case 1008:
            tf_poi.text = @"ktv";
            break;
        case 1009:
            tf_poi.text = @"超市";
            break;
        default:
            break;
    }
    
    key_text = tf_poi.text;
    is_search = YES;
    if (!is_change)
    {
        is_content = YES;
    }
    [self searchNearBy];
    
    CGRect frame = search_scroll.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    page_ctrl.currentPage = 0;
    [self.search_scroll setContentOffset:CGPointMake(frame.origin.x,  frame.origin.y) animated:NO];
}

- (void)tapHandle
{
    [search_bar removeFromSuperview];
    is_search = YES;
    [self addScrollView];
    head_view.frame = CGRectMake(0.0f, 0.0f, 264.0f, 44.0f);
    [self.navigationController.navigationBar addSubview:head_view];
    self.navigationItem.rightBarButtonItem = btn_map;
}

- (void)addScrollView
{
    [self removeMapView];
    search_scroll.pagingEnabled = YES;
    search_scroll.contentSize = CGSizeMake(search_scroll.frame.size.width * 2,0);
    search_scroll.showsHorizontalScrollIndicator = NO;
    search_scroll.showsVerticalScrollIndicator = NO;
    search_scroll.scrollsToTop = NO;
    search_scroll.delegate = self;
    search_scroll.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]];
    
    CGRect src_bounds = [UIScreen mainScreen].bounds;
    if (src_bounds.size.height == 568.0f)
    {
        search_scroll.frame = CGRectMake(0.0f, 0.0f, 320.0f, 459);
    }
    [self.view addSubview:search_scroll];
    
    page_ctrl.numberOfPages = 2;
    page_ctrl.currentPage = 1;
    page_ctrl.hidden = NO;
    page_ctrl.currentPageIndicatorTintColor = [UIColor colorWithRed:71.0f/255.0f green:158.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    page_ctrl.pageIndicatorTintColor = [UIColor colorWithRed:166.0f/255.0f green:155.0f/255.0f blue:151.0f/255.0f alpha:1.0f];

    CGRect frame = search_scroll.frame;
    frame.origin.x = 0;
    frame.origin.y = 20;
    poi_tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 20);
    [search_scroll addSubview:poi_tableView];
    [self.poi_tableView reloadData];

    frame.origin.x = 320;
    frame.origin.y = 20;
    search_button_view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 20);;
    search_button_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]];
    [search_scroll addSubview:search_button_view];
    
    if (is_search)
    {
        self.navigationItem.rightBarButtonItem = btn_map;
    }
    else if (!is_hot)
    {
        self.navigationItem.leftBarButtonItem = btn_map;
    }
    
    
    [self.view addSubview:page_ctrl];
    [self.search_scroll bringSubviewToFront:page_ctrl];
    
    if (is_list)
    {
        is_list = NO;
        page_ctrl.currentPage = 0;
        frame.origin.x = frame.size.width * 0;
    }
    else
    {
        frame.origin.x = frame.size.width * 1;
    }
    frame.origin.y = 0;
    [self.search_scroll setContentOffset:CGPointMake(frame.origin.x,  frame.origin.y) animated:NO];
}

- (void)searchNearBy
{
    if (![lb_city.text length])
    {
        [RWAlertView show:@"请等待定位完成后再操作!"];
        return;
    }
    else if (![key_text length])
    {
        [RWAlertView show:@"还没有填写地点名称哦!"];
        return;
    }
    
    [RWShowView show:@"loading"];
    is_loading = YES;
    action_type = 0;

    is_loading = YES;
    action_type = 0;
    
    poi_lng =  [[dic_poi objectForKey:@"lng"] floatValue];
    poi_lat = [[dic_poi objectForKey:@"lat"] floatValue];
    [poi_buffer removeAllObjects];
    BOOL flag = NO;
    search.delegate= self;
    if (!is_content)
    {
        flag = [search poiSearchInCity:lb_city.text withKey:key_text pageIndex:0];
    }
    else
    {
        flag = [search poiSearchNearBy:key_text center:CLLocationCoordinate2DMake(poi_lat, poi_lng) radius:1000 pageIndex:0];

    }
	if (!flag)
    {
        [RWAlertView show:@"糟糕搜索出错!"];
        return;
	}
    else if (is_content && !is_search)
    {
        [self addTableView];
    }

}

- (void)fetchNearByOld
{
    poi_lng =  [[dic_poi objectForKey:@"lng"] floatValue];
    poi_lat = [[dic_poi objectForKey:@"lat"] floatValue];
    buffer_count = buffer_count + 1;
    BOOL flag = NO;
    if (!is_content)
    {
        flag = [search poiSearchInCity:lb_city.text withKey:key_text pageIndex:buffer_count];
    }
    else
    {
        flag = [search poiSearchNearBy:key_text center:CLLocationCoordinate2DMake(poi_lat, poi_lng) radius:1000 pageIndex:buffer_count];
        
    }

    search.delegate= self;
	if (!flag)
    {
        [self updateTableView];
	}
}

- (void)fetchNearByNew
{
    poi_lng =  [[dic_poi objectForKey:@"lng"] floatValue];
    poi_lat = [[dic_poi objectForKey:@"lat"] floatValue];
    BOOL flag;
    buffer_count = buffer_count - 1;
    if (buffer_count >0)
    {
        flag = [search poiSearchInCity:lb_city.text withKey:key_text pageIndex:buffer_count];
    }
    else
    {
        flag = [search poiSearchInCity:lb_city.text withKey:key_text pageIndex:0];
    }
    search.delegate= self;
	if (!flag)
    {
        [self updateTableView];
	}
}

- (void)addTableView
{
    [self removeMapView];
    [self.view addSubview:self.poi_tableView];
    [self.poi_tableView reloadData];
    
    CGRect src_bounds = [UIScreen mainScreen].bounds;
    
    if (src_bounds.size.height == 568.0f)
    {
        poi_tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 459);
    }
    
    if (is_search)
    {
        self.navigationItem.rightBarButtonItem = btn_map;
    }
    else if (!is_hot)
    {
        self.navigationItem.leftBarButtonItem = btn_map;
    }
}

- (void)addMapView
{
    if (!is_map_btn)
    {
        NSArray* array = [NSArray arrayWithArray:map_view.annotations];
        [map_view removeAnnotations:array];
        array = [NSArray arrayWithArray:map_view.overlays];
        [map_view removeOverlays:array];
        [map_view removeFromSuperview];
        [bubble_view removeFromSuperview];
    }
    
    if (is_search)
    {
        tf_poi.text = key_text;
        [head_view removeFromSuperview];
    }
    
    is_map_btn = NO;
    [map_view addSubview:btn_poi];
    [self.view addSubview:map_view];
    
    is_show = NO;
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleLongPress:)];
    longPressGR.minimumPressDuration = 1.0;
    [self.map_view addGestureRecognizer:longPressGR];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController.navigationBar addSubview:search_bar];
    
    if ([poi_buffer count])
    {
        self.navigationItem.rightBarButtonItem = btn_list;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }

    if ([dic_poi count])
    {
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocation) name:@"shake" object:nil];
    }

}
- (void)removeMapView
{
    if (is_search)
    {
        self.navigationItem.rightBarButtonItem = btn_map;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = btn_map;
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shake" object:nil];
}

- (IBAction)btn_search_click:(id)sender
{
    is_search = YES;
    is_content = NO;
    [tf_poi resignFirstResponder];
    key_text = tf_poi.text;
    [self searchNearBy];
    
 }
- (IBAction)btn_city_click:(id)sender
{
    if ([tf_poi isFirstResponder])
    {
        [tf_poi resignFirstResponder];
    }
    [self cancelLocatePicker];
    locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
    [locatePicker addSubview:tool_bar];
    [locatePicker showInView:self.view];

}
- (IBAction)btn_button_click:(id)sender
{
    [search_bar removeFromSuperview];
    if (is_search)
    {
        is_search = NO;
        [head_view removeFromSuperview];
        [search_scroll removeFromSuperview];
        CGRect src_bounds = [UIScreen mainScreen].bounds;
        if (src_bounds.size.height == 568.0f)
        {
            poi_tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372 + 87.0f);
        }
        else
        {
            poi_tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 372);
        }
        self.navigationItem.leftBarButtonItem = btn_map;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    switch ([sender tag])
    {
        case 1:
            if (is_save)
            {
                break;
            }
            [im_save setImage:[UIImage imageNamed:@"nav_poi_save_highlight.png"]];
            [im_history setImage:[UIImage imageNamed:@"nav_poi_history.png"]];
            [im_area setImage:[UIImage imageNamed:@"nav_poi_area.png"]];
            is_save = YES;
            is_history = NO;
            is_hot = NO;
            is_more = NO;
            [self removeHotView];
            [self removeMapView];
            [self setSaveView];
            break;
        case 2:
            if (is_history)
            {
                break;
            }
            [im_save setImage:[UIImage imageNamed:@"nav_poi_save.png"]];
            [im_history setImage:[UIImage imageNamed:@"nav_poi_history_highlight.png"]];
            [im_area setImage:[UIImage imageNamed:@"nav_poi_area.png"]];
            is_history = YES;
            is_save = NO;
            is_hot = NO;
            is_more = NO;
            [self removeHotView];
            [self removeMapView];
            [self setRecordView];
            break;
        case 3:
            is_neaby = NO;
            [im_save setImage:[UIImage imageNamed:@"nav_poi_save.png"]];
            [im_history setImage:[UIImage imageNamed:@"nav_poi_history.png"]];
            [im_area setImage:[UIImage imageNamed:@"nav_poi_area_highlight.png"]];
            is_history = NO;
            is_save = NO;
            is_hot = YES;
            self.navigationItem.leftBarButtonItem = nil;
            self.navigationItem.rightBarButtonItem = nil;
            [self removeMapView];
            [self.search_scroll removeFromSuperview];
            [self removeHotView];
            [self setHotView];
            break;
        default:
            break;
    }
}

- (IBAction)btn_bubble_click:(id)sender
{
    if (!is_current && [poi_buffer count])
    {
        dic_poi = [poi_buffer objectAtIndex:current_index];
    }

    if (10 == [sender tag])
    {
        is_neaby = YES;
        is_search = NO;
        [im_save setImage:[UIImage imageNamed:@"nav_poi_save.png"]];
        [im_history setImage:[UIImage imageNamed:@"nav_poi_history.png"]];
        [im_area setImage:[UIImage imageNamed:@"nav_poi_area_highlight.png"]];
        is_history = NO;
        is_save = NO;
        is_hot = YES;
        [search_bar removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
        [self removeMapView];
        [self setHotView];
    }
    else if (11 == [sender tag])
    {
        UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"请选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送导航",@"发送好友",@"收藏地点",nil];
        [as showInView:self.view];
        
    }
    
    [selectedAV setSelected:NO];
    [bubble_view removeFromSuperview];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        is_friend = NO;

        AppDelegate *dele = [AppDelegate getInstance];
        dele.delegate = self;
        [dele checkToken];
    }
    else if (1 == buttonIndex)
    {
        is_friend = YES;
        AppDelegate *dele = [AppDelegate getInstance];
        dele.delegate = self;
        [dele checkToken];

    }
    else if (2 == buttonIndex)
    {
        RRToken *token = [RRToken getInstance];
        sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"poiSavedb_%@.sql",[token getProperty:@"service_number"]]];
        sqlTestList *sqlInsert = [[sqlTestList alloc]init];
        
        NSMutableString *str = [NSMutableString string];
        NSMutableString *str_tmp = [NSMutableString string];
        
        for (int i = 0; i < [dic_poi count]; i++)
        {
            [str appendFormat:@"\"%@\":\"%@\",",[dic_poi.allKeys objectAtIndex:i],[dic_poi.allValues objectAtIndex:i]];
        }
        
        [str deleteCharactersInRange:NSMakeRange([str length] -1 ,1)];
        [str_tmp appendFormat:@"{%@}",str];
        
        sqlInsert.sqlID = [[dic_poi objectForKey:@"addr"] hash];
        sqlInsert.sqlText = str_tmp;
        
        //调用封装好的数据库插入函数
        [sqlSer insertTestList:sqlInsert];
        str = nil;
        str_tmp = nil;
        
        [RWAlertView show:@"收藏成功!"];

    }
}

- (void)applyCustomAlertAppearance
{
	[[AHAlertView appearance] setContentInsets:UIEdgeInsetsMake(12, 18, 12, 18)];
	
	[[AHAlertView appearance] setBackgroundImage:[UIImage imageNamed:@"custom-dialog-background"]];
	
	UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(20, 8, 20, 8);
	
	UIImage *cancelButtonImage = [[UIImage imageNamed:@"custom-cancel-normal"]
								  resizableImageWithCapInsets:buttonEdgeInsets];
	UIImage *normalButtonImage = [[UIImage imageNamed:@"custom-button-normal"]
								  resizableImageWithCapInsets:buttonEdgeInsets];
    
    UIImage *cancelButtonImageHighlight = [[UIImage imageNamed:@"custom-cancel-normal-highlight"]
                                           resizableImageWithCapInsets:buttonEdgeInsets];
	UIImage *normalButtonImageHighlight = [[UIImage imageNamed:@"custom-button-normal-highlight"]
                                           resizableImageWithCapInsets:buttonEdgeInsets];
    
	[[AHAlertView appearance] setCancelButtonBackgroundImage:normalButtonImage
													forState:UIControlStateNormal];
	[[AHAlertView appearance] setButtonBackgroundImage:cancelButtonImage
											  forState:UIControlStateNormal];
    
    [[AHAlertView appearance] setSaveImage:[UIImage imageNamed:@"custom-weixuan.png"]];
    [[AHAlertView appearance] setCancelButtonBackgroundImage:normalButtonImageHighlight
													forState:UIControlStateHighlighted];
	[[AHAlertView appearance] setButtonBackgroundImage:cancelButtonImageHighlight
											  forState:UIControlStateHighlighted];
	
	[[AHAlertView appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      [UIFont boldSystemFontOfSize:18], UITextAttributeFont,
                                                      [UIColor whiteColor], UITextAttributeTextColor,
                                                      [UIColor clearColor], UITextAttributeTextShadowColor,
                                                      [NSValue valueWithCGSize:CGSizeMake(0, 0)], UITextAttributeTextShadowOffset,
                                                      nil]];
    
	[[AHAlertView appearance] setMessageTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIFont systemFontOfSize:15], UITextAttributeFont,
                                                        [UIColor darkGrayColor], UITextAttributeTextColor,
                                                        [UIColor clearColor], UITextAttributeTextShadowColor,
                                                        [NSValue valueWithCGSize:CGSizeMake(0, 0)], UITextAttributeTextShadowOffset,
                                                        nil]];
    
	[[AHAlertView appearance] setButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            [UIFont boldSystemFontOfSize:14], UITextAttributeFont,
                                                            [UIColor whiteColor], UITextAttributeTextColor,
                                                            [UIColor clearColor], UITextAttributeTextShadowColor,
                                                            [NSValue valueWithCGSize:CGSizeMake(0, 0)], UITextAttributeTextShadowOffset,
                                                            nil]];
}

- (void) checkTokenSuccess
{
    if (is_friend)
    {
        [self applyCustomAlertAppearance];
        NSString *title = @"发送汽车位置";
        NSString *message = @"请输入好友服务号";
        AHAlertView *_alert = [[AHAlertView alloc] initWithTitle:title message:message andDelegate:self];
        __weak AHAlertView *alert =_alert;
        [alert setCancelButtonTitle:@"发送" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleFade;
        }];
        [alert addButtonWithTitle:@"取消" block:^{
            alert.dismissalStyle = AHAlertViewDismissalStyleZoomDown;
        }];
        
        [alert setAlertViewStyle:AHAlertViewStylePlainTextInput];
        [alert show];
        return;
    }
    
    [RWShowView show:@"loading"];
    NSString *poi = [NSString stringWithFormat:@"%@|%@|%@,%@|1|%@",[dic_poi objectForKey:@"city"],[dic_poi objectForKey:@"name"],[dic_poi objectForKey:@"lng"],[dic_poi objectForKey:@"lat"],[dic_poi objectForKey:@"addr"]];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_POI_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:poi forKey:@"poi"];
    
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethNew:)];
	[loader loadwithTimer];
}

- (void)alertViewDidSendWithId:(NSString *)no
{
    if (is_fetchNearby)   [RWAlertView show:@"正在发送..."];
    else[RWShowView show:@"loading"];
    
    NSString *poi = [NSString stringWithFormat:@"%@|%@|%@,%@|1|%@",[dic_poi objectForKey:@"city"],[dic_poi objectForKey:@"name"],[dic_poi objectForKey:@"lng"],[dic_poi objectForKey:@"lat"],[dic_poi objectForKey:@"addr"]];
    NSLog(@"%@",poi);
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_POI_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:poi forKey:@"poi"];
    [req setParam:no forKey:@"to"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethNew:)];
	[loader loadwithTimer];
}

- (void) onFethNew:(NSNotification *)notify
{
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        is_fetchNearby = NO;
        [RWShowView closeAlert];
        [RWAlertView show:@"发送失败!" ];
 		return;
	}
    
    if (is_friend)
    {
        [RWAlertView show:@"发送成功! 稍后您的好友将收到该点的信息!"];
    }
    else if (is_fetchNearby)
    {
        is_fetchNearby = NO;
        [RWAlertView show:@"发送成功!"];
    }
    else
    {
        [RWAlertView show:@"发送成功! 稍后您的车机将收到该点的信息!"];
    }
}

- (void) onFetchFail:(NSNotification *)notify
{
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) alertViewDidCancel
{
    
}

- (IBAction)btn_tool_item:(id)sender
{
    [self cancelLocatePicker];
    switch ([sender tag])
    {
        case 100:
            lb_city.text = current_poi;
            is_change = NO;
            break;
        default:
            break;
    }
}

- (void)setSaveView
{
    RRToken *token = [RRToken getInstance];
    sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"poiSavedb_%@.sql",[token getProperty:@"service_number"]]];

	NSArray *listData = [sqlSer getTestList];
	
	if (poi_buffer)
	{
		[poi_buffer removeAllObjects];
	}
	
	poi_buffer = [NSMutableArray arrayWithCapacity:0];
    sqlTestList *sqlList = [[sqlTestList alloc] init];
    
	for (int j = 0; j < [listData count]; j++ )
	{
        sqlList = [listData objectAtIndex:j];
        NSDictionary *dic = [sqlList.sqlText JSONValue];
        [poi_buffer addObject:dic];
	}
    
    if ([poi_buffer count])
    {
        self.navigationItem.rightBarButtonItem = btn_edit;
        btn_edit.enabled = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self addTableView];
}

- (void)setRecordView
{
    RRToken *token = [RRToken getInstance];
    sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"poiRecorddb_%@.sql",[token getProperty:@"service_number"]]];
    
	NSArray *listData = [sqlSer getTestList];
	
	if (poi_buffer)
	{
		[poi_buffer removeAllObjects];
	}
	
	poi_buffer = [NSMutableArray arrayWithCapacity:0];
    sqlTestList *sqlList = [[sqlTestList alloc] init];
    
	for (int j = 0; j < [listData count]; j++ )
	{
        sqlList = [listData objectAtIndex:j];
        NSDictionary *dic = [sqlList.sqlText JSONValue];
        [poi_buffer addObject:dic];
	}
    
    if ([poi_buffer count])
    {
        self.navigationItem.rightBarButtonItem = btn_edit;
        btn_edit.enabled = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self addTableView];
}

- (IBAction)btn_poi_click:(id)sender
{
    is_more = NO;
    is_fail = NO;
    is_search = NO;
    is_save = NO;
    is_history = NO;
    is_hot = NO;
    is_loading = NO;
    is_current = YES;
    is_neaby = NO;
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    [im_save setImage:[UIImage imageNamed:@"nav_poi_save.png"]];
    [im_history setImage:[UIImage imageNamed:@"nav_poi_history.png"]];
    [im_area setImage:[UIImage imageNamed:@"nav_poi_area.png"]];
    
    NSArray* array = [NSArray arrayWithArray:map_view.annotations];
	[map_view removeAnnotations:array];
	array = [NSArray arrayWithArray:map_view.overlays];
	[map_view removeOverlays:array];
    [bubble_view removeFromSuperview];
    
    map_view.delegate = self;
    map_view.showsUserLocation = YES;
    lb_city.text = @"定位中";
}

- (void) btn_edit_click:(id)sender
{
	[self.poi_tableView deselectRowAtIndexPath:[self.poi_tableView indexPathForSelectedRow] animated:YES];
	[self.poi_tableView setEditing:!self.poi_tableView.editing animated:YES];
}  

- (void) btn_map_click:(id)sender
{
    if (is_search)
    {
        [head_view removeFromSuperview];
    }

    is_more = NO;
    is_fail = NO;
    is_search = NO;
    is_save = NO;
    is_history = NO;
    is_hot = NO;
    is_loading = NO;
    is_current = NO;
    is_neaby = NO;
    is_map_btn = YES;
    [im_save setImage:[UIImage imageNamed:@"nav_poi_save.png"]];
    [im_history setImage:[UIImage imageNamed:@"nav_poi_history.png"]];
    [im_area setImage:[UIImage imageNamed:@"nav_poi_area.png"]];

    [self cancelLocatePicker];
    [self.search_scroll removeFromSuperview];
    [self removeHotView];
    [self addMapView];
    [self.navigationController.navigationBar addSubview:search_bar];
}

- (IBAction)btn_list_click:(id)sender
{
    if (is_search)
    { 
        [search_bar removeFromSuperview];
        is_search = YES;
        is_list = YES;
        [self addScrollView];
        head_view.frame = CGRectMake(0.0f, 0.0f, 264.0f, 44.0f);
        [self.navigationController.navigationBar addSubview:head_view];
        self.navigationItem.rightBarButtonItem = btn_map;
        tf_poi.text = key_text;
    }
    else
    {
        [self addTableView];
        [search_bar removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;

    }
}

- (void) updateItemAtIndexPath:(NSIndexPath *)indexPath withString: (NSString *)string
{
    sqlService *sqlSer;
    RRToken *token = [RRToken getInstance];
    if (is_save)
    {
        sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"poiSavedb_%@.sql",[token getProperty:@"service_number"]]];
    }
    else if (is_history)
        
    {
        sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"poiRecorddb_%@.sql",[token getProperty:@"service_number"]]];
    }
    NSArray *listData = [sqlSer getTestList];
	sqlTestList *sqlList = [[sqlTestList alloc]init];
	sqlList = [listData objectAtIndex:indexPath.row];
    [sqlSer deleteTestList:sqlList];
	
    [poi_buffer removeObjectAtIndex:indexPath.row];
	[self.poi_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	[self.poi_tableView reloadData];
	if ([poi_buffer count] == 0)
	{
		btn_edit.enabled = NO;
		[self.poi_tableView setEditing:NO animated:YES];
	}
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    lb_city.text = picker.locate.city;
    is_content = NO;
    is_change = YES;
}

-(void)cancelLocatePicker
{
    [locatePicker cancelPicker];
    locatePicker.delegate = nil;
    locatePicker = nil;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if (0 == [poi_buffer count])
	{
		return 1;
	}
	
	else if (is_more)
	{
		return [poi_buffer count] + 1;
	}
	return [poi_buffer count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 == [poi_buffer count] && YES == is_loading)
	{
		static NSString *cell_id = @"empty_cell";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
		if (nil == cell)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
		}
		
		UIFont *font = [UIFont systemFontOfSize:15.0f];
		cell.textLabel.text = @"载入中...";
		cell.textLabel.font = font;
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
    
	if (0 == [poi_buffer count] && NO == is_loading)
	{
		static NSString *cell_id = @"empty_cell";
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
		if (nil == cell)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
		}
		
		UIFont *font = [UIFont systemFontOfSize:15.0f];
		cell.textLabel.font = font;
		if (is_fail)
		{
			cell.textLabel.text = @"网络异常,请稍后再试!";
		}
		else
		{
			cell.textLabel.text = @"无数据";
		}
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	
	if (indexPath.row < [poi_buffer count])
	{
		static NSString *CellIdentifier = @"PoiListCell";
		NSMutableDictionary *area_info = [NSMutableDictionary dictionaryWithDictionary:[poi_buffer objectAtIndex:indexPath.row]];
        if (is_save)
        {
            [area_info setObject:@"0" forKey:@"is_search"];
            [area_info setObject:@"1" forKey:@"hide_zimu"];
        }
        else if (is_history)
        {
            [area_info setObject:@"1" forKey:@"hide_zimu"];
            [area_info setObject:@"1" forKey:@"is_search"];
        }
        else
        {
            [area_info setObject:@"1" forKey:@"is_search"];
        }
        [area_info setObject:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"index"];
        [area_info setObject:self.lb_city.text forKey:@"city"];

		PoiListCell *cell = (PoiListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (nil == cell)
		{
			UIViewController *uc = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
			
			cell = (PoiListCell *)uc.view;
			[cell setContent:area_info];
            [cell setBuffer:poi_buffer];
		}
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
		return cell;
	}
    
	static NSString *cell_id = @"more_cell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
	}
	
	UIFont *font = [UIFont systemFontOfSize:15.0f];
	switch (action_type)
	{
		case 0:
			cell.textLabel.text = @"加载中...";
			break;
		case 1:
			cell.textLabel.text = @"+ 更多内容";
			break;
		case 2:
			cell.textLabel.text = @"松开即可刷新...";
			break;
		default:
			break;
	}
	if (is_loading)
	{
		cell.textLabel.text = @"加载中...";
	}
	cell.textLabel.textColor = [UIColor darkGrayColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.font = font;
	cell.tag = 110;
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"city_cell_back.png"]];
    
	UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	aiv.center = CGPointMake(cell.backgroundView.center.x - 50.0f, cell.backgroundView.center.y);
	[aiv startAnimating];
	if (action_type == 0)
	{
		[cell.backgroundView addSubview:aiv];
	}
	return cell;
}

- (CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([poi_buffer count] == 0)
	{
		return 70.0f;
	}
	
	if (indexPath.row < [poi_buffer count])
	{
		return [PoiListCell calCellHeight:[poi_buffer objectAtIndex:indexPath.row]];
	}
	return  44.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self updateItemAtIndexPath:indexPath withString:nil];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (0 == [poi_buffer count])
	{
		return;
	}
	if (indexPath.row >= [poi_buffer count])
	{
        action_type = 0;
        is_loading = YES;
        [self fetchNearByOld];
		return;
	}
    
    if (is_search)
    {
        RRToken *token = [RRToken getInstance];
        sqlService *sqlSer = [[sqlService alloc] initWithName:[NSString stringWithFormat:@"poiRecorddb_%@.sql",[token getProperty:@"service_number"]]];
        sqlTestList *sqlInsert = [[sqlTestList alloc]init];
        
        NSMutableDictionary *dict = [poi_buffer objectAtIndex:indexPath.row];
        NSMutableString *str = [NSMutableString string];
        NSMutableString *str_tmp = [NSMutableString string];
        
        for (int i = 0; i < [dict count]; i++)
        {
            [str appendFormat:@"\"%@\":\"%@\",",[dict.allKeys objectAtIndex:i],[dict.allValues objectAtIndex:i]];
        }
        
        [str deleteCharactersInRange:NSMakeRange([str length] -1 ,1)];
        [str_tmp appendFormat:@"{%@}",str];
        
        sqlInsert.sqlID = [[dict objectForKey:@"addr"] hash];
        sqlInsert.sqlText = str_tmp;
        
        if ([[sqlSer searchTestList:[[dict objectForKey:@"addr"] hash]] count])
        {
            [sqlSer updateTestList:sqlInsert];
        }
        else
        {
            [sqlSer insertTestList:sqlInsert];
        }
        str = nil;
        str_tmp = nil;
    }

	[self.poi_tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.poi_tableView removeFromSuperview];
    [self addMapView];
    
    NSArray* array = [NSArray arrayWithArray:map_view.annotations];
	[map_view removeAnnotations:array];
	array = [NSArray arrayWithArray:map_view.overlays];
	[map_view removeOverlays:array];

    current_index = indexPath.row;

    if (is_save || is_history)
    {
        NSDictionary *dic = [poi_buffer objectAtIndex:current_index];
		CLLocationDegrees a_lat = [[dic objectForKey:@"lat"]doubleValue];
		CLLocationDegrees a_lng = [[dic objectForKey:@"lng"]doubleValue];
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(a_lat, a_lng);
		annotation = [[BMKPointAnnotation alloc] init];
		annotation.coordinate = coordinate;
		annotation.title = [dic objectForKey:@"name"];
		annotation.subtitle = [NSString stringWithFormat:@"%d",current_index];
		[map_view addAnnotation:annotation];
    }
    else
    {
        for (int i = 0; [poi_buffer count] > i; i++)
        {
            NSDictionary *dic = [poi_buffer objectAtIndex:i];
            CLLocationDegrees a_lat = [[dic objectForKey:@"lat"]doubleValue];
            CLLocationDegrees a_lng = [[dic objectForKey:@"lng"]doubleValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(a_lat, a_lng);
            annotation = [[BMKPointAnnotation alloc] init];
            annotation.coordinate = coordinate;
            annotation.title = [dic objectForKey:@"name"];
            annotation.subtitle = [NSString stringWithFormat:@"%d",i];
            [map_view addAnnotation:annotation];
        }
    }
     
    NSDictionary *d = [poi_buffer objectAtIndex:indexPath.row];
    BMKCoordinateRegion region;
    region.center.latitude  = [[d objectForKey:@"lat"]doubleValue] ;
    region.center.longitude = [[d objectForKey:@"lng"]doubleValue];
    region.span.latitudeDelta  = 0.005;
    region.span.longitudeDelta = 0.005;
    map_view.region = region;
    
    [im_save setImage:[UIImage imageNamed:@"nav_poi_save.png"]];
    [im_history setImage:[UIImage imageNamed:@"nav_poi_history.png"]];
    [im_area setImage:[UIImage imageNamed:@"nav_poi_area.png"]];
    is_save = NO;
    is_history = NO;
    is_hot = NO;
    is_current = NO;

}

- (void)scrollViewDidScroll: (UIScrollView *)scrollView
{
	if (!scrollView.isDragging)
	{
		return;
	}
	
	UITableViewCell *cell = (UITableViewCell *)[self.poi_tableView viewWithTag:110];
    
	if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshNormal];
	}
	else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshPulling];
	}
	if (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height < 22.0f)
	{
		cell.textLabel.text = @"+ 更多内容";
		if (is_loading)
		{
			cell.textLabel.text = @"加载中...";
		}
	}
	else if (scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 22.0f)
	{
		cell.textLabel.text = @"松开即可刷新...";
		if (is_loading)
		{
			cell.textLabel.text = @"加载中...";
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < - 65.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		self.poi_tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [self fetchNearByNew];
	}

	else if (scrollView.contentSize.height > scrollView.bounds.size.height &&
			 scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentSize.height > 22.0f)
	{
		if (is_more)
		{
            [self fetchNearByOld];
		}
		return;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)ScrollView
{
    CGFloat pageWidth = search_scroll.frame.size.width;
    int page = floor((search_scroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (is_search && (page == 0) && (page_ctrl.currentPage != page))
    {
        
    }
    else
    {
        [tf_poi resignFirstResponder];
    }
    
    page_ctrl.currentPage = page;
}

#pragma mark -
#pragma mark hot view 


- (void)removeHotView
{
    [self.hot_view removeFromSuperview];
    hot_view = nil;
    
    for (int i = 0; i < count; i++)
	{
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[hot_dict objectForKey:[NSString stringWithFormat:@"%d",i]]];
        NSArray *content_arr = [dic objectForKey:@"content"];//得到内容
        
        UIView *titleView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d1",i+1] intValue]];
        [titleView removeFromSuperview];
        titleView = nil;
        
        UILabel *labTitle = (UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d4",i+1] intValue]];
        [labTitle removeFromSuperview];
        labTitle = nil;
        
        UIView *QQView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d",i+1] intValue]];
        [QQView removeFromSuperview];
        QQView = nil;
        
        for (int j = 0; j < [content_arr count]; j++)
        {
            UIButton *btn_content = (UIButton *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d5%d",i+1,j] intValue]];
            [btn_content removeFromSuperview];
            btn_content = nil;
            [(UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d6%d",i+1,j] intValue]] removeFromSuperview];
        }
     }
}

- (void)setHotView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sourcelist" ofType:@"plist"];
    if (hot_dict)
    {
        hot_dict = nil;
    }
 	hot_dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	[self.hot_view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]]];
	scroll_flag = YES;
	
	scroll_View.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]];
	[self.view addSubview:scroll_View];
	
    NSArray *img_arr = @[[UIImage imageNamed:@"hot_food.png"],[UIImage imageNamed:@"hot_traffic"],[UIImage imageNamed:@"hot_yule.png"],[UIImage imageNamed:@"hot_bank.png"],[UIImage imageNamed:@"hot_house.png"],[UIImage imageNamed:@"hot_shopping.png"],[UIImage imageNamed:@"hot_life.png"],[UIImage imageNamed:@"hot_other.png"]];
	count = [hot_dict count];
	NSInteger totalHeight = 0;//初始化的总高度
	for(int i = 0; i< count; i++)
	{
		NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[hot_dict objectForKey:[NSString stringWithFormat:@"%d",i]]];
		
		NSString *title = [dic objectForKey:@"title"];//得到标题
		
		NSArray *content_arr = [dic objectForKey:@"content"];//得到内容
		
		UIView *QQView = [[UIView alloc] initWithFrame:CGRectMake(0, totalHeight, 320, 53)];//添加view，开始view的高度为默认的50
		[QQView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"poi_cell_bg"]]];
		[QQView setTag:[[NSString stringWithFormat:@"%d",(i+1)] intValue]];
		[self.scroll_View addSubview:QQView];
		
 		totalHeight = totalHeight + 1 + 53;

		UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];//添加button所在的view，因为该view的颜色要改变，故增加一个view
		[titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"poi_cell_bg"]]];
		[titleView setTag:[[NSString stringWithFormat:@"%d1",i+1] intValue]];
		[QQView addSubview:titleView];
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setTag:[[NSString stringWithFormat:@"%d2",i+1] intValue]];
		[btn setFrame:CGRectMake(0, 0, 320, 53)];
		[btn addTarget:self action:@selector(reSetFrame:) forControlEvents:UIControlEventTouchUpInside];
		[titleView addSubview:btn];

		UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 28, 30)];
		img.image = [img_arr objectAtIndex:i];
		[img setTag:[[NSString stringWithFormat:@"%d3",i+1] intValue]];
		[titleView addSubview:img];
		
		UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, 100, 25)];
		labTitle.textColor = [UIColor darkGrayColor];
        [labTitle setTag:[[NSString stringWithFormat:@"%d4",i+1] intValue]];
        labTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
		labTitle.backgroundColor = [UIColor clearColor];
		labTitle.text = title;
		[titleView addSubview:labTitle];
        
        NSUInteger btnHight = 0;
        for (int j = 0; j < [content_arr count]; j++)
        {
            UIButton *btn_content = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn_content setTag:[[NSString stringWithFormat:@"%d5%d",i+1,j] intValue]];
            [btn_content setFrame:CGRectMake(0, btnHight + 53 + QQView.frame.origin.y, 320,0)];
            [btn_content setBackgroundImage:[UIImage imageNamed:@"city_cell_back.png"] forState:UIControlStateNormal];
            [btn_content addTarget:self action:@selector(btn_content_click:) forControlEvents:UIControlEventTouchUpInside];
            [scroll_View addSubview:btn_content];
            
            btnHight = btnHight + 44.0f;
            
            UILabel *contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 100, 0)];
            [contentTitle setTag:[[NSString stringWithFormat:@"%d6%d",i+1,j] intValue]];
            contentTitle.textColor = [UIColor lightGrayColor];
            contentTitle.font = [UIFont systemFontOfSize:15];
            contentTitle.backgroundColor = [UIColor clearColor];
            contentTitle.text = [content_arr objectAtIndex:j];
        }
        
	}
    
	scroll_View.contentSize = CGSizeMake(320, totalHeight);
}

- (void)reSetFrame:(id)sender
{
    UIButton *btn = (UIButton *)sender;
	NSInteger btnTag = btn.tag;
    NSUInteger btnHight = 0;
	NSInteger totalHeight = 0;//初始化的总高度
	
	if(lasterTag != btnTag && !scroll_flag)
	{
		scroll_flag = !scroll_flag;
	}
	
	lasterTag = btnTag;
	
	[UIView beginAnimations:nil context:(__bridge void *)(self.hot_view)];//开始动画
	[UIView setAnimationDuration:0.3];//设定速度
	for (int i = 0; i < count; i++)
	{
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[hot_dict objectForKey:[NSString stringWithFormat:@"%d",i]]];
        NSArray *content_arr = [dic objectForKey:@"content"];//得到内容

		if(btnTag > [[NSString stringWithFormat:@"%d2",i+1] intValue])//在点击该行前面的行，位置为默认的
		{
			UIView *titleView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d1",i+1] intValue]];
            [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"poi_cell_bg"]]];
			
            UILabel *labTitle = (UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d4",i+1] intValue]];
            labTitle.textColor = [UIColor darkGrayColor];

			UIView *QQView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d",i+1] intValue]];
			QQView.frame = CGRectMake(0, totalHeight, 320, 53);
			totalHeight = totalHeight + 1 + 53;
            for (int j = 0; j < [content_arr count]; j++)
            {
                UIButton *btn_content = (UIButton *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d5%d",i+1,j] intValue]];
                [btn_content setFrame:CGRectMake(0, btnHight + 53 + QQView.frame.origin.y, 320, 0)];
                [(UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d6%d",i+1,j] intValue]] removeFromSuperview];
            }
		}
		else if(btnTag == [[NSString stringWithFormat:@"%d2",i+1] intValue])//触发当前行
		{
			if(scroll_flag)
			{
				UIView *titleView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d1",i+1] intValue]];
                [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"poi_cell_bg"]]];
				
				UIView *QQView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d",i+1] intValue]];
				QQView.frame = CGRectMake(0, totalHeight, 320, 53);
                  
                UILabel *labTitle = (UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d4",i+1] intValue]];
                labTitle.textColor = [UIColor colorWithRed:0.0f green:87.0f/255.0f blue:168.0f/255.0f alpha:1.0f];
                for (int j = 0; j < [content_arr count]; j++)
                {
                    UIButton *btn_content = (UIButton *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d5%d",i+1,j] intValue]];
                    [btn_content setTag:[[NSString stringWithFormat:@"%d5%d",i+1,j] intValue]];
                    [btn_content setFrame:CGRectMake(0, QQView.frame.origin.y + btnHight + 53, 320, 44)];
                    [btn_content addTarget:self action:@selector(btn_content_click:) forControlEvents:UIControlEventTouchUpInside];
                    btnHight = btnHight + 44.0f;

                    UILabel *contentTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 25)];
                    [contentTitle setTag:[[NSString stringWithFormat:@"%d6%d",i+1,j] intValue]];
                    contentTitle.textColor = [UIColor lightGrayColor];
                    contentTitle.font = [UIFont systemFontOfSize:15];
                    contentTitle.backgroundColor = [UIColor clearColor];
                    contentTitle.text = [content_arr objectAtIndex:j];
                    [btn_content addSubview:contentTitle];
                }
                
                totalHeight = totalHeight + 10 + btnHight;
				scroll_flag = !scroll_flag;
			}
			else
			{
				UIView *titleView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d1",i+1] intValue]];
                [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"poi_cell_bg"]]];
				
				UIView *QQView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d",i+1] intValue]];
				QQView.frame = CGRectMake(0, totalHeight, 320, 53);
				totalHeight = totalHeight + 1 + 53;
                
                UILabel *labTitle = (UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d4",i+1] intValue]];
                labTitle.textColor = [UIColor darkGrayColor];
				
                
                for (int j = 0; j < [content_arr count]; j++)
                {
                    UIButton *btn_content = (UIButton *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d5%d",i+1,j] intValue]];
                    [btn_content setFrame:CGRectMake(0, btnHight + 53 + QQView.frame.origin.y, 320, 0)];
                    [(UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d6%d",i+1,j] intValue]] removeFromSuperview];
                 }
                
				scroll_flag = !scroll_flag;
			}
		}
		else//触发行下面的行
		{
			UIView *titleView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d1",i+1] intValue]];
            [titleView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"poi_cell_bg"]]];
			
			UIView *QQView = (UIView *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d",i+1] intValue]];
			QQView.frame = CGRectMake(0, totalHeight, 320, 53);
			totalHeight = totalHeight + 1 + 53;
            
            UILabel *labTitle = (UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d4",i+1] intValue]];
            labTitle.textColor = [UIColor darkGrayColor];

            for (int j = 0; j < [content_arr count]; j++)
            {
                UIButton *btn_content = (UIButton *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d5%d",i+1,j] intValue]];
                [btn_content setFrame:CGRectMake(0, btnHight + 53 + QQView.frame.origin.y, 320, 0)];
                [(UILabel *)[self.scroll_View viewWithTag:[[NSString stringWithFormat:@"%d6%d",i+1,j] intValue]] removeFromSuperview];
            }
		}
        
	}
    if (btnTag == 72 && !scroll_flag)
    {
        scroll_View.contentSize = CGSizeMake(320, totalHeight + 50.0f);
        [scroll_View setContentOffset:CGPointMake(0, btnHight) animated:YES];
    }
    else
    {
        scroll_View.contentSize = CGSizeMake(320, totalHeight);
    }
    

	[UIView commitAnimations];
    

}

- (void)btn_content_click:(id)sender
{
    NSUInteger index = [sender tag]/100;
    NSUInteger row = [sender tag]%[[NSString stringWithFormat:@"%d50",index] integerValue];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[hot_dict objectForKey:[NSString stringWithFormat:@"%d",index-1]]];
    NSArray *content_arr = [dic objectForKey:@"content"];
    key_text = [content_arr objectAtIndex:row];
    is_content = YES;
    [self removeHotView];
    [self searchNearBy];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        return;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint pt = [gestureRecognizer locationInView:self.map_view];
        CLLocationCoordinate2D longPress_coordinate = [map_view convertPoint:pt toCoordinateFromView:map_view];
        
        if (!search)
        {
            search = [[BMKSearch alloc]init];
        }
        search.delegate = self;
        [search reverseGeocode:longPress_coordinate];
        is_longPress = YES;
        
        is_more = NO;
        is_fail = NO;
        is_search = NO;
        is_save = NO;
        is_history = NO;
        is_hot = NO;
        is_loading = NO;
        is_current = YES;
        is_neaby = NO;
        [im_save setImage:[UIImage imageNamed:@"nav_poi_save.png"]];
        [im_history setImage:[UIImage imageNamed:@"nav_poi_history.png"]];
        [im_area setImage:[UIImage imageNamed:@"nav_poi_area.png"]];
    }
}


#pragma mark shake -

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        if (!is_fetchNearby)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
        }
    }
}

- (void)startLocation
{
    is_fetchNearby = YES;
    
    if (!lm)
    {
        lm = [[CLLocationManager alloc] init];
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        [lm startUpdatingLocation];
    }
    
    [RWAlertView show:@"正在搜索..."];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    lm.delegate = nil;
    lm = nil;
    gpsLat = [NSString stringWithFormat:@"%g",newLocation.coordinate.latitude];
    gpsLng = [NSString stringWithFormat:@"%g",newLocation.coordinate.longitude];
    [self fethNearby];

}

- (void) fethNearby
{
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, FETCH_NEARBY_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    
    [req setParam:gpsLat forKey:@"lat"];
	[req setParam:gpsLng forKey:@"lng"];
	[req setParam:@"100" forKey:@"radius"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethNearby:)];
	[loader loadwithTimer];
    
}

- (void) onFethNearby:(NSNotification *)notify
{
    is_loading = NO;
    [RWAlertView show:@"正在连接..."];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        is_fetchNearby = NO;
        [RWShowView closeAlert];
        [RWAlertView show:@"连接失败!" ];
  		return;
	}
    
    NSArray *arr = [json objectForKey:@"data"];
    if ([arr count] == 0)
    {
        is_fetchNearby = NO;
        [RWShowView closeAlert];
        [RWAlertView show:@"附近没有发现车机"];
        return;
    }
    
    NSDictionary *dic = [arr objectAtIndex:0];
    
    if ([dic count] == 0)
    {
        is_fetchNearby = NO;
        [RWShowView closeAlert];
        [RWAlertView show:@"附近没有发现车机"];
        return;
    }
    
    if (!is_current && [poi_buffer count])
    {
        dic_poi = [poi_buffer objectAtIndex:current_index];
    }
    
    [self alertViewDidSendWithId:[dic objectForKey:@"service_number"]];
    
 }

@end
