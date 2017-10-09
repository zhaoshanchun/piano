//
//  FavoritesManager.h
//  gangqinjiaocheng
//
//  Created by kun on 2017/9/26.
//  Copyright © 2017年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteObject : NSObject

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *preview;

@end

@interface FavoritesManager : NSObject

+ (FavoritesManager *)sharedManager;
- (void)add:(NSString *)uuid title:(NSString *)title preview:(NSString *)preview;
- (void)remove:(NSString *)uuid;
- (NSMutableArray *)getFavoriteArray;

@end
