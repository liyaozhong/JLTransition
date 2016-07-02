//
//  JLWindTransition.m
//  JLTransition
//
//  Created by joshuali on 16/7/2.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "JLWindTransition.h"

@interface JLWindTransition ()
{
    CGFloat width;
    int totalCount;
    int finishedCounter;
    id<UIViewControllerContextTransitioning> mtransitionContext;
}
@end

@implementation JLWindTransition

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
    width = size.width / xFactor;
    NSInteger numPerRow = 0;
    NSInteger totalNum = 0;
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    for (CGFloat y=0; y < size.height; y+= size.height / yFactor) {
        numPerRow ++;
        for (CGFloat x = size.width - size.width / xFactor; x >=0; x -=size.width / xFactor){
            totalNum ++;
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
            snapshot.tag = totalCount;
            totalCount ++;
        }
    }
    
    [containerView sendSubviewToBack:fromView];
    
    for(int i = 0 ; i < numPerRow ; i ++){
        NSTimeInterval delay = i * 0.1f;
        for(int j = 0 ; j < totalNum/numPerRow ; j ++){
            [self performSelector:@selector(triggerFlip:) withObject:[snapshots objectAtIndex:(j + i * totalNum/numPerRow)] afterDelay:delay];
            delay += 0.1f;
        }
    }
}

- (void) triggerFlip : (UIView *) view
{
    CGFloat margin = width/10;
    CGRect frame = view.layer.frame;
    view.layer.frame = CGRectMake(frame.origin.x + margin, frame.origin.y + margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
    [UIView animateWithDuration:[self transitionDuration:mtransitionContext] delay:0 options:0 animations:^{
        view.layer.transform = [self getTransForm3DWithAngle:-M_PI_2 offset : frame.origin.x];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        finishedCounter ++;
        if(finishedCounter == totalCount){
            [mtransitionContext completeTransition:![mtransitionContext transitionWasCancelled]];
        }
    }];
}

-(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle offset : (CGFloat) offset{
    CATransform3D move = CATransform3DMakeTranslation(0, 0, offset + width - [UIScreen mainScreen].bounds.size.width);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, width);
    CATransform3D rotate = CATransform3DMakeRotation(angle, 0, 1, 0);
    CATransform3D mat = CATransform3DConcat(CATransform3DConcat(move, rotate), back);
    return CATransform3DPerspect(mat, CGPointZero, 500);
    
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}


CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

@end
