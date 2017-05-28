//
//  FeedView.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/20.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedImageCell.h"
#import "FeedView.h"
#import "NYTPhotosViewController.h"
#import "QJPhoto.h"

@interface FeedView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UICollectionView *imageCollectionView;

@end

@implementation FeedView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.contentTextView.left.equalTo(superView).constant(DEFAULT_SPACE);
        self.contentTextView.top.equalTo(superView).constant(DEFAULT_SPACE);
        self.contentTextView.right.equalTo(superView).constant(-DEFAULT_SPACE);
        
        self.imageCollectionView.left.equalTo(superView).constant(DEFAULT_SPACE);
        self.imageCollectionView.top.equalTo(self.contentTextView.bottom).constant(DEFAULT_SPACE);
        self.imageCollectionView.right.equalTo(superView).constant(-DEFAULT_SPACE);
        self.imageCollectionView.bottom.equalTo(superView);

    }
    return self;
}

#pragma mark - private

-(void)showData{
    
    if(self.isReTweet){
        self.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        self.contentTextView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        self.contentTextView.text = [NSString stringWithFormat:@"@%@:%@", self.feed[@"user"][@"name"], self.feed[@"text"]];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        self.contentTextView.backgroundColor = [UIColor whiteColor];
        self.contentTextView.text = self.feed[@"text"];
    }

    if(self.feed[@"pic_urls"] && [self.feed[@"pic_urls"] count] > 0){
        self.imageCollectionView.hidden = NO;
        [self.imageCollectionView reloadData];
        self.imageCollectionView.bottom.equalTo(superView);
    }else{
        self.imageCollectionView.hidden = YES;
        self.contentTextView.bottom.equalTo(superView);
    }
    
    

    
//    if(self.feed[@"pic_urls"] && [self.feed[@"pic_urls"] count] > 0){
//        float imageRowNum = ([self.feed[@"pic_urls"] count]-1)/3+1;
//        float singleRowHeight = (SCREEN_WIDTH-BLANK_OFFSET*2)/3;
////        self.imageCollectionView.height.equalTo(@(imageRowNum*singleRowHeight));
//        self.imageCollectionView.hidden = NO;
//    }else{
//        self.imageCollectionView.hidden = YES;
//        self.contentTextView.bottom.equalTo(superView).constant(-DEFAULT_SPACE);
//
//    }
    


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
    QJFeedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([QJFeedImageCell class]) forIndexPath:indexPath];
    cell.imageUrl = self.feed[@"pic_urls"][indexPath.row][@"thumbnail_pic"];
    return cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return HALF_BLANK_OFFSET;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return HALF_BLANK_OFFSET;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray<QJPhoto*> *photos = [[NSMutableArray alloc] init];
    for(int i=0; i<[self.feed[@"pic_urls"] count]; i++){
        QJPhoto *photo = [[QJPhoto alloc] init];
        [photos addObject:photo];
    }
    
    __block int doneNum = 0;
    for(int i=0; i<[self.feed[@"pic_urls"] count]; i++){
        
        NSString *thumbUrl = self.feed[@"pic_urls"][i][@"thumbnail_pic"];
        NSString *largeUrl = [thumbUrl stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/bmiddle/"];
        NSURL *url = [NSURL URLWithString:largeUrl];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // 下载进度block
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // 下载完成block
            photos[i].image = image;
            doneNum++;
            if(doneNum == [self.feed[@"pic_urls"] count]){
                NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
                UIViewController *vc = self.window.rootViewController;
                [vc presentViewController:photosViewController animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - getter & setter
-(void)setFeed:(NSDictionary *)feed{
    _feed = feed;
    
    [self showData];
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
        layout.estimatedItemSize = CGSizeMake(44, 44);

        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        [_imageCollectionView registerClass:[QJFeedImageCell class] forCellWithReuseIdentifier:NSStringFromClass([QJFeedImageCell class])];
        if(self.isReTweet){
            _imageCollectionView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        }else{
            _imageCollectionView.backgroundColor = [UIColor whiteColor];
        }
        
        
        [self addSubview:_imageCollectionView];
    }
    return _imageCollectionView;
}





@end
