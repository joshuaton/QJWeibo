//
//  QJFeedImageCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/17.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//
#import "QJFeedImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define ITEM_WIDTH (SCREEN_WIDTH-BLANK_OFFSET*2-HALF_BLANK_OFFSET*2)/3-1

@interface QJFeedImageCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL isHeightCalculated;


@end

@implementation QJFeedImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.contentView.width.equalTo(@(ITEM_WIDTH));
        self.contentView.height.equalTo(@(ITEM_WIDTH));
        self.imageView.left.equalTo(superView);
        self.imageView.top.equalTo(superView);
        self.imageView.right.equalTo(superView);
        self.imageView.bottom.equalTo(superView);
        
    }
    
    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

#pragma mark - getter & setter

-(void)setImageUrl:(NSString *)imageUrl{
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/bmiddle/"];
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

@end
