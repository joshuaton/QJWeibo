//
//  QJFeedCellModel.h
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/17.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCell.h"

@interface QJFeedCellModel : NSObject

@property (nonatomic, strong) NSDictionary *feed;

-(CGFloat)cellHeight;

@end
