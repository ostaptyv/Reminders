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

@interface RIDotsControl ()

@property NSString *xibFileName;

@property CGFloat dotBorderWidth;
@property CGFloat dotConstraintValue;

@property NSInteger currentDotPosition;

@end

@implementation RIDotsControl

#pragma mark -setupView

- (void)setupView {
    [self setupDefaultPropertyValues];
    
    self.xibFileName = @"RIDotsControl";
    
//    https://stackoverflow.com/a/50369170
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    [bundle loadNibNamed:self.xibFileName owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self fillDotsStackViewFrom:0 forCount:self.dotsCount];
}

#pragma mark Default property values

- (void)setupDefaultPropertyValues {
    self.dotBorderWidth = defaultDotBorderWidth;
    self.dotConstraintValue = dotConstraintValue;
    
    self.currentDotPosition = 0;
}

#pragma mark Setup adding and removing KVO-observer

- (void)registerObservers {
    [self addObserver:self
           forKeyPath:@"dotsCount"
              options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
              context:RIDotsControlDotsCountContext];
    
    [self addObserver:self
           forKeyPath:@"dotsSpacing"
              options:NSKeyValueObservingOptionNew
              context:RIDotsControlDotsSpacingContext];
}

- (void)unregisterObservers {
    [self removeObserver:self
              forKeyPath:@"dotsCount"
                 context:RIDotsControlDotsCountContext];
    
    [self removeObserver:self
              forKeyPath:@"dotsSpacing"
                 context:RIDotsControlDotsSpacingContext];
}

#pragma mark Managing KVO property changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == RIDotsControlDotsCountContext) {
        NSUInteger oldDotsCount;
        NSUInteger newDotsCount;

        [(NSValue *)change[NSKeyValueChangeOldKey] getValue:&oldDotsCount];
        [(NSValue *)change[NSKeyValueChangeNewKey] getValue:&newDotsCount];

        NSUInteger countDifference = MAX(newDotsCount, oldDotsCount) - MIN(newDotsCount, oldDotsCount);

        if (newDotsCount > oldDotsCount) {
            NSUInteger startIndex = oldDotsCount ? oldDotsCount - 1 : 0;

            [self fillDotsStackViewFrom:startIndex forCount:countDifference];
        }

        else {
            [self removeDotsFromStackViewForCount:countDifference];
        }

        return;
    }
    
    if (context == RIDotsControlDotsSpacingContext) {
        CGFloat newDotsSpacing;

        [(NSValue *)change[NSKeyValueChangeNewKey] getValue:&newDotsSpacing];

        self.dotsStackView.spacing = newDotsSpacing;

        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark Manipulating dots quantity

- (void)fillDotsStackViewFrom:(NSUInteger)startArrayIndex forCount:(NSUInteger)count {
    for (NSUInteger i = startArrayIndex; i < count; i++) {
        RIDot *dot = [[RIDot alloc] initWithState:NO dotBorderWidth:self.dotBorderWidth dotColor:UIColor.defaultDotColor];
        
        [dot.widthAnchor constraintEqualToConstant:self.dotConstraintValue].active = YES;
        [dot.heightAnchor constraintEqualToConstant:self.dotConstraintValue].active = YES;
        
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

#pragma mark -recolorDotsTo:

- (void)recolorDotsTo:(NSInteger)dotPosition {
    if (dotPosition < 0 || dotPosition > self.dotsCount) {
        NSLog(@"Dot position is out of bounds (%lu in [0 | 1 .. %lu]", dotPosition, self.dotsCount);
        return;
    }

    NSInteger min = MIN(dotPosition, self.currentDotPosition);
    NSInteger max = MAX(dotPosition, self.currentDotPosition);

    for (NSInteger i = min; i < max; i++) {
        RIDot *dot = self.dotsStackView.arrangedSubviews[i];

        dot.isOn = self.currentDotPosition < dotPosition;
    }
    
    self.currentDotPosition = dotPosition;
}

#pragma mark Initializers
 
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

#pragma mark Dealloc

- (void)dealloc {
    [self unregisterObservers];
}

@end
