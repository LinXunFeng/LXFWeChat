//
//  NIMAVChat.h
//  NIMAVChat
//
//  Created by Netease
//  Copyright © 2016 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSDK.h"
#import "NIMAVChatDefs.h"


/**
 *  实时会话定义
 */
#import "NIMRTSManagerProtocol.h"
#import "NIMRTSOption.h"
#import "NIMRTSRecordingInfo.h"

/**
 *  多方实时会话定义
 */
#import "NIMRTSConferenceManagerProtocol.h"
#import "NIMRTSConference.h"
#import "NIMRTSConferenceData.h"


/**
 *  音视频网络通话定义
 */
#import "NIMNetCallManagerProtocol.h"
#import "NIMNetCallOption.h"
#import "NIMNetCallRecordingInfo.h"
#import "NIMNetCallMeeting.h"
#import "NIMNetCallUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  NIMSDK NIMAVChat Category
 */
@interface NIMSDK (NIMAVChat)

/**
 *  网络通话管理类
 */
@property (nonatomic,strong,readonly)   id<NIMNetCallManager> netCallManager;

/**
 *  实时会话管理类（点对点）
 */
@property (nonatomic,strong,readonly)   id<NIMRTSManager> rtsManager;

/**
 *  多方实时会话管理类
 */
@property (nonatomic,strong,readonly)   id<NIMRTSConferenceManager> rtsConferenceManager;


@end

NS_ASSUME_NONNULL_END
