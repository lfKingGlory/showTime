//
//  MSUserGuideView.m
//  mvvm+rac
//
//  Created by msj on 2017/3/13.
//  Copyright © 2017年 msj. All rights reserved.
//

#import "MSUserGuideView.h"

@implementation MSUserGuideView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.contentSize = CGSizeMake(size.width * 4, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width * 4, size.height)];
    imageView.userInteractionEnabled = YES;
    if (size.height > 480) {
        imageView.image = [UIImage imageNamed:@"big_user_guide_6"];
    }else{
        imageView.image = [UIImage imageNamed:@"big_user_guide_4"];
    }
    [scrollView addSubview:imageView];
    
    
    UIButton *btnEnter = [[UIButton alloc] init];
    if (size.height>=736) {
        btnEnter.frame = CGRectMake((4-1)*size.width + (size.width-160)/2.0, size.height-100, 160, 44);
    }else if (size.height>=667){
        btnEnter.frame = CGRectMake((4-1)*size.width + (size.width-160)/2.0, size.height-100, 160, 44);
    }else if (size.height>=568){
        btnEnter.frame = CGRectMake((4-1)*size.width + (size.width-160)/2.0, size.height-80, 160, 44);
    }else{
        btnEnter.frame = CGRectMake((4-1)*size.width + (size.width-160)/2.0, 415-25, 160, 44);
    }
    [btnEnter setImage:[UIImage imageNamed:@"go_bbm_n"] forState:UIControlStateNormal];
    [btnEnter setImage:[UIImage imageNamed:@"go_bbm_hl"] forState:UIControlStateHighlighted];
    [btnEnter addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnEnter];
    
}

- (void)btnAction {
    //保存最新版本的版本号，杀死app再次进入时，就不会出现引导页面了
    [[NSUserDefaults standardUserDefaults] setObject:@"ms_user_guide" forKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [self dismiss];
}

- (void)show {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.hidden = YES;
    //UIWindow 要有个rootViewController才行，这里创建一个隐藏的UIViewController
    self.rootViewController = vc;
    //让UIWindow级别处于最高
    self.windowLevel = UIWindowLevelAlert + 1;
    //让window显示
    self.hidden = NO;
}

- (void)dismiss {
    self.rootViewController = nil;
    self.hidden = YES;
}
@end
