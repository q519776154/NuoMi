//
//  BNQRCodeViewController.m
//  BNProject
//
//  Created by qianfeng on 16/9/23.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"

//扫描框的宽和高
#define kBorderImageViewWidthHeight 200
//扫描框的y坐标
#define kBorderImageViewYOffset 100
//扫描框距离线的距离
#define kBorderAndLineSpace 20
@interface BNQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UIImageView *_animationImageView;
    UIImageView *_borderImageView;
    //y的偏移
    CGFloat yOffset;
    BOOL _isUp;
}
//负责输出和输入设备交互
@property (nonatomic,strong) AVCaptureSession *Session;

@property (nonatomic,strong) NSTimer *animationTimer;

@end

@implementation BNQRCodeViewController

- (AVCaptureSession *)Session
{
    if (!_Session) {
        _Session = [[AVCaptureSession alloc] init];
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
       
        CGFloat screenWidth = self.view.frame.size.width;
        CGFloat screenHeight = self.view.frame.size.height;
        
        output.rectOfInterest = CGRectMake(
                                           (kBorderImageViewYOffset + kBorderAndLineSpace)/screenHeight,
                                           (self.view.center.x - kBorderImageViewYOffset + kBorderAndLineSpace)/screenWidth,
                                           (kBorderImageViewWidthHeight - 2*kBorderAndLineSpace)/screenHeight,
                                           (kBorderImageViewWidthHeight - 2*kBorderAndLineSpace)/screenWidth);
        if ([_Session canAddInput:input]) {
            [_Session addInput:input];
        }
        if ([_Session canAddOutput:output]) {
            [_Session addOutput:output];
        }
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        

    }
    return _Session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.Session];
    [self.view.layer addSublayer:previewLayer];
    //创建定时器
    [self createTimer];
    //扫描动画图片
    [self createScanAnimationImageView];
     //侦听app从后台进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterActiveStatus) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createTimer];
    [self startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.Session stopRunning];
    [_animationTimer invalidate];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

}

- (void)appWillEnterActiveStatus
{
    [self startRunning];
}

- (void)createTimer
{
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    [_animationTimer setFireDate:[NSDate distantFuture]];
     
}

- (void)stopRunning
{
    [self.Session stopRunning];
    
    [_animationTimer setFireDate:[NSDate distantFuture]];
}

- (void)startRunning
{
    [self.Session startRunning];
    [_animationTimer setFireDate:[NSDate distantPast]];
}

- (void)startAnimation
{
    if (yOffset >= 160) {
        _isUp = YES;
    }
    if (yOffset <= 0)
    {
        _isUp = NO;
    }
    if (_isUp) {
        yOffset--;
    }else
    {
        yOffset++;
    }
    [_animationImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_borderImageView).offset(kBorderAndLineSpace + yOffset);
    }];
    
}

- (void)createScanAnimationImageView
{
    UIImageView *borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smk"]];
    [self.view addSubview:borderImageView];
    _borderImageView = borderImageView;
    
    [borderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(kBorderImageViewYOffset);
        make.centerX.equalTo(self.view);
        make.width.and.height.equalTo(@(kBorderImageViewWidthHeight));
    }];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr_scan_line"]];
    [borderImageView addSubview:lineImageView];
    
    _animationImageView = lineImageView;
    
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(borderImageView).offset(kBorderAndLineSpace);
        make.left.equalTo(borderImageView).offset(kBorderAndLineSpace);
        make.width.equalTo(borderImageView).offset(-2*kBorderAndLineSpace);
        make.height.equalTo(@2);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count == 0) {
        return;
    }
    [self stopRunning];
    
    AVMetadataMachineReadableCodeObject *object = metadataObjects.firstObject;
    NSString *value = object.stringValue;
    
    if ([value hasPrefix:@"https://"]||[value hasPrefix:@"http://"]) {
        NSString *urlString = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [[UIApplication sharedApplication] openURL:url];
    }
    //打开qq
    else if([value hasPrefix:@"mqq://"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:value]];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"扫描成功" message:value delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //开始扫描
    [self startRunning];
}

@end
