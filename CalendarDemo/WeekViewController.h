//
//  WeekViewController.h
//  CalendarDemo - Graphical Calendars Library for iOS
//
//  Copyright (c) 2014-2015 Julien Martin. All rights reserved.
//

#import "MGCDayPlannerEKViewController.h"
#import "MainViewController.h"

@class WeekViewController;

@protocol WeekViewControllerDelegate <MGCDayPlannerViewDelegate, MGCDayPlannerEKViewControllerDelegate, CalendarViewControllerDelegate, UIViewControllerTransitioningDelegate>

@optional
- (void) dayPlannerView:(WeekViewController*)controller didSelectDayCellAtDate:(NSDate*)date;

@end


@interface WeekViewController : MGCDayPlannerEKViewController <CalendarViewControllerNavigation>

@property (nonatomic, weak) id<WeekViewControllerDelegate> delegate;
@property (nonatomic) BOOL showDimmedTimeRanges;

@end
