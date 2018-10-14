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


- (void) setDelegate:(id<ThemesViewControllerDelegate>)delegate{
    _delegate = delegate;
}

- (id<ThemesViewControllerDelegate>) delegate {
    return _delegate;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
