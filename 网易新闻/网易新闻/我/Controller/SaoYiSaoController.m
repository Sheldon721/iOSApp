//
//  SaoYiSaoController.m
//  网易新闻
//
//  Created by 李晓东 on 2017/8/24.
//  Copyright © 2017年 LiuChaoZheng. All rights reserved.
//

#import "SaoYiSaoController.h"
#import <AVFoundation/AVFoundation.h>
#import "SaoMaTiaoZhuanController.h"
@interface SaoYiSaoController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong) AVCaptureSession *captureSession;
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation SaoYiSaoController

- (void)viewWillAppear:(BOOL)animated{
    //开始扫码
    [self.captureSession startRunning];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self createSaoMiaoErWeiMa];
    
    UIBarButtonItem *ri = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(xiangCe)];
    [self.navigationItem setRightBarButtonItem:ri];
    //创建扫码框
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-100, kHeight/2-100, 200, 200)];
    imgV.image = [UIImage imageNamed:@"5b2c3a1c9b1488596cc1faf53c35fbd0.png"];
    [self.view addSubview:imgV];
}

- (void)createSaoMiaoErWeiMa{
    //初始化捕捉设备AVCaptureDevice
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if (!input) {
        return;
    }
    //创建输出
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //创建一个会话，并添加输入和输出
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    [self.captureSession addOutput:captureMetadataOutput];
    //设置为二维码类型
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //创建图层，摄像头捕捉到的画面都会在这个图层显示
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    //设置图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 设置图层的frame
    [self.videoPreviewLayer setFrame:self.view.layer.bounds];
    //将图层添加到预览view的图层上
    [self.view.layer addSublayer:self.videoPreviewLayer];
    //创建一个串行队列，并设置代理
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    //设置扫码范围
    captureMetadataOutput.rectOfInterest = CGRectMake((kHeight/2-100)/kHeight,
                                                      kWidth/2/kHeight,
                                                      200/kHeight,
                                                      200/kWidth);
}
#pragma mark - 扫码完成后调用此方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *str;
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            str = [metadataObj stringValue];
        }
        //跳转
        [self pushC:str];
        //结束捕获
        [self.captureSession stopRunning];
    }
    
}
#pragma mark - 打开系统相簿
- (void)xiangCe{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    //设置控制器类型系统相簿
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}
//选取照片/视频或拍照完成完成之后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //退出相簿控制器
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSString *str;
    //取出选中的图片
    UIImage *srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //转换为CIImage
    CIImage *ciIma = [CIImage imageWithCGImage:srcImage.CGImage];
    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *ary = [detector featuresInImage:ciIma];
    //取出探测到的数据
    for (CIQRCodeFeature *fe in ary) {
        str = fe.messageString;
        
    }
    [self pushC:str];
}

#pragma mark - 跳转控制器
- (void)pushC:(NSString *)str{
    //跳转控制器
    self.hidesBottomBarWhenPushed = YES;
    SaoMaTiaoZhuanController *smtz = [[SaoMaTiaoZhuanController alloc]init];
    smtz.url = str;
    //dispatch_sync(dispatch_get_main_queue(), ^{
    [self.navigationController pushViewController:smtz animated:YES];
  //  });
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
