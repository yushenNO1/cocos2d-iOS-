//
//  FirstVC.m
//  HelloWorldDemo-mobile
//
//  Created by 云盛科技 on 2017/10/16.
//

#import "FirstVC.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "AppController.h"
@interface FirstVC ()
@property(nonatomic,assign)BOOL isOpen;
@end

@implementation FirstVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


    [[NSNotificationCenter defaultCenter]postNotificationName:@"startFullScreen" object:nil];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    self.isOpen = YES;
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(100, 100, 100, 100);
    [Btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
    Btn.backgroundColor = [UIColor redColor];
    
}
-(void)btnClick:(UIButton *)sender{
    
    RootViewController *gameView = [[RootViewController alloc]init];
    [self presentViewController:gameView animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
