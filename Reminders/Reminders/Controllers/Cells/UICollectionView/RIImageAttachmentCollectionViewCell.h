//
//  RIImageAttachmentCollectionViewCell.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/6/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIImageAttachmentCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

- (IBAction)removeButtonTapped:(UIButton *)sender;

+ (NSString *)reuseIdentifier;

- (void)setupUI;

@end
