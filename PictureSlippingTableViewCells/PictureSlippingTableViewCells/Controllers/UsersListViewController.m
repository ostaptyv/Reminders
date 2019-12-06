//
//  UsersListViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UsersListViewController.h"
#import "UsersTableViewCell.h"
#import "ImageLoadOperation.h"
#import "ImageOutputOperation.h"
#import "ImageProvider.h"

@interface UsersListViewController ()

@property NSArray<NSString *> *userNamesArray;
@property NSArray<NSURL *> *imageUrlsArray;

@property NSMutableSet<ImageProvider *> *imageProvidersSet;

@property int countOfCellsInTableView;

@end

@implementation UsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.userNamesArray = @[@"Wade", @"Dave", @"Seth", @"Ivan", @"Riley", @"Gilbert", @"Jorge", @"Dan", @"Brian", @"Roberto", @"Ramon", @"Miles", @"Liam", @"Nathaniel", @"Ethan", @"Lewis", @"Milton", @"Claude", @"Joshua", @"Glen", @"Harvey", @"Blake", @"Antonio", @"Connor", @"Julian", @"Aidan", @"Harold", @"Conner", @"Peter", @"Hunter"];
    self.imageUrlsArray = [self makeImageUrlsArray];
    
    self.imageProvidersSet = [NSMutableSet setWithCapacity:self.userNamesArray.count];
    
    self.countOfCellsInTableView = 2500;
    
    [self setupNavigationBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countOfCellsInTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:UsersTableViewCell.reuseIdentifier forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![cell isKindOfClass:[UsersTableViewCell class]]) { return; }
    UsersTableViewCell *castedCell = cell;
    
    long index = indexPath.row % self.userNamesArray.count;
    
    NSString *text = self.userNamesArray[index];
    NSURL *url = self.imageUrlsArray[index];
    
    castedCell.nameLabel.text = text;
    [castedCell setImageUrl:url];
    
    ImageProvider *imageProvider = [[ImageProvider alloc] initWithImageUrl:url completion:^(UIImage * image) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{ castedCell.profilePicImageView.image = image; }];
    }];
    
    [self.imageProvidersSet addObject:imageProvider];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![cell isKindOfClass:[UsersTableViewCell class]]) { return; }
    
    UsersTableViewCell *castedCell = cell;
        
    void (^enumerationBlock)(ImageProvider * _Nonnull, BOOL * _Nonnull) = ^(ImageProvider *imageProvider, BOOL *stop) {
        if (imageProvider.imageUrl != castedCell.imageUrl) { return; }
        
        [imageProvider cancel];
        [self.imageProvidersSet removeObject:imageProvider];
        
        *stop = YES;
    };
    
    [self.imageProvidersSet enumerateObjectsUsingBlock:enumerationBlock];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (NSArray<NSURL *> *)makeImageUrlsArray {
    NSArray<NSString *> *stringUrlsArray = @[
    @"https://image.shutterstock.com/image-photo/man-poses-passport-photo-260nw-207377266.jpg",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMpzzamsRwuL15kqxATgPw_sseWOohEAT9pAg5PkO4KaXkEuFS&s",
    @"https://d2v9ipibika81v.cloudfront.net/uploads/sites/25/mars-e1566404404158.jpg",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6tuHFIWB0WxP3P8vAvrc30VlqrVL_JhhDhnWQkDKyzMlv1BF_&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8S3cFaXnxZaMD23M5lPbzYDOWLOqTUG_dObrIAvrYnppwsZhI&s",
    @"https://qph.fs.quoracdn.net/main-raw-633989463-rftvtjtzipztpvvmkrxwrxogjrrxystg.jpeg",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwkADtoUM1m2Xhi6w2aDyKMCE-ptCudV7EYbEt6c2qcSw7o3-n&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSORVlCMrKaELQTYANWsGiPlCaeS2xitphEbggYNHRwOyKDzZA2&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1H0arQsVnJbAgJ3k9M8ND34iopfs-1f31G5ay_njiLqckgPn-&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-I-nSuMqsxrclMWkBbIQY4qwPO2kRhevrcyomQ9IWHJRsE5XD&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRe5BQj4Z7_rRvsbYbyU0Gk_pCEFv-as3R5vNV0NGmkOscqxmFO&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgEl_QaHIa0CYsaKqll14uWxFveLi-eA9yjemV5djL15gn8YVF&s",
    @"https://us.123rf.com/450wm/kadettmann/kadettmann1505/kadettmann150500001/39586822-portrait-of-a-german-guy-with-beard.jpg?ver=6",
    @"https://image.shutterstock.com/image-photo/passport-picture-cool-guy-blue-260nw-288530261.jpg",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2XDbBBm-K2lwAAYNCNYaKwGYfmgk6PwBwAztAlfexEo9RDCjB&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQg2hLtnPHjFn5VCypTc705olMTK7wp7nR5AzTfOH9CaZ3YAl5F&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMhjfhNxsoF8FeOsNA0SAPQt9O7D3XOBiHcxSIvK8tn05FcS22&s",
    @"https://images.squarespace-cdn.com/content/v1/54ff160de4b0a76e3a90696a/1562150296188-4XEX3JKWVO9CJX5I4UOO/ke17ZwdGBToddI8pDm48kOyctPanBqSdf7WQMpY1FsRZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwwQIrqN0bcqL_6-iJCOAA0qwytzcs0JTq1XS2aqVbyK6GtMIM7F0DGeOwCXa63_4k/us+American+passport+visa+photo+bath?format=1000w",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTef4IrjmrNd3UqxhUKSNCuTCG4k8FSf9glPV6f_WiUvPNoKeQV&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRSWQj74VIqXoXdrdXnZOd0fd4j4CQZ825OkGbnf5jqikzEFcAEQ&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh412ICvQy_a7OAp0ZDiuWlCm08kel5mUQYvrGBhDDmlJkaJ_N&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwKsL6F-6Z18HrtEBdzyb49pIWSAWzIG0JTY7088BJyxbxx3U2&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR64mYX2tl_AWtznoo5-0WR169L6ZxmPF8kq7qmXF5U6uTDG33G&s",
    @"https://previews.123rf.com/images/warrengoldswain/warrengoldswain1610/warrengoldswain161000192/65426145-portrait-de-l-homme-réel-caucasien-blanc-sans-id-d-expression-ou-d-un-passeport-photo-collect.jpg",
    @"https://image.shutterstock.com/image-photo/calm-interesting-bearded-guy-trendy-260nw-1017384106.jpg",
    @"https://s3-us-west-1.amazonaws.com/bruinlife/wp-content/uploads/2018/05/02172440/2B8_5799.jpg",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUyP_tmQk5LYHW1BgoxpVcl-_urvmKSOd0jifFXRfZoUZAA1wG&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRneQDHR_zbbqMZG4zEPz-YbMju66bSoiQfTXUcYq0GSBUPl3ZU&s",
    @"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQT2f-RCo1KAyAHaI0Ke1o4m4uv937r0DZjg47VzKRWw0O8NZu&s",
    @"http://www.pngall.com/wp-content/uploads/2016/04/Mark-Zuckerberg-Free-Download-PNG.png"
    ];
    
    NSMutableArray<NSURL *> *result = [NSMutableArray arrayWithCapacity:stringUrlsArray.count];
    NSURL *failedToLoadImagePlaceholderUrl = [[NSBundle mainBundle] URLForResource:@"placeholder" withExtension:@"png"];

    for (int i = 0; i < stringUrlsArray.count; i++) {
        NSURL *imageUrl = [NSURL URLWithString:stringUrlsArray[i]];
        
        imageUrl = imageUrl != nil ? imageUrl : failedToLoadImagePlaceholderUrl;
        
        [result addObject:imageUrl];
    }
    
    return result;
}

@end
