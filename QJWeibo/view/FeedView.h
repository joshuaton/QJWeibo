//
//  FeedView.h
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/20.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//
#define HEAD_IMAGEVIEW_WIDTH 30

@interface FeedView : UIView

@property (nonatomic, strong) NSDictionary *feed;

@property (nonatomic, assign) BOOL isReTweet;

@property (nonatomic, assign) CGFloat viewHeight;


@end
