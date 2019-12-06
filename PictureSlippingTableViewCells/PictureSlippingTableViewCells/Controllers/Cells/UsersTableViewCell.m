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

+ (NSString *)reuseIdentifier {
    return reuseIdentifier;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    self.profilePicImageView.image = nil;
    self.nameLabel.text = nil;
}

- (void)setImageUrl:(NSURL *)imageUrl {
    if (!_imageUrl) {
        _imageUrl = imageUrl;
    }
}

@end
