//
//  GHMainViewController.m
//  GHLive
//
//  Created by kalian on 2017/2/14.
//  Copyright © 2017年 kalian. All rights reserved.
//

#import "GHMainViewController.h"
#import "GHHomeViewController.h"
#import "GHShowTimeViewController.h"
#import "GHProfileViewController.h"
#import "GHNavViewController.h"


@interface GHMainViewController ()<UITabBarControllerDelegate>

@end

@implementation GHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    [self setUP];
}
- (void)setUP
{
    [self addChildViewController:[[GHHomeViewController alloc] init] imageNamed:@"toolbar_home" title:@"首页"];
    [self addChildViewController:[[GHShowTimeViewController alloc] init] imageNamed:@"toolbar_live" title:@"直播"];
    [self addChildViewController:[[GHProfileViewController alloc] init] imageNamed:@"toolbar_me" title:@"个人中心"];
}
- (void)addChildViewController:(UIViewController *)childController imageNamed:(NSString *)imageName title:(NSString *)titleStr
{
    GHNavViewController *nav = [[GHNavViewController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel", imageName]];
    
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: Color(110.0, 113.0, 117.0),} forState:UIControlStateNormal];
    [self addChildViewController:nav];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController .childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count - 2) {
        
        GHShowTimeViewController *showTimeVc = [[GHShowTimeViewController alloc]init];
        [self presentViewController:showTimeVc animated:YES completion:nil];
        return NO;
        
        
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
