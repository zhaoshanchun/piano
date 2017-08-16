//
//  Common-Function.h
//  OpenRice
//
//  Created by hangyuen on 9/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#ifndef OpenRice_Common_Function_h
#define OpenRice_Common_Function_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

void saveObjectToUserDefaults(NSString *key, NSObject *obj);
NSObject* getObjectFromUserDefaults(NSString *key);
NSString* getStringFromUserDefaults(NSString *key);

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

// Check visible view controller is Present Model
void presentControllerInRootViewController(UIViewController *viewController, BOOL animated);
BOOL isPresentViewController(UIViewController *controller);
BOOL isSupportPhoneCall(void);
BOOL isValidEmail(NSString *email);
BOOL isOnlyNumbers(NSString *string);
BOOL checkIfOpenNotification();

NSCalendar *calendar();
NSDateFormatter *locDateFormatter();


BOOL containsString(NSString *fullString, NSString *subString);

// format - params [ text1, style1, text2, style2 ]
NSMutableAttributedString *formatAttributedStringByORFontGuide(NSArray *params, NSArray *paragraphStyles);
NSMutableAttributedString *formatAttributedStringWithHighlightedText(NSString *text, NSString *style, NSString *highlightedText, NSString *highlightedStyle);
NSMutableAttributedString *formatAttributedStringWithHighlightedTexts(NSString *text, NSString *style, NSArray *highlightedText, NSArray *highlightedStyle);
NSMutableAttributedString *formatAttributedStringWithLineHeight(NSAttributedString *attributedString, CGFloat lineHeight);

// Cut a string according to one width, and add at the end of the...(根据一个宽度来截断一个字符串，并且在末尾添加上...)
NSString *stringByTruncatingToWidth(CGFloat width, UIFont *font, NSString *string);
NSString *attributeStringByTruncatingToWidth(CGFloat width, NSString *fontKey, NSString *string, NSMutableParagraphStyle *style);
// add a newLineFlag at tail of string.
NSString *stringByAddNewLineFlag(NSString *string);
NSString *getSpaceStringInWidth(float width, NSString *fontKey);

NSString *getStarForRating(CGFloat number);

// image processing
NSString *mineTypeForImageData(NSData *data);
NSString *fileNameForImageData(NSData *data);







#endif
