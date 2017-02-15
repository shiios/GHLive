//
//  GHShowTimeViewController.m
//  GHLive
//
//  Created by kalian on 2017/2/14.
//  Copyright © 2017年 kalian. All rights reserved.
//

#import "GHShowTimeViewController.h"
#import <LFLiveKit.h>

@interface GHShowTimeViewController ()<LFLiveSessionDelegate>

@property (strong, nonatomic) IBOutlet UIButton *beautyBtn;

@property (strong, nonatomic) IBOutlet UIButton *captureBtn;

@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *startLiveBtn;

@property (nonatomic,strong) LFLiveSession *session;
/** RTMP地址 */
@property (nonatomic, copy) NSString *rtmpUrl;
@property (nonatomic, weak) UIView *livingPreView;

@end

@implementation GHShowTimeViewController

- (UIView *)livingPreView
{
    if (!_livingPreView) {
        UIView *livingPreView = [[UIView alloc] initWithFrame:self.view.bounds];
        livingPreView.backgroundColor = [UIColor clearColor];
        livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:livingPreView atIndex:0];
        _livingPreView = livingPreView;
    }
    return _livingPreView;
}

- (LFLiveSession *)session
{
    if (!_session) {
        _session = [[LFLiveSession alloc]initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2] captureType:LFLiveCaptureMaskVideo];
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    self.beautyBtn.layer.cornerRadius = self.beautyBtn.frame.size.height * 0.5;
    self.beautyBtn.layer.masksToBounds = YES;
    
    self.startLiveBtn.backgroundColor = KeyColor;
    self.startLiveBtn.layer.cornerRadius = self.startLiveBtn.frame.size.height * 0.5;
    self.startLiveBtn.layer.masksToBounds = YES;
    
    self.session.captureDevicePosition = AVCaptureDevicePositionFront;

}
#pragma mark - 智能美颜
- (IBAction)didBeautyBtnClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.session.beautyFace = !sender.selected;

}
#pragma mark - 切换摄像头
- (IBAction)didCaptureBtnClick:(UIButton *)sender {
    
    AVCaptureDevicePosition dePo = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (dePo == AVCaptureDevicePositionFront) ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    
}
#pragma mark - 关闭直播画面
- (IBAction)didCloseBtnClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 直播
- (IBAction)didLiveBtnClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
        
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        stream.url = @"rtmp://video-center.alivecdn.com/gstone/liveIOS?vhost=live.green-stone.cn";
        self.rtmpUrl = stream.url;
        [self.session startLive:stream];
        self.statusLabel.text = [NSString stringWithFormat:@"状态: 直播被开启\nRTMP: %@", self.rtmpUrl];
    }else{
        [self.session stopLive];
        self.statusLabel.text = [NSString stringWithFormat:@"状态: 直播被关闭\nRTMP: %@", self.rtmpUrl];
    }
}

#pragma mark - LFLiveSessionDelegate
- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state
{
    NSString *currentStatus;
    switch (state) {
        case LFLiveReady:
            currentStatus = @"准备中";
            break;
        case LFLivePending:
            currentStatus = @"连接中";
            break;
        case LFLiveStart:
            currentStatus = @"已连接";
            break;
        case LFLiveStop:
            currentStatus = @"已断开";
            break;
        case LFLiveError:
            currentStatus = @"连接出错";
            break;
        default:
            break;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@\nRTMP: %@",currentStatus, self.rtmpUrl];
}

@end
