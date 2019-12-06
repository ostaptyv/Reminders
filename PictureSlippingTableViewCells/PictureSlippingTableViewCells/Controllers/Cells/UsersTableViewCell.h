//
//  UsersTableViewCell.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoadOperation.h"
#import "ImageOutputOperation.h"


@interface UsersTableViewCell : UITableViewCell

@property (readonly) NSURL *imageUrl;

- (void)setImageUrl:(NSURL *)imageUrl;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;

+ (NSString *)reuseIdentifier;

@end
