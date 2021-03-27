//
//  YCKeyboardAdapterSDK.h
//  YCKeyboardAdapter
//
//  Created by yc on 2021/3/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YCKeyboardMgr [YCKeyboardAdapterSDK shareInstance]

NS_ASSUME_NONNULL_BEGIN

@protocol YCKeyboardAdapterSDKDelegate <NSObject>

@required

/// 监测键盘尺寸变化（Monitor keyboard size changes）
/// @param nowFrame 改变后的尺寸（now frame）
/// @param changeType 切换键盘同弹出键盘均为YES（Note:Switching the keyboard is the same as ejecting the keyboard）
-(void)yc_keyBoardWillChangeFrame:(CGRect)nowFrame changeType:(BOOL)changeType;

@end

@interface YCKeyboardAdapterSDK : NSObject


@property (nonatomic, weak) id <YCKeyboardAdapterSDKDelegate> delegate;

+(YCKeyboardAdapterSDK *)shareInstance;

@end

NS_ASSUME_NONNULL_END
