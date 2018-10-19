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
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@DEFAULT_SPACE);
            make.top.equalTo(@DEFAULT_SPACE);
            make.width.equalTo(@HEAD_IMAGEVIEW_WIDTH);
            make.height.equalTo(@HEAD_IMAGEVIEW_WIDTH);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).offset(DEFAULT_SPACE);
            make.top.equalTo(self.headImageView);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom);
        }];
        [self.feedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.timeLabel.mas_bottom);
            make.right.equalTo(@0);
        }];
        [self.reTweetedFeedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.feedView.mas_bottom);
            make.right.equalTo(@0);
            make.bottom.equalTo(@-DEFAULT_SPACE);
        }];
    }
    return self;
}

#pragma mark - private

-(void)showData{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.feed[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text = self.feed[@"user"][@"name"];
    self.timeLabel.text = [self formatDateStr:self.feed[@"created_at"]];
    
    self.feedView.feed = self.feed;
    
    if(self.feedView.feed[@"retweeted_status"]){
        self.reTweetedFeedView.feed = self.feedView.feed[@"retweeted_status"];
        
        [self.reTweetedFeedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.feedView.mas_bottom);
            make.right.equalTo(@0);
            make.bottom.equalTo(@-DEFAULT_SPACE);
        }];
    }else{
        [self.reTweetedFeedView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.feedView.mas_bottom);
            make.right.equalTo(@0);
            make.bottom.equalTo(@-DEFAULT_SPACE);
            make.height.equalTo(@0);
        }];
    }


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
