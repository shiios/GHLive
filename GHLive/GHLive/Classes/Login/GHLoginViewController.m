//
//  GHLoginViewController.m
//  GHLive
//
//  Created by kalian on 2017/2/14.
//  Copyright © 2017年 kalian. All rights reserved.
//

#import "GHLoginViewController.h"
#import "GHMainViewController.h"

@interface GHLoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *quickLoad;

@end

@implementation GHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (IBAction)jumpToHome:(UIButton *)sender {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self presentViewController:[[GHMainViewController alloc]init] animated:YES completion:^{
            
            
        }];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}




@end
