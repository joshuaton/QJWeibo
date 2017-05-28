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
#import "QJAutoLayoutFeedCell.h"
#import "MJRefresh.h"
#import "QJUIUtil.h"

@interface QJIndexViewController() <WBHttpRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, assign) NSInteger maxId;

@end

@implementation QJIndexViewController

#pragma mark - life
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"首页";
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[QJAutoLayoutFeedCell class] forCellReuseIdentifier:NSStringFromClass([QJAutoLayoutFeedCell class])];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryFriendFeeds:0];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self queryFriendFeeds:self.maxId-1];
    }];
    [self.view addSubview:self.tableView];
    
    [self queryFriendFeeds:0];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]){
        QJLoginViewController *vc = [[QJLoginViewController alloc] init];
        [self presentViewController: vc animated:YES completion:nil];
        return;
    }
}

#pragma mark - data
- (void)queryFriendFeeds:(NSInteger)maxId{
    if(maxId == 0){
        self.feeds = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"access_token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    params[@"max_id"] = [NSString stringWithFormat:@"%ld", (long)maxId];
    
    [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:params delegate:self withTag:@"getUserInfo"];
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    NSError *error;
    NSData  *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil)
    {
        NSLog(@"json parse failed \r\n");
        return;
    }
    
    if([json[@"error_code"] integerValue] == 21327 || [json[@"error_code"] integerValue] == 21332){
        QJLoginViewController *vc = [[QJLoginViewController alloc] init];
        [self presentViewController: vc animated:YES completion:nil];
        return;
    }
    
    if([json[@"error_code"] integerValue] != 0){
        [QJUIUtil showToast:json[@"error"] inView:self.view];
        return;
    }
    
    NSMutableArray *feeds = [json objectForKey:@"statuses"];
    
    for(int i=0; i<[feeds count]; i++){
        NSDictionary *feed = feeds[i];
        self.maxId = [feed[@"id"] integerValue];
        [self.feeds addObject:feed];
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.feeds count];
}

- (QJAutoLayoutFeedCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    QJAutoLayoutFeedCell *cell = (QJAutoLayoutFeedCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QJAutoLayoutFeedCell class]) forIndexPath:indexPath];
    
    cell.feed = [self.feeds objectAtIndex:indexPath.row];;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
}
@end
