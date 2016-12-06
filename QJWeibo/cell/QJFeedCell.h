//
//  QJFeedCell.h
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/4.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//
#import <UIKit/UIKit.h>

#define QJFeedCellReuseId @"QJFeedCellReuseId"
#define HeadImageViewWidth 30

@interface QJFeedCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *feed;

@end
