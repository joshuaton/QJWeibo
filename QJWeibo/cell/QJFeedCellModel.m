//
//  QJFeedCellModel.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/17.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "QJFeedCellModel.h"

@interface QJFeedCellModel()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation QJFeedCellModel

-(CGFloat)cellHeight{
    
    float textHeight = 0;
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-2*BLANK_OFFSET, MAXFLOAT);
    self.textView.text = self.feed[@"text"];
    CGSize sizeToFit = [self.textView sizeThatFits:maxSize];
    textHeight = sizeToFit.height;
    
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

-(UITextView *)textView{
    if(!_textView){
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.editable = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.scrollEnabled = NO;
        [_textView setTextContainerInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _textView;
}

@end
