//
//  UsersTableViewCell.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UsersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
