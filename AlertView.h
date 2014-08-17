//
//  AlertView.h
//  iNoknok
//
//  Created by jijunyuan on 14-7-29.
//  Copyright (c) 2014年 iNoknok.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureClickEventBlock)(void);
typedef void(^CancelClickEventBlock)(void);


@interface AlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labTitle;         //标题lab
@property (weak, nonatomic) IBOutlet UILabel *labContent;       //内容信息lab
@property (weak, nonatomic) IBOutlet UIButton *btnBigCancel;    //当只存在一个按钮时的button

@property (weak, nonatomic) IBOutlet UIButton *btnSmallCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnSure;    //当存在两个按钮时，确定按钮button        //当存在两个按钮时，取消按钮button



/**
 *  @brief 没有回调事件下得AlertView
 *
 *  @param aTitle            标题title
 *  @param aContent          内容信息
 *  @param cancleButtonTitle 取消按钮。例如只有一个按钮的时候可以直接给此按钮赋“确定”
 *  @param sureButtonTitle   确定按钮，当两个按钮同时出现时，此按钮作为确定按钮
 */
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle;

/**
 *  @brief 没有回调事件下得AlertView
 *
 *  @param aTitle            标题title
 *  @param aContent          内容信息
 *  @param cancleButtonTitle 取消按钮。例如只有一个按钮的时候可以直接给此按钮赋“确定”
 *  @param sureButtonTitle   确定按钮，当两个按钮同时出现时，此按钮作为确定按钮
 *  @param lineHeight         行高
 */
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle andLineHeight:(float)lineHeight;

/**
 *  @brief 存在回调事件下得AlertView
 *
 *  @param aTitle            标题title
 *  @param aContent          内容信息
 *  @param cancleButtonTitle 取消按钮。例如只有一个按钮的时候可以直接给此按钮赋“确定”
 *  @param sureButtonTitle   确定按钮，当两个按钮同时出现时，此按钮作为确定按钮
 *  @param sureClickBlock    当存在两个按钮时，点击确定按钮，触发此事件
 *  @param cancelClickBlock  当存在两个按钮时，点击取消按钮，触发此事件。当存在一个取消按钮时，点击触发此事件。
 */
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle sureButtonTitle:(NSString *)sureButtonTitle sureButtonClickEvent:(SureClickEventBlock)sureClickBlock cancelButtonClickEvent:(CancelClickEventBlock)cancelClickBlock;
/**
 *  @brief 存在回调事件下得AlertView
 *
 *  @param aTitle            标题title
 *  @param aContent          内容信息
 *  @param cancleButtonTitle 取消按钮。例如只有一个按钮的时候可以直接给此按钮赋“确定”
 *  @param sureButtonTitle   确定按钮，当两个按钮同时出现时，此按钮作为确定按钮
 *  @param sureClickBlock    当存在两个按钮时，点击确定按钮，触发此事件
 *  @param cancelClickBlock  当存在两个按钮时，点击取消按钮，触发此事件。当存在一个取消按钮时，点击触发此事件。
 *  @param lineHeight         行高
 */
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle sureButtonTitle:(NSString *)sureButtonTitle sureButtonClickEvent:(SureClickEventBlock)sureClickBlock cancelButtonClickEvent:(CancelClickEventBlock)cancelClickBlock andLineHeight:(float)lineHeight;

@end
