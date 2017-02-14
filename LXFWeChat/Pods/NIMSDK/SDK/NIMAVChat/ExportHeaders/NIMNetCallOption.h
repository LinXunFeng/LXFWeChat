//
//  NIMNetCallOption.h
//  NIMLib
//
//  Created by Netease.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CMSampleBuffer.h>
#import "NIMAVChatDefs.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  视频数据处理Block
 *
 *  @param sampleBuffer 摄像头采集到的视频原始数据，其中的 CVPixelBuffer 是 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange 数据格式
 */
typedef void(^NIMNetCallVideoSampleBufferHandler)(CMSampleBufferRef sampleBuffer);

/**
 *  语音数据处理Block
 *
 *  @param audioSamples  麦克风采集到的语音原始 PCM 采样数据，处理完的数据通过该字段回填
 *  @param samplesNumber 采样数据点数量
 *  @param sampleRate 采样率
 *
 *  @return 回填数据采样点数，不允许超过samplesNumber
 */

typedef NSUInteger(^NIMNetCallAudioSamplesHandler)(SInt16 *audioSamples, NSUInteger samplesNumber, Float64 sampleRate);

/**
 *  网络通话选项
 */
@interface NIMNetCallOption : NSObject

/**
 *  期望的发送视频质量
 *  @discussion SDK可能会根据具体机型运算性能和协商结果调整为更合适的清晰度，导致该设置无效（该情况通常发生在通话一方有低性能机器时）
 */
@property (nonatomic,assign)    NIMNetCallVideoQuality   preferredVideoQuality;

/**
 *  禁用视频裁剪
 *  @discussion 不禁用时，SDK可能会根据对端机型屏幕宽高比将本端画面裁剪后再发送，以节省运算量和网络带宽
 */
@property (nonatomic,assign)    BOOL          disableVideoCropping;

/**
 *  自动旋转远端画面, 默认为 YES
 *  @discussion 开启该选项, 以在远端设备旋转时在本端自动调整角度
 */
@property (nonatomic, assign)   BOOL          autoRotateRemoteVideo;


/**
 *  期望的视频编码器. 硬件编码设置仅在 iOS 8.0 及以上系统有效
 */
@property (nonatomic,assign)    NIMNetCallVideoCodec     preferredVideoEncoder;

/**
 *  期望的视频解码器. 硬件解码设置仅在 iOS 8.0 及以上系统有效
 */
@property (nonatomic,assign)    NIMNetCallVideoCodec     preferredVideoDecoder;

/**
 *  视频最大编码码率. 如果不指定, SDK 会根据视频质量自动选择
 */
@property (nonatomic, assign) NSUInteger videoMaxEncodeBitrate;

/**
 *  使用后置摄像头开始视频
 */
@property (nonatomic, assign) BOOL startWithBackCamera;

/**
 *  结束网络通话时自动停止AudioSession, 默认为 YES
 */

@property (nonatomic, assign) BOOL autoDeactivateAudioSession;

/**
 *  语音降噪, 默认为 YES
 */
@property (nonatomic, assign) BOOL audioDenoise;

/**
 *  人声检测, 默认为 YES
 */
@property (nonatomic, assign) BOOL voiceDetect;

/**
 *  本地采集的视频数据回调，供上层实现美颜等功能
 */
@property (nullable, nonatomic, copy) NIMNetCallVideoSampleBufferHandler  videoHandler;

/**
 *  本地采集的语音数据回调，供上层实现变音等功能
 */
@property (nullable, nonatomic, copy) NIMNetCallAudioSamplesHandler  audioHandler;

/**
 *  视频发送帧率
 */
@property (nonatomic, assign) NIMNetCallVideoFrameRate videoFrameRate;

/**
 *  启用互动直播，只在加入会议时设置有效
 */
@property (nonatomic, assign) BOOL enableBypassStreaming;

/**
 *  互动直播推流地址。只在加入会议时设置有效，只有主播端可以指定，每个频道只能有一个主播。
 *
 * @discussion 指定推流地址的客户端被认为是互动直播的主播端
 */
@property (nullable,nonatomic, strong) NSString *bypassStreamingUrl;

/**
 *  互动直播视频画面混屏模式，在 NIMNetCallVideoMixMode 里面选择合适的模式，只有主播设置有效
 */
@property (nonatomic, assign) NSUInteger bypassStreamingVideoMixMode;

/**
 *  服务器录制音频开关 (该开关仅在服务器开启录制功能时才有效)
 */
@property (nonatomic, assign)   BOOL           serverRecordAudio;

/**
 *  服务器录制视频开关 (该开关仅在服务器开启录制功能时才有效)
 */
@property (nonatomic, assign)   BOOL           serverRecordVideo;

/**
 *  扩展消息
 *  @discussion 仅在主叫发起点对点通话时设置有效，用于在主被叫之间传递额外信息，被叫收到呼叫时会携带该信息
 */
@property (nullable,nonatomic,copy)      NSString      *extendMessage;

/**
 *  网络通话请求是否附带推送
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为YES。将这个字段设为NO，网络通话请求将不再有苹果推送通知。
 */
@property (nonatomic,assign)    BOOL          apnsInuse;

/**
 *  推送是否需要角标计数
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为YES。将这个字段设为NO，网络通话请求将不再对角标计数。
 */
@property (nonatomic,assign)    BOOL          apnsBadge;

/**
 *  推送是否需要带前缀(一般为昵称)
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为YES。将这个字段设为NO，推送消息将不带有前缀(xx:)。
 */
@property (nonatomic,assign)    BOOL          apnsWithPrefix;

/**
 *  apns推送文案
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为nil，用户可以设置当前通知的推送文案
 */
@property (nullable,nonatomic,copy)      NSString      *apnsContent;

/**
 *  apns推送声音文件
 *  @discussion 仅在主叫发起点对点通话时设置有效，默认为nil，用户可以设置当前通知的推送声音。该设置会覆盖apnsPayload中的sound设置
 */
@property (nullable,nonatomic,copy)      NSString      *apnsSound;

/**
 *  apns推送Payload
 *  @discussion 仅在主叫发起点对点通话时设置有效，可以通过这个字段定义自定义通知的推送Payload,支持字段参考苹果技术文档,最多支持2K
 */
@property (nullable,nonatomic,copy)      NSDictionary   *apnsPayload;

@end

NS_ASSUME_NONNULL_END
