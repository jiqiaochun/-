//
//  HDNavigationController.m
//  
//
//  Created by 虎动 on 15/10/28.
//
//

#import "HDNavigationController.h"

@interface HDNavigationController ()

@end

@implementation HDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+(void)initialize{
    // 设置整个项目所用item的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置普通状态
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    
    // 设置不可用状态
    NSDictionary *disAttr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    [item setTitleTextAttributes:disAttr forState:UIControlStateDisabled];
}

// 重写这个方法的目的：能够拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 第一次进来的时候，数组self.viewControllers的长度为0，当再次进来的时候，数组长度为1，push进来的为子控制器，然后隐藏地步的tabbar
    if (self.viewControllers.count > 0) {
        // 自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置导航栏上面的内容
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) imageNormal:@"navigationbar_back" imageHlight:@"navigationbar_back_highlighted"];
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(forward) imageNormal:@"navigationbar_more" imageHlight:@"navigationbar_more_highlighted"];
    }
    
    [super pushViewController:viewController animated:YES];
    
}

- (void)back{
    // 此处self本身就是导航控制器 所以不需要self.navigationController
    [self popViewControllerAnimated:YES];
}
- (void)forward
{
    [self popToRootViewControllerAnimated:YES];
}

@end
