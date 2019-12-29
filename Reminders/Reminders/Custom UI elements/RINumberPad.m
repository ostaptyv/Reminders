//
//  RINumberPad.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/24/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RINumberPad.h"
#import "UIImage+ImageWithImageScaledToSize.h"
#import "RIConstants.h"

@interface RINumberPad ()

@property NSString *xibFileName;

@property CGSize clearIconSize;
@property NSUInteger biometryIconSideSize;

@end

@implementation RINumberPad

#pragma mark -setupView

- (void)setupView {
    self.xibFileName = @"RINumberPad";
    
//    https://stackoverflow.com/a/50369170
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    [bundle loadNibNamed:self.xibFileName owner:self options:nil];
     
    [self setDefaultPropertyValues];
    
    [self addSubview:self.contentView];

    NSMutableArray<RINumberPadButton *> *arrayOfNumberButtons = [NSMutableArray new];
    for (int i = 0; i < 10; i++) { // 10 is number of numbers 0-9
        RINumberPadButton *button = [self getNumberPadButtonForTag:i];

        [arrayOfNumberButtons addObject:button];
    }

    [self setupNumberButtonsWithArray:arrayOfNumberButtons];
    
    RINumberPadButton *clearButton = [self getNumberPadButtonForTag:RINumberPadButtonTagClear];
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    [self setupClearButton:clearButton withIcon:self.clearIcon];
    [self setupBiometryButton:biometryButton withIcon:self.biometryIcon];
}

- (void)setDefaultPropertyValues {
     self.clearIconSize = CGSizeMake(clearIconWidth, clearIconHeight);
     self.biometryIconSideSize = biometryIconSideSize;
}

#pragma mark Property setters

- (void)setClearIcon:(UIImage *)clearIcon {
    _clearIcon = clearIcon;
    
    RINumberPadButton *clearButton = [self getNumberPadButtonForTag:RINumberPadButtonTagClear];
    
    [self setupClearButton:clearButton withIcon:clearIcon];
}

- (void)setBiometryIcon:(UIImage *)biometryIcon {
    _biometryIcon = biometryIcon;
    
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    [self setupBiometryButton:biometryButton withIcon:biometryIcon];
}

- (void)setClearIconTintColor:(UIColor *)clearIconTintColor {
    _clearIconTintColor = clearIconTintColor;
    
    RINumberPadButton *clearButton = [self getNumberPadButtonForTag:RINumberPadButtonTagClear];
    
    clearButton.tintColor = clearIconTintColor;
}

- (void)setBiometryIconTintColor:(UIColor *)biometryIconTintColor {
    _biometryIconTintColor = biometryIconTintColor;
    
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    biometryButton.tintColor = biometryIconTintColor;
}

#pragma mark Access method for number pad buttons

- (RINumberPadButton *)getNumberPadButtonForTag:(RINumberPadButtonTag)buttonTag {
    RINumberPadButton *numberPadButton;
    
    for (UIStackView *nestedStackView in self.numberPadStackView.arrangedSubviews) {
        for (RINumberPadButton *button in nestedStackView.arrangedSubviews) {
            if (button.buttonTag != buttonTag) { continue; }
            
            numberPadButton = button;
        }
    }
    
    return numberPadButton;
}

#pragma mark UI setuping methods

- (void)setupNumberButtonsWithArray:(NSArray<RINumberPadButton *> *)arrayOfButtons {
    for (RINumberPadButton *button in arrayOfButtons) {
        button.exclusiveTouch = YES;
        
        button.layer.cornerRadius = MIN(button.bounds.size.height, button.bounds.size.width) / 2;
    }
}

- (void)setupClearButton:(UIButton *)clearButton withIcon:(UIImage *)clearIcon{
    clearButton.exclusiveTouch = YES;
    
    UIImage *clearIconScaled = [UIImage imageWithImage:clearIcon scaledToSize:self.clearIconSize];
    UIImage *clearIconTemplate = [clearIconScaled imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    clearButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [clearButton setImage:clearIconTemplate forState:UIControlStateNormal];
    
    CALayer *layer = [CALayer layer];
    
    layer.frame = CGRectMake(clearButton.imageView.frame.origin.x + clearIconWidth * clearIconBackgroundLayerXMultiplier,
                             clearButton.imageView.frame.origin.y + clearIconHeight * clearIconBackgroundLayerYMultiplier,
                             clearIconWidth * clearIconBackgroundLayerSizeMultiplier,
                             clearIconHeight * clearIconBackgroundLayerSizeMultiplier);
    layer.backgroundColor = [UIColor blackColor].CGColor;

    [clearButton.layer insertSublayer:layer below:clearButton.imageView.layer];
}

- (void)setupBiometryButton:(UIButton *)biometryButton withIcon:(UIImage *)biometryIcon {
    biometryButton.exclusiveTouch = YES;
    
    CGFloat edgeInset = (biometryButton.bounds.size.height - self.biometryIconSideSize) / 2;
    biometryButton.imageEdgeInsets = UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
    
    UIImage *biometryIconTemplate = [biometryIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [biometryButton setImage:biometryIconTemplate forState:UIControlStateNormal];
}

#pragma mark -numberPadButtonPressed:

- (IBAction)numberPadButtonPressed:(RINumberPadButton *)sender {
    switch (sender.buttonTag) {
        case RINumberPadButtonTagClear:
            if (![self.delegate respondsToSelector:@selector(didPressClearButton)]) { return; }
            
            [self.delegate didPressClearButton];
            break;
        case RINumberPadButtonTagBiometry:
            if (![self.delegate respondsToSelector:@selector(didPressBiometryButton)]) { return; }
            
            [self.delegate didPressBiometryButton];
            break;
            
        default: // switch case for numbers 0-9
            if (![self.delegate respondsToSelector:@selector(didPressButtonWithNumber:)]) { return; }
            
            [self.delegate didPressButtonWithNumber:sender.buttonTag];
            break;
    }
}

#pragma mark -hideBiometryButton

- (void)hideBiometryButton {
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    biometryButton.hiddenAppearance = YES;
}

#pragma mark Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithClearIcon:(UIImage *)clearIcon biometryIcon:(UIImage *)biometryIcon {
    self = [super init];
    
    if (self) {
        self.clearIcon = clearIcon;
        self.biometryIcon = biometryIcon;
    }
    
    return self;
}

@end