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
    textHeight = ceil(textHeight);
    
    float imageRowNum = 0;
    if(self.feed[@"pic_urls"] && [self.feed[@"pic_urls"] count] > 0){
        imageRowNum = ([self.feed[@"pic_urls"] count]-1)/3+1;
    }
    float singleRowHeight = (SCREEN_WIDTH-BLANK_OFFSET*2)/3;
    float imageCollectionViewHeight = imageRowNum*singleRowHeight;
    if(imageCollectionViewHeight > 0){
        imageCollectionViewHeight += BLANK_OFFSET;
    }
    
    return BLANK_OFFSET + HEAD_IMAGEVIEW_WIDTH + BLANK_OFFSET+ textHeight + BLANK_OFFSET + imageCollectionViewHeight;
}

@end
