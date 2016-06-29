//
//  JLFlipNavControlDelegate.m
//  JLTransition
//
//  Created by joshuali on 16/6/29.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "JLFlipNavControlDelegate.h"
#import "JLFlipTransition.h"

@implementation JLFlipNavControlDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    JLFlipTransition * transition = [JLFlipTransition new];
    transition.sequence = YES;
    return transition;
}
@end
