//
//  PageContentViewController.h
//  assignment1
//
//  Created by Hunter Houston on 2/4/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIPageViewController <UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pageImage;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
