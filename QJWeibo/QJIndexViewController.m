//
//  QJIndexViewController.m
//  QJWeibo
//
//  Created by ShaoJun on 2016/11/29.
//  Copyright © 2016年 ShaoJun. All rights reserved.
//
#import "QJIndexViewController.h"
#import "WBHttpRequest.h"
#import "QJLoginViewController.h"

@interface QJIndexViewController() <WBHttpRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *feeds;

@end

@implementation QJIndexViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults objectForKey:@"accessToken"];
    self.accessToken = accessToken;
    
    if(accessToken){
        [self queryFriendFeeds];
    }else{
        QJLoginViewController *vc = [[QJLoginViewController alloc] init];
        [self presentViewController: vc animated:YES completion:nil];
    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0,
                                      [[UIScreen mainScreen] bounds].size.width,
                                      [[UIScreen mainScreen] bounds].size.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)queryFriendFeeds{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:self.accessToken forKey:@"access_token"];
    
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:params delegate:self withTag:@"getUserInfo"];
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    NSError *error;
    NSData  *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil)
    {
        NSLog(@"json parse failed \r\n");
        return;
    }
    
    NSMutableArray *feeds = [json objectForKey:@"statuses"];
    self.feeds = feeds;
    for(int i=0; i<[feeds count]; i++){
        NSDictionary *feed = [feeds objectAtIndex:i];
        NSLog(@"feed:%@", feed);
    }
    
    [self.tableView reloadData];
 
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSDictionary *feed = [self.feeds objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [feed objectForKey:@"text"];
    
    return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"选中didSelectRowAtIndexPath row = %ld", indexPath.row);
}

@end
