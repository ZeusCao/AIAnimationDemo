//
//  AITriangleLayer.h
//  AIAnimationDemo
//
//  Created by 艾泽鑫 on 2016/10/19.
//  Copyright © 2016年 艾泽鑫. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface AITriangleLayer : CAShapeLayer
/** 所有动画时间*/
@property (assign,nonatomic,readonly)NSTimeInterval allInterval;
-(void)triangleAnimate;
@end
