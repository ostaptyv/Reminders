//
//  GDNumberPad.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/24/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDNumberPad.h"
#import "UIImage+ImageWithImageScaledToSize.h"

@interface GDNumberPad ()

@property NSString *xibFileName;

@property CGSize clearIconSize;
@property NSUInteger biometryIconSize;

@end

@implementation GDNumberPad

- (void)commonInit {
    self.xibFileName = @"GDNumberPad";
    
    [NSBundle.mainBundle loadNibNamed:self.xibFileName owner:self options:nil];
        
    self.clearIconSize = CGSizeMake(43.2, 34.6);
    self.biometryIconSize = 44;
    
    [self addSubview:self.contentView];
}

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    NSMutableArray<GDNumberPadButton *> *arrayOfNumberButtons = [NSMutableArray new];
    
    for (int i = 0; i < 10; i++) {
        GDNumberPadButton *button = [self getNumberPadButtonForTag:i];

        [arrayOfNumberButtons addObject:button];
    }

    [self setupNumberButtonsWithArray:arrayOfNumberButtons];
    
    GDNumberPadButton *clearButton = [self getNumberPadButtonForTag:GDNumberPadButtonTagClear];
    GDNumberPadButton *biometryButton = [self getNumberPadButtonForTag:GDNumberPadButtonTagBiometry];
    
    [self setupClearButton:clearButton withIcon:self.clearIcon];
    [self setupBiometryButton:biometryButton withIcon:self.biometryIcon];
}

#pragma mark Property setters

- (void)setClearIcon:(UIImage *)clearIcon {
    _clearIcon = clearIcon;
    
    GDNumberPadButton *clearButton = [self getNumberPadButtonForTag:GDNumberPadButtonTagClear];
    
    [self setupClearButton:clearButton withIcon:clearIcon];
}

- (void)setBiometryIcon:(UIImage *)biometryIcon {
    _biometryIcon = biometryIcon;
    
    GDNumberPadButton *biometryButton = [self getNumberPadButtonForTag:GDNumberPadButtonTagBiometry];
    
    [self setupBiometryButton:biometryButton withIcon:biometryIcon];
}

- (void)setClearIconTintColor:(UIColor *)clearIconTintColor {
    _clearIconTintColor = clearIconTintColor;
    
    GDNumberPadButton *clearButton = [self getNumberPadButtonForTag:GDNumberPadButtonTagClear];
    
    clearButton.tintColor = clearIconTintColor;
}

- (void)setBiometryIconTintColor:(UIColor *)biometryIconTintColor {
    _biometryIconTintColor = biometryIconTintColor;
    
    GDNumberPadButton *biometryButton = [self getNumberPadButtonForTag:GDNumberPadButtonTagBiometry];
    
    biometryButton.tintColor = biometryIconTintColor;
}

#pragma mark Access method for number pad buttons

- (GDNumberPadButton *)getNumberPadButtonForTag:(GDNumberPadButtonTag)buttonTag {
    GDNumberPadButton *numberPadButton;
    
    for (UIStackView *nestedStackView in self.numberPadStackView.arrangedSubviews) {
        for (GDNumberPadButton *button in nestedStackView.arrangedSubviews) {
            if (button.buttonTag != buttonTag) { continue; }
            
            numberPadButton = button;
        }
    }
    
    return numberPadButton;
}

#pragma mark UI setuping methods

- (void)setupNumberButtonsWithArray:(NSArray<GDNumberPadButton *> *)arrayOfButtons {
    for (GDNumberPadButton *button in arrayOfButtons) {
        button.exclusiveTouch = YES;
        
        button.layer.cornerRadius = MIN(button.bounds.size.height, button.bounds.size.width) / 2;
    }
}

- (void)setupClearButton:(UIButton *)clearButton withIcon:(UIImage *)clearIcon{
    clearButton.exclusiveTouch = YES;
    
    UIImage *clearIconScaled = [UIImage imageWithImage:clearIcon scaledToSize:self.clearIconSize];
    UIImage *clearIconTemplate = [clearIconScaled imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    clearButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [clearButton setImage:clearIconTemplate forState:UIControlStateNormal] ;
}

- (void)setupBiometryButton:(UIButton *)biometryButton withIcon:(UIImage *)biometryIcon {
    biometryButton.exclusiveTouch = YES;
    
    CGFloat edgeInset = (biometryButton.bounds.size.height - self.biometryIconSize) / 2;
    biometryButton.imageEdgeInsets = UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
    
    UIImage *biometryIconTemplate = [biometryIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [biometryButton setImage:biometryIconTemplate forState:UIControlStateNormal];
}

#pragma mark -numberPadButtonPressed:

- (IBAction)numberPadButtonPressed:(GDNumberPadButton *)sender {
    switch (sender.buttonTag) {
        case GDNumberPadButtonTagClear:
            if (![self.delegate respondsToSelector:@selector(didPressClearButton)]) { return; }
            
            [self.delegate didPressClearButton];
            break;
        case GDNumberPadButtonTagBiometry:
            if (![self.delegate respondsToSelector:@selector(didPressBiometryButton)]) { return; }
            
            [self.delegate didPressBiometryButton];
            break;
            
        default: // switch case for numbers 0-9
            if (![self.delegate respondsToSelector:@selector(didPressButtonWithNumber:)]) { return; }
            
            [self.delegate didPressButtonWithNumber:sender.buttonTag];
            break;
    }
}

#pragma mark Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
        [self viewDidLoad];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self commonInit];
        [self viewDidLoad];
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
