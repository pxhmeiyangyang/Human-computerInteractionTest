//
//  BaseVC.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/23.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
}
-(void)setNavigation{
    [self.navigationController.navigationBar setBarTintColor:YZH_GREEN];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    [self.navigationItem setTitle:[self VCTitle]];
    [self.view setBackgroundColor:YZH_BG_COLOR];    
}

-(void)backAction{

}

-(NSString* )VCTitle{
    return nil;
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
