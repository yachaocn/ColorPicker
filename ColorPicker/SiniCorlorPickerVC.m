//
//  SiniCorlorPickerVC.m
//  CustomePDFViewController
//
//  Created by yachaocn on 17/3/10.
//  Copyright © 2017年 yachaocn. All rights reserved.
//

#import "SiniCorlorPickerVC.h"


@interface SiniCorlorPickerVC ()

@property(nonatomic,strong) void (^pickedColor)(UIColor * foregroundColor,UIColor *backgroundColor);

@property(nonatomic,strong) UIImageView *colorPickerPoint;

@end

@implementation SiniCorlorPickerVC

//范围
static inline void CheckRGB(int *Value)
{
    if (*Value < 0) *Value = 0;
    else if (*Value > 255) *Value = 255;
}
//赋值
static inline void AssignRGB(int *R, int *G, int *B, int intR, int intG, int intB)
{
    *R = intR;
    *G = intG;
    *B = intB;
}

//设置明亮
static void SetBright(int *R, int *G, int *B, int bValue)
{
    int intR = *R;
    int intG = *G;
    int intB = *B;
    if (bValue > 0)
    {
        intR = intR + (255 - intR) * bValue / 255;
        intG = intG + (255 - intG) * bValue / 255;
        intB = intB + (255 - intB) * bValue / 255;
    }
    else if (bValue < 0)
    {
        intR = intR + intR * bValue / 255;
        intG = intG + intG * bValue / 255;
        intB = intB + intB * bValue / 255;
    }
    CheckRGB(&intR);
    CheckRGB(&intG);
    CheckRGB(&intB);
    AssignRGB(R, G, B, intR, intG, intB);
}

#pragma mark get method

-(UIColor *)foregroundColor
{
    if (!_foregroundColor) {
        _foregroundColor = [UIColor blackColor];
    }
    return _foregroundColor;
}

-(UIColor *)backGroundColor
{
    if (!_backGroundColor) {
        _backGroundColor = [UIColor whiteColor];
    }
    return _backGroundColor;
}
-(UIImageView *)colorPickerPoint
{
    if (!_colorPickerPoint) {
        _colorPickerPoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _colorPickerPoint.image = [UIImage imageNamed:@"colorPickerPoint"];
    }
    return _colorPickerPoint;
}
#pragma mark - set method

- (void)pickedColor:(void(^)(UIColor *foregroundColor,UIColor *backgroundColor))complite;
{
    self.pickedColor = complite;
}
-(void)setForegroundCenter:(CGPoint)foregroundCenter
{
    _foregroundCenter = foregroundCenter;
    self.colorPickerPoint.center = _foregroundCenter;
}
-(void)setBackgroundCenter:(CGPoint)backgroundCenter
{
    _backgroundCenter = backgroundCenter;
    self.colorPickerPoint.center = _backgroundCenter;
}


#pragma mark - view init


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.colorImageView.layer.cornerRadius = self.colorImageView.bounds.size.width/2 ;
    self.colorImageView.layer.masksToBounds = YES;
    self.colorReviewView.layer.cornerRadius = self.colorReviewView.bounds.size.width/2;
    self.colorReviewView.layer.masksToBounds = YES;
    self.colorReviewView.layer.borderColor = [UIColor redColor].CGColor;
    self.colorReviewView.layer.borderWidth = 1.0f;
    
    self.brightnessSliderBackView.layer.cornerRadius = 5.0f;
    [self.brightnessSlider setMinimumTrackTintColor:[UIColor clearColor]];
    [self.brightnessSlider setMaximumTrackTintColor:[UIColor clearColor]];
    
    if (!_colorPickerPoint.superview) [self.colorImageView addSubview:self.colorPickerPoint];
    
    
    //默认选中背景色
    if (!self.foregroundButton.selected && !self.backgroundButton.selected)
        self.backgroundButton.selected = YES;
    
    //禁止slider事件连续
    self.brightnessSlider.continuous = YES;
    
    if (self.foregroundButton.selected) {
        self.colorReviewView.backgroundColor = self.foregroundColor;
        //设置slider的值
        self.brightnessSlider.value = self.foregroundSliderValue;
        //改变slider的颜色
        [self changeSliderViewStyleWithColor:self.foregroundColor];
        //隐藏颜色指示器
        if (CGPointEqualToPoint(self.foregroundCenter, CGPointZero))
            self.colorPickerPoint.hidden = YES;
        else
            self.colorPickerPoint.hidden = NO;
        
    }else{
        self.colorReviewView.backgroundColor = self.backGroundColor;
         //设置slider的值
        self.brightnessSlider.value = self.backgroundSliderValue;
        //改变slider的颜色
        [self changeSliderViewStyleWithColor:self.backGroundColor];
        if (CGPointEqualToPoint(self.backgroundCenter, CGPointZero))
            self.colorPickerPoint.hidden = YES;
        else
            self.colorPickerPoint.hidden = NO;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:250.0f/255 green:245.0f/255 blue:237.0f/255 alpha:1];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

#pragma mark - target event 

- (IBAction)tabButtonClicked:(id)sender {
    UIButton *tabButton = (UIButton *)sender;
    self.foregroundButton.selected = NO;
    self.backgroundButton.selected = NO;
    tabButton.selected = YES;
    
    if (self.foregroundButton.selected) {
        self.brightnessSlider.value = self.foregroundSliderValue;
        if (CGPointEqualToPoint(self.foregroundCenter, CGPointZero)) {
            self.colorReviewView.backgroundColor = self.foregroundColor;
            self.colorPickerPoint.hidden = YES;
        }else{
            UIColor *color = [self pickedColorWithPoint:self.foregroundCenter];
            self.colorReviewView.backgroundColor = color;
            [UIView animateWithDuration:0.3 animations:^{
                self.colorPickerPoint.center = self.foregroundCenter;
            }];
        }
        //修改slider的颜色
        [self changeSliderViewStyleWithColor:self.foregroundColor];
    }else if (self.backgroundButton.selected){
        self.brightnessSlider.value = self.backgroundSliderValue;
        if (CGPointEqualToPoint(self.backgroundCenter, CGPointZero)) {
            self.colorReviewView.backgroundColor = self.backGroundColor;
            self.colorPickerPoint.hidden = YES;
        }else{
            UIColor *color = [self pickedColorWithPoint:self.backgroundCenter];
            self.colorReviewView.backgroundColor = color;
            [UIView animateWithDuration:0.3 animations:^{
                self.colorPickerPoint.center = self.backgroundCenter;
            }];
        }
        //修改slider的颜色
        [self changeSliderViewStyleWithColor:self.backGroundColor];
        
    }
    
}

- (IBAction)brightnessSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    CGPoint point = CGPointZero;
    UIColor *color;
    if (self.foregroundButton.selected)
    {
        point = self.foregroundCenter;
        self.foregroundSliderValue = value;
        color = self.foregroundColor;
    }else{
        point = self.backgroundCenter;
        self.backgroundSliderValue = value;
        color = self.backGroundColor;
    }
    
//    if (![self checkPoint:point inCircleWithRadius:self.colorImageView.bounds.size.width/2]) return;
//    UIColor *color = [self pickedColorWithPoint:point];
    if (!color) return;
    
    //改变颜色
    [self colorChanged:color];
   
}




#pragma mark - view touches

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.colorImageView];
   UIColor *color = [self pickedColorWithPoint:point];
    if (!color) return;
    //改变颜色
    [self colorChanged:color];
    //填充预览颜色
    [self setColorReviewWithColor:color];
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.colorImageView];
    UIColor *color = [self pickedColorWithPoint:point];
    if (!color) return;
    //改变颜色 调用block
    [self colorChanged:color];
    //填充预览颜色
    [self setColorReviewWithColor:color];
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.colorImageView];
    UIColor *color = [self pickedColorWithPoint:point];
    if (!color) return;
    //改变颜色 调用block
    [self colorChanged:color];
    //填充预览颜色
    [self setColorReviewWithColor:color];
    
}

/**
 调用颜色改变时的block块，并且调节亮度

 @param color 改变的颜色值
 */
-(void)colorChanged:(UIColor *)color
{
    //改变slider的颜色
    [self changeSliderViewStyleWithColor:color];
     //存储当前选中颜色 原色
    if (self.foregroundButton.selected){
        self.foregroundColor = color;
    }else{
        self.backGroundColor = color;
    }
    //明度处理
    CGFloat foreBrightnessValue = self.foregroundSliderValue;
    CGFloat backBrightnessValue = self.backgroundSliderValue;
    UIColor *finalyForegroundColor = [self changeColor:self.foregroundColor withBrightNessValue:-(int)foreBrightnessValue];
    UIColor *finalyBackgroundColor = [self changeColor:self.backGroundColor withBrightNessValue:-(int)backBrightnessValue];
    
    self.pickedColor(finalyForegroundColor,finalyBackgroundColor);
    
}

/**
 修改颜色的明亮度

 @param color 原始颜色
 @param brightness 明亮度 -255..255
 @return 修改后的color
 */
-(UIColor *)changeColor:(UIColor *)color withBrightNessValue:(int)brightness
{
    CGFloat R = 0, G =0,B=0,A= 0;
    BOOL result = [color getRed:&R green:&G blue:&B alpha:&A];
    
    int R255 = 0,G255 = 0,B255 = 0;
    if (result) {
        
        R255 = (int)(255*R);
        G255 = (int)(255*G);
        B255 = (int)(255*B);
        SetBright(&R255, &G255, &B255, brightness);
    }
    return [UIColor colorWithRed:R255/255.0f green:G255/255.0f blue:B255/255.0f alpha:1];
    
}

/**
 修改slider的颜色

 @param color 颜色
 */
-(void)changeSliderViewStyleWithColor:(UIColor *)color
{
    //创建渐变图片
    UIImage *GradientImage = [self createGradientImageWithSize:CGSizeMake(self.brightnessSlider.bounds.size.width, 10) startColor:color endColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] cornerRadius:5.0f];
    
    UIImage *clearImage = [self createImageWithSize:CGSizeMake(self.brightnessSlider.bounds.size.width, 10) Color:[UIColor clearColor] cornerRadius:10.0f];
    
    [self.brightnessSlider setMaximumTrackImage:GradientImage forState:UIControlStateNormal];
    [self.brightnessSlider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
    self.brightnessSliderBackView.image = GradientImage;
}

/**
 颜色拾取

 @param point point
 */
-(UIColor *)pickedColorWithPoint:(CGPoint)point
{
    UIColor *color = nil;
    if ([self checkPoint:point inCircleWithRadius:self.colorImageView.bounds.size.width/2]) {
        color = [self getColorOfPoint:point InView:self.colorImageView];
        //移动指示器
        if (self.colorPickerPoint.hidden) {
            self.colorPickerPoint.hidden = NO;
            self.colorPickerPoint.center = point;
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.colorPickerPoint.center = point;
            }];
        }
        //存储当前选中的位置
        if (self.foregroundButton.selected) {
            self.foregroundCenter = point;
        }else{
            self.backgroundCenter = point;
        }
        
    }
    
    return color;
    
}

/**
 填充预览颜色

 @param color color
 */
-(void)setColorReviewWithColor:(UIColor *)color
{
    self.colorReviewView.backgroundColor = color;
}

#pragma mark - tools

- (UIColor *) getColorOfPoint:(CGPoint)point InView:(UIView*)view
{
    
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [view.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    NSString *hexColor = [NSString stringWithFormat:@"#%02x%02x%02x",pixel[0],pixel[1],pixel[2]];
    
    UIColor *color = [self getColorInformationWith:hexColor];
    
    return color;
}


- (UIColor *)getColorInformationWith:(NSString*)hexColor
{
    //转换hex值
    unsigned int red ,green,blue;
    
    NSScanner *scanner = [NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(1, 2)]];
    [scanner scanHexInt:&red];
    
    scanner = [NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(3, 2)]];
    [scanner scanHexInt:&green];
    
    scanner = [NSScanner scannerWithString:[hexColor substringWithRange:NSMakeRange(5, 2)]];
    [scanner scanHexInt:&blue];
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

/**
 根据响应的颜色，创建渐变图片

 @param startColor 颜色
 @return 返回值 image
 */
- (UIImage *)createGradientImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor cornerRadius:(CGFloat)radius
{
    CGFloat height = size.height;
    CGFloat with = size.width;
    
    CGFloat startR = 0,startG = 0, startB = 0, startA = 0;
    BOOL startResult = [startColor getRed:&startR green:&startG blue:&startB alpha:&startA];
    if (!startResult) return nil;
    
    CGFloat endR = 0 , endG = 0, endB = 0, endA = 0;
    BOOL endResult = [endColor getRed:&endR green:&endG blue:&endB alpha:&endA];
    if (!endResult) return nil;
    //创建透明｜2倍图像(清晰，针对视网膜屏幕)上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(with, height), NO, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置圆角
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, with, height) cornerRadius:radius] addClip];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    const CGFloat components[] = {
                                startR, startG, startB, startA,
                                endR, endG, endB, endA,
                                };
    
    const CGFloat locations[] = {0,1};
    CGGradientRef gradientRf = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGPoint startPoint = CGPointMake(0, height/2);
    CGPoint endPoint = CGPointMake(with, height/2);
    CGContextDrawLinearGradient(context, gradientRf, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return image;
}

/**
 创建图片

 @param size 大小
 @param color 颜色
 @param radius 圆角度
 @return image
 */
- (UIImage *)createImageWithSize:(CGSize)size Color:(UIColor *)color cornerRadius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    [bezierPath addClip];
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(context);
    return image;
}

//===============================================

-(UIColor *)pickerColorInImage:(UIImage *)image withPoint:(CGPoint)point
{
    UIColor *color = nil;
    CGImageRef cgImage = image.CGImage;
    size_t with = CGImageGetWidth(cgImage);
//    size_t height = CGImageGetHeight(cgImage);
    NSUInteger x = (NSUInteger)floor(point.x)*image.scale;
    NSUInteger y = (NSUInteger)floor(point.y)*image.scale;
    
    if ([self checkPoint:point inCircleWithRadius:self.colorImageView.bounds.size.width/2]) {
        CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
        CFDataRef bitemapData = CGDataProviderCopyData(dataProvider);
        const UInt8 *data = CFDataGetBytePtr(bitemapData);
        size_t offset = (with*y + x)*4;
        UInt8 red   = data[offset];
        UInt8 green = data[offset + 1];
        uint blue   = data[offset + 2];
        uint alpha  = data[offset + 3];
        CFRelease(bitemapData);
        color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    }
    
    return color;
}

/**
 判断是否点击的是圆内

 @param point image view 上的点
 @param radius 圆的半径
 @return bool
 */
- (BOOL)checkPoint:(CGPoint)point inCircleWithRadius:(CGFloat)radius
{
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    if ((pow((x-radius), 2) + pow((y - radius), 2)) <= pow(radius, 2)) {
        return YES;
    }else{
        return NO;
    }
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
