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
#import "QJFeedCell.h"
#import "QJFeedCellModel.h"

@interface QJIndexViewController() <WBHttpRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *feedsModel;

@end

@implementation QJIndexViewController

#pragma mark - life
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[QJFeedCell class] forCellReuseIdentifier:QJFeedCellReuseId];
    [self.view addSubview:self.tableView];
    
    self.feedsModel = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefaults objectForKey:@"accessToken"];
    self.accessToken = accessToken;
    if(accessToken){
        [self queryFriendFeeds];
    }else{
        QJLoginViewController *vc = [[QJLoginViewController alloc] init];
        [self presentViewController: vc animated:YES completion:nil];
    }
}

#pragma mark - data
- (void)queryFriendFeeds{
    
    
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
    
    for(int i=0; i<[feeds count]; i++){
        QJFeedCellModel *cellModel = [[QJFeedCellModel alloc] init];
        cellModel.feed = [feeds objectAtIndex:i];
        [self.feedsModel addObject:cellModel];
    }
    
    [self.tableView reloadData];
}



#pragma mark - tableview delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.feedsModel count];
}

- (QJFeedCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    QJFeedCell *cell = (QJFeedCell *)[tableView dequeueReusableCellWithIdentifier:QJFeedCellReuseId forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    QJFeedCellModel *cellModel = [self.feedsModel objectAtIndex:indexPath.row];
    cell.feed = cellModel.feed;
    
    return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    QJFeedCellModel *cellModel = [self.feedsModel objectAtIndex:indexPath.row];
    return [cellModel cellHeight];
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
}
@end
