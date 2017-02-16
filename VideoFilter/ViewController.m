//
//  ViewController.m
//  myGPUImageVideoCamera
//
//  Created by 沐沐 on 17/2/15.
//  Copyright © 2017年 yushi. All rights reserved.
//

#import "ViewController.h"
#import <GPUImageView.h>
#import <GPUImageVideoCamera.h>
#import <GPUImageSepiaFilter.h>

@interface ViewController ()
@property (nonatomic , strong) GPUImageView *myGPUImageView;
@property (nonatomic , strong) GPUImageVideoCamera *myGPUVideoCamera;
@property (nonatomic , strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) UISlider *levelSliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myGPUVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.myGPUVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.myGPUVideoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    self.filter = [[GPUImageSepiaFilter alloc] init];
    [self.myGPUVideoCamera addTarget:self.filter];
    self.myGPUImageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.myGPUImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:self.myGPUImageView];
    [self.filter addTarget:self.myGPUImageView];
    
    self.levelSliderView = ({
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, (self.view.frame.size.height - 100), 150, 20)];
        slider.minimumValue = 0.0;// 设置最小值
        slider.maximumValue = 1.0;// 设置最大值
        slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
        slider.continuous = YES;// 设置可连续变化
        [slider addTarget:self action:@selector(levelSliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        [self.view addSubview:slider];
        slider;
    });

    
    [self.myGPUVideoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)levelSliderValueChanged:(id)sender{
    UISlider *slider = (UISlider *)sender;
    [(GPUImageSepiaFilter *)(self.filter) setIntensity:[(UISlider *)sender value]];
    NSLog(@"beautyLevel = %f",slider.value);
}

@end
