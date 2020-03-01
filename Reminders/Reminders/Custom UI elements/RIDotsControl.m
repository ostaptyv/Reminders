//
//  RIDotsControl.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/27/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIDotsControl.h"
#import "RIConstants.h"

//PRIVATE CONSTANTS:
static void *RIDotsControlDotsCountContext = &RIDotsControlDotsCountContext;
static void *RIDotsControlDotsSpacingContext = &RIDotsControlDotsSpacingContext;
static void *RIDotsControlDotConfigurationContext = &RIDotsControlDotConfigurationContext;

static NSString* const kDotsCountKeyPath = @"dotsCount";
static NSString* const kDotsSpacingKeyPath = @"dotsSpacing";
static NSString* const kDotConfigurationKeyPath = @"dotConfiguration";

@interface RIDotsControl ()

@property (strong, nonatomic) UINotificationFeedbackGenerator *notificationFeedbackGenerator;

@end

@implementation RIDotsControl

#pragma mark - Setup view

- (void)setupView {
    [self setDefaultPropertyValues];
    
    NSString *xibFileName = NSStringFromClass(RIDotsControl.class);
    
//    https://stackoverflow.com/a/50369170
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    [bundle loadNibNamed:xibFileName owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.dotsStackView.bounds = self.bounds;
    
    [self fillDotsStackViewFrom:0 forCount:self.dotsCount];
}

#pragma mark - Default property values

- (void)setDefaultPropertyValues {
    self.dotConfiguration = RIDotConfiguration.defaultConfiguration;
    
    self.currentDotPosition = 0;
    
    self.notificationFeedbackGenerator = [UINotificationFeedbackGenerator new];
    self.notificationFeedbackType = UINotificationFeedbackTypeError;
}

#pragma mark - Setup adding and removing KVO-observer

- (void)registerObservers {
    [self addObserver:self
           forKeyPath:kDotsCountKeyPath
              options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
              context:RIDotsControlDotsCountContext];
    
    [self addObserver:self
           forKeyPath:kDotsSpacingKeyPath
              options:NSKeyValueObservingOptionNew
              context:RIDotsControlDotsSpacingContext];
    
    [self addObserver:self
           forKeyPath:kDotConfigurationKeyPath
              options:NSKeyValueObservingOptionNew
              context:RIDotsControlDotConfigurationContext];
}

- (void)unregisterObservers {
    [self removeObserver:self
              forKeyPath:kDotsCountKeyPath
                 context:RIDotsControlDotsCountContext];
    
    [self removeObserver:self
              forKeyPath:kDotsSpacingKeyPath
                 context:RIDotsControlDotsSpacingContext];
    
    [self removeObserver:self
              forKeyPath:kDotConfigurationKeyPath
                 context:RIDotsControlDotConfigurationContext];
}

#pragma mark - Managing KVO property changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == RIDotsControlDotsCountContext) {
        NSUInteger oldDotsCount;
        NSUInteger newDotsCount;
        NSValue *oldValue = (NSValue *)change[NSKeyValueChangeOldKey];
        NSValue *newValue = (NSValue *)change[NSKeyValueChangeNewKey];

        [oldValue getValue:&oldDotsCount];
        [newValue getValue:&newDotsCount];

        NSUInteger countDifference = MAX(newDotsCount, oldDotsCount) - MIN(newDotsCount, oldDotsCount);

        if (newDotsCount > oldDotsCount) {
            NSUInteger startIndex = oldDotsCount ? oldDotsCount - 1 : 0;

            [self fillDotsStackViewFrom:startIndex forCount:countDifference];
        } else {
            [self removeDotsFromStackViewForCount:countDifference];
        }

        return;
    }
    
    if (context == RIDotsControlDotsSpacingContext) {
        CGFloat newDotsSpacing;
        NSValue *newValue = (NSValue *)change[NSKeyValueChangeNewKey];

        [newValue getValue:&newDotsSpacing];

        self.dotsStackView.spacing = newDotsSpacing;

        return;
    }
    
    if (context == RIDotsControlDotConfigurationContext) {
        RIDotConfiguration *dotConfiguration = change[NSKeyValueChangeNewKey];
        
        for (RIDot *dot in self.dotsStackView.arrangedSubviews) {
            dot.dotConfiguration = dotConfiguration;
        }
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Manipulating dots quantity

- (void)fillDotsStackViewFrom:(NSUInteger)startIndex forCount:(NSUInteger)count {
    for (NSUInteger i = startIndex; i < count; i++) {
        RIDot *dot = [[RIDot alloc] initWithState:NO dotConfiguration:self.dotConfiguration];
        CGSize dotSize = [self calculateDotSize];
        
        [dot.widthAnchor constraintEqualToConstant:dotSize.width].active = YES;
        [dot.heightAnchor constraintEqualToConstant:dotSize.height].active = YES;
        
        [self.dotsStackView addArrangedSubview:dot];
    }
}

- (void)removeDotsFromStackViewForCount:(NSUInteger)count {
    NSUInteger startIndex = self.dotsStackView.arrangedSubviews.count - 1;
    
    for (NSUInteger i = startIndex; i > count; i--) {
        RIDot *dot = self.dotsStackView.arrangedSubviews[i];
        
        [self.dotsStackView removeArrangedSubview:dot];
    }
}

#pragma mark - Recolor dots

- (void)recolorDotsTo:(NSInteger)dotPosition completionHandler:(void (^)(BOOL))completionHandler {
    if (dotPosition < 0 || dotPosition > self.dotsCount) {
        NSLog(@"Dot position is out of bounds (%lu in [0 | 1 .. %lu]", dotPosition, self.dotsCount);
        return;
    }

    NSInteger min = MIN(dotPosition, self.currentDotPosition);
    NSInteger max = MAX(dotPosition, self.currentDotPosition);

    for (NSInteger i = min; i < max; i++) {
        RIDot *dot = self.dotsStackView.arrangedSubviews[i];
        
        dot.completionHandler = completionHandler;
        dot.isOn = self.currentDotPosition < dotPosition;
    }
    
    self.currentDotPosition = dotPosition;
}

- (void)recolorDotsTo:(NSInteger)dotPosition {
    [self recolorDotsTo:dotPosition completionHandler:nil];
}

#pragma mark - Shake control (with haptics or not)

- (void)shakeControlWithHaptic:(BOOL)shouldUseHaptic {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 0.7;
    animation.values = @[ @-52.5, @27.5, @-25, @20, @-12.5, @7.5, @-5, @0 ];
    
    if (shouldUseHaptic) {
        [self.notificationFeedbackGenerator notificationOccurred:self.notificationFeedbackType];
    }

    [self.layer addAnimation:animation forKey:@"shake"];
}

#pragma mark - Private methods for internal purposes

- (CGSize)calculateDotSize {
    CGFloat floatDotsCount = (CGFloat)self.dotsCount;
    CGFloat possibleWidth = (self.dotsStackView.bounds.size.width - self.dotsSpacing * (floatDotsCount - 1)) / floatDotsCount;
    CGFloat possibleHeight = self.dotsStackView.bounds.size.height;
    
    CGFloat min = MIN(possibleWidth, possibleHeight);

    return CGSizeMake(min, min);
}

#pragma mark - Initializers
 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupView];
        [self registerObservers];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self setupView];
        [self registerObservers];
    }
    
    return self;
}

- (instancetype)initWithDotsCount:(NSUInteger)dotsCount {
    self = [super init];
    
    if (self) {
        [self registerObservers];
        
        self.dotsCount = dotsCount;
    }
    
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self unregisterObservers];
}

@end

