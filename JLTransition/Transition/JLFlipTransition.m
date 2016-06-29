//
//  JLFlipTransition.m
//  JLTransition
//
//  Created by joshuali on 16/6/29.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "JLFlipTransition.h"

@interface JLFlipTransition ()
{
    int totalCount;
    int finishedCounter;
    id<UIViewControllerContextTransitioning> mtransitionContext;
}
@end

@implementation JLFlipTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    mtransitionContext = transitionContext;
    UIViewController *toVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * fromView = fromVC.view;
    UIView * toView = toVC.view;
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    finishedCounter = 0;
    totalCount = 0;
    CGSize size = toView.frame.size;
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 4.0f;
    CGFloat yFactor = xFactor * size.height / size.width;
    
    NSInteger numPerRow = 0;
    NSInteger totalNum = 0;
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    for (CGFloat y=0; y < size.height; y+= size.height / yFactor) {
        numPerRow ++;
        for (CGFloat x = size.width; x >=0; x -=size.width / xFactor){
            totalNum ++;
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
            totalCount ++;
        }
    }
    
    [containerView sendSubviewToBack:fromView];
    
    if(self.sequence){
        for(int i = 0 ; i < numPerRow ; i ++){
            NSTimeInterval delay = i * 0.1f;
            for(int j = 0 ; j < totalNum/numPerRow ; j ++){
                [self performSelector:@selector(triggerFlip:) withObject:[snapshots objectAtIndex:(j + i * totalNum/numPerRow)] afterDelay:delay];
                delay += 0.1f;
            }
        }
        
    }else{
        for(UIView * view in snapshots){
            [self performSelector:@selector(triggerFlip:) withObject:view afterDelay:rand()/(double)RAND_MAX/2];
        }
    }
}

- (void) triggerFlip : (UIView *) view
{
    CGFloat margin = 1;
    view.layer.anchorPoint = CGPointMake(0, 0.5f);
    CGRect frame = view.layer.frame;
    view.layer.frame = CGRectMake(frame.origin.x - frame.size.width/2 + margin, frame.origin.y + margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
    [UIView animateWithDuration:[self transitionDuration:mtransitionContext] delay:0 options:0 animations:^{
        view.layer.transform = [self getTransForm3DWithAngle:-M_PI_2];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        finishedCounter ++;
        if(finishedCounter == totalCount){
            [mtransitionContext completeTransition:![mtransitionContext transitionWasCancelled]];
        }
    }];
}

-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002f;
    transform = CATransform3DRotate(transform,angle,0,1,0);
    return transform;
    
}

@end
