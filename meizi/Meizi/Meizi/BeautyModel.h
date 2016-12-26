//
//  BeautyModel.h
//  Meizi
//
//  Created by lemon on 2016/12/16.
//  Copyright © 2016年 lemon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeautyModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageSrc;
@property (nonatomic,assign) int starCount;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)beautyWithDict:(NSDictionary*)dict;
+ (void)beautyArrayWithOffset:(int)offset limit:(int)limit complection:(void(^)(NSArray*array,NSError *error))complection;
@end
