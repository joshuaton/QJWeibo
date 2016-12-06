//
//  QJFeedCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/4.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCell.h"

#define ContentMargin 10

@interface QJFeedCell()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation QJFeedCell

-(void)layoutSubviews{
    self.contentLabel.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - ContentMargin * 2, self.frame.size.height);
    self.seperatorView.frame = CGRectMake(0, self.frame.size.height-1, ScreenWidth, 1);
}

#pragma mark - getter & setter

-(void)setFeed:(NSDictionary *)feed{
    self.contentLabel.text = [feed objectForKey:@"text"];
    [self.contentLabel sizeToFit];
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UIView *)seperatorView{
    if(!_seperatorView){
        _seperatorView = [[UIView alloc] init];
        _seperatorView.backgroundColor = [UIColor grayColor];
        [self addSubview:_seperatorView];
    }
    return _seperatorView;
}


@end
