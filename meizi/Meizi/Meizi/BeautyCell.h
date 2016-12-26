//
//  BeautyCell.h
//  Meizi
//
//  Created by lemon on 2016/12/16.
//  Copyright © 2016年 lemon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeautyModel.h"

@interface BeautyCell : UITableViewCell
@property (nonatomic,strong) UIImageView *beautyView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *starButton;
@property (nonatomic,strong) UILabel *starLabel;
@property (nonatomic,strong) BeautyModel *model;
@property (nonatomic,assign) BOOL isLast;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
