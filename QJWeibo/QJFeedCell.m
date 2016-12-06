//
//  QJFeedCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/4.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ContentMargin 10

@interface QJFeedCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation QJFeedCell

-(void)layoutSubviews{
    self.headImageView.frame = CGRectMake(0, 0, HeadImageViewWidth, HeadImageViewWidth);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame), self.headImageView.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame), self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    self.contentLabel.frame = CGRectMake(0, CGRectGetMaxY(self.headImageView.frame), [[UIScreen mainScreen] bounds].size.width - ContentMargin * 2, self.frame.size.height);
}

#pragma mark - getter & setter

-(void)setFeed:(NSDictionary *)feed{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:feed[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text = feed[@"user"][@"name"];
    self.timeLabel.text = feed[@"created_at"];
    self.contentLabel.text = [feed objectForKey:@"text"];
    
    [self.nameLabel sizeToFit];
    [self.timeLabel sizeToFit];
    [self.timeLabel sizeToFit];
    
    
    [self layoutSubviews];
}

-(UIImageView *)headImageView{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}



@end
