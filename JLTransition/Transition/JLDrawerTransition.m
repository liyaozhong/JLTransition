//
//  JLDrawerTransition.m
//  JLTransition
//
//  Created by joshuali on 16/6/29.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "JLDrawerTransition.h"

@interface JLDrawerTransition ()
{
    int totalCount;
    int flippedCount;
    NSInteger numPerRow;
    NSInteger totalNum;
    NSInteger randomPick;
    CGPoint pickedCenter;
    NSMutableArray *snapshots;
    NSMutableArray * flippedViews;
    id<UIViewControllerContextTransitioning> mtransitionContext;
}
@end

@implementation JLDrawerTransition
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
    totalCount = 0;
    flippedCount = 0;
    CGSize size = toView.frame.size;
    
    snapshots = [NSMutableArray new];
    
    CGFloat xFactor = 8.0f;
    CGFloat yFactor = xFactor * size.height / size.width;
    
    int rowNum = 0;
    totalNum = 0;
    UIView *fromViewSnapshot = [fromView snapshotViewAfterScreenUpdates:NO];
    for (CGFloat y = 0; y < size.height; y += size.height / yFactor) {
        rowNum ++;
        for(CGFloat x = 0; x < size.width; x += size.width / xFactor){
            totalNum ++;
            CGRect snapshotRegion = CGRectMake(x, y, size.width / xFactor, size.height / yFactor);
            UIView *snapshot = [fromViewSnapshot resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
            snapshot.frame = snapshotRegion;
            snapshot.tag = (totalNum - 1);
            [containerView addSubview:snapshot];
            [snapshots addObject:snapshot];
            totalCount ++;
        }
    }
    numPerRow = totalNum/rowNum;
    [containerView sendSubviewToBack:fromView];
    flippedViews = [NSMutableArray new];
    randomPick = rand() % totalNum;
    UIView * pickedView = [snapshots objectAtIndex:randomPick];
    pickedCenter = pickedView.center;
    [pickedView removeFromSuperview];
    [flippedViews addObject:[NSNumber numberWithInteger:randomPick]];
    flippedCount = 1;
    [self triggerFlips];
}

- (void) triggerFlips
{
    NSMutableArray * addFlip = [NSMutableArray new];
    NSMutableSet * addedSet = [NSMutableSet new];
    for(NSNumber * flipped in flippedViews){
        NSInteger index = [flipped integerValue];
        if(index % numPerRow > 0){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index-1)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index-1)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index-1)]];
                    [addFlip addObject:[snapshots objectAtIndex:index-1]];
                }
            }
        }
        if(index % numPerRow < (numPerRow - 1)){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index+1)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index+1)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index+1)]];
                    [addFlip addObject:[snapshots objectAtIndex:index+1]];
                }
            }
        }
        if(index / numPerRow >= 1){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index-numPerRow)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index-numPerRow)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index-numPerRow)]];
                    [addFlip addObject:[snapshots objectAtIndex:index-numPerRow]];
                }
            }
        }
        if(index < totalNum - numPerRow){
            if(![flippedViews containsObject:[NSNumber numberWithInteger:(index+numPerRow)]]){
                if(![addedSet containsObject:[NSNumber numberWithInteger:(index+numPerRow)]]){
                    [addedSet addObject:[NSNumber numberWithInteger:(index+numPerRow)]];
                    [addFlip addObject:[snapshots objectAtIndex:index+numPerRow]];
                }
            }
        }
    }
    for(UIView * added in addFlip){
        [self triggerFlip:added];
        [flippedViews addObject:[NSNumber numberWithInteger:added.tag]];
    }
    [self performSelector:@selector(triggerFlips) withObject:nil afterDelay:0.05f];
}

- (void) triggerFlip : (UIView *) view
{
    CGFloat margin = 1;
    CGRect frame = view.frame;
    view.frame = CGRectMake(frame.origin.x + margin, frame.origin.y + margin, frame.size.width - margin * 2, frame.size.height - margin * 2);
    [UIView animateWithDuration:[self transitionDuration:mtransitionContext] delay:0  usingSpringWithDamping:1 initialSpringVelocity:0 options:0 animations:^{
        view.transform = CGAffineTransformMakeTranslation(pickedCenter.x - view.center.x, pickedCenter.y - view.center.y);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        flippedCount ++;
        if(flippedCount == totalCount){
            [(UIView*)[snapshots objectAtIndex:randomPick] removeFromSuperview];
            [mtransitionContext completeTransition:![mtransitionContext transitionWasCancelled]];
        }
    }];
}
@end
