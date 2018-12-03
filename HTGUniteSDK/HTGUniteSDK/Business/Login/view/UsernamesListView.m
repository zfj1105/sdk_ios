//
//  UsernamesListView.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/24.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UsernamesListView.h"
#import "UsernamesCell.h"

@implementation UsernamesListView

- (instancetype)init
{
    if (self = [super init]) {
        self.layer.borderWidth = .2;
        self.layer.borderColor = [UIColor colorWithHex:@"#aaaaaa"].CGColor;
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        
        [self addSubview:self.table];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.table mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}

- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = NO;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *  cellIdentifier = @"usernames";
    UsernamesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UsernamesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UserInfo *user = self.array[indexPath.row];
    cell.usernameLb.text = user.username;
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(actionDeleteName:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSelected:)]) {
        [self.delegate actionSelected:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

#pragma mark - 懒加载
- (void)actionDeleteName:(id)sender
{
    UIButton *button  = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionDelete:)]) {
        [self.delegate actionDelete:button.tag];
    }
}

@end
