//
//  MSCardViewController.m
//  showTime
//
//  Created by msj on 16/10/31.
//  Copyright © 2016年 msj. All rights reserved.
//

#import "MSCardViewController.h"
#import "UIView+FrameUtil.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionUp,
    UIPanGestureRecognizerDirectionDown,
    UIPanGestureRecognizerDirectionLeft,
    UIPanGestureRecognizerDirectionRight
};

@interface MSCardViewController ()
@property (strong, nonatomic) UIImageView *imageView1;
@property (strong, nonatomic) UIImageView *imageView2;
@property (strong, nonatomic) UIImageView *imageView3;
@property (strong, nonatomic) UIPanGestureRecognizer *panges;

@end

@implementation MSCardViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(15, 40, 22, 22)];
    [back setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    self.fd_interactivePopDisabled = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:233.0/256.0 green:111.0/256.0 blue:132.0/256.0 alpha:1];
    
    self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 100, self.view.width - 50, self.view.height - 200)];
    self.imageView1.backgroundColor = [UIColor blackColor];
    
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 100, self.view.width - 50, self.view.height - 200)];
    self.imageView2.backgroundColor = [UIColor yellowColor];
    
    self.imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 100, self.view.width - 50, self.view.height - 200)];
    self.imageView3.backgroundColor = [UIColor colorWithRed:151.0/256.0 green:244.0/256.0 blue:169.0/256.0 alpha:1];
    
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    [self.view addSubview:self.imageView3];
    
    self.imageView1.layer.zPosition = 0;
    
    self.imageView2.layer.zPosition = 100;
    
    self.imageView3.layer.zPosition = 200;
    
    NSArray *arr = @[_imageView3,_imageView2,_imageView1];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -2.5/2000;
    
    for (int i = 0; i < arr.count; i++) {
        UIImageView *img = arr[i];
        img.layer.transform = perspective;
        img.layer.transform = CATransform3DTranslate(img.layer.transform, 0, i*-5, 0);
        img.layer.transform = CATransform3DScale(img.layer.transform, 1-0.1*i, 1, 1);
        img.layer.transform = CATransform3DRotate(img.layer.transform, -5*M_PI/180, 1, 0, 0);
        img.layer.opacity = 1-0.1*i;
        img.layer.cornerRadius = 5;
        img.layer.masksToBounds = YES;
    }
    self.panges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:self.panges];

}

- (void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)pan:(UIPanGestureRecognizer *)sender
{
    static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;
    
    switch (sender.state) {
            
        case UIGestureRecognizerStateBegan: {
            
            if (direction == UIPanGestureRecognizerDirectionUndefined) {
                
                CGPoint velocity = [sender velocityInView:sender.view];
                
                BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
                
                if (isVerticalGesture) {
                    if (velocity.y > 0) {
                        direction = UIPanGestureRecognizerDirectionDown;
                    } else {
                        direction = UIPanGestureRecognizerDirectionUp;
                    }
                }
                
                else {
                    if (velocity.x > 0) {
                        direction = UIPanGestureRecognizerDirectionRight;
                    } else {
                        direction = UIPanGestureRecognizerDirectionLeft;
                    }
                }
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    NSLog(@"UIPanGestureRecognizerDirectionUp");
                    //                    [self handleUpwardsGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    //                    [self handleDownwardsGesture:sender];
                    NSLog(@"UIPanGestureRecognizerDirectionDown");
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                    NSLog(@"UIPanGestureRecognizerDirectionLeft");
                    //                    [self handleLeftGesture:sender];
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    NSLog(@"UIPanGestureRecognizerDirectionRight");
                    //                    [self handleRightGesture:sender];
                    break;
                }
                default: {
                    break;
                }
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            direction = UIPanGestureRecognizerDirectionUndefined;
            break;
        }
            
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
