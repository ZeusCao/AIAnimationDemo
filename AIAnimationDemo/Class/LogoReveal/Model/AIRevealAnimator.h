//
//  AIRevealAnimator.h
//  AIAnimationDemo
//
//  Created by 艾泽鑫 on 2017/3/26.
//  Copyright © 2017年 艾泽鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIRevealAnimator : NSObject<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
/** 持续时间*/
@property(nonatomic, assign)NSTimeInterval animationDuration;
/** 操作*/
@property(nonatomic, assign)UINavigationControllerOperation operation;
/** 存储内容*/
@property(nonatomic,weak)id<UIViewControllerContextTransitioning> storedContext;
@end
