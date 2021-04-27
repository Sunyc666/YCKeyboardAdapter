//
//  YCKeyboardAdapter.m
//  YCKeyboardAdapter
//
//  Created by yc on 2021/3/27.
//

#import "YCKeyboardAdapter.h"

@interface YCKeyboardAdapter(){
    dispatch_source_t _timer;
    BOOL _yc_keyboard_show_type;//YES Show or NO Hidden
}
@end

@implementation YCKeyboardAdapter

+(YCKeyboardAdapter*)shareInstance{
    static YCKeyboardAdapter * instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
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
    });
    return instance;
}

+(void)yc_keyboardWillShowNotification:(NSNotification *)notfi{
    YCKeyboardMgr->_yc_keyboard_show_type = YES;
}

+(void)yc_keyboardWillHideNotification:(NSNotification *)notfi{
    YCKeyboardMgr->_yc_keyboard_show_type = NO;
}

+(void)yc_keyboardNotfication:(NSNotification *)notfi{
    [YCKeyboardMgr yc_delayToPerform];
}

-(void)yc_delayToPerform{
    if (_timer) {
        return;
    }
    __block NSInteger allTime = 0;
    __weak typeof(self) weakSelf = YCKeyboardMgr;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),5*NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        __strong typeof(self) strongSelf = weakSelf;
        allTime += 5;
        if (allTime > 50) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect keyBoardRect = [strongSelf getKeyBoard];
                CGFloat changeDistance = keyBoardRect.size.height;
                if (changeDistance < 100) {
                    return;
                }
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(yc_keyBoardWillChangeFrame:changeType:)]) {
                    [strongSelf.delegate yc_keyBoardWillChangeFrame:keyBoardRect changeType:YCKeyboardMgr->_yc_keyboard_show_type];
                }
            });
            dispatch_source_cancel(strongSelf->_timer);
            strongSelf->_timer = 0;
        }
    });
    dispatch_resume(_timer);
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

@end
