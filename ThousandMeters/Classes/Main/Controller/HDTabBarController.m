//
//  HDTabBarController.m
//  
//
//  Created by 虎动 on 15/10/28.
//
//

#import "HDTabBarController.h"
#import "HDHomeViewController.h"
#import "HDHotStyleViewController.h"
#import "HDShoppingCartViewController.h"
#import "HDPersonalCenterViewController.h"
#import "HDNavigationController.h"


@interface HDTabBarController ()

@end

@implementation HDTabBarController

+ (void)initialize{
    UITabBarItem *item = [UITabBarItem appearance];
    
    // 设置普通状态
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    [item setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    
    // 设置被选中状态
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    [item setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HDHomeViewController *home = [[HDHomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    HDHotStyleViewController *HotStyle = [[HDHotStyleViewController alloc] init];
    [self addChildVc:HotStyle title:@"爆款" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    HDShoppingCartViewController *ShoppingCart = [[HDShoppingCartViewController alloc] init];
    [self addChildVc:ShoppingCart title:@"购物车" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    HDPersonalCenterViewController *PersonalCenter = [[HDPersonalCenterViewController alloc] init];
    [self addChildVc:PersonalCenter title:@"个人中心" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    //[[UITabBar appearance] setShadowImage:[UIImage new]];
    //[[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    //[[UITabBar appearance] setTranslucent:NO]; // 半透明
    //[self.tabBar setBarTintColor:HDColor(226, 71, 85)];
    //[[UITabBar appearance] setBackgroundColor:HDColor(226, 71, 85)];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器
    childVc.title = title; // 同时设置tabBar和NavigationBar的文字
    
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    
    // 声明：这张图片按照原始的样子显示出来，不要自动渲染成其他颜色（比如默认的蓝色）
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSDictionary *textAttr = @{NSForegroundColorAttributeName:HDColor(123,123,123)};
    NSDictionary *seltextAttr = @{NSForegroundColorAttributeName:[UIColor orangeColor]};
    [childVc.tabBarItem setTitleTextAttributes:textAttr forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:seltextAttr forState:UIControlStateSelected];
    //childVc.view.backgroundColor = HDRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    HDNavigationController *nav = [[HDNavigationController alloc] initWithRootViewController:childVc];
    // 设置为子控制器
    [self addChildViewController:nav];
}

@end
