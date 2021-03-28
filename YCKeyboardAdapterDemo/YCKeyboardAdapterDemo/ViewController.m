//
//  ViewController.m
//  YCKeyboardAdapterDemo
//
//  Created by yc on 2021/3/28.
//

#import "ViewController.h"
#import "YCKeyboardAdapter.h"
@interface ViewController ()<YCKeyboardAdapterDelegate>
@property (strong, nonatomic) UITextField *tef;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YCKeyboardMgr.delegate = self;
    
    //初始化一个距离页面底部40的tef
    _tef = [[UITextField alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 80, self.view.frame.size.width - 40, 40)];
    
    _tef.backgroundColor = [UIColor redColor];
    _tef.placeholder = @"测试Tef随键盘改变位置";
    [self.view addSubview:_tef];
}

/// 监测键盘尺寸变化（Monitor keyboard size changes）
/// @param nowFrame 改变后的尺寸（now frame）
/// @param changeType 切换键盘同弹出键盘均为YES（Note:Switching the keyboard is the same as ejecting the keyboard）
-(void)yc_keyBoardWillChangeFrame:(CGRect)nowFrame changeType:(BOOL)changeType{
    CGFloat distance = 0;
    if (changeType) {
        //键盘弹出 - 计算输入法实际高度 ：实际高度 = nowFrame.origin.y + nowFrame.size.height
        distance = self.view.frame.size.height - 40 - (nowFrame.origin.y + nowFrame.size.height);
    }else{
        //键盘回收 - 恢复到初始位置
        distance = self.view.frame.size.height - 80;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tef.frame = CGRectMake(20, distance, self.view.frame.size.width - 40, 40);
    }];
}

@end
