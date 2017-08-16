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

#define topBarheight      ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?64:44)
#define DeviceVersion     [[[UIDevice currentDevice] systemVersion] floatValue] //判断系统版本
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height < 568)    //判断该设备是否为3.5寸
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height >= 568)   //判断该设备是否为5
#define iPhone4 ([UIScreen mainScreen].bounds.size.height==480?YES:NO)
#define iPhone5 ([UIScreen mainScreen].bounds.size.height==568?YES:NO)
#define iPhone6 ([UIScreen mainScreen].bounds.size.height==667?YES:NO)
#define iPhone6_plus ([UIScreen mainScreen].bounds.size.height==736?YES:NO)

// iOS System Version Checking
#define IS_IOS_8_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS_8_OR_BELOW ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
#define IS_IOS_9_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

// iOS Device Checking
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_HEIGHT < 568.0)
#define IS_IPHONE_5 (SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_WIDTH == 320.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && SCREEN_HEIGHT == 736.0)
#define IS_IPHONE_6_PLUS_OR_ABOVE (IS_IPHONE && SCREEN_HEIGHT >= 736.0)
#define IS_IPHONE_6_OR_ABOVE (IS_IPHONE && SCREEN_WIDTH > 320.0)

#define STATUS_BAR_HEIGHT CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
// Hardcoded first unless there is better choice
#define NAVIGATION_BAR_HEIGHT 44.f
// Custom Tab Bar with 1px line at the top
#define TAB_BAR_HEIGHT  50.f
#define SR2_TOOL_BAR_HEIGHT  60.f

#define LANG_ZH     @"tc"   // Tranditional Chinese
#define LANG_EN     @"en"   // English
#define LANG_SC     @"sc"   // Simplified Chinese
#define LANG_Thai   @"th"   // Thai
#define LANG_ID     @"id"   // Bahasa
#define LANG_JP     @"ja"   // Japanese

#define LANG_HK     @"hk"   // Tranditional Chinese (Hong Kong)
#define LANG_TW     @"tw"   // Tranditional Chinese (Taiwan)



#define AppID                   @"1230303508"
#define AdmobApplicationID      @"ca-app-pub-8216990062470309~2518401071"
//#define AdUnitID                @"ca-app-pub-8216990062470309/3995134275"
//#define TestDevice              @"" ///admob test device

#define AdUnitID                @"ca-app-pub-3940256099942544/2934735716"  /////for test
#define TestDevice              @"a492223edaf92cbf1987951af14e360a" ///admob test device




#endif /* CommonDefine_h */
