//
//  TTVideoPlayerCell.m
//  VedioPlayerDemo
//
//  Created by xun.liu on 14/11/13.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import "TTVideoPlayerCell.h"
#import "TTGridView.h"

@implementation TTVideoPlayerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setupViews
{
    self.backgroundColor = COLORWITHRGB(244, 244, 244, 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (int i=0; i<2; i++) {
        TTGridView *gridView = [[[NSBundle mainBundle] loadNibNamed:@"TTGridView" owner:self options:nil] lastObject];
        gridView.tag = 2014+i;
        [self.contentView addSubview:gridView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetailView:)];
        [gridView addGestureRecognizer:tap];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i=0; i<2; i++) {
        int tag = 2014 + i;
        TTGridView *gridView = (TTGridView *)[self.contentView viewWithTag:tag];
        
        gridView.frame = CGRectMake(145*i + 10*(i+1), 10, 145, 147);
        
    }
}

- (void)tapToDetailView:(UITapGestureRecognizer *)tap
{
    NSLog(@"gridTag = %ld",(long)tap.view.tag);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
