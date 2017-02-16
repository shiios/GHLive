//
//  GHShowTimeViewController.m
//  GHLive
//
//  Created by kalian on 2017/2/14.
//  Copyright © 2017年 kalian. All rights reserved.
//

#import "GHShowTimeViewController.h"
#import <LFLiveKit.h>
#import <BarrageRenderer.h>
#import "NSSafeObject.h"

@interface GHShowTimeViewController ()<LFLiveSessionDelegate>

@property (strong, nonatomic) IBOutlet UIButton *beautyBtn;
@property (strong, nonatomic) IBOutlet UIButton *captureBtn;

@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *startLiveBtn;
@property (strong, nonatomic) IBOutlet UIButton *barrage;

@property (nonatomic,strong) LFLiveSession *session;
/** RTMP地址 */
@property (nonatomic, copy) NSString *rtmpUrl;
@property (nonatomic, weak) UIView *livingPreView;
///粒子动画
@property (nonatomic,strong) CAEmitterLayer *emitterlayer;
///弹幕
@property (nonatomic,strong) BarrageRenderer *renderer;
@property (nonatomic,strong) NSTimer *timer;

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

#pragma mark - 粒子动画
- (CAEmitterLayer *)emitterlayer
{
    if (!_emitterlayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        ///🌰发射器在xy平面的中心位置
        emitterLayer .emitterPosition = CGPointMake(self.livingPreView.frame.size.width - 50, self.livingPreView.frame.size.height - 50);
        ///发射器尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        ///渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        NSMutableArray *array = [NSMutableArray array];
        ///创建粒子
        for (int i = 0; i < 10; i++) {
            
            ///发射单元
            CAEmitterCell *shopCell = [CAEmitterCell emitterCell];
            ///粒子的创建速率
            shopCell.birthRate = 1.0;
            ///粒子存活时间
            shopCell.lifetime = arc4random_uniform(4) + 1;
            ///粒子生存时间容差
            shopCell.lifetimeRange = 1.5;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30",i]];
            ///粒子内容
            shopCell.contents = (id)[image CGImage];
            ///粒子的运动速度
            shopCell.velocity = arc4random_uniform(100) + 100;
            ///粒子的速度容差
            shopCell.velocityRange = 80;
            ///粒子在xy平面的发射角度
            shopCell.emissionLongitude = M_PI + M_PI_2;
            ///粒子发射角度的容差
            shopCell.emissionRange = M_PI_2 / 6;
            ///缩放比例
            shopCell.scale = 0.3;
            [array addObject:shopCell];
        }
        emitterLayer.emitterCells = array;
        [self.view.layer insertSublayer:emitterLayer above:self.livingPreView.layer];
        _emitterlayer = emitterLayer;
    }
    return _emitterlayer;
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
    
    
    ///设置弹幕
    [self barrageShow];
}

- (void)barrageShow
{
    _renderer = [[BarrageRenderer alloc]init];
    _renderer.canvasMargin = UIEdgeInsetsMake(GHScreenHeight * 0.3, 10, 10, 10);
    [self.view addSubview:_renderer.view];
    
    NSSafeObject *safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    

}

#pragma mark - 自动发动弹幕
- (void)autoSendBarrage
{
    NSInteger spriteNumber = [self.renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) {
        [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}
#pragma mark - 弹幕描述符生产方法
long _index = 0;
///BarrageDescriptor: 弹幕描述符
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor *descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [self danMuText][arc4random_uniform((uint32_t)[self danMuText].count)];
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * random()/RAND_MAX + 50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
    
        [self showHint:@"弹幕被点击啦..."];
        
    };
    return descriptor;
}


- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GHDanMu.plist" ofType:nil]];
}

- (void)setup
{
    self.beautyBtn.layer.cornerRadius = self.beautyBtn.frame.size.height * 0.5;
    self.beautyBtn.layer.masksToBounds = YES;
    
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
    
    [self.renderer stop];
    [self.renderer.view removeFromSuperview];
    self.renderer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 直播
- (IBAction)didLiveBtnClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
        // 开始来访动画
        [self.emitterlayer setHidden:NO];
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        stream.url = @"rtmp://video-center.alivecdn.com/gstone/liveIOS?vhost=live.green-stone.cn";
        self.rtmpUrl = stream.url;
        [self.session startLive:stream];
        self.statusLabel.text = [NSString stringWithFormat:@"状态: 直播被开启\nRTMP: %@", self.rtmpUrl];
    }else{
        // 结束来访动画
        [self.emitterlayer setHidden:YES];
        [self.session stopLive];
        self.statusLabel.text = [NSString stringWithFormat:@"状态: 直播被关闭\nRTMP: %@", self.rtmpUrl];
    }
}

#pragma mark - 弹幕开关

- (IBAction)barrageBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    sender.selected ? [self.renderer start] : [self.renderer stop];

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
