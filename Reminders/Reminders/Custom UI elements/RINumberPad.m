//
//  RINumberPad.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/24/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RINumberPad.h"
#import "RIUIImage+ImageWithImageScaledToSize.h"
#import "RIConstants.h"
#import "RIAccessibilityConstants.h"

//PRIVATE CONSTANTS:
static void *RINumberPadClearIconContext = &RINumberPadClearIconContext;
static void *RINumberPadBiometryIconContext = &RINumberPadBiometryIconContext;
static void *RINumberPadClearIconTintColorContext = &RINumberPadClearIconTintColorContext;
static void *RINumberPadBiometryIconTintColorContext = &RINumberPadBiometryIconTintColorContext;

static NSString* const kClearIconKeyPath = @"clearIcon";
static NSString* const kBiometryIconKeyPath = @"biometryIcon";
static NSString* const kClearIconTintColorKeyPath = @"clearIconTintColor";
static NSString* const kBiometryIconTintColorKeyPath = @"biometryIconTintColor";

@interface RINumberPad ()

@property (assign, nonatomic) CGSize clearIconSize;
@property (assign, nonatomic) NSUInteger biometryIconSideSize;

@end

@implementation RINumberPad

#pragma mark - Property setters

- (void)setBiometryButtonHidden:(BOOL)biometryButtonHidden {
    biometryButtonHidden ? [self hideBiometryButton] : [self showBiometryButton];

    _biometryButtonHidden = biometryButtonHidden;
}

- (void)setBiometryButtonEnabled:(BOOL)biometryButtonEnabled {
    biometryButtonEnabled ? [self enableBiometryButton] : [self disableBiometryButton];
    
    _biometryButtonEnabled = biometryButtonEnabled;
}

#pragma mark - Set default property values

- (void)setDefaultPropertyValues {
     self.clearIconSize = CGSizeMake(kClearIconWidth, kClearIconHeight);
     self.biometryIconSideSize = kBiometryIconSideSize;
}

#pragma mark - Setup view

- (void)setupView {
    [self setupXib];
    [self setDefaultPropertyValues];
    
    [self registerObservers];
    
    [self addSubview:self.contentView];
    [self setupButtons];
    
    self.accessibilityIdentifier = kNumberPadIdentifier;
}

#pragma mark - Setup .xib

- (void)setupXib {
    NSString *xibFileName = NSStringFromClass(RINumberPad.class);
    
//    https://stackoverflow.com/a/50369170
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [bundle loadNibNamed:xibFileName owner:self options:nil];
}

#pragma mark - Setup adding and removing KVO-observer

- (void)registerObservers {
    [self addObserver:self
           forKeyPath:kClearIconKeyPath
              options:NSKeyValueObservingOptionNew
              context:RINumberPadClearIconContext];
    
    [self addObserver:self
           forKeyPath:kBiometryIconKeyPath
              options:NSKeyValueObservingOptionNew
              context:RINumberPadBiometryIconContext];
    
    [self addObserver:self
           forKeyPath:kClearIconTintColorKeyPath
              options:NSKeyValueObservingOptionNew
              context:RINumberPadClearIconTintColorContext];
    
    [self addObserver:self
           forKeyPath:kBiometryIconTintColorKeyPath
              options:NSKeyValueObservingOptionNew
              context:RINumberPadBiometryIconTintColorContext];
}

- (void)unregisterObservers {
    [self removeObserver:self
              forKeyPath:kClearIconKeyPath
                 context:RINumberPadClearIconContext];
    
    [self removeObserver:self
              forKeyPath:kBiometryIconKeyPath
                 context:RINumberPadBiometryIconContext];
    
    [self removeObserver:self
              forKeyPath:kClearIconTintColorKeyPath
                 context:RINumberPadClearIconTintColorContext];
    
    [self removeObserver:self
              forKeyPath:kBiometryIconTintColorKeyPath
                 context:RINumberPadBiometryIconTintColorContext];
}

#pragma mark - Managing KVO property changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == RINumberPadClearIconContext) {
        RINumberPadButton *clearButton = [self getNumberPadButtonForTag:RINumberPadButtonTagClear];
        UIImage *clearIcon = change[NSKeyValueChangeNewKey];
        
        [self setupClearButton:clearButton withIcon:clearIcon];
        
        return;
    }
    
    if (context == RINumberPadBiometryIconContext) {
        RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
        UIImage *biometryIcon = change[NSKeyValueChangeNewKey];
        
        [self setupBiometryButton:biometryButton withIcon:biometryIcon];
        
        return;
    }
    
    if (context == RINumberPadClearIconTintColorContext) {
        RINumberPadButton *clearButton = [self getNumberPadButtonForTag:RINumberPadButtonTagClear];
        UIColor *clearIconTintColor = change[NSKeyValueChangeNewKey];
        
        clearButton.tintColor = clearIconTintColor;
        
        return;
    }
    
    if (context == RINumberPadBiometryIconTintColorContext) {
        RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
        UIColor *biometryIconTintColor = change[NSKeyValueChangeNewKey];
        
        biometryButton.tintColor = biometryIconTintColor;
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Access method for number pad buttons

- (RINumberPadButton *)getNumberPadButtonForTag:(RINumberPadButtonTag)buttonTag {
    if (buttonTag == RINumberPadButtonTagBiometry) {
        for (UIButton *button in self.biometryButtonStackView.arrangedSubviews.firstObject.subviews) {
            if ([button isKindOfClass:RINumberPadButton.class]) {
                return (RINumberPadButton *)button;
            }
        }
    }
    
    RINumberPadButton *numberPadButton;
    
    for (UIStackView *nestedStackView in self.numberPadStackView.arrangedSubviews) {
        for (RINumberPadButton *button in nestedStackView.arrangedSubviews) {
            if ([button isKindOfClass:UIStackView.class]) {
                continue;
            }
            if (button.buttonTag != buttonTag) {
                continue;
            }
            
            numberPadButton = button;
        }
    }
    
    return numberPadButton;
}

#pragma mark - UI setuping methods

- (void)setupButtons {
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
    
    for (UIButton *button in self.biometryButtonStackView.arrangedSubviews.firstObject.subviews) {
        if (![button isKindOfClass:RINumberPadButton.class]) {
            button.accessibilityIdentifier = kNumberPadFallbackBiometryButtonIdentifier;
        }
    }
}

- (void)setupNumberButtonsWithArray:(NSArray<RINumberPadButton *> *)arrayOfButtons {
    for (RINumberPadButton *button in arrayOfButtons) {
        button.exclusiveTouch = YES;
        
        button.layer.cornerRadius = MIN(button.bounds.size.height, button.bounds.size.width) / 2;
    }
}

- (void)setupClearButton:(UIButton *)clearButton withIcon:(UIImage *)clearIcon{
    clearButton.exclusiveTouch = YES;
    
    [self setIcon:clearIcon forClearButton:clearButton];
}

- (void)setupBiometryButton:(UIButton *)biometryButton withIcon:(UIImage *)biometryIcon {
    biometryButton.exclusiveTouch = YES;
    
    [self setIcon:biometryIcon forBiometryButton:biometryButton];
}

- (void)setIcon:(UIImage *)icon forClearButton:(UIButton *)clearButton {
    UIImage *clearIconScaled = [UIImage imageWithImage:icon scaledToSize:self.clearIconSize];
    UIImage *clearIconTemplate = [clearIconScaled imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    clearButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [clearButton setImage:clearIconTemplate forState:UIControlStateNormal];
    
    CALayer *layer = [CALayer layer];
    
    layer.frame = CGRectMake(clearButton.imageView.frame.origin.x + kClearIconWidth * kClearIconBackgroundLayerXMultiplier,
                             clearButton.imageView.frame.origin.y + kClearIconHeight * kClearIconBackgroundLayerYMultiplier,
                             kClearIconWidth * kClearIconBackgroundLayerSizeMultiplier,
                             kClearIconHeight * kClearIconBackgroundLayerSizeMultiplier);
    layer.backgroundColor = [UIColor blackColor].CGColor;

    [clearButton.layer insertSublayer:layer below:clearButton.imageView.layer];
}

- (void)setIcon:(UIImage *)icon forBiometryButton:(UIButton *)biometryButton {
    CGFloat edgeInset = (biometryButton.bounds.size.height - self.biometryIconSideSize) / 2;
    biometryButton.imageEdgeInsets = UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
    
    UIImage *biometryIconTemplate = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [biometryButton setImage:biometryIconTemplate forState:UIControlStateNormal];
}

#pragma mark - Button tapped handling

- (IBAction)numberPadButtonTapped:(RINumberPadButton *)sender {
    switch (sender.buttonTag) {
        case RINumberPadButtonTagClear:
            if (![self.delegate respondsToSelector:@selector(didPressClearButton)]) {
                return;
            }
            
            [self.delegate didPressClearButton];
            break;
            
        case RINumberPadButtonTagBiometry:
            if (![self.delegate respondsToSelector:@selector(didPressBiometryButton)]) {
                return;
            }
            
            [self.delegate didPressBiometryButton];
            
            
            break;
            
        default: // switch case for numbers 0-9
            if (![self.delegate respondsToSelector:@selector(didPressButtonWithNumber:)]) {
                return;
            }
            
            [self.delegate didPressButtonWithNumber:sender.buttonTag];
            break;
    }
}

- (IBAction)biometryFallbackButtonTapped:(UIButton *)sender {
    if (self.biometryFallbackActionBlock != nil) {
        self.biometryFallbackActionBlock();
    }
}

#pragma mark - Hide/show biometry button

- (void)hideBiometryButton {
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    biometryButton.hidden = YES;
}

- (void)showBiometryButton {
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    biometryButton.hidden = NO;
}

#pragma mark - Enable/disable biometry button

- (void)enableBiometryButton {
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    biometryButton.enabled = YES;
    biometryButton.alpha = 1.0;
}

- (void)disableBiometryButton {
    RINumberPadButton *biometryButton = [self getNumberPadButtonForTag:RINumberPadButtonTagBiometry];
    
    biometryButton.enabled = NO;
    biometryButton.alpha = kLockScreenDisabledBiometryButtonAlphaValue;
}

#pragma mark - Initializers

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
        [self setupView];
        
        self.clearIcon = clearIcon;
        self.biometryIcon = biometryIcon;
    }
    
    return self;
}

#pragma mark - Dealloc method

- (void)dealloc {
    [self unregisterObservers];
}

@end
