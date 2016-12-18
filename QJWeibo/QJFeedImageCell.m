//
//  QJFeedImageCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/17.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//
#import "QJFeedImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface QJFeedImageCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation QJFeedImageCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.frame = self.contentView.frame;
        [self.contentView addSubview:_imageView];
    }
    
    return self;
}

#pragma mark - getter & setter

-(void)setImageUrl:(NSString *)imageUrl{
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/bmiddle/"];
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

@end
