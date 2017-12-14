//
//  YJTComposeView.m
//
//  Created by yejingtao on 16/6/2.
//  Copyright © 2016年 yejingtao. All rights reserved.
//

#import "YJTComposeView.h"

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;
@interface YJTComposeView ()

//提示标语
@property (nonatomic, strong) UILabel *placeHolderLabel;
@end

@implementation YJTComposeView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.font = [UIFont systemFontOfSize:16.f];
    if (!self.placeholder) {
        self.placeholder = @"";
    }
    
    if (!self.placeholderColor) {
        self.placeholderColor = [UIColor lightGrayColor];
    }
    
    // 监听textview里面的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])){
        
        self.placeholder = @"";
        self.placeholderColor = [UIColor lightGrayColor];
        // 监听textview里面的变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification {
    if([[self placeholder] length] == 0) {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0) {
            [[self viewWithTag:999] setAlpha:1];
        }else{
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect {
    
    if([[self placeholder] length] > 0){
        if (_placeHolderLabel == nil){
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 10)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = [UIFont systemFontOfSize:15];
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if([[self text] length] == 0 && [[self placeholder] length] > 0){
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end
