//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Тимур on 11/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThemesViewController : UIViewController
{
    id<ThemesViewControllerDelegate> _delegate;
    Themes* _model;
    IBOutletCollection(UIButton) NSArray *themesButtons;
}
@property (assign, nonatomic) id<ThemesViewControllerDelegate> delegate;

- (IBAction)themeButtonTapped:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
