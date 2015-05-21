//
//  TTSettingViewController.m
//  vodPlayerDemo4
//
//  Created by xun.liu on 14/12/25.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import "TTSettingViewController.h"
#import "AppDelegate.h"

@interface TTSettingViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *IPtextField;

@end

@implementation TTSettingViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = COLORWITHRGB(244, 244, 244, 1);
    
    [self keyboardNotification];
}

- (IBAction)changeIPAction:(id)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (_IPtextField.text != nil) {
        app.type = 1;
        app.playerIP = _IPtextField.text;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"子给IP" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        //请输入网址
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入网址" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    app.isSetting = YES;
}

- (IBAction)haiyaobaozangAction:(id)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.type = 2;
    
    app.isSetting = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"海妖宝藏" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)locationIPAction:(id)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.type = 3;
    app.isSetting = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本地服务器" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)keyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnyWhere:)];
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         NSLog(@"SYSTEMVERSION == %f",SYSTEMVERSION);
                         if (SYSTEMVERSION >= 7.0) {
//                             CGRect bottomFrame = self.bottomView.frame;
//                             bottomFrame.origin.y = self.view.bounds.size.height - keyboardHeight - bottomFrame.size.height;
//                             self.bottomView.frame = bottomFrame;
                         }
                         else {
                             
                         }
                         
                         
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
    
    [self.view addGestureRecognizer:tapRecognizer];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnyWhere:)];
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (SYSTEMVERSION >= 7.0) {
//        CGRect bottomFrame = self.bottomView.frame;
//        bottomFrame.origin.y = self.view.bounds.size.height - bottomFrame.size.height;
//        self.bottomView.frame = bottomFrame;
    }
    else {
        
    }
    
    [UIView commitAnimations];
    
    [self.view removeGestureRecognizer:tapRecognizer];
}

- (void)didTapAnyWhere:(UITapGestureRecognizer *)recognizer
{
    [self.IPtextField resignFirstResponder];
}

#pragma mark - UITextfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didTapAnyWhere:nil];
    return YES;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
