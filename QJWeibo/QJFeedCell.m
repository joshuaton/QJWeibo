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

@end

@implementation QJFeedCell

-(void)layoutSubviews{
    self.contentLabel.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - ContentMargin * 2, self.frame.size.height);
}

-(CGFloat)cellHeight{
    return self.contentLabel.frame.size.height;
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


@end
