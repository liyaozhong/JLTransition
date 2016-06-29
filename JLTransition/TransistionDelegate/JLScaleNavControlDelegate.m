//
//  JLScaleNavControlDelegate.m
//  JLTransition
//
//  Created by joshuali on 16/6/29.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "JLScaleNavControlDelegate.h"
#import "JLScaleTransition.h"

@implementation JLScaleNavControlDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [JLScaleTransition new];
}

@end
