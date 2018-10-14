//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Тимур on 11/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

#import "ThemesViewController.h"

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _model = [[Themes alloc] init];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[[self.navigationController navigationBar] barTintColor]];
}

- (void) setDelegate:(id<ThemesViewControllerDelegate>)delegate{
    _delegate = delegate;
}

- (id<ThemesViewControllerDelegate>) delegate {
    return _delegate;
}

- (void)dealloc {
    [themesButtons release];
    [_model release];
    printf("DEALLOC\n");
    [super dealloc];
}

- (IBAction)themeButtonTapped:(UIButton *)sender {
    if (sender == [themesButtons objectAtIndex:0]) {
        [_delegate themesViewController:self didSelect:[_model theme1]];
        [[self.navigationController navigationBar] setBarTintColor:[_model theme1]];
    } else if (sender == [themesButtons objectAtIndex:1]) {
        [_delegate themesViewController:self didSelect:[_model theme2]];
        [[self.navigationController navigationBar] setBarTintColor:[_model theme2]];
    } else {
        [_delegate themesViewController:self didSelect:[_model theme3]];
        [[self.navigationController navigationBar] setBarTintColor:[_model theme3]];
    }
}

@end
