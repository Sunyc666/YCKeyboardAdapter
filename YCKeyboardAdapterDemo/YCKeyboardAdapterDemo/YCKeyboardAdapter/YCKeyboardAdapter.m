//
//  YCKeyboardAdapter.m
//  YCKeyboardAdapter
//
//  Created by yc on 2021/3/27.
//

#import "YCKeyboardAdapter.h"

@interface YCKeyboardAdapter(){
    BOOL _yc_keyboard_show_type;//YES Show or NO Hidden
}
@end

@implementation YCKeyboardAdapter

-(instancetype)init{
    self = [super init];
    if (self) {
        //用以计算键盘高度（Used to calculate the height of the keyboard）
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(yc_keyboardNotfication:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        //监听键盘的两种状态（Listen for two states of the keyboard） - WillShow || WillHide
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(yc_keyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(yc_keyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

-(void)yc_keyboardWillShowNotification:(NSNotification *)notfi{
    _yc_keyboard_show_type = YES;
}

-(void)yc_keyboardWillHideNotification:(NSNotification *)notfi{
    _yc_keyboard_show_type = NO;
    [self.delegate yc_keyBoardWillChangeFrame:CGRectZero changeType:NO];
}

-(void)yc_keyboardNotfication:(NSNotification *)notfi{
    [self yc_delayToPerform];
}

-(void)yc_delayToPerform{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        CGRect keyBoardRect = [strongSelf getKeyBoard];
        CGFloat changeDistance = keyBoardRect.size.height;
        if (changeDistance < 100) {
            return;
        }
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(yc_keyBoardWillChangeFrame:changeType:)]) {
            [strongSelf.delegate yc_keyBoardWillChangeFrame:keyBoardRect changeType:self->_yc_keyboard_show_type];
        }
    });
}

- (CGRect)getKeyBoard{
    UIView *keyBoardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow*window in [windows reverseObjectEnumerator]){
        keyBoardView = [self getKeyBoardInView:window];
        if (keyBoardView){
            return keyBoardView.frame;
        }
    }
    return CGRectMake(0, 0, 0, 0);
}

- (UIView *)getKeyBoardInView:(UIView *)view{
    for(UIView *subView in [view subviews]){
        if (strstr(object_getClassName(subView), "UIInputSetHostView")){
            return subView;
        }else{
            UIView *tempView = [self getKeyBoardInView:subView];
            if (tempView){
                return tempView;
            }
        }
    }
    return nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
