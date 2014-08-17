//
//  AlertView.m
//  iNoknok
//
//  Created by jijunyuan on 14-7-29.
//  Copyright (c) 2014年 iNoknok.com. All rights reserved.
//

#import "AlertView.h"

#define LINE_HEIGHT 17.0f  //默认行高
#define PAN_VALUE 500.f
#define SCREEN_BOUND_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_BOUND [UIScreen mainScreen].bounds

@interface AlertView()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *vBottom;      //底部放button的view
@property (weak, nonatomic) IBOutlet UIView *vVLine;       //底部竖线
@property (weak, nonatomic) IBOutlet UIView *hLine;        //水平线
@property (weak,nonatomic) AlertView * alertViewTemp;

@property (nonatomic,copy) SureClickEventBlock sureBlock;
@property (nonatomic,copy) CancelClickEventBlock cancelBlock;

+(AlertView *)shareAlertViewTitle:(NSString *)aTitle content:(NSString *)aContent;

//三个按钮的触发事件
- (IBAction)bigSureButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)smallSureButtonClick:(id)sender;

@end

@implementation AlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil] lastObject];
    }
    return self;
}


#pragma mark - 单利
/**
 *  @brief AlertView的单利
 *
 *  @param aTitle   title
 *  @param aContent 内容信息
 *
 *  @return 返回alertview
 */

static AlertView * alertView = nil;
+(AlertView *)shareAlertViewTitle:(NSString *)aTitle content:(NSString *)aContent
{
    @synchronized(alertView)
    {
        if (alertView == nil)
        {
            alertView  = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            CGFloat height = [alertView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            alertView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-height)/2.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
        }
        alertView.labTitle.text = aTitle;
        alertView.labContent.text = aContent;
    }
    return alertView;
}


/**
 *  @brief window的单利
 */
static UIWindow * alertWindow = nil;
+(UIWindow *)shareWindow
{
    @synchronized(alertWindow)
    {
        if (alertWindow == nil)
        {
            alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.hidden = NO;
            alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
            alertWindow.windowLevel = UIWindowLevelAlert+1;
            
            //添加手势
            [alertWindow addGestureRecognizer:[AlertView sharePanGrcognizer]];
            [alertWindow addGestureRecognizer:[AlertView shareSwipeGrcognizer]];
            [alertWindow addGestureRecognizer:[AlertView shareBottomSwipeGrcognizer]];
            //            [[AlertView sharePanGrcognizer] requireGestureRecognizerToFail:[AlertView shareSwipeGrcognizer]];
            //             [[AlertView sharePanGrcognizer] requireGestureRecognizerToFail:[AlertView shareBottomSwipeGrcognizer]];
            
        }
    }
    return alertWindow;
}

/**
 *  @brief swiperRecognizer单利
 */
static UIPanGestureRecognizer * panRecognizer = nil;
+(UIPanGestureRecognizer *)sharePanGrcognizer
{
    @synchronized(panRecognizer)
    {
        if (panRecognizer == nil)
        {
            panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
        }
    }
    return panRecognizer;
}

/**
 *  @brief swiperRecognizer
 */

static UISwipeGestureRecognizer * swipeRecognizer = nil;
+(UISwipeGestureRecognizer *)shareSwipeGrcognizer
{
    @synchronized(swipeRecognizer)
    {
        if (swipeRecognizer == nil)
        {
            swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
            [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
        }
    }
    return swipeRecognizer;
}

static UISwipeGestureRecognizer * swipeBottomRecognizer = nil;
+(UISwipeGestureRecognizer *)shareBottomSwipeGrcognizer
{
    @synchronized(swipeBottomRecognizer)
    {
        if (swipeBottomRecognizer == nil)
        {
            swipeBottomRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
            [swipeBottomRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
        }
    }
    return swipeBottomRecognizer;
}


#pragma mark - 处理
/**
 *  @brief 处理alert
 *
 *  @param aTitle            标题
 *  @param aContent          内容
 *  @param cancleButtonTitle 取消按钮标题
 *  @param sureButtonTitle   确定按钮标题
 *  @param lineSpace         行间距
 *
 *  @return 返回alertView
 */
+ (AlertView *)showTemptitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle sureButtonTitle:(NSString *)sureButtonTitle andLineHeight:(float)lineHeight
{
    AlertView * alert = [AlertView shareAlertViewTitle:aTitle content:aContent];
    if (aTitle != nil)
    {
        alert.labTitle.text = aTitle;
    }
    
    [self shareBottomSwipeGrcognizer].delegate = alertView;
    [self sharePanGrcognizer].delegate = alertView;
    [self shareSwipeGrcognizer].delegate = alertView;
    
    //设置行间距
    if (aContent != nil)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = lineHeight;
        paragraphStyle.maximumLineHeight = lineHeight;
        paragraphStyle.minimumLineHeight = lineHeight;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *ats = @{
                              NSFontAttributeName : [UIFont fontWithName:alert.labContent.font.fontName size:15.0f],
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        alert.labContent.attributedText = [[NSAttributedString alloc] initWithString:aContent attributes:ats];
    }
    
    CGFloat height = [alert systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    alert.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height-height)/2.0, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
    
    //window
    UIWindow * aWindow = [AlertView shareWindow];
    [aWindow addSubview:alert];
    
    if ((sureButtonTitle == nil || sureButtonTitle.length==0)&&(cancleButtonTitle != nil || cancleButtonTitle.length>0))
    {
        [alert.btnBigCancel setTitle:cancleButtonTitle forState:UIControlStateNormal];
        alert.btnSmallCancel.hidden = YES;
        alert.btnSure.hidden = YES;
        alert.vVLine.hidden = YES;
        alert.btnBigCancel.hidden = NO;
    }
    else
    {
        if (sureButtonTitle != nil && cancleButtonTitle != nil)
        {
            [alert.btnSmallCancel setTitle:cancleButtonTitle forState:UIControlStateNormal];
            [alert.btnSure setTitle:sureButtonTitle forState:UIControlStateNormal];
            alert.btnSmallCancel.hidden = NO;
            alert.btnSure.hidden = NO;
            alert.vVLine.hidden = NO;
            alert.btnBigCancel.hidden = YES;
        }
        else if(sureButtonTitle != nil && cancleButtonTitle == nil)
        {
            [alert.btnBigCancel setTitle:sureButtonTitle forState:UIControlStateNormal];
            alert.btnSmallCancel.hidden = YES;
            alert.btnSure.hidden = YES;
            alert.vVLine.hidden = YES;
            alert.btnBigCancel.hidden = NO;
        }
        else
        {
            alert.btnSmallCancel.hidden = YES;
            alert.btnSure.hidden = YES;
            alert.vVLine.hidden = YES;
            alert.btnBigCancel.hidden = YES;
        }
    }
    return alert;
}


#pragma mark - 手势处理
static float pointY;
+ (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    UIView *page = [recognizer view];
    CGPoint translation = [recognizer translationInView:page];
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        pointY = alertView.frame.origin.y;
    }
    else if (recognizer.state ==UIGestureRecognizerStateChanged)
    {
        alertView.frame = CGRectMake(alertView.frame.origin.x, pointY+translation.y, alertView.frame.size.width, alertView.frame.size.height);
        
        float value = 0.8-ABS(translation.y)/PAN_VALUE;
        if (value<0)
        {
            value = 0.f;
        }
        [self shareWindow].backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:value];
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGFloat height = [alertView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        if (alertView.frame.origin.y>0 && alertView.frame.origin.y<SCREEN_BOUND_SIZE.height-height)
        {
            [UIView animateWithDuration:0.25 animations:^{
                alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
                alertView.frame = CGRectMake(0,pointY, CGRectGetWidth(SCREEN_BOUND), height);
            } completion:^(BOOL finished) {
                alertWindow.hidden = NO;
                alertWindow.alpha = 1.0;
            }];
            
        }
        else if(alertView.frame.origin.y <= 0)
        {
            [UIView animateWithDuration:0.25 animations:^{
                alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0];
                alertView.frame = CGRectMake(0, -SCREEN_BOUND_SIZE.height, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
            } completion:^(BOOL finished) {
                alertWindow.alpha = 1.0;
                alertWindow.hidden = YES;
                alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f];
                alertView.cancelBlock();
            }];
        }
        else if(alertView.frame.origin.y >= SCREEN_BOUND_SIZE.height-height)
        {
            [UIView animateWithDuration:0.25 animations:^{
                alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0];
                alertView.frame = CGRectMake(0, SCREEN_BOUND_SIZE.height, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
            } completion:^(BOOL finished) {
                alertWindow.alpha = 1.0;
                alertWindow.hidden = YES;
                alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f];
                alertView.sureBlock();
            }];
        }
    }
}

+ (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"%s",__FUNCTION__);
    
    
    CGFloat height = [alertView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    if (recognizer.direction==UISwipeGestureRecognizerDirectionUp)
    {
        NSLog(@"fangxiang = UISwipeGestureRecognizerDirectionUp");
        [UIView animateWithDuration:0.25 animations:^{
            alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
            alertView.frame = CGRectMake(0, -SCREEN_BOUND_SIZE.height, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
        } completion:^(BOOL finished) {
            alertWindow.alpha = 1.0;
            alertWindow.hidden = YES;
            alertView.cancelBlock();
        }];
    }
    else if(recognizer.direction==UISwipeGestureRecognizerDirectionDown)
    {
        NSLog(@"fangxiang = UISwipeGestureRecognizerDirectionDown");
        [UIView animateWithDuration:0.25 animations:^{
            alertWindow.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
            alertView.frame = CGRectMake(0, SCREEN_BOUND_SIZE.height, CGRectGetWidth([[UIScreen mainScreen] bounds]), height);
        } completion:^(BOOL finished) {
            alertWindow.alpha = 1.0;
            alertWindow.hidden = YES;
            alertView.sureBlock();
        }];
    }
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if(gestureRecognizer ==[AlertView sharePanGrcognizer])
//    {
//        INFO(@"sharePanGrcognizer");
//        return YES;
//    }
//     if(gestureRecognizer ==[AlertView shareBottomSwipeGrcognizer] || gestureRecognizer ==[AlertView shareSwipeGrcognizer])
//     {
//          INFO(@"shareBottomGrcognizer");
//         return YES;
//     }
//    return NO;
//}

#pragma mark - 接口处理
/**
 *  @brief 只有一个按钮，并且没有毁掉函数
 *
 *  @param aTitle            标题
 *  @param aContent          内容
 *  @param cancleButtonTitle 取消按钮标题
 */
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle
{
    AlertView * alert = [self showTemptitle:aTitle content:aContent cancelbuttonTitle:cancleButtonTitle sureButtonTitle:nil andLineHeight:LINE_HEIGHT];
    alert.cancelBlock = ^(void){
        ;
    };
    alert.sureBlock = ^(void){
        ;
    };
    [AlertView shareWindow].hidden = NO;
}
/**
 *  @brief 只有一个按钮，并且没有毁掉函数
 *
 *  @param aTitle            标题
 *  @param aContent          内容
 *  @param cancleButtonTitle 取消按钮标题
 *  @param lineHeight        行高
 */
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle andLineHeight:(float)lineHeight
{
    AlertView * alert = [self showTemptitle:aTitle content:aContent cancelbuttonTitle:cancleButtonTitle sureButtonTitle:nil andLineHeight:lineHeight];
    alert.cancelBlock = ^(void){
        ;
    };
    alert.sureBlock = ^(void){
        ;
    };
    [AlertView shareWindow].hidden = NO;
}
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
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle sureButtonTitle:(NSString *)sureButtonTitle sureButtonClickEvent:(SureClickEventBlock)sureClickBlock cancelButtonClickEvent:(CancelClickEventBlock)cancelClickBlock
{
    
    AlertView * alert = [self showTemptitle:aTitle content:aContent cancelbuttonTitle:cancleButtonTitle sureButtonTitle:sureButtonTitle andLineHeight:LINE_HEIGHT];
    alert.sureBlock = ^(void){
        if (sureClickBlock != nil) {
             sureClickBlock();
        }
    };
    alert.cancelBlock = ^(void){
        if (cancelClickBlock != nil)
        {
            cancelClickBlock();
        }
    };
    [AlertView shareWindow].hidden = NO;
}
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
+(void)showtitle:(NSString *)aTitle content:(NSString *)aContent cancelbuttonTitle:(NSString *)cancleButtonTitle sureButtonTitle:(NSString *)sureButtonTitle sureButtonClickEvent:(SureClickEventBlock)sureClickBlock cancelButtonClickEvent:(CancelClickEventBlock)cancelClickBlock andLineHeight:(float)lineHeight
{
    AlertView * alert = [self showTemptitle:aTitle content:aContent cancelbuttonTitle:cancleButtonTitle sureButtonTitle:sureButtonTitle andLineHeight:LINE_HEIGHT];
    alert.sureBlock = ^(void){
        if (sureClickBlock != nil) {
            sureClickBlock();
        }
    };
    alert.cancelBlock = ^(void){
        if (cancelClickBlock != nil)
        {
            cancelClickBlock();
        }
    };
    [AlertView shareWindow].hidden = NO;
}


#pragma mark - 按钮事件
- (IBAction)bigSureButtonClick:(id)sender
{
    [AlertView shareWindow].hidden = YES;
    self.cancelBlock();
}

- (IBAction)cancelButtonClick:(id)sender
{
    [AlertView shareWindow].hidden = YES;
    self.cancelBlock();
}

- (IBAction)smallSureButtonClick:(id)sender
{
    [AlertView shareWindow].hidden = YES;
    self.sureBlock();
}
@end
