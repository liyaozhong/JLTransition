//
//  JLNavControlDelegate.m
//  JLTransition
//
//  Created by joshuali on 16/6/29.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "JLNavControlDelegate.h"
#import "JLScaleTransition.h"
#import "JLFlipTransition.h"

@implementation JLNavControlDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if(self.transition){
        Class transition = NSClassFromString(self.transition);
        return [transition new];
    }
    return nil;
}

@end
