//
//  ViewController.m
//  AlertViewDemo
//
//  Created by jijunyuan on 14/8/17.
//  Copyright (c) 2014年 jijunyuan. All rights reserved.
//

#import "ViewController.h"
#import "AlertView.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickMe:(UIButton *)sender {
    [AlertView showtitle:@"早安心语" content:@"如果我在等一个人回来，我会希望她看到我的时候，我是一个很值得他欣赏的人。" cancelbuttonTitle:@"取消" sureButtonTitle:@"确定" sureButtonClickEvent:^{
        [AlertView showtitle:nil content:@"就算你人缘再好，能在你困难的时候帮助你的还是只有那么寥寥数人，狂欢，不过是一群人的孤单。真正的朋友，是能够伴你度过寂寞、孤独以及沉默的那个人。" cancelbuttonTitle:@"OK"];
    } cancelButtonClickEvent:^{
        ;
    }];
}


@end
