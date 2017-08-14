//
//  Common-Define.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/13.
//  Copyright © 2017年 kun. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#ifdef PRODUCTION
#define MyLog(...)
#else
#define MyLog(...) NSLog(__VA_ARGS__)
#endif

#define debugLog(...) NSLog(__VA_ARGS__)


// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define documentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height < 568)    //判断该设备是否为3.5寸
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height >= 568)   //判断该设备是否为5
#define DeviceVersion     [[[UIDevice currentDevice] systemVersion] floatValue] //判断系统版本
#define topBarheight      ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?64:44)

#define AppID                   @"1230303508"
#define AdmobApplicationID      @"ca-app-pub-8216990062470309~2518401071"
//#define AdUnitID                @"ca-app-pub-8216990062470309/3995134275"
//#define TestDevice              @"" ///admob test device

#define AdUnitID                @"ca-app-pub-3940256099942544/2934735716"  /////for test
#define TestDevice              @"a492223edaf92cbf1987951af14e360a" ///admob test device

#define iPhone4 ([UIScreen mainScreen].bounds.size.height==480?YES:NO)
#define iPhone5 ([UIScreen mainScreen].bounds.size.height==568?YES:NO)

#define iPhone6 ([UIScreen mainScreen].bounds.size.height==667?YES:NO)
#define iPhone6_plus ([UIScreen mainScreen].bounds.size.height==736?YES:NO)


#endif /* CommonDefine_h */
