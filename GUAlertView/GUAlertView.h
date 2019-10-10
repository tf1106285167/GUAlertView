//
//  GUAlertView.h
//  ShoppingMall
//
//  Created by TuFa on 2017/7/31.
//  Copyright © 2017年 GiveU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapConfirmHandler)(void);
typedef void(^TapCancelHandler)(void);

@interface GUAlertView : UIView

@property (nonatomic, assign) BOOL isTapBehind; //是否点击空白处消失 默认YES

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;    //!< 标题
@property (weak, nonatomic) IBOutlet UILabel *labContent;  //!< 内容
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;  //!< 左侧按钮
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm; //!< 右侧按钮
@property (nonatomic, strong) UIButton *singleBtn;         //!< 只有一个button时
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crossLineViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTitleContraint;
@property (weak, nonatomic) IBOutlet UIView *crossLineView; //!< 横向分隔线

@property (nonatomic, copy) TapConfirmHandler confirmHandler; //!< 确定回调
@property (nonatomic, copy) TapCancelHandler cancelHandler;   //!< 取消回调

@property (nonatomic, strong) UIView *parentView;


/**
 GUAlertView弹框  只有一个按钮时，另一个则传空

 @param title 标题
 @param message 内容
 @param leftTitle 左侧按钮标题
 @param rightTitle 右侧按钮标题
 @param confirm 点击右侧按钮回调
 */
+ (GUAlertView *)showTitle:(NSString *)title withMessage:(NSString *)message actionLeftTitle:(NSString *)leftTitle actionRightTitle:(NSString *)rightTitle cancelHandler:(TapConfirmHandler)cancel confirmHandler:(TapConfirmHandler)confirm;

/**
 GUAlertView弹框  只有一个按钮时，另一个则传空
 
 @param title 标题
 @param attributeMessage 内容
 @param leftTitle 左侧按钮标题
 @param rightTitle 右侧按钮标题
 @param confirm 点击右侧按钮回调
 */
+ (GUAlertView *)showTitle:(NSString *)title withAttributeMessage:(NSAttributedString *)attributeMessage actionLeftTitle:(NSString *)leftTitle actionRightTitle:(NSString *)rightTitle cancelHandler:(TapConfirmHandler)cancel confirmHandler:(TapConfirmHandler)confirm;


/**
 设置内容的不同字体颜色

 @param color 不同的字体的颜色
 @param textStr 显示的内容
 */
- (void)setTextOtherColor:(UIColor *)color otherColorText:(NSString *)textStr;


/**
 点击右上角移除样式
 */
- (void)clickRightCornerRemoveStyle;

/**
 设置内容的不同字体大小
 
 @param titleFont 标题字体大小
 @param contentFont 显示内容的字体大小
 */
- (void)setTitleFont:(CGFloat)titleFont contentFont:(CGFloat)contentFont;
/**
 将弹框展示在不同的父视图上  view为nil，默认展示在keyWindow

 @param title 标题
 @param message 内容
 @param leftTitle 左侧按钮标题
 @param rightTitle 右侧按钮标题
 @param confirm 点击右侧按钮回调
 @param view 要展示在哪一个父视图上
 */
+ (GUAlertView *)showTitle:(NSString *)title withMessage:(NSString *)message actionLeftTitle:(NSString *)leftTitle actionRightTitle:(NSString *)rightTitle cancelHandler:(TapConfirmHandler)cancel confirmHandler:(TapConfirmHandler)confirm inView:(UIView *)view;
@end
