//
//  BeautyModel.m
//  Meizi
//
//  Created by lemon on 2016/12/16.
//  Copyright © 2016年 lemon. All rights reserved.
//

#import "BeautyModel.h"
#import <AFNetworking.h>

@implementation BeautyModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return  self;
}
    
+ (instancetype)beautyWithDict:(NSDictionary*)dict{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)modelArrayWithArray:(NSArray *)array{
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array)
    {
        BeautyModel *model = [self beautyWithDict:dict];
        [modelArray addObject:model];
    }
    return modelArray;
}
    
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
    
+ (void)beautyArrayWithOffset:(int)offset limit:(int)limit complection:(void(^)(NSArray*array,NSError *error))complection{
    NSString *url = [NSString stringWithFormat:@"http://localhost:5000/meinv/?offset=%d&limit=%d",offset,limit];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downlogaProgred=%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"task = %@",task);
        NSLog(@"responseObject= %@",responseObject);
        if (responseObject==nil)
        {
            complection(nil,nil);
            return ;
        }
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *modelArray = [self modelArrayWithArray:array];
        complection(modelArray,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        complection(nil,error);
    }];
}

    
    
    
    
    
    
    
    
    
    
    
@end
