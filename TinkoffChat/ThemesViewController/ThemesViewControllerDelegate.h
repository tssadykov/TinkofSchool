//
//  ThemesViewControllerDelegate.h
//  TinkoffChat
//
//  Created by Тимур on 11/10/2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThemesViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ThemesViewControllerDelegate <NSObject>
-(void)themesViewController: (ThemesViewController *)controller didSelect:(UIColor *)selectedTheme;
@end

NS_ASSUME_NONNULL_END
