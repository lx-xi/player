//
//  TTHomeViewController.m
//  vodPlayerDemo
//
//  Created by xun.liu on 14/12/8.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import "TTHomeViewController.h"
#import "TTVideoPlayerCell.h"
#import "PlayerUI.h"

@interface TTHomeViewController ()<PlayerUIDelegate>
{
//    PlayerUI *_player;
    BOOL _isFirst;
}

@property (nonatomic, strong) PlayerUI *player;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation TTHomeViewController

- (IBAction)gobackAction:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [_player videoStop];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_player removeFromSuperview];
    _player = nil;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.isSetting = NO;
}

- (void)dealloc
{
    NSLog(@"dealloc -----TTHomeViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUrlString:(NSString *)urlString
{
//    urlString = [[NSBundle mainBundle] pathForResource:@"fast-1280X720" ofType:@"mp4"];
//    urlString = @"http://192.168.15.64/2.mp4";
    _isFirst = YES;
    NSLog(@"setUrlString");
    if (_urlString != urlString) {
        _urlString = urlString;
        if (!_player) {
            _player = [[PlayerUI alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 240) URL:urlString];
            _player.delegate = self;
            [self.view addSubview:_player];
        }
    }
}

//换集
- (IBAction)video_1_action:(id)sender
{
    NSString *urlStr = video_url_yishengsuoai;
    _player.urlString = urlStr;
}

- (IBAction)video_2_action:(id)sender
{
    NSString *urlStr = video_url_pingfandelu;
    _player.urlString = urlStr;
}

- (IBAction)video_3_action:(id)sender
{
    NSString *urlStr = video_url_haiyao;
    _player.urlString = urlStr;
}

- (IBAction)video_4_action:(id)sender
{
    NSString *urlStr = @"http://vod.ttmv.com/movies/1000000453/1000000453_240.mp4";
    _player.urlString = urlStr;
}

- (IBAction)video_5_action:(id)sender
{
    NSString *urlStr = @"http://godmusic.bs2dl.yy.com/godmusic_1428683534114_h264.mp4";
    _player.urlString = urlStr;
}

- (IBAction)video_6_action:(id)sender
{
    NSString *urlStr = @"http://godmusic.bs2dl.yy.com/godmusic_1427949106436_h264.mp4";
    _player.urlString = urlStr;
    
    NSString *sandboxPath = [SandboxHelper homePath];
    NSLog(@"sandbox = %@", sandboxPath);
}

#pragma mark - PlayerUI delegate
- (void)fullScreenAction
{
    [self setFullScreen];
}

#pragma mark - 横竖屏适配
-(void)setFullScreen{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = 0;
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            val = UIInterfaceOrientationLandscapeRight;
            
        }else{
            val = UIInterfaceOrientationPortrait;
        }
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    NSLog(@"viewWillTransitionToSize");
//    NSLog(@"self.view = %@", NSStringFromCGRect(self.view.frame));
//}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"fromInterfaceOrientation = %ld",fromInterfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"toInterfaceOrientation = %ld",toInterfaceOrientation);
    _isFirst = NO;
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {//旋转到横屏执行的动画
        
        [UIView animateWithDuration:duration animations:^{
            if (SYSTEMVERSION >= 8.0) {
                _player.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                NSLog(@"self.view = %@", NSStringFromCGRect(self.view.frame));
                NSLog(@"_player = %@", NSStringFromCGRect(_player.frame));
                
            }
            else {
                self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                _player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
            }
            
        }];
        
    }else{//返回竖屏执行的动画
        
        [UIView animateWithDuration:duration animations:^{
            if (SYSTEMVERSION >= 8.0) {
                _player.frame = CGRectMake(0, 0, self.view.frame.size.width, 240);
                NSLog(@"self.view = %@", NSStringFromCGRect(self.view.frame));
                NSLog(@"_player = %@", NSStringFromCGRect(_player.frame));
            }
            else {
                self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                _player.frame = CGRectMake(0, 0, kScreenWidth, 240);
            }
        }];
    }
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSUInteger)supportedInterfaceOrientations
{
    //处理iOS8下横屏进入时的bug
    if (_player && _isFirst) {
        UIInterfaceOrientation toInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            _player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
            NSLog(@"%@", NSStringFromCGRect(_player.frame));
            
            _isFirst = NO;
        }
        else {
            
        }
    }
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"-=-=-=-=-内存超标啦啦啦啦啦啦啦啦啦-=-=-a-=-=-=");
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
