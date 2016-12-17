//
//  QJFeedCellModel.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/17.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCellModel.h"

@implementation QJFeedCellModel

-(CGFloat)cellHeight{
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-2*BLANK_OFFSET, MAXFLOAT);
    
    CGFloat textHeight = [self.feed[@"text"] boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    return BLANK_OFFSET + HEAD_IMAGEVIEW_WIDTH + BLANK_OFFSET+ textHeight + BLANK_OFFSET;
}

@end
