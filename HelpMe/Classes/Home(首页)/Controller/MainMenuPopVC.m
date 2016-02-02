//
//  MainMenuPopVC.m
//  HelpMe
//
//  Created by 刘伟龙 on 16/2/2.
//  Copyright © 2016年 lwl. All rights reserved.
//

#import "MainMenuPopVC.h"
#import "TableGroupModel.h"
#import "TableItemModel.h"

#define kCellTagMySOS       0
#define kCellTagMyMoney     1
#define kCellTagMessage     2
#define kCellTagDiscover    3
#define kCellTagSetup       4

@interface MainMenuPopVC()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *menuArrays;

@end

@implementation MainMenuPopVC

-(NSMutableArray *)menuArrays{
    if (_menuArrays == nil) {
        _menuArrays = [NSMutableArray array];
    }
    
    return _menuArrays;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = kThemeColor;
    
    [self initSubTableView];
    [self initTableData];
    
    [self addSwipeRecognizer];
}

-(void)initSubTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMenuTableViewVCWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = kThemeColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
}

-(void)initTableData{
    TableGroupModel *group =[TableGroupModel group];
    
    TableItemModel *item1 = [TableItemModel initWithTitle:@"我的求助" detailTitle:@"" icon:@"sidebar_menu_icon_order" tag:kCellTagMySOS];
    TableItemModel *item2 = [TableItemModel initWithTitle:@"我的钱包" detailTitle:@"" icon:@"sidebar_menu_icon_invitation" tag:kCellTagMyMoney];
    TableItemModel *item3 = [TableItemModel initWithTitle:@"消息中心" detailTitle:@"" icon:@"sidebar_menu_icon_message" tag:kCellTagMessage];
    TableItemModel *item4 = [TableItemModel initWithTitle:@"发现" detailTitle:@"" icon:@"sidebar_icn_found" tag:kCellTagDiscover];
    TableItemModel *item5 = [TableItemModel initWithTitle:@"设置" detailTitle:@"" icon:@"sidebar_menu_icon_setting" tag:kCellTagSetup];
    
    group.items = @[item1, item2, item3, item4, item5];
    
    [self.menuArrays addObject:group];
}
#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuArrays.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TableGroupModel *group = [self.menuArrays objectAtIndex:section];
    return group.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 54;
    }else{
        return 54;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"menu";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    TableGroupModel *group = [self.menuArrays objectAtIndex:indexPath.section];
    TableItemModel *item = [group.items objectAtIndex:indexPath.row];
    
    cell.backgroundColor = kThemeColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.imageView.image = [UIImage imageNamed:item.icon];
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = item.detailTitle;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(popMenuDidSelected:)]){
        [self.delegate popMenuDidSelected:indexPath];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.view.x = -kMenuTableViewVCWidth;
        }];
    }
}

-(void)addSwipeRecognizer{
    [self addSwipeRecognizerLeft];
    [self addSwipeRecognizerRight];
}

// 添加左滑手势
- (void)addSwipeRecognizerLeft
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopMenu)];
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    // 添加手势
    [[self view] addGestureRecognizer:swipeRecognizer];
}

// 添加右滑手势
- (void)addSwipeRecognizerRight
{
    // 初始化手势并添加执行方法
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPopMenu)];
    // 手势方向
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    // 响应的手指数
    swipeRecognizer.numberOfTouchesRequired = 1;
    // 添加手势
    [[self view] addGestureRecognizer:swipeRecognizer];
}

-(void)showPopMenu{
    [UIView animateWithDuration:0.1 animations:^{
        self.view.x = 0;
    }];
}

-(void)hidePopMenu{
    [UIView animateWithDuration:0.1 animations:^{
        self.view.x = -kMenuTableViewVCWidth;
    }];
}
@end
