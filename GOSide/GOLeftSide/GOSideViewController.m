//
//  GOSideViewController.m
//  GOSide
//
//  Created by DingDing on 16/4/143.
//  Copyright © 2016年 2GoRoom. All rights reserved.
//

#import "GOSideViewController.h"
#import <Masonry.h>
#import "GOSide.h"

@interface GOSideViewController ()

@property (nonatomic, readwrite) UIViewController *leftViewController;
@property (nonatomic, readwrite) UIViewController *contentViewController;

@end

@implementation GOSideViewController

- (void)dealloc
{

}

- (void)loadView
{
    [super loadView];
    
    _lSpace = 100;
    _sideCurrentStatus = SideStatusClose;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configSideWithLeftViewController:(UIViewController *)leftVC contentViewController:(UIViewController *)contentVC
{
    self.leftViewController    = leftVC;
    self.contentViewController = contentVC;

    [self addChildViewController:_leftViewController];
    [self addChildViewController:_contentViewController];
    
    [self.view addSubview:_leftViewController.view];
    [self.view addSubview:_contentViewController.view];
    
    [_leftViewController didMoveToParentViewController:self];
    [_contentViewController didMoveToParentViewController:self];

    
    [_contentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [_leftViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addPanGesInView:_contentViewController.view];
}

- (void)addPanGesInView:(UIView *)panView
{
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];

    [panView addGestureRecognizer:panGes];
}

/*
 * 此处针对不同动画效果可以单独进行处理
 */
- (void)handlePanGestures:(UIPanGestureRecognizer *)ges
{
    CGPoint translation = [ges translationInView:_contentViewController.view];
    
    CGFloat x = [_contentViewController.view center].x + translation.x;
    
    x = MIN(GOScreenWidth / 2.0 + GOScreenWidth - _lSpace, x);
    
    x = MAX(x, GOScreenWidth / 2.0);
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {
        
        }
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            
            [_contentViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(0);
                make.leading.mas_equalTo(x - GOScreenWidth / 2.0);
                make.width.mas_equalTo(320);
                make.bottom.mas_equalTo(0);
                
            }];
            
            [ges setTranslation:CGPointZero inView:_contentViewController.view];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_sideCurrentStatus == SideStatusOpen)
            {
                if (x - GOScreenWidth / 2.0 < GOScreenWidth - _lSpace - 100) {
                    [self closeLeftSide];
                }
                else
                {
                    [self openLeftSide];
                }
            }
            else
            {
                if (x - GOScreenWidth / 2.0 > 50) {
                    [self openLeftSide];
                }
                else
                {
                    [self closeLeftSide];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)openLeftSide
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];

    [_contentViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(GOScreenWidth - _lSpace);
        make.width.mas_equalTo(320);
        make.bottom.mas_equalTo(0);
        
    }];
    
    [self leftViewControllerWillAppear];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];

    }completion:^(BOOL finished) {
        
        [self leftViewControllerDidAppear];
        
        // 放在最后
        _sideCurrentStatus = SideStatusOpen;

    }];
}

- (void)closeLeftSide
{
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [self leftViewControllerWillDissAppear];
    
    [_contentViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(320);
        make.bottom.mas_equalTo(0);
        
    }];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        
        [self leftViewControllerDissAppear];
        
        _sideCurrentStatus = SideStatusClose;

    }];
    
}

/*
 * 子控制器生命周期接管
 */
- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}


- (void)leftViewControllerWillAppear
{
    if (_sideCurrentStatus != SideStatusOpen) {
        [_leftViewController beginAppearanceTransition:YES animated:YES];
    }
}


- (void)leftViewControllerWillDissAppear
{
    if (_sideCurrentStatus != SideStatusClose) {
        
        [_leftViewController beginAppearanceTransition:NO animated:YES];
        
    }
}

- (void)leftViewControllerDidAppear
{
    if (_sideCurrentStatus != SideStatusOpen) {
        [_leftViewController endAppearanceTransition];
    }
}


- (void)leftViewControllerDissAppear
{
    if (_sideCurrentStatus != SideStatusClose) {
        
        [_leftViewController endAppearanceTransition];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
