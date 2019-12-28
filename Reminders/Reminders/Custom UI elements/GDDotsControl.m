//
//  GDDotsControl.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/27/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "GDDotsControl.h"

// CONSTANTS:
const CGFloat dotBorderWidth = 1.25;
const CGFloat dotConstraintValue = 13;

@interface GDDotsControl ()

@property NSString *xibFileName;

@property CGFloat dotBorderWidth;
@property CGFloat dotConstraintValue;

@property NSInteger currentDotPosition;

@end

@implementation GDDotsControl

#pragma mark -setupView

- (void)setupView {
    [self setupDefaultPropertyValues];
    
    self.xibFileName = @"GDDotsControl";
    
//    https://stackoverflow.com/a/50369170
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    [bundle loadNibNamed:self.xibFileName owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self fillDotsStackViewFrom:0 forCount:self.dotsCount];
}

#pragma mark Property setters

- (void)setDotsCount:(NSUInteger)dotsCount {
    NSUInteger countDifference = MAX(dotsCount, _dotsCount) - MIN(dotsCount, _dotsCount);
    
    if (dotsCount > _dotsCount) {
        NSUInteger startIndex = _dotsCount ? _dotsCount - 1 : 0;
        
        [self fillDotsStackViewFrom:startIndex forCount:countDifference];
    } else {
        [self removeDotsFromStackViewForCount:countDifference];
    }
    
    _dotsCount = dotsCount;
}

- (void)setDotsSpacing:(CGFloat)dotsSpacing {
    _dotsSpacing = dotsSpacing;
    
    self.dotsStackView.spacing = dotsSpacing;
}

#pragma mark Default property values

- (void)setupDefaultPropertyValues {
    self.dotBorderWidth = dotBorderWidth;
    self.dotConstraintValue = dotConstraintValue;
    
    self.currentDotPosition = 0;
}

#pragma mark Manipulating dots quantity

- (void)fillDotsStackViewFrom:(NSUInteger)startArrayIndex forCount:(NSUInteger)count {
    for (NSUInteger i = startArrayIndex; i < count; i++) {
        GDDot *dot = [[GDDot alloc] initWithState:NO dotBorderWidth:self.dotBorderWidth dotColor:[UIColor blackColor]];
        
        [dot.widthAnchor constraintEqualToConstant:self.dotConstraintValue].active = YES;
        [dot.heightAnchor constraintEqualToConstant:self.dotConstraintValue].active = YES;
        
        [self.dotsStackView addArrangedSubview:dot];
    }
}

- (void)removeDotsFromStackViewForCount:(NSUInteger)count {
    NSUInteger startIndex = self.dotsStackView.arrangedSubviews.count - 1;
    
    for (NSUInteger i = startIndex; i > count; i--) {
        GDDot *dot = self.dotsStackView.arrangedSubviews[i];
        
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
        GDDot *dot = self.dotsStackView.arrangedSubviews[i];

        dot.isOn = self.currentDotPosition < dotPosition;
    }
    
    self.currentDotPosition = dotPosition;
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

- (instancetype)initWithDotsCount:(NSUInteger)dotsCount {
    self = [super init];
    
    if (self) {
        self.dotsCount = dotsCount;
    }
    
    return self;
}

@end
