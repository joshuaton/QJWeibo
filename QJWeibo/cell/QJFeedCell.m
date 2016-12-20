//
//  QJFeedCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/4.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//


#import "QJFeedCell.h"
#import "FeedView.h"


@interface QJFeedCell()

@property (nonatomic, strong) FeedView *feedView;
@property (nonatomic, strong) FeedView *reTweetedFeedView;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation QJFeedCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.feedView = [[FeedView alloc] init];
        self.feedView.frame = CGRectZero;
        [self addSubview:self.feedView];
        
        self.reTweetedFeedView = [[FeedView alloc] init];
        self.reTweetedFeedView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.reTweetedFeedView];
        
        self.seperatorView = [[UIView alloc] init];
        self.seperatorView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.seperatorView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.feedView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.feedView layoutSubviews];
    CGRect frame = self.feedView.frame;
    frame.size.height = self.feedView.viewHeight;
    self.feedView.frame = frame;
    
    
    if(self.feedView.feed[@"retweeted_status"]){
        self.reTweetedFeedView.hidden = NO;
        self.reTweetedFeedView.frame = CGRectMake(0, self.feedView.viewHeight, self.frame.size.width, self.frame.size.height-self.feedView.viewHeight);
    }else{
        self.reTweetedFeedView.hidden = YES;
    }
    
    self.seperatorView.frame = CGRectMake(0, self.frame.size.height-ONE_PIXEL, SCREEN_WIDTH, ONE_PIXEL);
}

-(void)setFeed:(NSDictionary *)feed{
    _feed = feed;
    
    self.feedView.feed = feed;
    if(self.feedView.feed[@"retweeted_status"]){
        self.reTweetedFeedView.feed = self.feedView.feed[@"retweeted_status"];
    }
    
}


@end
