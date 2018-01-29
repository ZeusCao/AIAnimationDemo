//
//  AIPop1ViewController.m
//  AIAnimationDemo
//
//  Created by 艾泽鑫 on 16/9/26.
//  Copyright © 2016年 艾泽鑫. All rights reserved.
//  衰减效果

#import "AIPop1ViewController.h"

@interface AIPop1ViewController ()<POPAnimationDelegate>
/** 方块*/
@property(nonatomic,weak)UIView *showView;
@end

@implementation AIPop1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 100, 100)];
    self.showView    = showView;
    showView.backgroundColor = [UIColor colorWithHexString:@"#3B9AD8"];
    [self.view addSubview:showView];
    //添加手势
    UIPanGestureRecognizer *panGest =  [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handGesture:)];
    [showView addGestureRecognizer:panGest];
}

- (void)handGesture:(UIPanGestureRecognizer*)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    recognizer.view.center = CGPointMake(translation.x + recognizer.view.center.x,
                                         translation.y + recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    if (recognizer.state == UIGestureRecognizerStateEnded) {//松手的时候执行
        //获得加速度
        CGPoint velocity = [recognizer velocityInView:self.view];
        //添加pop动画
        POPDecayAnimation *decayAnimation = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPosition];
        decayAnimation.delegate           = self;
        decayAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        [recognizer.view.layer pop_addAnimation:decayAnimation forKey:nil];
    }
}
#pragma mark -POPAnimationDelegate
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    AILog(@"衰减动画结束");
    if (!CGRectContainsPoint(self.view.frame, self.showView.center)) {
        self.showView.frame = CGRectMake(20, 100, 100, 100);
    }
}


@end
