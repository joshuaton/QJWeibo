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

@interface QJIndexViewController() <WBHttpRequestDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *feeds;

@end

@implementation QJIndexViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, StatusBarHeight, ScreenWidth, ScreenHeight-StatusBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[QJFeedCell class] forCellReuseIdentifier:QJFeedCellReuseId];
    [self.view addSubview:self.tableView];
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
    self.feeds = feeds;
    [self.tableView reloadData];
}



#pragma mark - tableview delegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.feeds count];
}

- (QJFeedCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    QJFeedCell *cell = (QJFeedCell *)[tableView dequeueReusableCellWithIdentifier:QJFeedCellReuseId forIndexPath:indexPath];
    cell.feed = [self.feeds objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSDictionary *feed = [self.feeds objectAtIndex:indexPath.row];
    return [self heightForRowWithModel:feed] + HeadImageViewWidth;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
}

//动态计算cell的高度
- (CGFloat)heightForRowWithModel:(NSDictionary *)feed
{
    //这里只写了label的计算
    //文本的高度
    CGSize textSize = [self labelAutoCalculateRectWith:[feed objectForKey:@"text"] FontSize:15 MaxSize:CGSizeMake(200,1000)];
    //3.返回cell 的总高度
    return textSize.height + 10;
}

/*根据传过来的文字内容、字体大小、宽度和最大尺寸动态计算文字所占用的size
 * text 文本内容
 * fontSize 字体大小
 * maxSize  size（宽度，1000）
 * return  size （计算的size）
 */
- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    // iOS7中用以下方法替代过时的iOS6中的sizeWithFont:constrainedToSize:lineBreakMode:方法
    CGSize labelSize = [text boundingRectWithSize: maxSize
                                   options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                attributes:attributes
                                   context:nil].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

@end
