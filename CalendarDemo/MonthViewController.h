//
//  MonthViewController.h
//  CalendarDemo - Graphical Calendars Library for iOS
//
//  Copyright (c) 2014-2015 Julien Martin. All rights reserved.
//

#import "MGCMonthPlannerEKViewController.h"
#import "MainViewController.h"

@class MonthViewController;

@protocol MonthViewControllerDelegate<MGCMonthPlannerViewDelegate, CalendarViewControllerDelegate, UIViewControllerTransitioningDelegate>

@optional
- (void) monthViewController:(MonthViewController*)controller didSelectDayCellAtDate:(NSDate*)date;

@end


@interface MonthViewController : MGCMonthPlannerEKViewController <CalendarViewControllerNavigation>

@property (nonatomic, weak) id<MonthViewControllerDelegate> delegate;

@end
