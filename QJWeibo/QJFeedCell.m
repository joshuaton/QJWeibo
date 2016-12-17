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
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation QJFeedCell

-(void)layoutSubviews{
    
    self.headImageView.frame = CGRectMake(ContentMargin, BLANK_OFFSET, HEAD_IMAGEVIEW_WIDTH, HEAD_IMAGEVIEW_WIDTH);
    
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+BLANK_OFFSET, self.headImageView.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
    self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame), self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - ContentMargin * 2, MAXFLOAT);
    CGFloat textHeight = [self.contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    maxSize.height = textHeight;
    self.contentLabel.frame = CGRectMake(ContentMargin, CGRectGetMaxY(self.headImageView.frame)+BLANK_OFFSET, maxSize.width, maxSize.height);
    
    self.seperatorView.frame = CGRectMake(0, self.frame.size.height-1, SCREEN_WIDTH, 1);
}

#pragma mark - getter & setter

-(void)setFeed:(NSDictionary *)feed{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:feed[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text = feed[@"user"][@"name"];
    self.timeLabel.text = feed[@"created_at"];
    self.contentLabel.text = [feed objectForKey:@"text"];
    
    [self.nameLabel sizeToFit];
    [self.timeLabel sizeToFit];
    [self.contentLabel sizeToFit];
    
    
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
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UIView *)seperatorView{
    if(!_seperatorView){
        _seperatorView = [[UIView alloc] init];
        _seperatorView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_seperatorView];
    }
    return _seperatorView;
}



@end
