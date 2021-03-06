//
//  RootViewController.m
//  vodPlayerDemo
//
//  Created by xun.liu on 14/12/10.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import "TTRootViewController.h"
#import "TTRootTableViewCell.h"

@interface TTRootViewController () <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray *_dataArray;
    int _flag;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation TTRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if (!app.isSetting) {
        
        return;
    }

    _tableView.hidden = YES;
    _activity.hidden = NO;
    _flag = app.type;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    });
    [_connection cancel];
    
    if (_flag == 1) {
        //自设ip
        [self loadData:1];
    }
    else if (_flag == 2) {
        //海妖宝藏
        [self loadData:2];
    }
    else if (_flag == 3) {
        //本地服务器
        [self loadData:3];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.isSetting = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    
    self.tableView.backgroundColor =  COLORWITHRGB(244, 244, 244, 1);
    self.tableView.hidden = YES;
    _activity.hidden = NO;
    [_activity startAnimating];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _flag = 2;
    [self loadData:2];
}

- (void)loadData:(int)flag
{
    if (_dataArray.count != 0) {
        [_dataArray removeAllObjects];
    }
    
    NSURL *url;
    if (flag == 1) {
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/VideoList.txt", app.playerIP]];
        
    }
    else if (flag == 2) {
        NSArray *dataArr = @[@"海妖宝藏"];
        NSMutableArray *array2D = nil;
        for (int i=0; i<dataArr.count; i++) {
            
            array2D = [_dataArray lastObject];
            if (array2D.count == 2 || array2D == nil) {
                array2D = [NSMutableArray arrayWithCapacity:2];
                [_dataArray addObject:array2D];
            }
            
            NSString *urlstring = [dataArr objectAtIndex:i];
            [array2D addObject:urlstring];
        }
        
        [_tableView reloadData];
        _tableView.hidden = NO;
        _activity.hidden = YES;
        [_activity stopAnimating];
        
        return;
    }
    else if (flag == 3) {
        url = [NSURL URLWithString:@"http://192.168.15.64:80/VideoList.txt"];
    }
    else {
        return;
    }
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30.0];
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    

}

#pragma mark - NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    NSLog(@"response length = %lld   stateCode %ld", [response expectedContentLength], (long)responseCode);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@", result);
    
    //整理数组
    NSArray *dataArr = [result objectForKey:@"data"];
    NSMutableArray *array2D = nil;
    for (int i=0; i<dataArr.count; i++) {
        
        array2D = [_dataArray lastObject];
        if (array2D.count == 2 || array2D == nil) {
            array2D = [NSMutableArray arrayWithCapacity:2];
            [_dataArray addObject:array2D];
        }
        
        NSString *urlstring = [dataArr objectAtIndex:i];
        [array2D addObject:urlstring];
    }
    
    [_tableView reloadData];
    _tableView.hidden = NO;
    _activity.hidden = YES;
    [_activity stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"response error %@", [error localizedFailureReason]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络加载失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    _activity.hidden = YES;
    [_activity stopAnimating];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}



#pragma mark - UITableView dataSource / delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *homeIdentify = @"homeCell";
//    TTRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeIdentify];
//    if (!cell) {
//        cell = [[TTRootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:homeIdentify];
//    }
    TTRootTableViewCell *cell = [[TTRootTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.flag = _flag;
    cell.data = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 157;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
