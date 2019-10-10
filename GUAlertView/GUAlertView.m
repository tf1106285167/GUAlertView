//
//  GUAlertView.m
//  ShoppingMall
//
//  Created by TuFa on 2017/7/31.
//  Copyright © 2017年 GiveU. All rights reserved.
//

#import "GUAlertView.h"
#import "UIView+SDExtension.h"
#import <objc/runtime.h>
#import "Masonry.h"

#define ScreenHeight             [UIScreen mainScreen].bounds.size.height
#define ScreenWidth              [UIScreen mainScreen].bounds.size.width
#define StringIfEmpty(string)       ((!string || 0 == string.length || [[NSNull null] isEqual:string]) ?@"":string)

#define GUCornerRadius  5

@interface GUAlertView ()

@property (nonatomic, strong, class) NSMutableArray<GUAlertView *> *displayAlertViews;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabTopConstraint;

@end

@implementation GUAlertView

//+ (NSMutableArray<GUAlertView *> *)displayAlertViews {
//    NSMutableArray *displayAlertViews = objc_getAssociatedObject(self, @selector(displayAlertViews));
//    if (!displayAlertViews) {
//        displayAlertViews = @[].mutableCopy;
//        self.displayAlertViews = displayAlertViews;
//    }
//    return displayAlertViews;
//}
//
//+ (void)setDisplayAlertViews:(NSMutableArray<GUAlertView *> *)displayAlertViews {
//    objc_setAssociatedObject(self, @selector(displayAlertViews), displayAlertViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (instancetype)init {
    
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(GUAlertView.class) owner:self options:nil].lastObject;
        self.sd_width = ScreenWidth;
        self.sd_height = ScreenHeight;
        self.isTapBehind = YES;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.backView.layer.cornerRadius = GUCornerRadius;
    self.backView.clipsToBounds = YES;
    
    [self.btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
//    @weakify(self);
//    [[self.btnCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        [self removeAlertView:NO];
//    }];
    
    [self.btnConfirm addTarget:self action:@selector(btnConfirmClick) forControlEvents:UIControlEventTouchUpInside];
//    [[self.btnConfirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self);
//        [self removeAlertView:YES];
//    }];
    
    UITapGestureRecognizer *recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [self addGestureRecognizer:recognizerTap];
}

- (void)btnCancelClick {
    [self removeAlertView:NO];
}
- (void)btnConfirmClick {
    [self removeAlertView:YES];
}

/** 点击空白区域视图消失*/
- (void)handleTapBehind:(UITapGestureRecognizer *)tap {

    if (self.isTapBehind) {        
        CGPoint location = [tap locationInView:nil];
        if (![self.backView pointInside:[self.backView convertPoint:location fromView:self] withEvent:nil]){
            [self removeAlertView:NO];
        }
    }
}

- (void)showTitle:(NSString *)title withMessage:(NSString *)message actionLeftTitle:(NSString *)leftTitle actionRightTitle:(NSString *)rightTitle {
    
    self.labTitle.text = title;
    self.labContent.text = message;
    [self.btnCancel setTitle:leftTitle forState:UIControlStateNormal];
    [self.btnConfirm setTitle:rightTitle forState:UIControlStateNormal];
    
    if (![self checkStrNoEmpty:title]) {
        self.contentLabTopConstraint.constant = 5;
    }
    
    if (![self checkStrNoEmpty:message]) {
        self.contentLabTopConstraint.constant = 0;
        self.labTitle.font = [UIFont systemFontOfSize:16];
    }
    
    if (![self checkStrNoEmpty:leftTitle]  || ![self checkStrNoEmpty:rightTitle]) {
        
        if ([self checkStrNoEmpty:leftTitle]) {
            [self.singleBtn setTitle:leftTitle forState:UIControlStateNormal];
            [self.singleBtn setTitleColor:[self.btnCancel titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
//            @weakify(self);
//            [[self.singleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                @strongify(self);
//                [self removeAlertView:NO];
//            }];
            [self.singleBtn addTarget:self action:@selector(singleBtnClickNo) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.singleBtn setTitle:rightTitle forState:UIControlStateNormal];
            [self.singleBtn setTitleColor:[self.btnConfirm titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
//            @weakify(self);
//            [[self.singleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//                @strongify(self);
//                [self removeAlertView:YES];
//            }];
            [self.singleBtn addTarget:self action:@selector(singleBtnClickNo) forControlEvents:UIControlEventTouchUpInside];

        }
    }
}

- (void)singleBtnClickNo {
    [self removeAlertView:NO];
}
- (void)singleBtnClickYes {
    [self removeAlertView:YES];
}

//移除弹框+动画
- (void)removeAlertView:(BOOL)isConfirmBtn {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
        [self.class.displayAlertViews removeObject:self];
        if (self.class.displayAlertViews.count > 0) {
            [self.class showAlertView:self.class.displayAlertViews[0]];
        }
        if (isConfirmBtn) {
            if (self.confirmHandler) {
                self.confirmHandler();
            }
        }else{
            if (self.cancelHandler) {
                self.cancelHandler();
            }
        }
    }];
}

//弹框+动画
+ (void)showAlertView:(GUAlertView *)alertView {
    alertView.alpha = 0;
    [alertView.parentView addSubview:alertView];
    [UIView animateWithDuration:0.25 animations:^{
        alertView.alpha = 1;
    } completion:nil];
}

+ (GUAlertView *)showTitle:(NSString *)title withMessage:(NSString *)message actionLeftTitle:(NSString *)leftTitle actionRightTitle:(NSString *)rightTitle cancelHandler:(TapConfirmHandler)cancel confirmHandler:(TapConfirmHandler)confirm {
    GUAlertView *alertView = [[GUAlertView alloc] init];
    [alertView showTitle:title withMessage:message actionLeftTitle:leftTitle actionRightTitle:rightTitle];
    alertView.confirmHandler = confirm;
    alertView.cancelHandler = cancel;
    alertView.parentView = [UIApplication sharedApplication].keyWindow;
    
    [self.displayAlertViews addObject:alertView];
    if (self.displayAlertViews.count == 1) {
        [self showAlertView:alertView];
    } else {
        [self.displayAlertViews addObject:alertView];
    }
    return alertView;
}

+ (GUAlertView *)showTitle:(NSString *)title withAttributeMessage:(NSAttributedString *)attributeMessage actionLeftTitle:(NSString *)leftTitle actionRightTitle:(NSString *)rightTitle cancelHandler:(TapConfirmHandler)cancel confirmHandler:(TapConfirmHandler)confirm {
    GUAlertView *alertView = [[GUAlertView alloc] init];
    [alertView showTitle:title withMessage:nil actionLeftTitle:leftTitle actionRightTitle:rightTitle];
    alertView.labContent.attributedText = attributeMessage;
    alertView.confirmHandler = confirm;
    alertView.cancelHandler = cancel;
    alertView.parentView = GUAppDelegate.window;
    
    [self.displayAlertViews addObject:alertView];
    if (self.displayAlertViews.count == 1) {
        [self showAlertView:alertView];
    } else {
        [self.displayAlertViews addObject:alertView];
    }
    return alertView;
}

+ (GUAlertView *)showTitle:(NSString *)title withMessage:(NSString *)message actionLeftTitle:(NSString *)leftTitle actionRightTitle:(NSString *)rightTitle cancelHandler:(TapConfirmHandler)cancel confirmHandler:(TapConfirmHandler)confirm inView:(UIView *)view {
    GUAlertView *alertView = [[GUAlertView alloc] init];
    [alertView showTitle:title withMessage:message actionLeftTitle:leftTitle actionRightTitle:rightTitle];
    alertView.confirmHandler = confirm;
    alertView.cancelHandler = cancel;
    alertView.parentView = view;
    
    [self.displayAlertViews addObject:alertView];
    if (self.displayAlertViews.count == 1) {
        [self showAlertView:alertView];
    } else {
        [self.displayAlertViews addObject:alertView];
    }
    return alertView;
}


/** 只有一个按钮时*/
- (UIButton *)singleBtn {
    if (!_singleBtn) {
        _singleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backView addSubview:_singleBtn];
//        [_singleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(@0);
//            make.height.equalTo(@45);
//        }];
        _singleBtn.backgroundColor = [UIColor whiteColor];
        _singleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _singleBtn;
}

- (void)setTextOtherColor:(UIColor *)color otherColorText:(NSString *)textStr {
    //设置内容字体颜色 如果内容为空，则是设置标题不同颜色
    NSString *contentStr = self.labContent.text;
    NSString *titleStr = self.labTitle.text;
    if (![self checkStrNoEmpty:contentStr]) {
        if ([titleStr containsString:textStr]) {
            NSMutableAttributedString *attributedTitleStr = [[NSMutableAttributedString alloc] initWithString:StringIfEmpty(titleStr)];
            NSRange colorRange = NSMakeRange([titleStr rangeOfString:textStr].location, [titleStr rangeOfString:textStr].length);
            [attributedTitleStr addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
            [self.labTitle setAttributedText:attributedTitleStr];
        }
        return;
    }
    
    if ([contentStr containsString:textStr]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:StringIfEmpty(contentStr)];
        NSRange colorRange = NSMakeRange([contentStr rangeOfString:textStr].location, [contentStr rangeOfString:textStr].length);
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
        [self.labContent setAttributedText:attributedString];
    }
}

- (void)setTitleFont:(CGFloat)titleFont contentFont:(CGFloat)contentFont {
    //设置内容字体颜色 如果内容为空，则是设置标题不同颜色
    self.labTitle.font = [UIFont systemFontOfSize:titleFont];
    self.labContent.font = [UIFont systemFontOfSize:contentFont];
}

- (void)clickRightCornerRemoveStyle {
    self.btnCancel.userInteractionEnabled = NO;
    self.singleBtn.userInteractionEnabled = NO;
    self.btnConfirm.userInteractionEnabled = NO;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:closeBtn];
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.width.height.mas_equalTo(44);
//    }];
    [closeBtn setImage:[UIImage imageNamed:@"icon_SClose"] forState:UIControlStateNormal];
//    @weakify(self)
//    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        [self removeAlertView:YES];
//    }];
    [closeBtn addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnCloseClick {
    [self removeAlertView:YES];
}

- (BOOL)checkStrNoEmpty:(NSString *)string {
    if (!string || string.length == 0) {
        return NO;
    }
    return YES;
}

@end
