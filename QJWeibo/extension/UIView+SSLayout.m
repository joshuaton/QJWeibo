//
//  UIView+SSLayout.m
//  AutoLayout
//
//  Created by wenshuishi on 2017/1/6.
//  Copyright © 2017年 wenshuishi. All rights reserved.
//

#import "UIView+SSLayout.h"


@interface LayoutAttribute ()

@property (nonatomic, weak) UIView *view;

@property (nonatomic) NSLayoutAttribute type;

- (instancetype)initWithView:(UIView *)view type:(NSLayoutAttribute)type;

@end

/////////////////////////////////////////////////////////////////////////////////


@implementation LayoutAttribute

- (instancetype)initWithView:(UIView *)view type:(NSLayoutAttribute)type {
    if (self = [super init]) {
        self.view = view;
        self.type = type;
    }
    return self;
}

- (LayoutAttribute* (^)(id))equalTo {
    return [self equalToBlockWithRelation:NSLayoutRelationEqual];
}

- (LayoutAttribute* (^)(id))lessThanOrEqualTo {
    return [self equalToBlockWithRelation:NSLayoutRelationLessThanOrEqual];
}

- (LayoutAttribute* (^)(id))greaterThanOrEqualTo {
    return [self equalToBlockWithRelation:NSLayoutRelationGreaterThanOrEqual];
}

- (CGFloat)currentConstant {
    CGFloat constant = 0;
    NSLayoutConstraint *existConstraint = [self existConstraint];
    if (existConstraint) {
        constant = existConstraint.constant;
    }
    return constant;
}

- (LayoutAttribute* (^)(id))equalToBlockWithRelation:(NSLayoutRelation)relation {
    return ^LayoutAttribute* (id item2) {
        
        [self addLayoutConstraintWithItem2:item2 relation:relation multiplier:1];
        
        return self;
    };
}

- (void)addLayoutConstraintWithItem2:(id)item2 relation:(NSLayoutRelation)relation multiplier:(CGFloat)multiplier {
    
    NSLayoutConstraint *existConstraint = [self existConstraint];
    
    if (existConstraint) {
        [self.view.superview removeConstraint:existConstraint];
    }
    
    NSLayoutConstraint *constraint = [self buildConstraintRelateBy:relation toItem2:item2 multiplier:multiplier];

#ifdef DEBUG
    NSString *key = [NSString stringWithFormat:@"constraint_%@_for_%@_%p", [self stringFromType], [self.view class], self.view];
#else
    NSString *key = [NSString stringWithFormat:@"constraint_%ld_for_%@_%p", (long)self.type, [self.view class], self.view];
#endif

    constraint.identifier = key;
    
    if (constraint) {
        if (self.view.translatesAutoresizingMaskIntoConstraints) {
            self.view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        [self.view.superview addConstraint:constraint];
    } else {
        NSLog(@"auto layout error");
    }
}

- (NSLayoutConstraint *)buildConstraintRelateBy:(NSLayoutRelation)relation toItem2:(id)item2 multiplier:(CGFloat)multiplier {
    
    NSLayoutConstraint *constraint = nil;
    
    if ([item2 isMemberOfClass:[SSSuperView class]]) {
        //代表父view
        item2 = self.view.superview;
    } else if ([item2 isMemberOfClass:[SSLayoutGuide class]]) {
        item2 = ((SSLayoutGuide *)item2).systemLayoutGuide;
    }

    if ([item2 isKindOfClass:[UIView class]] || [item2 conformsToProtocol:@protocol(UILayoutSupport) /* topLayoutGuide or bottomLayoutGuide */]) {
        constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:self.type relatedBy:relation toItem:item2 attribute:self.type multiplier:multiplier constant:0];
        
    } else if ([item2 isKindOfClass:[NSNumber class]]) {
        
        CGFloat constant = [((NSNumber *)item2) floatValue];
        constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:self.type relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:multiplier constant:constant];
        
    } else if ([item2 isKindOfClass:[LayoutAttribute class]]) {
        NSLayoutAttribute attr2 = ((LayoutAttribute *)item2).type;
        id view2 = ((LayoutAttribute *)item2).view;
        if ([view2 isMemberOfClass:[SSSuperView class]]) {
            //item2 maybe -> superView.left, superView.right ...
            view2 = self.view.superview;
        } else if ([view2 isMemberOfClass:[SSLayoutGuide class]]) {
            view2 = ((SSLayoutGuide *)view2).systemLayoutGuide;
        }
        constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:self.type relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:0];
        
    } else {
        NSLog(@"auto layout error: unknow type: %@", item2);
    }
    
    return constraint;
}

- (NSLayoutConstraint *)existConstraint {
    
#ifdef DEBUG
    NSString *key = [NSString stringWithFormat:@"constraint_%@_for_%@_%p", [self stringFromType], [self.view class], self.view];
#else
    NSString *key = [NSString stringWithFormat:@"constraint_%ld_for_%@_%p", (long)self.type, [self.view class], self.view];
#endif
    
    return [self existConstraintWithKey:key];
}

- (NSLayoutConstraint *)existConstraintWithKey:(NSString *)key {
    NSLayoutConstraint *existConstraint = nil;
    NSArray *constraints = self.view.superview.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        if ([constraint.identifier isEqualToString:key]) {
            existConstraint = constraint;
            break;
        }
    }
    return existConstraint;
}

- (void (^)(CGFloat))constant {
    
    return ^(CGFloat value) {
        NSLayoutConstraint *existConstraint = [self existConstraint];
        if (existConstraint) {
            existConstraint.constant = value;
        }
//        return self;
    };
}

- (void (^)(CGFloat))multiplier {
    
    return ^(CGFloat value) {
        NSLayoutConstraint *existConstraint = [self existConstraint];
        if (existConstraint) {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:existConstraint.firstItem attribute:existConstraint.firstAttribute relatedBy:existConstraint.relation toItem:existConstraint.secondItem attribute:existConstraint.secondAttribute multiplier:value constant:existConstraint.constant];
            constraint.shouldBeArchived = existConstraint.shouldBeArchived;
            constraint.priority = existConstraint.priority;
            constraint.identifier = existConstraint.identifier;
            constraint.active = existConstraint.active;
            [self.view.superview removeConstraint:existConstraint];
            [self.view.superview addConstraint:constraint];
        }
        //        return self;
    };
}

- (void (^)(BOOL))active {
    return ^(BOOL isActive) {
        NSLayoutConstraint *existConstraint = [self existConstraint];
        if (existConstraint) {
            if ([existConstraint respondsToSelector:@selector(setActive:)]) {
                [existConstraint setActive:isActive];
            } else {
                NSAssert([existConstraint respondsToSelector:@selector(setActive:)], @"[NSLayoutConstraint setActive:] is not support current system version");
            }
        }
    };
}

- (void (^)())remove {
    return ^() {
        NSLayoutConstraint *existConstraint = [self existConstraint];
        if (existConstraint) {
            [self.view.superview removeConstraint:existConstraint];
        }
    };
}

#ifdef DEBUG

- (NSString *)stringFromType {
    NSString *desc = nil;
    switch (self.type) {
        case NSLayoutAttributeLeft:
            desc = @"left";
            break;
        case NSLayoutAttributeRight:
            desc = @"right";
            break;
        case NSLayoutAttributeTop:
            desc = @"top";
            break;
        case NSLayoutAttributeBottom:
            desc = @"bottom";
            break;
        case NSLayoutAttributeLeading:
            desc = @"leading";
            break;
        case NSLayoutAttributeTrailing:
            desc = @"trailing";
            break;
        case NSLayoutAttributeWidth:
            desc = @"width";
            break;
        case NSLayoutAttributeHeight:
            desc = @"height";
            break;
        case NSLayoutAttributeCenterX:
            desc = @"centerX";
            break;
        case NSLayoutAttributeCenterY:
            desc = @"centerY";
            break;
        case NSLayoutAttributeLastBaseline:
            desc = @"lastBaseLine";
            break;
        case NSLayoutAttributeFirstBaseline:
            desc = @"firstBaseLine";
            break;
        case NSLayoutAttributeLeftMargin:
            desc = @"leftMargin";
            break;
        case NSLayoutAttributeRightMargin:
            desc = @"rightMargin";
            break;
        case NSLayoutAttributeTopMargin:
            desc = @"topMargin";
            break;
        case NSLayoutAttributeBottomMargin:
            desc = @"bottomMargin";
            break;
        case NSLayoutAttributeLeadingMargin:
            desc = @"leadMargin";
            break;
        case NSLayoutAttributeTrailingMargin:
            desc = @"trailMargin";
            break;
        case NSLayoutAttributeCenterXWithinMargins:
            desc = @"centerXWithinMargins";
            break;
        case NSLayoutAttributeCenterYWithinMargins:
            desc = @"centerYWithinMargins";
            break;
        case NSLayoutAttributeNotAnAttribute:
            desc = @"notAnAttribute";
            break;
        default:
            desc = [NSString stringWithFormat:@"%ld", (long)self.type];
            break;
    }
    
    return desc;
    
}

#endif

@end


/////////////////////////////////////////////////////////////////////////////////


@implementation UIView (SSLayout)

/////////////////////////////////////

- (LayoutAttribute *)left {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeLeft];
}

- (LayoutAttribute *)top {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeTop];
}

- (LayoutAttribute *)right {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeRight];
}

- (LayoutAttribute *)bottom {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeBottom];
}

- (LayoutAttribute *)width {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeWidth];
}

- (LayoutAttribute *)height {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeHeight];
}

- (LayoutAttribute *)centerX {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeCenterX];
}

- (LayoutAttribute *)centerY {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeCenterY];
}

/////////////////////////////////////

- (LayoutAttribute *)leftMargin {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeLeftMargin];
}

- (LayoutAttribute *)rightMargin {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeRightMargin];
}

- (LayoutAttribute *)topMargin {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeTopMargin];
}

- (LayoutAttribute *)bottomMargin {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeBottomMargin];
}


- (LayoutAttribute *)leadingMargin {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeLeadingMargin];
}

- (LayoutAttribute *)trailingMargin {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeTrailingMargin];
}

/////////////////////////////////////


- (LayoutAttribute *)leading {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeLeading];
}

- (LayoutAttribute *)trailing {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeTrailing];
}

- (LayoutAttribute *)baseline {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeBaseline];
}

- (LayoutAttribute *)firstBaseline {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeFirstBaseline];
}

- (LayoutAttribute *)lastBaseline {
    return [[LayoutAttribute alloc] initWithView:self type:NSLayoutAttributeLastBaseline];
}

/////////////////////////////////////


- (void)setHorizontalContentSizePriority:(UILayoutPriority)horizontalContentSizePriority {
    [self setContentCompressionResistancePriority:horizontalContentSizePriority forAxis:UILayoutConstraintAxisHorizontal];
}

- (UILayoutPriority)horizontalContentSizePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setVerticalContentSizePriority:(UILayoutPriority)verticalContentSizePriority {
    [self setContentCompressionResistancePriority:verticalContentSizePriority forAxis:UILayoutConstraintAxisVertical];
}

- (UILayoutPriority)verticalContentSizePriority {
    return [self contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical];
}

- (void)makeConstraints:(void (^)(UIView *view))constraintsBlock {
    constraintsBlock(self);
}

@end

/////////////////////////////////////


@implementation  SSSuperView


@end

/////////////////////////////////////


//@interface SSLayoutGuide ()
//
//@property (nonatomic, strong) id<UILayoutSupport> systemLayoutGuide;
//
//@end

@implementation SSLayoutGuide

+ (instancetype)layoutGuideWithSystemLayoutGuide:(id <UILayoutSupport>)systemLayoutGuide {
    SSLayoutGuide *layoutGuide = [[SSLayoutGuide alloc] init];
    layoutGuide.systemLayoutGuide = systemLayoutGuide;
    return layoutGuide;
}

@end

/////////////////////////////////////
