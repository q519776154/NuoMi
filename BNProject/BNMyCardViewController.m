//
//  BNMyCardViewController.m
//  BNProject
//
//  Created by qianfeng on 16/9/23.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNMyCardViewController.h"
#import "UIImage+Context.h"
#import "Masonry.h"
@interface BNMyCardViewController ()

@property (nonatomic,weak) UIImageView *qrImageView;
//检测
@property (nonatomic, strong) CIDetector *detector;

@end

@implementation BNMyCardViewController

- (UIImageView *)qrImageView
{
    if (!_qrImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.bounds = CGRectMake(0, 0, 300, 300);
        imageView.center = self.view.center;
         [self.view addSubview:imageView];
        
        UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(detectorQRCodeFromImage:)];
        [imageView addGestureRecognizer:tapGesture];
        
       
        _qrImageView = imageView;
        
        [self createMyHeadImageView];
    }
    return _qrImageView;
}

#pragma mark - 创建头像
-  (void)createMyHeadImageView
{
    CGFloat width = 60;
    CGFloat height = 60;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.headImage];
    imageView.layer.cornerRadius = 10;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor greenColor].CGColor;
    imageView.layer.borderWidth = 1;
    [_qrImageView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_qrImageView);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [self QRImageWithMessage:@"1234567890" size:self.qrImageView.frame.size];
    
    self.qrImageView.image = image;
    
   
   
    
    
    UIImageView *barCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.qrImageView.frame) + 30, 300, 60)];
    barCodeImageView.image = [self EANImageWithMessage:@"1234567890" size:barCodeImageView.frame.size];
    [self.view addSubview:barCodeImageView];
    
    
    
    
    
}

#pragma mark - 生成条形码
- (UIImage *)EANImageWithMessage:(NSString *)message size:(CGSize)size
{
    //CoreImage
    //创建生成条形码的滤镜类
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    //NSLog(@"%@",[filter inputKeys]);
    
    //设置二维码的内容
    [filter setValue:[message dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    
    //获取条形码图片
    CIImage *ciimage = [filter outputImage];
    
    UIImage *image = [UIImage imageWithCIImage:ciimage];
    
    return [image imageFromContextWithSize:size];

}

- (void)initQRCodeDetector
{
    UIImage *image = self.qrImageView.image;
    if (!image) {
        return;
    }
    _detector = [CIDetector detectorOfType:CIFeatureTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray *features = [_detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count == 0) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"图片中不存在二维码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        return;
    }
    CIQRCodeFeature *qrFeature = features.firstObject;
    NSString *message = qrFeature.messageString;
    [[[UIAlertView alloc] initWithTitle:@"识别到了二维码" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
}


#pragma mark - 检测图中的二维码
- (void)detectorQRCodeFromImage:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self initQRCodeDetector];
    }
}
#pragma mark - 生成二维码图片
- (UIImage *)QRImageWithMessage:(NSString *)message size:(CGSize)size
{
    /**
     *  滤镜
     */
    //创建生成二维码的滤镜类
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //NSLog(@"%@",[filter inputKeys]);
    
    //设置二维码的内容
    [filter setValue:[message dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    
    //获取二维码图片
    CIImage *ciimage = [filter outputImage];
    
    //二维码添加颜色  CIFalseColor伪造颜色的滤镜
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    /*
     inputKey:
     inputImage,
     inputColor0,
     inputColor1
     */
    //设置要添加颜色图片
    [colorFilter setValue:ciimage forKey:@"inputImage"];
    //设置二维码的颜色
    [colorFilter setValue:[CIColor colorWithCGColor:[UIColor redColor].CGColor] forKey:@"inputColor0"];
    //设置背景的颜色
    //[colorFilter setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor1"];
    CIImage *colorImage = [colorFilter outputImage];
    
    UIImage *image = [UIImage imageWithCIImage:colorImage];
    
    return [image imageFromContextWithSize:size];
    
    
}
- (void)test
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.image = [UIImage imageNamed:@"guide_1080_1920_1"];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochorme"];
    [filter setValue:[CIImage imageWithCGImage:imageView.image.CGImage] forKey:@"inputImage"];
    [filter setValue:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor] forKey:@"inputColor"];
    UIImage *image = [UIImage imageWithCIImage:[filter outputImage]];
    imageView.image = image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
