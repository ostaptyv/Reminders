//
//  ReminderTableViewCell.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "ReminderTableViewCell.h"

@implementation ReminderTableViewCell

static NSString *reuseIdentifier = @"ReminderTableViewCell";

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
