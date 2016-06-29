//
//  ViewController.m
//  JLTransition
//
//  Created by joshuali on 16/6/29.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "ViewController.h"
#import "TargetViewController.h"
#import "JLNavControlDelegate.h"

@interface ViewController ()
@property (nonatomic, strong) JLNavControlDelegate * transitionDelagate;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitionDelagate = [JLNavControlDelegate new];
    self.transitionDelagate.transition = @"JLDrawerTransition";
}

- (IBAction)triggerTransitionDelegate:(id)sender
{
    self.navigationController.delegate = self.transitionDelagate;
    [self.navigationController pushViewController:[TargetViewController new] animated:YES];
}

@end
