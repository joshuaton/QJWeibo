//
//  QJPhoto.h
//  QJWeibo
//
//  Created by ShaoJun on 2016/12/31.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "NYTPhoto.h"

@interface QJPhoto : NSObject <NYTPhoto>

/**
 *  The image to display.
 *
 *  This property is used if and only if `-imageData` returns `nil`. Note, however, that returning `UIImage`s from this property whenever possible will result in better performance. See `-imageData`'s documentation for discussion.
 */
@property (nonatomic, readonly, nullable) UIImage *image;

/**
 *  The image data to display.
 *
 *  This property's value, if non-`nil`, is preferred over `-image`. This allows clients to provide image data for FLAnimatedImage when the library is compiled with `ANIMATED_GIF_SUPPORT` defined.
 *
 *  Note that if you're working with a non-animated image, using a native `UIImage` will provide better performance. Therefore, it is recommended to return `nil` from this property unless this photo is an animated GIF.
 */
@property (nonatomic, readonly, nullable) NSData *imageData;

/**
 *  A placeholder image for display while the image is loading.
 *
 *  This property is used if and only if `-imageData` returns `nil`.
 */
@property (nonatomic, readonly, nullable) UIImage *placeholderImage;

/**
 *  An attributed string for display as the title of the caption.
 */
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionTitle;

/**
 *  An attributed string for display as the summary of the caption.
 */
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionSummary;

/**
 *  An attributed string for display as the credit of the caption.
 */
@property (nonatomic, readonly, nullable) NSAttributedString *attributedCaptionCredit;

-(void)setImage:(UIImage * _Nullable)image;

@end
