//
//  ViewController.m
//  Happy New Year
//
//  Created by 钟柳 on 16/2/17.
//  Copyright © 2016年 钟柳. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"
#import "Test_TableViewCell.h"
#import "TestTwo_TableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *myTableView;
// 数据源数组
@property (nonatomic,strong)NSMutableArray *dataArray;
// 记录点击位置
@property (nonatomic,strong)NSIndexPath *selectPath;
// 记录cell状态
@property (nonatomic,assign)BOOL selectStatus;
// 记录组头视图状态
@property (nonatomic,strong)NSMutableArray *selectHeaderArr;
@end

@implementation ViewController
- (NSMutableArray *)selectHeaderArr{
    if (!_selectHeaderArr) {
        _selectHeaderArr = [NSMutableArray array];
    }
    return _selectHeaderArr;
}
- (NSIndexPath *)selectPath{
    if (!_selectPath) {
        _selectPath = [NSIndexPath indexPathForRow:1000 inSection:1000];
    }
    return _selectPath;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatMytableView];
    
    [self registerCell];
    
    [self dataSource];
}

- (void)creatMytableView{
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
}

- (void)dataSource{
    for (NSInteger i = 0 ; i < 4; i ++) {
        NSMutableArray *subArray = [NSMutableArray array];
        for (NSInteger i = 0 ; i < arc4random() % 10 + 10; i ++) {
            NSString *str = [NSString stringWithFormat:@"我今天卖饼不卖西瓜！我今年%d岁了！",arc4random() % 10 + 20];
            [subArray addObject:str];
        }
        [self.dataArray addObject:subArray];
    }
}

- (void)registerCell{
    [self.myTableView registerNib:[UINib nibWithNibName:@"Test_TableViewCell" bundle:nil] forCellReuseIdentifier:@"test_cell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"TestTwo_TableViewCell" bundle:nil] forCellReuseIdentifier:@"test_twoCell"];
}
#pragma mark - UITableViewDeleget 表代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath == self.selectPath) {
        TestTwo_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test_twoCell"];
        return cell;
    } else {
        Test_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test_cell" forIndexPath:indexPath];
        // 赋值时考虑
        if (indexPath.section == self.selectPath.section && indexPath.row > self.selectPath.row) {
            [cell setDataTitleLable:self.dataArray[indexPath.section][indexPath.row - 1]];
        } else {
            [cell setDataTitleLable:self.dataArray[indexPath.section][indexPath.row]];
        }
        return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.selectHeaderArr containsObject:[NSString stringWithFormat:@"%ld",section]]) {
        return 0;
    } else {
        NSArray *arr = self.dataArray[section];
        if (self.selectStatus && section == self.selectPath.section) {
            return arr.count + 1;
        } else {
            return arr.count;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderView *view = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    view.tag = section;
    // Lable
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.bounds.size.width / 2, 40)];
    lable.text = @"我是卖西瓜的老板！";
    lable.textColor = [UIColor blueColor];
    [view addSubview:lable];
    // 添加头部事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    if (self.selectStatus) {
        // 如果已经打开过了,先关闭
        self.selectStatus = NO;
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[self.selectPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView endUpdates];
        // 判断是否再打开
        if (path != self.selectPath) {
            if (path.row > self.selectPath.row && path.section >= self.selectPath.section) {
                // 记录选择点
                self.selectPath = [NSIndexPath indexPathForRow:path.row - 1 inSection:path.section];
                // 状态为点击打开
                self.selectStatus = YES;
                [tableView beginUpdates];
                [tableView insertRowsAtIndexPaths:@[self.selectPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            } else {
                    // 记录选择点
                    self.selectPath = [NSIndexPath indexPathForRow:path.row inSection:path.section];
                    // 状态为点击打开
                    self.selectStatus = YES;
                    [tableView beginUpdates];
                    [tableView insertRowsAtIndexPaths:@[self.selectPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
            }
        }
    } else {
        // 记录选择点
        self.selectPath = path;
        // 状态为点击打开
        self.selectStatus = YES;
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}
#pragma mark - 点击事件
- (void)clickAction:(UIGestureRecognizer *)tap{
    HeaderView *view = (HeaderView *)tap.view;
    if ([self.selectHeaderArr containsObject:[NSString stringWithFormat:@"%ld",tap.view.tag]]) {
        view.isOpend = NO;
    } else {
        view.isOpend = YES;
    }
    // 记下状态和组数
    if (!view.isOpend) {
        [self.selectHeaderArr removeObject:[NSString stringWithFormat:@"%ld",tap.view.tag]];
    } else {
        [self.selectHeaderArr addObject:[NSString stringWithFormat:@"%ld",tap.view.tag]];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tap.view.tag, 1)];
    [self.myTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}





















@end
