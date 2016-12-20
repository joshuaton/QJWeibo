//
//  FeedView.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/20.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "QJFeedImageCell.h"
#import "FeedView.h"


@interface FeedView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UICollectionView *imageCollectionView;


@end

@implementation FeedView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
//        [self headImageView];
//        [self nameLabel];
//        [self timeLabel];
//        [self contentTextView];
//        [self imageCollectionView];
//        [self seperatorView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.headImageView.frame = CGRectMake(BLANK_OFFSET, BLANK_OFFSET, HEAD_IMAGEVIEW_WIDTH, HEAD_IMAGEVIEW_WIDTH);
    
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+BLANK_OFFSET, self.headImageView.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame), self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    
    float maxWidth = SCREEN_WIDTH - BLANK_OFFSET * 2;
    CGSize sizeToFit = [self.contentTextView sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    self.contentTextView.frame = CGRectMake(BLANK_OFFSET, CGRectGetMaxY(self.headImageView.frame)+BLANK_OFFSET, maxWidth, sizeToFit.height);
    
    float imageRowNum = 0;
    if(self.feed[@"pic_urls"] && [self.feed[@"pic_urls"] count] > 0){
        imageRowNum = ([self.feed[@"pic_urls"] count]-1)/3+1;
    }
    float singleRowHeight = (SCREEN_WIDTH-BLANK_OFFSET*2)/3;
    self.imageCollectionView.frame = CGRectMake(BLANK_OFFSET, CGRectGetMaxY(self.contentTextView.frame)+BLANK_OFFSET, SCREEN_WIDTH-BLANK_OFFSET*2, imageRowNum*singleRowHeight);
    
    
    self.viewHeight = CGRectGetMaxY(self.imageCollectionView.frame);
}

#pragma mark - getter & setter
-(void)setFeed:(NSDictionary *)feed{
    _feed = feed;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:feed[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text = feed[@"user"][@"name"];
    self.timeLabel.text = [self formatDateStr:feed[@"created_at"]];
    self.contentTextView.text = feed[@"text"];
    [self.imageCollectionView reloadData];
    
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

-(UITextView *)contentTextView{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.editable = NO;
        _contentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        _contentTextView.scrollEnabled = NO;
        [_contentTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addSubview:_contentTextView];
    }
    return _contentTextView;
}

-(UICollectionView *)imageCollectionView{
    if(!_imageCollectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        [_imageCollectionView registerClass:[QJFeedImageCell class] forCellWithReuseIdentifier:QJFeedImageCell_REUSEID];
        
        
        
        [self addSubview:_imageCollectionView];
    }
    return _imageCollectionView;
}

#pragma mark - collectionview delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.feed[@"pic_urls"] count];
}

- (QJFeedImageCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QJFeedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QJFeedImageCell_REUSEID forIndexPath:indexPath];
    cell.imageUrl = self.feed[@"pic_urls"][indexPath.row][@"thumbnail_pic"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float imageWidth = (SCREEN_WIDTH-BLANK_OFFSET*2-HALF_BLANK_OFFSET*2)/3;
    return CGSizeMake(imageWidth, imageWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return HALF_BLANK_OFFSET;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return HALF_BLANK_OFFSET;
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