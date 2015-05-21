//
//  TTHomeTableViewCell.m
//  VedioPlayerDemo
//
//  Created by xun.liu on 14/11/13.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import "TTRootTableViewCell.h"
#import "TTGridView.h"
#import "TTHomeViewController.h"

@implementation TTRootTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setData:(NSArray *)data
{
    if (_data != data) {
        _data = data;
        [self setupViews];
    }
}

- (void)setupViews
{
    self.backgroundColor = COLORWITHRGB(244, 244, 244, 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (int i=0; i<2; i++) {
        TTGridView *gridView = [[[NSBundle mainBundle] loadNibNamed:@"TTGridView" owner:nil options:nil] lastObject];
        gridView.tag = 2214+i;
        [self.contentView addSubview:gridView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetailView:)];
        [gridView addGestureRecognizer:tap];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i=0; i<2; i++) {
        int tag = 2214+i;
        TTGridView *gridView = (TTGridView *)[self.contentView viewWithTag:tag];
        
        if (i<_data.count) {
            gridView.hidden = NO;
            gridView.frame = CGRectMake(145*i + 10*(i+1), 10, 145, 147);
            gridView.urlstring = _data[i];
        }
        else {
            gridView.hidden = YES;
        }
    }
}

- (void)tapToDetailView:(UITapGestureRecognizer *)tap
{
    int tag = (int)tap.view.tag;
    NSLog(@"gridTag = %d",tag);
    
    TTHomeViewController *ctrl = [[TTHomeViewController alloc] init];
    if (_flag == 1) {
        //自定义ip
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        ctrl.urlString = [NSString stringWithFormat:@"http://%@/%@", app.playerIP, [_data objectAtIndex:tag-2214]];
    }
    else if (_flag == 2) {
        //海妖宝藏
        ctrl.urlString = video_url_pingfandelu;
    }
    else if (_flag == 3) {
        //本地服务器
        ctrl.urlString = [NSString stringWithFormat:@"http://192.168.15.64:80/%@", [_data objectAtIndex:tag-2214]];
//        ctrl.urlString = [NSString stringWithFormat:@"http://192.168.12.99:88/%@", [_data objectAtIndex:tag-2214]];
    }
//    [self.viewController.navigationController pushViewController:ctrl animated:YES];
    [self.viewController presentViewController:ctrl animated:YES completion:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
