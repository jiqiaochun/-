//
//  HDHomeViewController.m
//  ThousandMeters
//
//  Created by 虎动 on 15/10/28.
//  Copyright © 2015年 虎动. All rights reserved.
//

#import "HDHomeViewController.h"
#import "HotQueueModel.h"
#import "HomeMenuCell.h"
#import "UIImageBannerScrollView.h"


@interface HDHomeViewController () <UITableViewDelegate,UITableViewDataSource,BannerScrollViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_menuArray;//圆形按钮
    HotQueueModel *_hotQueueData;
}
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) HDSearchBar *searchBar;

@property (nonatomic, strong) NSArray               *imageViewArray;
@property (nonatomic, strong) UIImageBannerScrollView     *scrolLoopView;

@end

@implementation HDHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    navView.backgroundColor = [UIColor grayColor];
    [self.view addSubview: navView];
    self.navView = navView;
    
    //学校
    HDButton *schoolBtn = [HDButton buttonWithType:UIButtonTypeCustom];
    schoolBtn.frame = CGRectMake(10, 27, 60, 30);
    //schoolBtn.backgroundColor = [UIColor redColor];
    schoolBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [schoolBtn setTitle:@"清华" forState:UIControlStateNormal];
    [schoolBtn setImage:[UIImage imageNamed:@"icon_homepage_downArrow"] forState:UIControlStateNormal];
    [self.navView addSubview:schoolBtn];
    
    // 创建搜索框对象
    HDSearchBar *searchBar = [HDSearchBar searchBar];
    searchBar.frame = CGRectMake(70, 27, kWidth-90, 30);
    //    searchBar.backgroundColor = [UIColor redColor];
    [self.navView addSubview:searchBar];
    self.searchBar = searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
    [self initTableView];
    
    [self initScrollViewRoll];

    self.searchBar.delegate = self;
}

// 图片轮播器
- (void)initScrollViewRoll{
    if (!_scrolLoopView) {
        _scrolLoopView = [[UIImageBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 180) images:self.imageViewArray];
        _scrolLoopView.bannerScrollTimer = 4.f;
        _scrolLoopView.bannerAutoScroll = YES;
        _scrolLoopView.scrollDelegate = self;
        _scrolLoopView.isNeedTopGrayShadow = YES;
        [_scrolLoopView startScrolling];
    }
    self.tableView.tableHeaderView = self.scrolLoopView;
}

- (NSArray *)imageViewArray {
    if (!_imageViewArray) {
        _imageViewArray = [NSArray arrayWithObjects:
                           @"http://demo.lanrenzhijia.com/2014/pic0929/images/taobao.png",
                           @"http://demo.lanrenzhijia.com/2014/pic0929/images/jd.png",
                           @"http://demo.lanrenzhijia.com/2014/pic0929/images/youku.png", nil];
    }
    return _imageViewArray;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewClicked:(UIImageBannerScrollView *)bannerView didSelectIndex:(NSInteger)index withUrlString:(NSString *)urlString {
    NSLog(@"index:%ld, urlString:%@", index, urlString);
}

//初始化数据
-(void)initData{
    _hotQueueData = [[HotQueueModel alloc] init];
    
    //
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    _menuArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

// 结束searchBar的第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180;
    }else if (indexPath.section == 1){
        return 180;
    }else if (indexPath.section == 2){
        return 180;
    }else{
        return 180;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    headerView.backgroundColor = HDColor(239, 239, 244);
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 0)];
    footerView.backgroundColor = HDColor(239, 239, 244);
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIndentifier = @"menucell";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        static NSString *cellIndentifier = @"menucell2";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        static NSString *cellIndentifier = @"menucell3";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *cellIndentifier = @"menucell4";
        HomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            cell = [[HomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier menuArray:_menuArray];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}



#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




@end
