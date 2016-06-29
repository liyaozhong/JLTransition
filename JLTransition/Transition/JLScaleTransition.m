//
//  JLScaleTransition.m
//  JLTransition
//
//  Created by joshuali on 16/6/29.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "JLScaleTransition.h"

@implementation JLScaleTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = fromVC.view;
    UIView * toView = toVC.view;
    NSLog(@"startAnimation! fromView = %@", fromView);
    NSLog(@"startAnimation! toView = %@", toView);
    for(UIView * view in containerView.subviews){
        NSLog(@"startAnimation! list container subviews: %@", view);
    }
    
    [containerView addSubview:toVC.view];
    
    [[transitionContext containerView] bringSubviewToFront:fromVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.alpha = 0.0;
        fromVC.view.transform = CGAffineTransformMakeScale(0.2, 0.2);
        toVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromVC.view.transform = CGAffineTransformMakeScale(1, 1);
        [transitionContext completeTransition:YES];
        for(UIView * view in containerView.subviews){
            NSLog(@"endAnimation! list container subviews: %@", view);
        }
    }];
}

@end
