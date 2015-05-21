//
//  TTGridView.m
//  VedioPlayerDemo
//
//  Created by xun.liu on 14/11/13.
//  Copyright (c) 2014年 xun.liu. All rights reserved.
//

#import "TTGridView.h"

@implementation TTGridView

- (void)setUrlstring:(NSString *)urlstring
{
    if (_urlstring != urlstring) {
        _urlstring = urlstring;
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentLabel.text = _urlstring;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
