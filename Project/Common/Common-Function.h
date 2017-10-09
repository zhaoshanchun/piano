//
//  Common-Function.h
//  gangqinjiaocheng
//
//  Created by zhaosc on 17/8/13.
//  Copyright © 2017年 kun. All rights reserved.
//

#ifndef OpenRice_Common_Function_h
#define OpenRice_Common_Function_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kLanguagekey @"kLanguagekey"

void saveObjectToUserDefaults(NSString *key, NSObject *obj);

NSObject* getObjectFromUserDefaults(NSString *key);
NSString* getStringFromUserDefaults(NSString *key);

BOOL containsString(NSString *fullString, NSString *subString);

NSString *getLocalLanguage();
NSString *localizeString(NSString *stringKey);


NSDictionary *fontDictionary();

NSString* getFontName(NSString *fontType);

CGSize getSizeForString(NSString *string, UIFont *font, CGFloat width, CGFloat height);
CGSize getSizeForAttributedString(NSAttributedString *string, CGFloat width, CGFloat height);


void setFontAndTextColorForFontKey(NSString *fontKey, UIFont **font, UIColor **color);
UIFont *getFontByKey(NSString *fontKey);


NSDictionary *mergeDictionaries(NSDictionary *lhs, NSDictionary *rhs);
NSDictionary *removeKeysFromDictionary(NSDictionary *dict, NSArray *keys);

void deleteObjectByKey(NSString *key, NSMutableDictionary *dict);
id jsonObjectFromJSONString(NSString *string);

NSString *jsonStringFromNSObject(id object);

BOOL isPresentViewController(UIViewController *controller);
BOOL isSupportPhoneCall();
BOOL isValidEmail(NSString *email);
BOOL isOnlyNumbers(NSString *string);


NSCalendar *calendar();
NSDateFormatter *locDateFormatter();
NSDate *formatDateFromLocalDate(NSString *dateString);


NSMutableAttributedString *formatAttributedStringByORFontGuide(NSArray *params, NSArray *paragraphStyles);
NSString *stringByAddNewLineFlag(NSString *string);
NSString *getSpaceStringInWidth(float width, NSString *fontKey);
NSMutableAttributedString *formatAttributedStringWithHighlightedText(NSString *text, NSString *style, NSString *highlightedText, NSString *highlightedStyle);
NSMutableAttributedString *formatAttributedStringWithHighlightedTexts(NSString *text, NSString *style, NSArray *highlightedText, NSArray *highlightedStyle);
NSMutableAttributedString *formatAttributedStringWithLineHeight(NSAttributedString *attributedString, CGFloat lineHeight);
NSString *stringByTruncatingToWidth(CGFloat width, UIFont *font, NSString *string);
NSString *attributeStringByTruncatingToWidth(CGFloat width, NSString *fontKey, NSString *string, NSMutableParagraphStyle *style);


void presentControllerInRootViewController(UIViewController *viewController, BOOL animated);
BOOL checkIfOpenNotification();


NSString *mineTypeForImageData(NSData *data);
NSString *fileNameForImageData(NSData *data);



#endif


