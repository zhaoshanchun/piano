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
#define IS_IOS_6_OR_BELOW ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
#define IS_IOS_7_OR_BELOW ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#define IS_IOS_7_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS_8_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS_8_OR_BELOW ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0)
#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0))
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
#define KEYBOARD_HEIGHT  216.f


#define LANG_EN     @"en"   // English
#define LANG_SC     @"sc"   // Simplified Chinese


#define AppID                   @"1295460632"
#define AdmobApplicationID      @"ca-app-pub-8216990062470309~2518401071"
//#define AdUnitID                @"ca-app-pub-8216990062470309/3995134275"
//#define TestDevice              @"" ///admob test device

#define AdUnitID                @"ca-app-pub-3940256099942544/2934735716"  /////for test
#define TestDevice              @"a492223edaf92cbf1987951af14e360a" ///admob test device


#define kSourceEtag             @"kSourceEtag"
#define kSourceEtagCacheTime    @"kSourceEtagCacheTime"
#define kLoginedUser            @"kLoginedUser"


// Toast
#define kToastDuration      2.0
#define kToastPositionTop   @"top"
#define kToastPositionCenter    @"center"
#define kToastPositionBottom    @"bottom"


// -- Table View Cell --
#define kCellDefaultHeight 44.0f
#define kCellDefaultLRMargin 15.0f
#define kCellDefaultTBMargin 15.0f
#define kCellDefaultAccessWidth 6.0f    // Right arrow size
#define kCellDefaultAccessHeight 12.0f


// Login/Register
#define kRegisterSuccessNotification @"kRegisterSuccessNotification"


// API Manager
#define kHTTPLoadCount 20
#define kHTTPShareListLoadCount 5
#define kHTTPTimeoutInterval 10.0f
#define kHTTPPostTimeoutInterval 120.0f
#define kHTTPMethodGet @"GET"
#define kHTTPMethodPost @"POST"
// #define kHTTPHomeAddress @"http://www.appshopping.store/app"
// #define kHTTPHomeAddress @"http://119.23.174.22/app"
#define kHTTPHomeAddress @"http://www.szappstore.com:8080/app"
#define kAPILogin @"login"
#define kAPISetAvatar @"upload_icon?"
#define kAPIGetImage @"get_image?file="
#define kAPIVerifiCode @"get_verify_code"
#define kAPIRegister @"register"

// Content list
#define kAPIHome    @"home_page"
#define kAPIContentList @"program_list"
#define kAPIContentDetail @"program_source"
#define kAPIShareSubmit @"share_submit"
#define kAPIShareList @"share_list"
#define kAPIPraise @"praise"


#define kAPPID @"yixuekaoshi"


#define kChineseDot @"●";



#endif /* CommonDefine_h */
