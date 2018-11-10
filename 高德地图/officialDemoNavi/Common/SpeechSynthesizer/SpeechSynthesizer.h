//
//  SpeechSynthesizer.h
//  AMapNaviKit
//
//  Created by李晓东 on 17/19/24.
//  Copyright © 2017年 李晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 *  iOS7及以上版本可以使用 AVSpeechSynthesizer 合成语音
 *
 *  或者采用"科大讯飞"等第三方的语音合成服务
 */
@interface SpeechSynthesizer : NSObject

+ (instancetype)sharedSpeechSynthesizer;

- (BOOL)isSpeaking;

- (void)speakString:(NSString *)string;

- (void)stopSpeak;

@end
