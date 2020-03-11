//
//  RIPasscodeEntryView.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/30/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIPasscodeEntryView.h"
#import "RIConstants.h"

//PRIVATE CONSTANTS:
static void *RIPasscodeEntryViewFailedAttemptsCountContext = &RIPasscodeEntryViewFailedAttemptsCountContext;

static NSString* const kFailedAttemptsCountKeyPath = @"failedAttemptsCount";

@implementation RIPasscodeEntryView

#pragma mark - Property getters

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

- (BOOL)hasText {
    if (![self.delegate respondsToSelector:@selector(hasText)]) {
        return NO;
    }
    
    return [self.delegate hasText];
}

#pragma mark - Setup view

- (void)setupView {
    [self registerObservers];
    
    NSString *xibFileName = NSStringFromClass(RIPasscodeEntryView.class);
        
    NSBundle *bundle = [NSBundle bundleForClass:RIPasscodeEntryView.class];
    [bundle loadNibNamed:xibFileName owner:self options:nil];
    
    [self addSubview:self.contentView];
    [self constraintContentView];
    
    [self setupFailedAttemptLabel];
}

#pragma mark - Setup UI

- (void)setupFailedAttemptLabel {
    self.failedAttemptsLabel.clipsToBounds = YES;
    self.failedAttemptsLabel.layer.cornerRadius = self.failedAttemptsLabel.bounds.size.height / 2;
}

#pragma mark - Setup adding and removing KVO-observers

- (void)registerObservers {
    [self addObserver:self
           forKeyPath:kFailedAttemptsCountKeyPath
              options:NSKeyValueObservingOptionNew
              context:RIPasscodeEntryViewFailedAttemptsCountContext];
}

- (void)unregisterObservers {
    [self removeObserver:self
              forKeyPath:kFailedAttemptsCountKeyPath
                 context:RIPasscodeEntryViewFailedAttemptsCountContext];
}

#pragma mark - Managing KVO property changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == RIPasscodeEntryViewFailedAttemptsCountContext) {
        NSUInteger failedAttemptsCount;
        NSValue *newValue = change[NSKeyValueChangeNewKey];
        
        [newValue getValue:&failedAttemptsCount];
        
        self.failedAttemptsLabel.hidden = failedAttemptsCount == 0;
        
        NSString *pluralSuffix = failedAttemptsCount > 1 ? @"s" : @"";
        NSString *failedAttemptsString = [NSString stringWithFormat:@"%lu %@%@", failedAttemptsCount, kPasscodeEntryFailedAttemptText, pluralSuffix];
        
        self.failedAttemptsLabel.text = failedAttemptsString;
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - UIKeyInput protocol implementation

- (void)insertText:(nonnull NSString *)text {
    if (![self.delegate respondsToSelector:@selector(insertText:)]) { return; }

    [self.delegate insertText:text];
}

- (void)deleteBackward {
    if (![self.delegate respondsToSelector:@selector(deleteBackward)]) { return; }
    
    [self.delegate deleteBackward];
}

#pragma mark - Constraint content view

- (void)constraintContentView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:0.0].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:0.0].active = YES;
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:0.0].active = YES;
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

#pragma mark - Dealloc method

- (void)dealloc {
    [self unregisterObservers];
}

@end
