//
//  FeedView.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/20.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCell.h"
#import "QJFeedImageCell.h"
#import "FeedView.h"


@interface FeedView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UICollectionView *imageCollectionView;


@end

@implementation FeedView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if(!self.isReTweet){
        self.contentTextView.text = self.feed[@"text"];
    }else{
        self.contentTextView.text = [NSString stringWithFormat:@"@%@:%@", self.feed[@"user"][@"name"], self.feed[@"text"]];
    }
    
    float maxWidth = self.frame.size.width - BLANK_OFFSET * 2;
    CGSize sizeToFit = [self.contentTextView sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    self.contentTextView.frame = CGRectMake(BLANK_OFFSET, BLANK_OFFSET, maxWidth, sizeToFit.height);
    
    float imageRowNum = 0;
    if(self.feed[@"pic_urls"] && [self.feed[@"pic_urls"] count] > 0){
        imageRowNum = ([self.feed[@"pic_urls"] count]-1)/3+1;
    }
    float singleRowHeight = (self.frame.size.width-BLANK_OFFSET*2)/3;
    self.imageCollectionView.frame = CGRectMake(BLANK_OFFSET, CGRectGetMaxY(self.contentTextView.frame)+BLANK_OFFSET, self.frame.size.width-BLANK_OFFSET*2, imageRowNum*singleRowHeight);
    
    
    self.viewHeight = CGRectGetMaxY(self.imageCollectionView.frame);
}

#pragma mark - getter & setter
-(void)setFeed:(NSDictionary *)feed{
    _feed = feed;
    
    
    [self.imageCollectionView reloadData];
    
}




-(UITextView *)contentTextView{
    if(!_contentTextView){
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.editable = NO;
        _contentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        _contentTextView.scrollEnabled = NO;
        [_contentTextView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        if(self.isReTweet){
            _contentTextView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        }else{
            _contentTextView.backgroundColor = [UIColor whiteColor];
        }
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
        if(self.isReTweet){
            _imageCollectionView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        }else{
            _imageCollectionView.backgroundColor = [UIColor whiteColor];
        }
        
        
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
    float imageWidth = (self.frame.size.width-BLANK_OFFSET*2-HALF_BLANK_OFFSET*2)/3-1;
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



@end
