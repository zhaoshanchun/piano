//
//  Common-Function.m
//  OpenRice
//
//  Created by hangyuen on 9/10/14.
//  Copyright (c) 2014 OpenRice Limited. All rights reserved.
//

#import "Common-Function.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


#if (CN == 0)
@import GoogleMobileAds;
#endif

void saveObjectToUserDefaults(NSString *key, NSObject *obj) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj forKey:key];
    [defaults synchronize];
}

NSObject* getObjectFromUserDefaults(NSString *key) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

NSString* getStringFromUserDefaults(NSString *key) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:key];
}

BOOL containsString(NSString *fullString, NSString *subString) {
    NSRange range = [fullString rangeOfString:subString];
    return range.length != 0;
}


NSDictionary *fontDictionary() {
    static NSDictionary *fontDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontDictionary = @{
                           @"L":@{LANG_EN:@"Lato-Light", LANG_SC:@"HelveticaNeue-Light"},
                           @"I":@{LANG_EN:@"Lato-Italic", LANG_SC:@"HelveticaNeue-Light"},
                           @"N":@{LANG_EN:@"Lato-Regular", LANG_SC:@"HelveticaNeue"},
                           @"B":@{LANG_EN:@"Lato-Bold", LANG_SC:@"HelveticaNeue-Medium"},
                           };
    });
    return fontDictionary;
}

NSString* getFontName(NSString *fontType) {
    // 暂时只支持中文 LANG_SC, LANG_EN 待文字本地化后再处理
    NSString *font = [[fontDictionary() objectForKey:[fontType uppercaseString]] objectForKey:LANG_SC];
    return (font == nil) ? [[fontDictionary() objectForKey:[fontType uppercaseString]] objectForKey:LANG_EN] : font;
}

CGSize getSizeForString(NSString *string, UIFont *font, CGFloat width, CGFloat height) {
    CGSize size = CGSizeZero;
    CGSize bSize = CGSizeMake(width, height);
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        
        size = CGRectIntegral([string boundingRectWithSize:bSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font } context:nil]).size;
        
    }
    return size;
}

CGSize getSizeForAttributedString(NSAttributedString *string, CGFloat width, CGFloat height) {
    CGSize size = CGSizeZero;
    CGSize bSize = CGSizeMake(width, height);
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        
        size = CGRectIntegral([string boundingRectWithSize:bSize
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   context:nil]).size;
    }
    return size;
}


void setFontAndTextColorForFontKey(NSString *fontKey, UIFont **font, UIColor **color) {
    if (fontKey.length > 3) {
        // It assume:
        // 1. The fontKey in "o10N" format
        // 2. The smallest font size is 10, and is 2 characters for all cases
        // 3. The font name is 1 character
        NSString *cKey = [fontKey substringToIndex:fontKey.length - 3];
        NSString *sKey = [fontKey substringWithRange:NSMakeRange(fontKey.length - 3, 2)];
        NSString *fKey = [fontKey substringFromIndex:fontKey.length - 1];
        *font = [UIFont fontWithName:getFontName(fKey) size:([sKey floatValue])];
        *color = [UIColor colorForKey:cKey];
    } else {
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([a-z,A-Z]{1,4})([0-9]{1,3})([a-z,A-Z]{1})"
                                                                               options:0 error:&error];
        NSArray *matches = [regex matchesInString:fontKey
                                          options:0
                                            range:NSMakeRange(0, [fontKey length])];
        for (NSTextCheckingResult *match in matches) {
            if ([match numberOfRanges] == 4) {      // range 0 hold the full string
                NSString *cKey = [fontKey substringWithRange:[match rangeAtIndex:1]];
                NSString *sKey = [fontKey substringWithRange:[match rangeAtIndex:2]];
                NSString *fKey = [fontKey substringWithRange:[match rangeAtIndex:3]];
                
                *font = [UIFont fontWithName:getFontName(fKey) size:[sKey floatValue]];
                *color = [UIColor colorForKey:cKey];
            }
        }
    }
}

UIFont *getFontByKey(NSString *fontKey) {
    UIFont *font;
    UIColor *color;
    setFontAndTextColorForFontKey(fontKey, &font, &color);
    return font;
}



NSDictionary *mergeDictionaries(NSDictionary *lhs, NSDictionary *rhs) {
    if (lhs == nil) return [NSDictionary dictionaryWithDictionary:rhs];
    if (rhs == nil) return [NSDictionary dictionaryWithDictionary:lhs];
    
    NSMutableDictionary *ret = [lhs mutableCopy];
    [ret addEntriesFromDictionary:rhs];
    return [NSDictionary dictionaryWithDictionary:ret];
}

NSDictionary *removeKeysFromDictionary(NSDictionary *dict, NSArray *keys) {
    NSMutableDictionary *ret = [dict mutableCopy];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = (NSString *)obj;
        [ret removeObjectForKey:key];
    }];
    return [NSDictionary dictionaryWithDictionary:ret];
}

void deleteObjectByKey(NSString *key, NSMutableDictionary *dict) {
    for (NSString *searchKey in dict) {
        NSArray *arr = [searchKey componentsSeparatedByString:@"="];
        if ([arr.firstObject isEqualToString:key]) {
            [dict removeObjectForKey:searchKey];
            break;
        }
    }
}

id jsonObjectFromJSONString(NSString *string) {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    return nil;
}

NSString *jsonStringFromNSObject(id object) {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        MyLog(@"Got an error: %@", error);
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

BOOL isPresentViewController(UIViewController *controller) {
    if([controller presentingViewController])
        return YES;
    if([[controller presentingViewController] presentedViewController] == controller)
        return YES;
    
    if ([controller navigationController] != nil) {
        if([[[controller navigationController] presentingViewController] presentedViewController] == [controller navigationController])
            return YES;
    }
    
    if([[[controller tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]] || [[[controller tabBarController] presentingViewController] isKindOfClass:[MainTabBarController class]])
        return YES;
    
    return NO;
}

BOOL isSupportPhoneCall() {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *carrierName = [carrier carrierName];
    return ([carrierName length] > 0);
}
BOOL isValidEmail(NSString *email) {
    if (email.length == 0 || email.length > 100) {
        return NO;
    }
    
    NSString *regExPattern = @"\\b[_a-zA-Z0-9-]+(\\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.((aero|coop|info|museum|name)|([0-9]{1,3})|([a-zA-Z]{2,3}))\\b";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

BOOL isOnlyNumbers(NSString *string) {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        return YES;
    }
    return NO;
}


NSCalendar *calendar() {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    });
    return calendar;
}

NSDateFormatter *locDateFormatter() {
    static NSDateFormatter *locDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locDateFormatter = [[NSDateFormatter alloc] init];
        [locDateFormatter setTimeZone: [NSTimeZone defaultTimeZone]];
        locDateFormatter.calendar = calendar();
    });
    return locDateFormatter;
}

NSDate *formatDateFromLocalDate(NSString *dateString) {
    NSDateFormatter *dateFormatter = locDateFormatter();
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:dateString];
}


NSMutableAttributedString *formatAttributedStringByORFontGuide(NSArray *params, NSArray *paragraphStyles) {
    NSMutableArray *mergedParams = [params mutableCopy];
    if (paragraphStyles) {
        [params enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ((int)idx-2 >= 0 && [obj stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
                [mergedParams removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(idx, 2)]];
                [mergedParams replaceObjectAtIndex:idx-2 withObject:[[params objectAtIndex:idx-2] stringByAppendingString:obj]];
            }
        }];
    }
    NSUInteger count = [mergedParams count]/2;
    NSInteger paragraphIndex = 0;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    for (NSUInteger i = 0; i < count; i++) {
        UIFont *font;
        UIColor *color;
        NSString *subString = [mergedParams objectAtIndex:(i * 2)];
        NSString *fontKey = [mergedParams objectAtIndex:((i * 2) + 1)];
        setFontAndTextColorForFontKey(fontKey, &font, &color);
        
        if (paragraphStyles && [subString hasSuffix:@"\n"]) {
            subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            NSRange range = [subString rangeOfString:@"\n" options:NSBackwardsSearch];
            if (range.length > 0) {
                NSRange prefixRange = (NSRange){ 0, range.location + range.length };
                NSRange suffixRange = (NSRange){ range.location + range.length, subString.length - (range.location + range.length) };
                NSString *prefixString = [subString substringWithRange:prefixRange];
                NSString *suffixString = [subString substringWithRange:suffixRange];
                
                NSMutableAttributedString *sAttrStr = [[NSMutableAttributedString alloc] initWithString:prefixString];
                [sAttrStr addAttribute:NSFontAttributeName value:font range:prefixRange];
                [sAttrStr addAttribute:NSForegroundColorAttributeName value:color range:prefixRange];
                [sAttrStr addAttribute:NSParagraphStyleAttributeName value:[NSParagraphStyle new] range:prefixRange];
                [attrStr appendAttributedString:sAttrStr];
                subString = suffixString;
            }
            
            if (i < count-1) {
                subString = [subString stringByAppendingString:@"\n"];
            }
        }
        NSMutableAttributedString *sAttrStr = [[NSMutableAttributedString alloc] initWithString:subString];
        NSRange range = NSMakeRange(0, subString.length);
        [sAttrStr addAttribute:NSFontAttributeName value:font range:range];
        [sAttrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        NSParagraphStyle *style;
        if (paragraphStyles && paragraphStyles.count > paragraphIndex && ([subString hasSuffix:@"\n"] || i==count-1) ) {
            style = [paragraphStyles objectAtIndex:paragraphIndex];
            if (paragraphStyles.count > paragraphIndex+1) {
                paragraphIndex++;
            }
        }
        if (style) {
            [sAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
        } else if (paragraphStyles && i==count-1) {
            [sAttrStr addAttribute:NSParagraphStyleAttributeName value:[NSParagraphStyle defaultParagraphStyle] range:range];
        }
        [attrStr appendAttributedString:sAttrStr];
    }
    return attrStr;
}

NSString *stringByAddNewLineFlag(NSString *string) {
    NSString *newString = [string stringByAppendingString:@"\n"];
    return newString;
}

NSString *getSpaceStringInWidth(float width, NSString *fontKey) {
    UIFont *font = getFontByKey(fontKey);
    NSMutableString *string = [NSMutableString stringWithString:@""];
    CGSize stringSize = getSizeForString(string, font, MAXFLOAT, 20);
    
    while (stringSize.width < width) {
        [string appendString:@" "];
        stringSize = getSizeForString(string, font, MAXFLOAT, 20);
    }
    return string;
}

NSMutableAttributedString *formatAttributedStringWithHighlightedText(NSString *text, NSString *style, NSString *highlightedText, NSString *highlightedStyle) {
    NSRange highlightedRange = [text rangeOfString:highlightedText options:NSCaseInsensitiveSearch];
    if (highlightedRange.location == NSNotFound) {
        return formatAttributedStringByORFontGuide(@[ text, style ], nil);
    }
    UIFont *font,  *highlightedFont;
    UIColor *color, *highlightedColor;
    setFontAndTextColorForFontKey(style, &font, &color);
    setFontAndTextColorForFontKey(highlightedStyle, &highlightedFont, &highlightedColor);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttributes:@{
                                      NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: color
                                      }
                              range:(NSRange){ 0, text.length }];
    [attributedString addAttributes:@{
                                      NSFontAttributeName:highlightedFont,
                                      NSForegroundColorAttributeName: highlightedColor
                                      }
                              range:highlightedRange];
    
    return attributedString;
}

NSMutableAttributedString *formatAttributedStringWithHighlightedTexts(NSString *text, NSString *style, NSArray *highlightedText, NSArray *highlightedStyle) {
    UIFont *font,  *highlightedFont;
    UIColor *color, *highlightedColor;
    setFontAndTextColorForFontKey(style, &font, &color);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString addAttributes:@{
                                      NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: color
                                      }
                              range:(NSRange){ 0, text.length }];

    for (NSInteger index = 0; index < highlightedText.count; index++) {
        setFontAndTextColorForFontKey(highlightedStyle[index], &highlightedFont, &highlightedColor);
        NSRange highlightedRange = [text rangeOfString:highlightedText[index] options:NSCaseInsensitiveSearch];
        [attributedString addAttributes:@{
                                          NSFontAttributeName:highlightedFont,
                                          NSForegroundColorAttributeName: highlightedColor
                                          }
                                  range:highlightedRange];
    }
    return attributedString;

}

NSMutableAttributedString *formatAttributedStringWithLineHeight(NSAttributedString *attributedString, CGFloat lineHeight) {
    NSMutableAttributedString *formattedAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSRange range = NSMakeRange(0, attributedString.length);
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    [formattedAttributedString addAttribute:NSParagraphStyleAttributeName value:style range:range];
    return formattedAttributedString;
}

NSString *stringByTruncatingToWidth(CGFloat width, UIFont *font, NSString *string) {
    NSMutableString *str = [NSMutableString stringWithString:string];
    if (getSizeForString(string,font,MAXFLOAT,MAXFLOAT).width > width) {
        width -= getSizeForString(@"...",font,MAXFLOAT,MAXFLOAT).width;
        // （Get the last character of the range）得到最后一个字符的range
        NSRange range = {str.length - 1, 1};
        while (getSizeForString(str,font,MAXFLOAT,MAXFLOAT).width > width) {
            [str deleteCharactersInRange:range];
            range.location--;
        }
        if (str.length > 0) {
            NSUInteger lastCharIndex = [str length] - 1;
            NSRange rangeOfLastChar = [str rangeOfComposedCharacterSequenceAtIndex: lastCharIndex];
            str = [NSMutableString stringWithString:[[str substringToIndex: rangeOfLastChar.location] stringByAppendingString:@"..."]];
        }
    }
    return str;
}

NSString *attributeStringByTruncatingToWidth(CGFloat width, NSString *fontKey, NSString *string, NSMutableParagraphStyle *style) {
    NSMutableString *str = [[NSMutableString alloc] initWithString:string];
    NSMutableAttributedString *strMutableAttributeString = (NSMutableAttributedString*)formatAttributedStringByORFontGuide(@[str, fontKey], @[style]);
    CGSize size = getSizeForAttributedString(strMutableAttributeString, MAXFLOAT, MAXFLOAT);
    
    if (size.width > width) {
        NSMutableAttributedString *lapostropheAttributeString = (NSMutableAttributedString*)formatAttributedStringByORFontGuide(@[@"...", fontKey], @[style]);
        CGSize apostropheSize = getSizeForAttributedString(lapostropheAttributeString, MAXFLOAT, MAXFLOAT);
        width -= apostropheSize.width;
        
        NSRange range = {str.length - 1, 1};
        while (size.width > width) {
            [str deleteCharactersInRange:range];
            range.location--;
            strMutableAttributeString = (NSMutableAttributedString*)formatAttributedStringByORFontGuide(@[str, fontKey], @[style]);
            size = getSizeForAttributedString(strMutableAttributeString, MAXFLOAT, MAXFLOAT);
        }
        
        if (str.length > 0) {
            NSUInteger lastCharIndex = [str length] - 1;
            NSRange rangeOfLastChar = [str rangeOfComposedCharacterSequenceAtIndex: lastCharIndex];
            str = [NSMutableString stringWithString:[[str substringToIndex: rangeOfLastChar.location] stringByAppendingString:@"..."]];
        }
    }
    return str;
}


void presentControllerInRootViewController(UIViewController *viewController, BOOL animated) {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate.window.rootViewController respondsToSelector:@selector(presentationController)] &&
        [appDelegate.window.rootViewController presentationController]) {
        [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    } else if (appDelegate.window.rootViewController.presentedViewController) {
        [appDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    }    
    [appDelegate.window.rootViewController presentViewController:viewController animated:animated completion:nil];
}


BOOL checkIfOpenNotification() {
    UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    return (types & UIUserNotificationTypeAlert) || (types & UIUserNotificationTypeBadge) || (types & UIUserNotificationTypeSound);
}


NSString *mineTypeForImageData(NSData *data) {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

NSString *fileNameForImageData(NSData *data) {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"temp.jpg";
        case 0x89:
            return @"temp.png";
        case 0x47:
            return @"temp.gif";
        case 0x49:
        case 0x4D:
            return @"temp.tiff";
    }
    return nil;
}



