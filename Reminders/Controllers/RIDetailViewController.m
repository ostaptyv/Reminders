//
//  RIDetailViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIDetailViewController.h"
#import "RIConstants.h"
#import "RIImageAttachmentCollectionViewCell.h"

@interface RIDetailViewController ()

@property (strong, nonatomic) NSArray<UIImage *> *arrayOfImages;

@end

@implementation RIDetailViewController

#pragma mark - View did load method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDetailVcDependingOnGivenReminder];
    
    [self setupScrollView];
    [self setupTextView];
    [self setupCollectionView];
    
    [self handleArrayOfImagesCountChange:self.arrayOfImages.count];
}

#pragma mark - Creating instance

+ (RIDetailViewController *)instanceWithRawReminder:(RIReminderRaw *)reminder {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    RIDetailViewController *detailVc = [storyboard instantiateInitialViewController];

    detailVc.reminder = reminder;
    
    return detailVc;
}

#pragma mark - Setup detail VC depending on given reminder

- (void)setupDetailVcDependingOnGivenReminder {
    self.textView.text = self.reminder.text;
    self.arrayOfImages = self.reminder.arrayOfImages;
}

#pragma mark - Setup UI

- (void)setupScrollView {
    self.scrollView.contentInset = UIEdgeInsetsMake(kScrollViewTopContentInset, 0.0, kScrollViewBottomContentInset, 0.0);
}

- (void)setupTextView {
    self.textView.editable = NO;
}

- (void)setupCollectionView {
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0, kCollectionViewSectionInset, 0.0, kCollectionViewSectionInset);
}

#pragma mark - Collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RIImageAttachmentCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:RIImageAttachmentCollectionViewCell.reuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = self.arrayOfImages[indexPath.item];
    cell.removeButton.hidden = YES;
    
    [cell setupUI];
    
    return cell;
}

#pragma mark - Hide collection view depending on 'arrayOfImages' count

- (void)handleArrayOfImagesCountChange:(NSUInteger)newCount {
    if (newCount == 0) {
        self.collectionView.hidden = YES;
    } else {
        self.collectionView.hidden = NO;
    }
}

@end
