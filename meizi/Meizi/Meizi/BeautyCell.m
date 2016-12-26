
//
//  BeautyCell.m
//  Meizi
//
//  Created by lemon on 2016/12/16.
//  Copyright © 2016年 lemon. All rights reserved.
//

#import "BeautyCell.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface BeautyCell()
@property (nonatomic,strong) UIView *separator;
@end

@implementation BeautyCell

- (void)setModel:(BeautyModel *)model{
    _model = model;
    //self.beautyView.image  = [UIImage imageNamed:@"xin"];
    self.titleLabel.text = model.title;
    self.starLabel.text = [NSString stringWithFormat:@"%d",model.starCount];
    [self.beautyView sd_setImageWithURL:[NSURL URLWithString:model.imageSrc] placeholderImage:[UIImage imageNamed:@"xin.png"]];
}

- (void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (_isLast)
    {
        self.separator.hidden = YES;
    }
    else{
        self.separator.hidden = NO;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *reuserId = @"BeautyCell";
    BeautyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    if (cell == nil)
    {
       cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuserId];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self prepareUI];
    }
    return  self;
}


- (void)prepareUI{
    //添加imageview
    self.beautyView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.beautyView];
    [self.beautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(98);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
    }];
    
    //添加分割线
    self.separator = [[UIView alloc]init];
    self.separator.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    [self.contentView addSubview:self.separator];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.beautyView.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    //添加点赞按钮
    self.starButton = [[UIButton alloc] init];
    [self.starButton setImage:[UIImage imageNamed:@"unlike.png"] forState:UIControlStateNormal];
    [self.starButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.starButton];

    
    //添加标题lable
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font  = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.mas_equalTo(self.beautyView.mas_right).offset(5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        //make.bottom.mas_equalTo(self.starButton.mas_top);
    }];
    
    
    //设置点赞数字label
    self.starLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.starLabel];
    self.starLabel.textColor = [UIColor lightGrayColor];
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.titleLabel.mas_right).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.separator.mas_top).offset(-5);
    }];
    
    //设置点赞按钮
    [self.starButton addTarget:self action:@selector(giveStar) forControlEvents:UIControlEventTouchUpInside];
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.starLabel.mas_left);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(self.starLabel.mas_height);
        make.centerY.mas_equalTo(self.starLabel.mas_centerY);
    }];

}


- (void)giveStar{
    if (self.starButton.isSelected)
    {
        self.starButton.selected = NO;
        //取消点赞
        self.model.starCount--;
        self.starLabel.text = [NSString stringWithFormat:@"%d",self.model.starCount];
    }
    else{
        self.starButton.selected = YES;
        //发送点赞请求
        self.model.starCount++;
        self.starLabel.text = [NSString stringWithFormat:@"%d",self.model.starCount];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
