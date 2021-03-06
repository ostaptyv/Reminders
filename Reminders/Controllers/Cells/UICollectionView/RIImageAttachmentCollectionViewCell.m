//
//  RIImageAttachmentCollectionViewCell.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/6/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIImageAttachmentCollectionViewCell.h"
#import "RIConstants.h"
#import "RIUIImage+ImageWithImageScaledToSize.h"
#import "RIUIImage+Constants.h"

@interface RIImageAttachmentCollectionViewCell ()

@property (assign, nonatomic) BOOL isButtonFirstTimeSetupped;

@end

@implementation RIImageAttachmentCollectionViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(RIImageAttachmentCollectionViewCell.class);
}

- (void)setupUI {
    if (!self.isButtonFirstTimeSetupped) {
        [self setupRemoveButton:self.removeButton withIcon:UIImage.removeIcon];
        
        self.isButtonFirstTimeSetupped = YES;
    }
    
    [self roundCorners];
}

- (void)setupRemoveButton:(UIButton *)removeButton withIcon:(UIImage *)removeIcon {
    UIImage *removeIconScaled = [UIImage imageWithImage:removeIcon scaledToSize:removeButton.bounds.size];
    UIImage *removeIconTemplate = [removeIconScaled imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    removeButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [removeButton setImage:removeIconTemplate forState:UIControlStateNormal];

    CALayer *layer = [CALayer layer];
    
    CGFloat imageViewX = removeButton.imageView.frame.origin.x;
    CGFloat imageViewY = removeButton.imageView.frame.origin.y;
    CGFloat removeIconWidth = removeButton.imageView.image.size.width;
    CGFloat removeIconHeight = removeButton.imageView.image.size.height;
    
    CGFloat layerFrameX = (imageViewX + removeIconWidth * kRemoveAttachmentIconBackgroundLayerOriginMultiplier) + kRemoveAttachmentIconImageInset;
    CGFloat layerFrameY = (imageViewY + removeIconHeight * kRemoveAttachmentIconBackgroundLayerOriginMultiplier) + kRemoveAttachmentIconImageInset;
    CGFloat layerFrameWidth = (removeIconWidth * kRemoveAttachmentIconBackgroundLayerSizeMultiplier) - kRemoveAttachmentIconImageInset * 2.0;
    CGFloat layerFrameHeight = (removeIconHeight * kRemoveAttachmentIconBackgroundLayerSizeMultiplier) - kRemoveAttachmentIconImageInset * 2.0;
    
    layer.frame = CGRectMake(layerFrameX, layerFrameY, layerFrameWidth, layerFrameHeight);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    
    [removeButton.layer insertSublayer:layer below:removeButton.imageView.layer];
}

- (void)roundCorners {
    self.contentView.layer.cornerRadius = kImageAttachmentCollectionViewCellCornerRadius;
}

- (IBAction)removeButtonTapped:(UIButton *)sender {
    
    NSDictionary<NSString *, id> *userInfo = @{
        @"image": self.imageView.image
    };
    
    NSNotification *notification = [[NSNotification alloc] initWithName:RIRemoveAttachmentButtonTappedNotification object:self userInfo:userInfo];
    
    [NSNotificationCenter.defaultCenter postNotification:notification];
}

@end
