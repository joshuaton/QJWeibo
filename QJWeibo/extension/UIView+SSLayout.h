//
//  UIView+SSLayout.h
//  AutoLayout
//
//  Created by wenshuishi on 2017/1/6.
//  Copyright © 2017年 wenshuishi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LayoutAttribute : NSObject


@property (nonatomic, readonly) LayoutAttribute* (^equalTo)(id item2 /* NSNumber/UIView/LayoutAttribute/id <UILayoutSupport> */);
@property (nonatomic, readonly) LayoutAttribute* (^lessThanOrEqualTo)(id item2);
@property (nonatomic, readonly) LayoutAttribute* (^greaterThanOrEqualTo)(id item2);

@property (nonatomic, readonly) void (^constant)(CGFloat value);
@property (nonatomic, readonly) void (^multiplier)(CGFloat value);

@property (nonatomic, readonly) void (^active)(BOOL isActive); //NS_AVAILABLE(10_10, 8_0)
@property (nonatomic, readonly) void (^remove)();

- (CGFloat)currentConstant;

@end

/****************************************/

//对所有view都不需要调用 view.translatesAutoresizingMaskIntoConstraints = NO;
//No need to call view.translatesAutoresizingMaskIntoConstraints = NO;

/****************************************/

@interface UIView (SSLayout)

@property (nonatomic, readonly) LayoutAttribute *left, *top, *right, *bottom, *width, *height, *centerX, *centerY;

@property (nonatomic, readonly) LayoutAttribute *leftMargin, *rightMargin, *topMargin, *bottomMargin, *leadingMargin, *trailingMargin;

@property (nonatomic, readonly) LayoutAttribute *leading, *trailing, *baseline, *firstBaseline, *lastBaseline;

@property (nonatomic) UILayoutPriority horizontalContentSizePriority, verticalContentSizePriority;

- (void)makeConstraints:(void (^)(UIView *view))constraintsBlock;

@end

//////////////////////////////////////////////////////////////

@interface SSSuperView : UIView

@end

#define superView   ([[SSSuperView alloc] init])

//////////////////////////////////////////////////////////////

@interface SSLayoutGuide : UIView

@property (nonatomic, strong) id<UILayoutSupport> systemLayoutGuide;

+ (instancetype)layoutGuideWithSystemLayoutGuide:(id<UILayoutSupport>)systemLayoutGuide;

@end

#define topGuide  [SSLayoutGuide layoutGuideWithSystemLayoutGuide:self.topLayoutGuide]  // use in ViewController only
#define bottomGuide  [SSLayoutGuide layoutGuideWithSystemLayoutGuide:self.bottomLayoutGuide]  // use in ViewController only


