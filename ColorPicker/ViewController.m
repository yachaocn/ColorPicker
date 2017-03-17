//
//  ViewController.m
//  ColorPicker
//
//  Created by yachaocn on 17/3/16.
//  Copyright © 2017年 yachaocn. All rights reserved.
//

#import "ViewController.h"
#import "SiniCorlorPickerVC.h"

@interface ViewController ()

@property(nonatomic,strong) SiniCorlorPickerVC *colorPickerVC;;

@property (weak, nonatomic) IBOutlet UIView *foregroundColorPreView;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorPreView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.foregroundColorPreView.layer.borderWidth = 1.0f;
    self.backgroundColorPreView.layer.borderWidth = 1.0f;
    self.foregroundColorPreView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColorPreView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}
-(SiniCorlorPickerVC *)colorPickerVC
{
    if (!_colorPickerVC) {
        _colorPickerVC = [[SiniCorlorPickerVC alloc]initWithNibName:@"SiniCorlorPickerVC" bundle:nil];
        _colorPickerVC.modalPresentationStyle = UIModalPresentationPopover;
        _colorPickerVC.preferredContentSize = CGSizeMake(350, 400);
        
    }
    return _colorPickerVC;
}

- (IBAction)popColorPickerVC:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    UIPopoverPresentationController *poperPresentVC = self.colorPickerVC.popoverPresentationController;
    poperPresentVC.sourceView = button.superview;
    poperPresentVC.sourceRect = button.frame;
    poperPresentVC.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    UIBarButtonItem *barbuttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    poperPresentVC.barButtonItem = barbuttonItem;
    
    [self.colorPickerVC pickedColor:^(UIColor *foregroundColor, UIColor *backgroundColor) {
        self.foregroundColorPreView.backgroundColor = foregroundColor;
        self.backgroundColorPreView.backgroundColor = backgroundColor;
    }];
    [self presentViewController:self.colorPickerVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
