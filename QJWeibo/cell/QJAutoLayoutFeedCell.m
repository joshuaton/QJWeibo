//
//  QJAutoLayoutFeedCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2017/5/28.
//  Copyright © 2017年 ShaoJun. All rights reserved.
//

#import "QJAutoLayoutFeedCell.h"
#import "FeedView.h"

#define HEAD_IMAGEVIEW_WIDTH 30.0


@interface QJAutoLayoutFeedCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) FeedView *feedView;
@property (nonatomic, strong) FeedView *reTweetedFeedView;

@end

@implementation QJAutoLayoutFeedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.headImageView.left.equalTo(superView).constant(DEFAULT_SPACE);
        self.headImageView.top.equalTo(superView).constant(DEFAULT_SPACE);
        self.headImageView.width.equalTo(@HEAD_IMAGEVIEW_WIDTH);
        self.headImageView.height.equalTo(@HEAD_IMAGEVIEW_WIDTH);
        
        self.nameLabel.left.equalTo(self.headImageView.right).constant(DEFAULT_SPACE);
        self.nameLabel.top.equalTo(self.headImageView);
        
        self.timeLabel.left.equalTo(self.nameLabel);
        self.timeLabel.top.equalTo(self.nameLabel.bottom);
        
        self.feedView.left.equalTo(superView);
        self.feedView.top.equalTo(self.timeLabel.bottom);
        self.feedView.right.equalTo(superView);
        
        self.reTweetedFeedView.left.equalTo(superView);
        self.reTweetedFeedView.top.equalTo(self.feedView.bottom);
        self.reTweetedFeedView.right.equalTo(superView);
        self.reTweetedFeedView.bottom.equalTo(superView).constant(-DEFAULT_SPACE);

    }
    return self;
}

#pragma mark - private

-(void)showData{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.feed[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text = self.feed[@"user"][@"name"];
    self.timeLabel.text = [self formatDateStr:self.feed[@"created_at"]];
    
    self.feedView.feed = self.feed;
    self.reTweetedFeedView.feed = self.feedView.feed[@"retweeted_status"];


}

-(NSString *)formatDateStr:(NSString *)str{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *creatDate = [fmt dateFromString:str];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    return [fmt stringFromDate:creatDate];
}

#pragma mark - getter & setter

-(void)setFeed:(NSDictionary *)feed{
    _feed = feed;
    [self showData];
}

-(UIImageView *)headImageView{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(FeedView *)feedView{
    if(!_feedView){
        _feedView = [[FeedView alloc] init];
        [self.contentView addSubview:_feedView];
    }
    return _feedView;
}

-(FeedView *)reTweetedFeedView{
    if(!_reTweetedFeedView){
        _reTweetedFeedView = [[FeedView alloc] init];
        _reTweetedFeedView.isReTweet = YES;
        [self.contentView addSubview:_reTweetedFeedView];
    }
    return _reTweetedFeedView;
}

@end
