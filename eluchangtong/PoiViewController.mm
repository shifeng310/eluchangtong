//
//  PoiViewController.m
//  eluchangtong
//
//  Created by 方鸿灏 on 12-11-13.
//  Copyright (c) 2012年 方鸿灏. All rights reserved.
//

#import "PoiViewController.h"
#import "RoadRover.h"
#import "AppDelegate.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "RWAlertView.h"
#import "RWShowView.h"
#import "PoiListViewController.h"
#import "RWTrafficDetailController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

BOOL isRetina = FALSE;
#define driveSpeed 60
#define busSpeed 20
#define walkSpeed 5

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
	int _degree;
    NSString *_city;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@property (nonatomic,copy) NSString *city;

@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@synthesize city = _city;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end



@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGSize rotatedSize = self.size;
	if (isRetina) {
		rotatedSize.width *= 2;
		rotatedSize.height *= 2;
	}
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end

@implementation PoiViewController
@synthesize map_view;
@synthesize btn_poi;
@synthesize lb_des;
@synthesize lb_poi;
@synthesize head_view;
@synthesize transitRoute_plan;
@synthesize drive_plan;
@synthesize walk_plan;
@synthesize start;
@synthesize end;
@synthesize city_name;
@synthesize saddr;
@synthesize daddr;
@synthesize current_lat;
@synthesize current_lng;
@synthesize lb_car_poi;
@synthesize btn_send;
@synthesize bubble_view;
@synthesize seg_view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"汽车位置";
    
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
    {
        map_view.frame = CGRectMake(0.0f, 0.0f, 320.0f, map_view.frame.size.height + 87.0f);
    }
    
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
	if ((fabs(screenSize.width - 640.0f) < 0.1)
		&& (fabs(screenSize.height - 960.0f) < 0.1))
	{
		isRetina = TRUE;
	}

    self.map_view.delegate = self;
    
    btn_poi.frame = CGRectMake(235.0f, 325.0f, 48.0f, 48.0f);
    [self.map_view addSubview:btn_poi];
    
    btn_history = [[UIBarButtonItem alloc]initWithTitle:@"历史记录" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_history_click:)];
    self.navigationItem.rightBarButtonItem = btn_history;
    
    sg_ctrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"自驾", @"公交", @"步行",nil]];
    [sg_ctrl setImage:[UIImage imageNamed:@"zijia.png"] forSegmentAtIndex:0];
    [sg_ctrl setImage:[UIImage imageNamed:@"gongjiao.png"] forSegmentAtIndex:1];
    [sg_ctrl setImage:[UIImage imageNamed:@"buxing.png"] forSegmentAtIndex:2];

	sg_ctrl.segmentedControlStyle = UISegmentedControlStyleBar;
	[sg_ctrl addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventValueChanged];
	sg_ctrl.frame = CGRectMake(0, 0, 150, 28);
	sg_ctrl.selectedSegmentIndex = 0;
	self.navigationItem.titleView = sg_ctrl;

    head_view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 45.0f);
	
	[map_view addSubview:head_view];
    lb_poi.text = @"正在获取汽车位置...";
	lb_des.text = @"正在获取自驾线路...";
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
	[head_view addGestureRecognizer:singleTap];

    policy_type = 0;

    AppDelegate *dele = [AppDelegate getInstance];
    dele.delegate = self;
    [dele checkToken];
   // self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [RWAlertView closeAlert];
    [RWShowView closeAlert];
    [timer invalidate];
    timer = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
        btn_poi = nil;
        map_view = nil;
    }
}

- (void)dealloc
{
    map_view.delegate = nil;
    search.delegate = nil;
    map_view = nil;
    btn_poi = nil;
    poi_buffer = nil;
    annotation = nil;
    timer = nil;
    btn_history = nil;
    sg_ctrl = nil;
    lb_poi = nil;
	lb_des = nil;
    head_view = nil;
    lb_car_poi = nil;
    btn_send = nil;
    bubble_view = nil;
    seg_view = nil;
    start = nil;
	end = nil;
    search = nil;
    selectedAV = nil;
    nav = nil;
	transitRoute_plan = nil;
	drive_plan = nil;
	walk_plan = nil;
}

- (void)mapView:(BMKMapView *)MapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil)
	{
		self.current_lat = [NSString stringWithFormat:@"%g",userLocation.location.coordinate.latitude];
		self.current_lng = [NSString stringWithFormat:@"%g",userLocation.location.coordinate.longitude];
		
		CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
		search.delegate = self;
		[search reverseGeocode:pt];
	}
	
	map_view.showsUserLocation = NO;
	
}

- (void)mapView:(BMKMapView *)MapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil)
		NSLog(@"locate failed: %@", [error localizedDescription]);
	else {
		NSLog(@"locate failed");
	}
	
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
        if (is_car_poi)
        {
            is_car_poi = NO;
            lb_poi.text = [NSString stringWithFormat:@"汽车位置:%@",result.strAddr];
            car_poi = result.strAddr;
            car_city_name = result.addressComponent.city;
            map_view.delegate = self;
            map_view.showsUserLocation = YES;
            return;
        }
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
		[map_view addAnnotation:item];
	}
	
	saddr =  result.strAddr;
    current_city_name = result.addressComponent.city;
	[RWShowView closeAlert];
	
	NSArray* array = [NSArray arrayWithArray:map_view.annotations];
	[map_view removeAnnotations:array];
	array = [NSArray arrayWithArray:map_view.overlays];
	[map_view removeOverlays:array];
	CLLocationCoordinate2D startPt = (CLLocationCoordinate2D){0, 0};
	CLLocationCoordinate2D endPt = (CLLocationCoordinate2D){0, 0};
	if (self.current_lng != nil && self.current_lat != nil) {
		startPt = (CLLocationCoordinate2D){[current_lat floatValue], [current_lng floatValue]};
	}
	if (self.lng != nil && self.lat != nil) {
		endPt = (CLLocationCoordinate2D){[self.lat floatValue], [self.lng floatValue]};
	}
	
	city_name = result.addressComponent.city;
	start = [[BMKPlanNode alloc]init];
	start.pt = startPt;
	start.name = result.strAddr;
	end = [[BMKPlanNode alloc]init];
	end.name = daddr;
	end.pt = endPt;
	
	search.drivingPolicy = BMKCarTimeFirst;
	BOOL flag = [search drivingSearch:result.strAddr startNode:start endCity:daddr endNode:end];
	if (!flag)
	{
		NSLog(@"search failed");
		[RWShowView closeAlert];
		lb_des.text = @"未找到自驾路线,试一下其他方式吧!";
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = end.pt;
		item.title = annotation_title;
		item.subtitle = daddr;
		[map_view addAnnotation:item];
		BMKCoordinateRegion region;
		region.center.latitude  = end.pt.latitude;
		region.center.longitude = end.pt.longitude;
		region.span.latitudeDelta  = 0.01;
		region.span.longitudeDelta = 0.01;
		map_view.region = region;
	}
	else
	{
		[map_view setCenterCoordinate:result.geoPt animated:YES];
		BMKCoordinateRegion region;
		region.center.latitude  = result.geoPt.latitude;
		region.center.longitude = result.geoPt.longitude;
		region.span.latitudeDelta  = 0.01;
		region.span.longitudeDelta = 0.01;
		map_view.region   = region;
	}
}


- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
	if (error == BMKErrorOk)
	{
		self.transitRoute_plan = [NSArray arrayWithArray:result.plans];
		if (1 == sg_ctrl.selectedSegmentIndex)
		{
			[self setTransitData];
		}
	}
	
	else
	{
		lb_des.text = @"未找到公交路线,试一下其他方式吧!";
		[RWShowView closeAlert];
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = end.pt;
		item.title = annotation_title;
		item.subtitle = daddr;
		[map_view addAnnotation:item];
		
		BMKCoordinateRegion region;
		region.center.latitude  = end.pt.latitude;
		region.center.longitude = end.pt.longitude;
		region.span.latitudeDelta  = 0.01;
		region.span.longitudeDelta = 0.01;
		map_view.region   = region;
	}
    
}


- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
	if (error == BMKErrorOk)
	{
		self.drive_plan = [NSArray arrayWithArray:result.plans];
		if (0 == sg_ctrl.selectedSegmentIndex)
		{
			[self setDriveData];
		}
	}
	
	else
	{
		lb_des.text = @"未找到自驾路线,试一下其他方式吧!";
		[RWShowView closeAlert];
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = end.pt;
		item.title = annotation_title;
		item.subtitle = daddr;
		[map_view addAnnotation:item];
		
		BMKCoordinateRegion region;
		region.center.latitude  = end.pt.latitude;
		region.center.longitude = end.pt.longitude;
		region.span.latitudeDelta  = 0.01;
		region.span.longitudeDelta = 0.01;
		map_view.region   = region;
	}
    
	
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
	if (error == BMKErrorOk)
	{
		self.walk_plan = [NSArray arrayWithArray:result.plans];
		if (2 == sg_ctrl.selectedSegmentIndex)
		{
			[self setWalkData];
		}
	}
	
	else
	{
		lb_des.text = @"未找到步行路线,试一下其他方式吧!";
		[RWShowView closeAlert];
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = end.pt;
		item.title = annotation_title;
		item.subtitle = daddr;
		[map_view addAnnotation:item];
		
		BMKCoordinateRegion region;
		region.center.latitude  = end.pt.latitude;
		region.center.longitude = end.pt.longitude;
		region.span.latitudeDelta  = 0.01;
		region.span.longitudeDelta = 0.01;
		map_view.region   = region;
	}
    
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = NO;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = NO;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = NO;
                view.enabled = NO;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = NO;
                view.enabled = NO;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = NO;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
            view.enabled = NO;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)Annotation
{
	if ([Annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)Annotation];
 
	}
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (BMKPinAnnotationView *mkaview in views)
	{
        if ([mkaview.annotation.subtitle isEqualToString:@"汽车位置"])
        {
            point = [mapView convertCoordinate:mkaview.annotation.coordinate toPointToView:mapView];
            selectedAV = mkaview;
            lb_car_poi.text = mkaview.annotation.subtitle;
            [self showBubble];
        }
	}
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    if ([view isKindOfClass:[BMKAnnotationView class]])
    {
        point = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView];
        selectedAV = view;
        lb_car_poi.text = view.annotation.subtitle;
        [self showBubble];
    }
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

- (void)showBubble
{
    if (bubble_view)
    {
        [bubble_view removeFromSuperview];
    }
    bubble_view.frame = CGRectMake(point.x - bubble_view.frame.size.width *0.5 - 3, point.y - bubble_view.frame.size.height - 35.0f, 133, bubble_view.frame.size.height);
    lb_car_poi.frame = CGRectMake(0.0f, 0.0f, 92, 38);
    [bubble_view addSubview:lb_car_poi];
    [self.map_view addSubview:bubble_view];
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}


- (void)loadData
{
    if (is_loading)
    {
        return;
    }
    is_loading  = YES;
    [RWShowView show:@"loading"];
	NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, GET_GPS_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadData:)];
	[loader loadwithTimer];
    
}

- (void)onLoadData:(NSNotification *)notify
{
    is_loading  = NO;
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        [RWShowView closeAlert];
        if ([[json objectForKey:@"errcode"] integerValue] == 601)
        {
            [RWAlertView show:@"没有找到您汽车的位置!" ];
            self.navigationItem.rightBarButtonItem = nil;
            return;
        }
        [RWAlertView show:@"网络链接失败!" ];
        [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
 		return;
	}

    [poi_buffer removeAllObjects];
    if ([json objectForKey:@"data"])
    {
        NSDictionary *dic = [json objectForKey:@"data"];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] floatValue], [[dic objectForKey:@"lng"] floatValue]);
        NSDictionary *dic_baidu = BMKBaiduCoorForWgs84(location);
        CLLocationCoordinate2D location_baidu = BMKCoorDictionaryDecode(dic_baidu);
        NSDictionary *d = @{@"lat" : [NSString stringWithFormat:@"%f",location_baidu.latitude ],@"lng":[NSString stringWithFormat:@"%f",location_baidu.longitude],@"updatetime":[dic objectForKey:@"updatetime"]};
        [poi_buffer addObject:d];
        
        self.lat = [NSString stringWithFormat:@"%f",location_baidu.latitude ];
        self.lng = [NSString stringWithFormat:@"%f",location_baidu.longitude ];
        daddr = @"汽车位置";
        
        is_car_poi = YES;
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){location_baidu.latitude, location_baidu.longitude};
        search = [[BMKSearch alloc]init];
		search.delegate = self;
		[search reverseGeocode:pt];

    }
    else
    {
        lb_poi.text = @"没有找到您汽车的位置!" ;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)onLoadFail:(NSNotification *)notify
{
    is_loading  = NO;
    [RWShowView closeAlert];
    [RWAlertView show:@"网络链接失败!" ];
  	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
    
}

- (void) segmentedControlChange:(id)sender
{
    UISegmentedControl *sg = (UISegmentedControl *)sender;
	[RWAlertView closeAlert];
    [bubble_view removeFromSuperview];
	if (0 == sg.selectedSegmentIndex)
	{
		[RWShowView show:@"loading"];
		lb_des.text = @"正在获取自驾线路...";
		NSArray* array = [NSArray arrayWithArray:map_view.annotations];
		[map_view removeAnnotations:array];
		array = [NSArray arrayWithArray:map_view.overlays];
		[map_view removeOverlays:array];
		
		if ([self.drive_plan count])
		{
			[self setDriveData];
			return;
		}
		[self searchDriveData];
	}
	
	if (1 == sg.selectedSegmentIndex)
	{
		[RWShowView show:@"loading"];
		lb_des.text = @"正在获取公交线路...";
		NSArray* array = [NSArray arrayWithArray:map_view.annotations];
		[map_view removeAnnotations:array];
		array = [NSArray arrayWithArray:map_view.overlays];
		[map_view removeOverlays:array];
		if ([self.transitRoute_plan count])
		{
			[self setTransitData];
			return;
		}
		[self searchTransitData];
	}
	
	if (2 == sg.selectedSegmentIndex)
	{
		[RWShowView show:@"loading"];
		lb_des.text = @"正在获取步行线路...";
		NSArray* array = [NSArray arrayWithArray:map_view.annotations];
		[map_view removeAnnotations:array];
		array = [NSArray arrayWithArray:map_view.overlays];
		[map_view removeOverlays:array];
		if ([self.walk_plan count])
		{
			[self setWalkData];
			return;
		}
		[self searchWalkData];
	}

}

- (IBAction)btn_send_click:(id)sender
{
    is_send = YES;
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"请选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送车机",@"发送好友",nil];
    [as showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        is_friend = NO;
        [self sendToCheJi];
    }
    else if (1 == buttonIndex)
    {
        is_friend = YES;

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

    }
}

- (void)alertViewDidSendWithId:(NSString *)no
{
    RouteAnnotation *route_annotation = selectedAV.annotation;
    [RWShowView show:@"loading"];
    NSString *poi = [NSString stringWithFormat:@"%@|%@|%@,%@|1|%@",route_annotation.city,route_annotation.subtitle,[NSString stringWithFormat:@"%f",route_annotation.coordinate.longitude],[NSString stringWithFormat:@"%f",route_annotation.coordinate.latitude],route_annotation.title];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_POI_URL];
	RRToken *token = [RRToken getInstance];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
	[req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
	[req setParam:poi forKey:@"poi"];
    [req setParam:no forKey:@"service_number"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onFetchFail:)];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onFethNew:)];
	[loader loadwithTimer];
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


- (void) sendToCheJi
{
    RouteAnnotation *route_annotation = selectedAV.annotation;
    [RWShowView show:@"loading"];
    NSString *poi = [NSString stringWithFormat:@"%@|%@|%@,%@|1|%@",route_annotation.city,route_annotation.subtitle,[NSString stringWithFormat:@"%f",route_annotation.coordinate.longitude],[NSString stringWithFormat:@"%f",route_annotation.coordinate.latitude],route_annotation.title];
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

- (void) onFethNew:(NSNotification *)notify
{
    [RWShowView closeAlert];
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	
	if (![[json objectForKey:@"success"] boolValue])
	{
        [RWShowView closeAlert];
        [RWAlertView show:@"发送失败!" ];
 		return;
	}
    
    if (is_friend)
    {
        [RWAlertView show:@"发送成功! 稍后您的好友将收到该点的信息!"];
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


- (void)singleTap
{
    if ([car_poi length] == 0)
    {
        return;
    }
    
	RWTrafficDetailController *ctrl = [[RWTrafficDetailController alloc] initWithStyle:UITableViewStyleGrouped];
	ctrl.transitRoute_plan = self.transitRoute_plan;
	ctrl.drive_plan = self.drive_plan;
	ctrl.walk_plan = self.walk_plan;
	ctrl.city_name = self.city_name;
	ctrl.saddr = self.start.name;
    ctrl.daddr = car_poi;
	ctrl.start = self.start;
	ctrl.end = self.end;
	ctrl.delegate = self;
	nav = [[NavController alloc] initWithRootViewController:ctrl];
	if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 5.0)
	{
//        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
//        [nav.navigationBar setTintColor:[UIColor colorWithRed:71.0f/255.0f green:158.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
	}
	
	[nav setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self.navigationController presentModalViewController:nav animated:YES];
}

#pragma mark check token

- (void) checkTokenSuccess
{
    poi_buffer = [NSMutableArray arrayWithCapacity:0];
    [self loadData];
}

- (void) alertViewDidCancel
{
    if (is_send)
    {
        is_send = NO;
        return;
    }
    [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.0f];
    
}

- (void) popToViewController
{
	[self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (void)btn_history_click:(id)sender
{
    selectedAV = nil;
    PoiListViewController *ctrl = [[PoiListViewController alloc]initWithStyle:UITableViewStylePlain];
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)getPoiBuffer:(NSMutableArray *)poi
{
    is_ploy = YES;
    [bubble_view removeFromSuperview];
    NSArray* array = [NSArray arrayWithArray:map_view.annotations];
	[map_view removeAnnotations:array];
	array = [NSArray arrayWithArray:map_view.overlays];
	[map_view removeOverlays:array];

    NSDictionary *sdic = [poi objectAtIndex:0];
    NSDictionary *edic = [poi objectAtIndex:[poi count] - 1];
    
    CLLocationDegrees slatitude = [[sdic objectForKey:@"lat"] floatValue];
    CLLocationDegrees slongitude = [[sdic objectForKey:@"lng"] floatValue];
    CLLocationCoordinate2D scoordinate = CLLocationCoordinate2DMake(slatitude, slongitude);
    
    CLLocationDegrees elatitude = [[edic objectForKey:@"lat"] floatValue];
    CLLocationDegrees elongitude = [[edic objectForKey:@"lng"] floatValue];
    CLLocationCoordinate2D ecoordinate = CLLocationCoordinate2DMake(elatitude, elongitude);

    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
	item.coordinate = scoordinate;
	item.title = @"汽车起始位置";
	item.type = 0;
	item.subtitle =  @"汽车起始位置";
	[map_view addAnnotation:item];
	
	int size = [poi count];
	
    CLLocationCoordinate2D * locationCoodinateArr =  (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * [poi count]);
    locationCoodinateArr[0] = scoordinate;


    for (int j = 1; j < size - 1; j++)
    {
        NSDictionary *dic = [poi objectAtIndex:j];
        CLLocationDegrees lat = [[dic objectForKey:@"lat"] floatValue];
        CLLocationDegrees lng = [[dic objectForKey:@"lng"] floatValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"time"] doubleValue]]];
        NSString *time = post_date;

        item = [[RouteAnnotation alloc]init];
        item.coordinate = coordinate;
        item.title = @"汽车位置";
        item.subtitle = [ NSString stringWithFormat:@"更新时间:%@",time];
        item.type = 4;
        locationCoodinateArr[j] = coordinate;
     }

    locationCoodinateArr[size -1] = ecoordinate;

	item = [[RouteAnnotation alloc]init];
	item.coordinate = ecoordinate;
	item.type = 1;
	item.title = @"汽车终止位置";
	item.subtitle = @"汽车终止位置";
	[map_view addAnnotation:item];
    
    
	BMKPolyline* polyLine = [BMKPolyline polylineWithCoordinates:locationCoodinateArr count:size];
	[map_view addOverlay:polyLine];
    

}

- (void) searchTransitData
{
	if (policy_type <=2)
	{
		policy_type = 3;
	}
	
	[RWShowView show:@"loading"];
	search.transitPolicy = policy_type;
	search.delegate = self;
	BOOL flag = [search transitSearch:city_name startNode:start endNode:end];
	if (!flag) {
		NSLog(@"search failed");
		[RWShowView closeAlert];
		lb_des.text = @"未找到公交路线,试一下其他方式吧!";
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = end.pt;
		item.title = annotation_title;
		item.subtitle = daddr;
		[map_view addAnnotation:item];
		
		BMKCoordinateRegion region;
		region.center.latitude  = end.pt.latitude;
		region.center.longitude = end.pt.longitude;
		region.span.latitudeDelta  = 0.25;
		region.span.longitudeDelta = 0.25;
		map_view.region   = region;
        
	}
}

- (void) searchDriveData
{
	if (policy_type > 3)
	{
		policy_type = 1;
	}
	[RWShowView show:@"loading"];
	search.drivingPolicy = policy_type;
	search.delegate = self;
	BOOL flag = [search drivingSearch:start.name startNode:start endCity:end.name endNode:end];
	if (!flag)
	{
		NSLog(@"search failed");
		[RWShowView closeAlert];
		lb_des.text = @"未找到自驾路线,试一下其他方式吧!";
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = end.pt;
		item.title = annotation_title;
		item.subtitle = daddr;
		[map_view addAnnotation:item];
		
		BMKCoordinateRegion region;
		region.center.latitude  = end.pt.latitude;
		region.center.longitude = end.pt.longitude;
		region.span.latitudeDelta  = 0.25;
		region.span.longitudeDelta = 0.25;
		map_view.region   = region;
	}
}

- (void) searchWalkData
{
	[RWShowView show:@"loading"];
	search.delegate = self;
	BOOL flag = [search walkingSearch:start.name startNode:start endCity:end.name endNode:end];
	if (!flag) {
		NSLog(@"search failed");
		[RWShowView closeAlert];
		lb_des.text = @"未找到步行路线,试一下其他方式吧!";
		BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
		item.coordinate = end.pt;
		item.title = annotation_title;
		item.subtitle = daddr;
		[map_view addAnnotation:item];
		
		BMKCoordinateRegion region;
		region.center.latitude  = end.pt.latitude;
		region.center.longitude = end.pt.longitude;
		region.span.latitudeDelta  = 0.25;
		region.span.longitudeDelta = 0.25;
		map_view.region   = region;
	}
}

- (void) setTransitData
{
	[RWShowView closeAlert];
	BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[self.transitRoute_plan objectAtIndex:0];
	if (!plan)
	{
		lb_des.text = @"未找到公交路线,试一下其他方式吧!";
		return;
	}
	
	int distance = plan.distance/1000;
	int hour = distance/busSpeed;
	int min = ((distance%busSpeed) *60)/busSpeed;
	int mine = (((plan.distance/100)%walkSpeed) *60)/walkSpeed;
    
	if (search.transitPolicy == BMKBusTimeFirst)
	{
		if (plan.distance/100 == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"方案:时间优先  约:%d0米/%d分钟",plan.distance/10,mine];
		}
        
		else if (plan.distance/1000 == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"方案:时间优先  约:%d00米/%d分钟",plan.distance/100,mine];
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"方案:时间优先  约:%d公里/%d小时%d分钟",distance,hour,min];
		}
	}
	
	else if (search.transitPolicy == BMKBusTransferFirst)
	{
		if (plan.distance/100 == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"方案:最少换乘  约:%d0米/%d分钟",plan.distance/10,mine];
		}
        
		else if (plan.distance/1000 == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"方案:最少换乘  约:%d00米/%d分钟",plan.distance/100,mine];
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"方案:最少换乘  约:%d公里/%d小时%d分钟",distance,hour,min];
		}
	}
	else if (search.transitPolicy == BMKBusWalkFirst)
	{
		if (plan.distance/100 == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"方案:最小步行距离  约:%d0米/%d分钟",plan.distance/10,mine];
		}
        
		else if (plan.distance/1000 == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"方案:最小步行距离  约:%d00米/%d分钟",plan.distance/100,mine];
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"方案:最小步行距离  约:%d公里/%d小时%d分钟",distance,hour,min];
		}
	}
	
	RouteAnnotation* item = [[RouteAnnotation alloc]init];
	item.coordinate = plan.startPt;
	item.title = saddr;
	item.type = 0;
	item.subtitle = @"当前位置";
	[map_view addAnnotation:item];
	item = [[RouteAnnotation alloc]init];
	item.coordinate = plan.endPt;
	item.type = 1;
	item.title = annotation_title;
	item.subtitle = daddr;
	[map_view addAnnotation:item];
	
	int size = [plan.lines count];
	int index = 0;
	for (int i = 0; i < size; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			index += len;
		}
		BMKLine* line = [plan.lines objectAtIndex:i];
		index += line.pointsCount;
		if (i == size - 1) {
			i++;
			route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
			break;
		}
	}
	
	BMKMapPoint* points = new BMKMapPoint[index];
	index = 0;
	
	for (int i = 0; i < size; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
			memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
			index += len;
		}
		BMKLine* line = [plan.lines objectAtIndex:i];
		memcpy(points + index, line.points, line.pointsCount * sizeof(BMKMapPoint));
		index += line.pointsCount;
		
		item = [[RouteAnnotation alloc]init];
		item.coordinate = line.getOnStopPoiInfo.pt;
		item.title = line.tip;
		
		if (line.type == 0) {
			item.type = 2;
		} else {
			item.type = 3;
		}
		
		[map_view addAnnotation:item];
		route = [plan.routes objectAtIndex:i+1];
		item = [[RouteAnnotation alloc]init];
		item.coordinate = line.getOffStopPoiInfo.pt;
		item.title = route.tip;
		
		if (line.type == 0) {
			item.type = 2;
		} else {
			item.type = 3;
		}
		[map_view addAnnotation:item];
		if (i == size - 1) {
			i++;
			route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			break;
		}
	}
	
	BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
	[map_view addOverlay:polyLine];
	delete []points;
    
}

- (void) setDriveData
{
	[RWShowView closeAlert];
	BMKRoutePlan* plan = (BMKRoutePlan*)[self.drive_plan objectAtIndex:0];
	if (!plan)
	{
		lb_des.text = @"未找到自驾路线,试一下其他方式吧!";
		return;
	}
    
	int distance = plan.distance/1000;
	int hour = distance/driveSpeed;
	int min = ((distance%driveSpeed) *60)/driveSpeed;
	int mine = (((plan.distance/100)%walkSpeed) *60)/walkSpeed;
    
	if (search.drivingPolicy == BMKCarTimeFirst)
	{
		if (plan.distance/100 == 0)
		{
			if (mine == 0 && min == 0)
			{
				lb_des.text = [NSString stringWithFormat:@"方案:时间优先  约:%d0米/少于1分钟",plan.distance/10];
			}
			else
			{
				lb_des.text = [NSString stringWithFormat:@"方案:时间优先  约:%d0米/%d分钟",plan.distance/10,mine];
			}
            
		}
		else if (plan.distance/1000 == 0)
		{
			if (mine == 0 && min == 0)
			{
				lb_des.text = [NSString stringWithFormat:@"方案:时间优先   约:%d00米/少于1分钟",plan.distance/100];
			}
			else
			{
				lb_des.text = [NSString stringWithFormat:@"方案:时间优先  约:%d00米/%d分钟",plan.distance/100,mine];
			}
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"方案:时间优先  约:%d公里/%d小时%d分钟",distance,hour,min];
		}
	}
	
	else if (search.drivingPolicy == BMKCarDisFirst)
	{
		if (plan.distance/100 == 0)
		{
			if (mine == 0 && min == 0)
			{
				lb_des.text = [NSString stringWithFormat:@"方案:最短距离  约:%d0米/少于1分钟",plan.distance/10];
			}
			else
			{
				lb_des.text = [NSString stringWithFormat:@"方案:最短距离  约:%d0米/%d分钟",plan.distance/10,mine];
			}
		}
        
		else if (plan.distance/1000 == 0)
		{
			if (mine == 0 && min == 0)
			{
				lb_des.text = [NSString stringWithFormat:@"方案:最短距离   约:%d00米/少于1分钟",plan.distance/100];
			}
			else
			{
				lb_des.text = [NSString stringWithFormat:@"方案:最短距离  约:%d00米/%d分钟",plan.distance/100,mine];
			}
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"方案:最短距离  约:%d公里/%d小时%d分钟",distance,hour,min];
		}
	}
	else if (search.drivingPolicy == BMKCarFeeFirst)
	{
		if (plan.distance/100 == 0)
		{
			if (mine == 0 && min == 0)
			{
				lb_des.text = [NSString stringWithFormat:@"方案:较少费用  约:%d0米/少于1分钟",plan.distance/10];
			}
			else
			{
				lb_des.text = [NSString stringWithFormat:@"方案:较少费用  约:%d0米/%d分钟",plan.distance/10,mine];
			}
            
		}
		else if (plan.distance/1000 == 0)
		{
			if (mine == 0 && min == 0)
			{
				lb_des.text = [NSString stringWithFormat:@"方案:较少费用   约:%d00米/少于1分钟",plan.distance/100];
			}
			else
			{
				lb_des.text = [NSString stringWithFormat:@"方案:较少费用  约:%d00米/%d分钟",plan.distance/100,mine];
			}
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"方案:较少费用  约:%d公里/%d小时%d分钟",distance,hour,min];
		}
	}
	
	RouteAnnotation* item = [[RouteAnnotation alloc]init];
	item.coordinate = start.pt;
	item.title = saddr;
	item.type = 0;
	item.subtitle = @"当前位置";
    item.city = current_city_name;
	[map_view addAnnotation:item];
	
	int index = 0;
	int size = [plan.routes count];
	for (int i = 0; i < 1; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			index += len;
		}
	}
	
	BMKMapPoint* points = new BMKMapPoint[index];
	index = 0;
	
	for (int i = 0; i < 1; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
			memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
			index += len;
		}
		size = route.steps.count;
		for (int j = 0; j < size; j++) {
			BMKStep* step = [route.steps objectAtIndex:j];
			item = [[RouteAnnotation alloc]init];
			item.coordinate = step.pt;
			item.title = step.content;
			item.degree = step.degree * 30;
			item.type = 4;
			[map_view addAnnotation:item];
		}
	}
	
	item = [[RouteAnnotation alloc]init];
	item.coordinate = end.pt;
	item.type = 1;
	item.title = car_poi;
	item.subtitle = daddr;
    item.city = car_city_name;
	[map_view addAnnotation:item];
	BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
	[map_view addOverlay:polyLine];
	delete []points;
    
}

- (void) setWalkData
{
	[RWShowView closeAlert];
	BMKRoutePlan* plan = (BMKRoutePlan*)[self.walk_plan objectAtIndex:0];
	if (!plan)
	{
		lb_des.text = @"未找到步行路线,试一下其他方式吧!";
		return;
	}
	int distance = plan.distance/1000;
	int hour = distance/walkSpeed;
	int min = ((distance%walkSpeed) *60)/walkSpeed;
	int mine = (((plan.distance/100)%walkSpeed) *60)/walkSpeed;
    
	if (plan.distance/100 == 0)
	{
		if (min == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"约:%d0米/少于1分钟",plan.distance/10];
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"约:%d0米/%d分钟",plan.distance/10,mine];
		}
	}
	else if (plan.distance/1000 == 0)
	{
		if (mine == 0 && min == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"约:%d00米/少于1分钟",plan.distance/100];
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"约:%d00米/%d分钟",plan.distance/100,mine];
		}
        
	}
	else
	{
		if (mine == 0 && min == 0)
		{
			lb_des.text = [NSString stringWithFormat:@"约:%d公里/少于1分钟",distance];
		}
		else
		{
			lb_des.text = [NSString stringWithFormat:@"约:%d公里/%d小时%d分钟",distance,hour,min];
		}
	}
	
	RouteAnnotation* item = [[RouteAnnotation alloc]init];
	item.coordinate = start.pt;
	item.title = saddr;
	item.type = 0;
	item.subtitle = @"当前位置";
	[map_view addAnnotation:item];
	
	int index = 0;
	int size = [plan.routes count];
	for (int i = 0; i < 1; i++) {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++) {
			int len = [route getPointsNum:j];
			index += len;
		}
	}
	
	BMKMapPoint* points = new BMKMapPoint[index];
	index = 0;
	
	for (int i = 0; i < 1; i++)
    {
		BMKRoute* route = [plan.routes objectAtIndex:i];
		for (int j = 0; j < route.pointsCount; j++)
        {
			int len = [route getPointsNum:j];
			BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
			memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
			index += len;
		}
		size = route.steps.count;
		for (int j = 0; j < size; j++) {
			BMKStep* step = [route.steps objectAtIndex:j];
			item = [[RouteAnnotation alloc]init];
			item.coordinate = step.pt;
			item.title = step.content;
			item.degree = step.degree * 30;
			item.type = 4;
			[map_view addAnnotation:item];
		}
	}
	
	item = [[RouteAnnotation alloc]init];
	item.coordinate = end.pt;
	item.type = 1;
	item.title = annotation_title;
	item.subtitle = daddr;
	[map_view addAnnotation:item];
	BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
	[map_view addOverlay:polyLine];
	delete []points;
}

#pragma mark -
#pragma mark RWTrafficDetailControllerDelegate

- (void) didFinishSortWithDictionary:(NSMutableDictionary *)dict
{
    if ([dict count] == 0)
    {
        return;
    }
	if ([dict objectForKey:@"drive_plan"])
	{
		self.drive_plan = [NSMutableArray arrayWithObject:[dict objectForKey:@"drive_plan"]];
	}
	
	if ([dict objectForKey:@"transitRoute_plan"])
	{
		self.transitRoute_plan = [NSMutableArray arrayWithArray:[dict objectForKey:@"transitRoute_plan"]];
	}
	if ([dict objectForKey:@"walk_plan"])
	{
		self.walk_plan =  [NSMutableArray arrayWithObject:[dict objectForKey:@"walk_plan"]];
	}
	
	self.start = [dict objectForKey:@"start"];
	
	NSArray* array = [NSArray arrayWithArray:map_view.annotations];
	[map_view removeAnnotations:array];
	array = [NSArray arrayWithArray:map_view.overlays];
	[map_view removeOverlays:array];
	
	search.transitPolicy = [[dict objectForKey:@"transitPolicy"]integerValue];
	search.drivingPolicy = [[dict objectForKey:@"drivingPolicy"]integerValue];
	switch ([[dict objectForKey:@"src_type"] integerValue])
	{
		case 0:
			sg_ctrl.selectedSegmentIndex = 0;
			[self setDriveData];
			break;
		case 1:
			sg_ctrl.selectedSegmentIndex = 1;
			[self setTransitData];
			break;
		case 2:
			sg_ctrl.selectedSegmentIndex = 2;
			[self setWalkData];
			break;
		default:
			break;
	}
    
}

@end
