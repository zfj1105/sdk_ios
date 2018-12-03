//
//  UsernamesCell.m
//  HTGUniteSDKDemo
//
//  Created by zfj2602 on 2018/4/24.
//  Copyright © 2018年 zfj2602. All rights reserved.
//

#import "UsernamesCell.h"

@implementation UsernamesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.usernameLb];
        [self.contentView addSubview:self.deleteButton];
        
        
        [self.usernameLb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 10));
            make.centerY.equalTo(self.contentView);
        }];
        [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    return self;
}

- (UILabel *)usernameLb
{
    if (!_usernameLb) {
        _usernameLb = [UILabel new];
        _usernameLb.textAlignment = NSTextAlignmentLeft;
        _usernameLb.textColor = [UIColor colorWithHex:@"##9D9E9D"];
        _usernameLb.font = KSYSTEM_FONT_(10);
        
    }
    return _usernameLb;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton new];
        _deleteButton.titleLabel.font = KICON_FONT_(15);
        [_deleteButton setTitle:@"\U0000e635" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor colorWithHex:@"#CCCCCC"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
