//
//  NIMAVChatDefs.h
//  NIMAVChat
//
//  Created by fenric on 16/10/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#ifndef NIMAVChatDefs_h
#define NIMAVChatDefs_h

/**
 *  网络通话视频质量
 */
typedef NS_ENUM(NSInteger, NIMNetCallVideoQuality) {
    /**
     *  默认视频质量
     */
    NIMNetCallVideoQualityDefault    = 0,
    /**
     *  低视频质量
     */
    NIMNetCallVideoQualityLow        = 1,
    /**
     *  中等视频质量
     */
    NIMNetCallVideoQualityMedium     = 2,
    /**
     *  高视频质量
     */
    NIMNetCallVideoQualityHigh       = 3,
    /**
     *  480P等级视频质量
     */
    NIMNetCallVideoQuality480pLevel  = 4,
    /**
     *  720P等级视频质量
     */
    NIMNetCallVideoQuality720pLevel  = 5,
    
};


/**
 *  视频编码器
 */
typedef NS_ENUM(NSUInteger, NIMNetCallVideoCodec) {
    /**
     *  默认编解码器, SDK 自己选择合适的编码器
     */
    NIMNetCallVideoCodecDefault = 0,
    /**
     *  软件编解码
     */
    NIMNetCallVideoCodecSoftware = 1,
    /**
     *  硬件编解码. 注意: 硬件编解码只在 iOS 8.0 及以上系统适用
     */
    NIMNetCallVideoCodecHardware = 2,
};


/**
 *  视频帧率
 */
typedef NS_ENUM(NSUInteger, NIMNetCallVideoFrameRate) {
    /**
     *  SDK 支持的最小帧率
     */
    NIMNetCallVideoFrameRateMin = 0,
    /**
     *  5 FPS
     */
    NIMNetCallVideoFrameRate5FPS,
    /**
     *  10 FPS
     */
    NIMNetCallVideoFrameRate10FPS,
    /**
     *  15 FPS
     */
    NIMNetCallVideoFrameRate15FPS,
    /**
     *  20 FPS
     */
    NIMNetCallVideoFrameRate20FPS,
    /**
     *  25 FPS
     */
    NIMNetCallVideoFrameRate25FPS,
    /**
     *  缺省帧率
     */
    NIMNetCallVideoFrameRateDefault,
    /**
     *  SDK 支持的最大帧率
     */
    NIMNetCallVideoFrameRateMax,
};



/**
 *  视频混频模式, 用于互动直播连麦时的视频混频参数设置
 */
typedef NS_ENUM(NSUInteger, NIMNetCallVideoMixMode) {
    /**
     *  右侧纵排浮窗(画中画)
     */
    NIMNetCallVideoMixModeFloatingRightVertical  = 0,
    /**
     *  左侧纵排浮窗(画中画)
     */
    NIMNetCallVideoMixModeFloatingLeftVertical   = 1,
    /**
     *  分格平铺, 显示完整画面, 不裁剪
     */
    NIMNetCallVideoMixModeLatticeAspectFit       = 2,
    /**
     *  分格平铺, 填满区域, 可能裁剪
     */
    NIMNetCallVideoMixModeLatticeAspectFill      = 3,
};

/**
 *  NIM 网络通话 Error Domain
 */
extern NSString *const NIMNetCallErrorDomain;

/**
 *  网络通话错误码
 */
typedef NS_ENUM(NSInteger, NIMNetCallErrorCode) {
    /**
     *  超过最大允许直播节点数量
     */
    NIMNetCallErrorCodeBypassSetExceedMax = 20202,
    
    /**
     *  必须由主播第一个开启直播
     */
    NIMNetCallErrorCodeBypassSetHostNotJoined = 20203,
    
    /**
     *  互动直播服务器错误
     */
    NIMNetCallErrorCodeBypassSetServerError = 20204,
    
    /**
     *  互动直播其他错误
     */
    NIMNetCallErrorCodeBypassSetOtherError = 20205,
    
    /**
     *  互动直播服务器没有响应
     */
    NIMNetCallErrorCodeBypassSetNoResponse = 20404,
    
    /**
     *  重连过程中无法进行相关操作，稍后再试
     */
    NIMNetCallErrorCodeBypassReconnecting = 20405,
    
    /**
     *  互动直播设置超时
     */
    NIMNetCallErrorCodeBypassSetTimeout = 20408,
    
};


/**
 *  用户离开多人实时会话的原因
 */
typedef NS_ENUM(NSUInteger, NIMRTSConferenceUserLeaveReason) {
    /**
     *  正常离开
     */
    NIMRTSConferenceUserLeaveReasonNormal,
    /**
     *  超时离开
     */
    NIMRTSConferenceUserLeaveReasonTimeout,
};



/**
 *  NIM 多人实时会话 Error Domain
 */
extern NSString *const NIMRTSConferenceErrorDomain;

/**
 *  多人实时会话错误码
 */
typedef NS_ENUM(NSInteger, NIMRTSConferenceErrorCode) {
    /**
     *  与服务器连接已断开
     */
    NIMRTSConferenceErrorCodeServerDisconnected = 21001,

};


#endif /* NIMAVChatDefs_h */
