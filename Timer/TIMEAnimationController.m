//
//  TIMEAnimationController.m
//  Timing
//
//  Created by Francisco Javier Álvarez García on 01/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "TIMEAnimationController.h"

@implementation TIMEAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) return 1.0;
    else return 1.0f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *coverView = [[UIView alloc] initWithFrame:[transitionContext containerView].frame];
    coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [[transitionContext containerView] addSubview:fromViewController.view];
        [[transitionContext containerView] addSubview:coverView];
        [[transitionContext containerView] addSubview:toViewController.view];
        
        coverView.alpha = 0.0;
        
        CGRect startFrame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-256)/2,
                                       [[UIScreen mainScreen] bounds].size.height,
                                       256,
                                       454);
        CGRect endFrame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-256)/2,
                                    ([[UIScreen mainScreen] bounds].size.height-454)/2,
                                    256,
                                    454);
        toViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             toViewController.view.frame = endFrame;
                             coverView.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             [transitionContext completeTransition:YES];
                         }];
        
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] addSubview:coverView];
        [[transitionContext containerView] addSubview:fromViewController.view];
        
        coverView.alpha = 1.0;
        
        CGRect startFrame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-256)/2,
                                       ([[UIScreen mainScreen] bounds].size.height-454)/2,
                                       256,
                                       454);
        
        CGRect endFrame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-256)/2,
                                     [[UIScreen mainScreen] bounds].size.height,
                                     256,
                                     454);
        
        fromViewController.view.frame = startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             fromViewController.view.frame = endFrame;
                             coverView.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             [coverView removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
    
}

@end
