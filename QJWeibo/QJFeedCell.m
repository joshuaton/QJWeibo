//
//  QJFeedCell.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/4.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "QJFeedImageCell.h"



@interface QJFeedCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UICollectionView *imageCollectionView;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation QJFeedCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self headImageView];
        [self nameLabel];
        [self timeLabel];
        [self contentLabel];
        [self imageCollectionView];
        [self seperatorView];
    }
    return self;
}

-(void)layoutSubviews{
    
    self.headImageView.frame = CGRectMake(BLANK_OFFSET, BLANK_OFFSET, HEAD_IMAGEVIEW_WIDTH, HEAD_IMAGEVIEW_WIDTH);
    
    [self.nameLabel sizeToFit];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame)+BLANK_OFFSET, self.headImageView.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
    [self.timeLabel sizeToFit];
    self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame), self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - BLANK_OFFSET * 2, MAXFLOAT);
    CGFloat textHeight = [self.contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height;
    maxSize.height = ceil(textHeight);
    self.contentLabel.frame = CGRectMake(BLANK_OFFSET, CGRectGetMaxY(self.headImageView.frame)+BLANK_OFFSET, maxSize.width, maxSize.height);
    
    float imageRowNum = 0;
    if(self.feed[@"pic_urls"] && [self.feed[@"pic_urls"] count] > 0){
        imageRowNum = ([self.feed[@"pic_urls"] count]-1)/3+1;
    }
    float singleRowHeight = (SCREEN_WIDTH-BLANK_OFFSET*2)/3;
    self.imageCollectionView.frame = CGRectMake(BLANK_OFFSET, CGRectGetMaxY(self.contentLabel.frame)+BLANK_OFFSET, SCREEN_WIDTH-BLANK_OFFSET*2, imageRowNum*singleRowHeight);
    
    self.seperatorView.frame = CGRectMake(0, self.frame.size.height-ONE_PIXEL, SCREEN_WIDTH, ONE_PIXEL);
}

#pragma mark - getter & setter

-(void)setFeed:(NSDictionary *)feed{
    _feed = feed;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:feed[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    self.nameLabel.text = feed[@"user"][@"name"];
    self.timeLabel.text = [self formatDateStr:feed[@"created_at"]];
    self.contentLabel.text = [feed objectForKey:@"text"];
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
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
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

-(UIView *)seperatorView{
    if(!_seperatorView){
        _seperatorView = [[UIView alloc] init];
        _seperatorView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_seperatorView];
    }
    return _seperatorView;
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
