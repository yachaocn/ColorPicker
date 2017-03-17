//
//  SiniCorlorPickerVC.h
//  CustomePDFViewController
//
//  Created by yachaocn on 17/3/10.
//  Copyright © 2017年 yachaocn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiniCorlorPickerVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;

@property (weak, nonatomic) IBOutlet UIButton *foregroundButton;

@property (weak, nonatomic) IBOutlet UIImageView *colorImageView;

@property (weak, nonatomic) IBOutlet UIView *colorReviewView;

@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (weak, nonatomic) IBOutlet UIImageView *brightnessSliderBackView;

//选中的颜色（没有修改明度）
@property(nonatomic,strong) UIColor *foregroundColor;

@property(nonatomic,strong) UIColor *backGroundColor;

/**
 前景色拾色器的位置
 */
@property(nonatomic) CGPoint foregroundCenter;

/**
 前景色明度值 0..255
 */
@property(nonatomic) CGFloat foregroundSliderValue;

/**
 背景色拾色器的位置
 */
@property(nonatomic) CGPoint backgroundCenter;

/**
 背景色明度值 0..255
 */
@property(nonatomic) CGFloat backgroundSliderValue;

/**
 选取颜色回调
 此处颜色为修改明度后的回调
 @param complite block
 */
-(void) pickedColor:(void(^)(UIColor *foregroundColor,UIColor *backgroundColor))complite;

@end
