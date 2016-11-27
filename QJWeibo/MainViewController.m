//
//  ViewController.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/11/26.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//

#import "MainViewController.h"
#import "WeiboSDK.h"
#import "WeiboSDK+Statistics.h"

@interface MainViewController ()

/*
App Key：1730913158
App Secret：ace731305639467357b1bea6317db3fb
*/

@property (nonatomic, retain) UIButton *loginButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.title = @"主页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.loginButton = [[UIButton alloc] init];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor redColor]];
    self.loginButton.frame = CGRectMake(100, 100, 200, 100);
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.loginButton];
}

-(void)loginButtonAction:(id)sender{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
//    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
