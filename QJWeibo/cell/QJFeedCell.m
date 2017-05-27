//
//  QJFeedCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/4.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//


#import "QJFeedCell.h"
#import "FeedView.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface QJFeedCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) FeedView *feedView;
@property (nonatomic, strong) FeedView *reTweetedFeedView;

@end

@implementation QJFeedCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.feedView = [[FeedView alloc] init];
        self.feedView.frame = CGRectZero;
        [self.contentView addSubview:self.feedView];
        
        self.reTweetedFeedView = [[FeedView alloc] init];
        self.reTweetedFeedView.isReTweet = YES;
        self.reTweetedFeedView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.reTweetedFeedView];
        
    }
    return self;
}

-(void)setupView{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.feed[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text = self.feed[@"user"][@"name"];
    self.timeLabel.text = [self formatDateStr:self.feed[@"created_at"]];
    
    self.headImageView.frame = CGRectMake(BLANK_OFFSET, BLANK_OFFSET, HEAD_IMAGEVIEW_WIDTH, HEAD_IMAGEVIEW_WIDTH);
    
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+BLANK_OFFSET, self.headImageView.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame), self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    
    self.feedView.frame = CGRectMake(0, CGRectGetMaxY(self.headImageView.frame), SCREEN_WIDTH, self.feedView.viewHeight);
    
    
    if(self.feedView.feed[@"retweeted_status"]){
        self.reTweetedFeedView.hidden = NO;
        self.reTweetedFeedView.frame = CGRectMake(0, CGRectGetMaxY(self.feedView.frame), SCREEN_WIDTH, self.reTweetedFeedView.viewHeight);
        self.cellHeight = CGRectGetMaxY(self.reTweetedFeedView.frame)+BLANK_OFFSET;

        
    }else{
        self.reTweetedFeedView.hidden = YES;
        self.cellHeight = CGRectGetMaxY(self.feedView.frame)+BLANK_OFFSET;

    }
    
    
}

-(void)setFeed:(NSDictionary *)feed{
    _feed = feed;
    
    self.feedView.feed = feed;
    if(self.feedView.feed[@"retweeted_status"]){
        self.reTweetedFeedView.feed = self.feedView.feed[@"retweeted_status"];
    }
    
    [self setupView];
    
}

#pragma mark - getter & setter
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
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

#pragma mark - tools
-(NSString *)formatDateStr:(NSString *)str{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *creatDate = [fmt dateFromString:str];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    return [fmt stringFromDate:creatDate];
}


@end
