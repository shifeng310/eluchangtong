//
//  RRDebuger.h
//  lib_net
//
//  Created by lyq on 11-6-8.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LOGEX(level, format, ...) (level?NSLog(@"-- level:%d locate(%s:%d - %@) --\n%@", level, __FILE__, __LINE__, NSStringFromSelector(_cmd), [NSString stringWithFormat:format, __VA_ARGS__]):NSLog(format, __VA_ARGS__))
#else
#define LOGEX(level, format, ...)
#endif

/*----------------------- 后台数据接口定义 -----------------------*/

//#define BASE_URL @"http://192.168.10.7"
//#define BASE_URL @"http://210.83.232.227"
//#define BASE_URL @"http://192.168.13.40"
#define BASE_URL @"http://www.mycar4s.com"

//初始化系统
#define INIT_URL @"/api/mobile/init"

//注册
#define REG_URL @"/api/mobile/reg"

//登录地址
#define LOGIN_URL @"/api/mobile/login"

//登出
#define LOGOUT_URL @"/api/mobile/logout"

//消息中心
#define MSG_LIST_URL @"/api/mobile/servermessage"

//常用电话
#define USR_TEL_URL @"/api/mobile/usefultel"

//个人资料
#define USR_PROFILE_URL @"/api/mobile/setting"

//修改密码
#define CHANGE_PASS_URL @"/api/mobile/changepwd"

//修改头像
#define CHANGE_ICON_URL @"/api/mobile/changeicon"

//行车里程
#define DRIVE_RECORD_URL @"/api/mobile/drivingrecord"

//获取当前位置
#define GET_GPS_URL @"/api/mobile/getgps"

//获取位置列表
#define GPS_LIST_URL @"/api/mobile/gpslist"

//获取位置详情
#define GPS_DETAIL_URL @"/api/mobile/gpsdetail"

//获取位置详情测试
#define GPS_DETAIL_TEST_URL @"/api/mobile/gpsdetailtest"

//爱车服务
#define NOTICE_MSG_URL @"/api/mobile/notice"

//上传POI
#define SEND_POI_URL @"/api/mobile/sendpoi"

//获取版本信息
#define GET_VER_URL @"/api/mobile/currentiphone"

//获取附近车机
#define FETCH_NEARBY_URL @"/api2/mobile/nearby"

/*----------------------- 常用常量定义 -----------------------*/

//当前版本
#define CURRENT_VERSION_CHAR	@"1.1.0"

//发送源类型：2表示iphone终端
#define SRC_TYPE_CHAR			@"2"
#define SRC_TYPE_INT			2

//单元格背景色
#define CELL_BG_COLOR_RED		0.88276f
#define CELL_BG_COLOR_GREEN		0.90588f
#define CELL_BG_COLOR_BLUE		0.92941f
#define CELL_BG_COLOR_ALPHA		0.2f
