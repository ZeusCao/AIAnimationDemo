//
//  AIContainerViewController.m
//  AIAnimationDemo
//
//  Created by 艾泽鑫 on 2017/6/19.
//  Copyright © 2017年 艾泽鑫. All rights reserved.
//

#import "AIContainerViewController.h"
#import "AISideMenuTableViewController.h"
#import "AIOfficeBuddyViewController.h"
#import "AIMenuButton.h"
@interface AIContainerViewController ()

/**菜单 */
@property(nonatomic,strong)UIViewController   *menuViewController;
/** 中间的controller*/
@property(nonatomic,strong)UINavigationController *centerViewController;
/** 是否打开*/
@property(nonatomic,assign,getter=isOpening)BOOL opening;
@end
CGFloat menuWith                = 80.;
NSTimeInterval animationTime    = .5;
@implementation AIContainerViewController

- (instancetype)init
{
    AISideMenuTableViewController   *sideVC   = [[AISideMenuTableViewController alloc]init];
    AIOfficeBuddyViewController     *office   = [[AIOfficeBuddyViewController alloc]initWithNibName:@"AIOfficeBuddyViewController" bundle:nil];
    UINavigationController *nav               = [[UINavigationController alloc]initWithRootViewController:office];
    sideVC.centerVC                           = [nav.viewControllers firstObject];
    self                                      = [self initWithSlideMeun:sideVC center:nav];
    return self;
}
-(instancetype)initWithSlideMeun:(UIViewController*)slideMeun center:(UINavigationController*)center {
    self = [super init];
    if (self) {
        _menuViewController     = slideMeun;
        _centerViewController   = center;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor       = [UIColor blackColor];
    [self setNeedsStatusBarAppearanceUpdate];
    //中心
    [self addChildViewController:self.centerViewController];
    [self.view addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self];
    //菜单
    [self addChildViewController:self.menuViewController];
    [self.view addSubview:self.menuViewController.view];
    [self.menuViewController didMoveToParentViewController:self];
    
    self.menuViewController.view.layer.anchorPoint      = CGPointMake(1., self.menuViewController.view.layer.anchorPoint.y);
    self.menuViewController.view.frame                  = CGRectMake(-menuWith, 0, menuWith, self.view.ai_height);
    
    UIPanGestureRecognizer  *panGesture                 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
    [self setMenuToPercent:0];
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)setMenuToPercent:(CGFloat)percent {
    self.centerViewController.view.ai_x         = menuWith * percent;
    _menuViewController.view.layer.transform    = [self menuTransformWithPercent:percent];
    _menuViewController.view.alpha              = MAX(0.2, percent);
    
    AIOfficeBuddyViewController *centerVC       = [self.centerViewController.viewControllers firstObject];
    AIMenuButton *menuButton                    = centerVC.menuButton;
    menuButton.imageView.layer.transform        = [self buttonTransformPercent:percent];
}

/**
 菜单旋转

 @param percent 旋转的百分比
 @return 返回改变值
 */
- (CATransform3D)menuTransformWithPercent:(CGFloat)percent {
    CATransform3D identity     = CATransform3DIdentity;
    identity.m34               = -1.0/1000;
    CGFloat remainingPercent   = 1.0 - percent;
    CGFloat angle              = remainingPercent * M_PI * -.5;
    
    CATransform3D rotationTransform     = CATransform3DRotate(identity, angle, 0., 1., 0.);
    CATransform3D translationTransform  = CATransform3DMakeTranslation(menuWith * percent, 0, 0);
    return CATransform3DConcat(rotationTransform, translationTransform);
}
- (CATransform3D)buttonTransformPercent:(CGFloat)percent {
    CATransform3D identity     = CATransform3DIdentity;
    identity.m34               = -1.0/1000;
    
    CGFloat angle              = percent * M_PI;
    CATransform3D rotationTransform     = CATransform3DMakeRotation(angle, 1., 1., 0.);
    return rotationTransform;
}
- (void)toggleSideMenu {
    BOOL isOpen   = floor(self.centerViewController.view.frame.origin.x/menuWith);
    CGFloat targetProgress  = isOpen?0.:1.;
    
    [UIView animateWithDuration:animationTime animations:^{
        [self setMenuToPercent:targetProgress];
    } completion:^(BOOL finished) {
        self.menuViewController.view.layer.shouldRasterize  = NO;
    }];
}
#pragma mark -Action
- (void)handleGesture:(UIPanGestureRecognizer*)pan {
    //todo
    CGPoint translation   = [pan translationInView:self.view.superview];
    CGFloat progess       = translation.x / menuWith * (self.isOpening ? 1.:-1.);
    progess               = MIN(MAX(progess, 0.), 1.);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            
            BOOL isOpen       = floor(self.centerViewController.view.frame.origin.x / menuWith);
            self.opening      = !isOpen;
            self.menuViewController.view.layer.shouldRasterize     = YES;
            self.menuViewController.view.layer.rasterizationScale  = [UIScreen mainScreen].scale;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self setMenuToPercent:(self.isOpening? progess:1-progess)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            CGFloat targetProgress;
            if (self.isOpening) {
                targetProgress     = progess < 0.5 ? 0.:1.;
            } else {
                targetProgress     = progess < 0.5 ? 1.:0.;
            }
            AIWeakSelf;
            [UIView animateWithDuration:animationTime animations:^{
                [weakSelf setMenuToPercent:targetProgress];
            } completion:nil];
            self.menuViewController.view.layer.shouldRasterize = NO;
            break;
        }
        default:
            break;
    }
}


@end
