//
//  GetInformationVC.m
//  Human-computerInteractionTest
//
//  Created by pxh on 16/8/24.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "GetInformationVC.h"
#import "ListenTestVC.h"
//#import "UIViewController+BackButtonHandler.h"
@interface GetInformationVC ()

@end

@implementation GetInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextClick:(id)sender {
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Human-computer" bundle:[NSBundle mainBundle]];
    ListenTestVC* vc = [storyBoard instantiateViewControllerWithIdentifier:@"ListenTestVC"];

//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
