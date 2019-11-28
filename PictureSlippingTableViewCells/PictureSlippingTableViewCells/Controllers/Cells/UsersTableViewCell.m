//
//  UsersTableViewCell.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "UsersTableViewCell.h"

@implementation UsersTableViewCell

static NSString *reuseIdentifier = @"UsersTableViewCell";

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (NSString *)reuseIdentifier {
    return reuseIdentifier;
}

@end
