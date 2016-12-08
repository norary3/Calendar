//
//  MonthViewController.m
//  CalendarDemo - Graphical Calendars Library for iOS
//
//  Copyright (c) 2014-2015 Julien Martin. All rights reserved.
//

#import "MonthViewController.h"
#import "NSCalendar+MGCAdditions.h"
#import "NSAttributedString+MGCAdditions.h"
#import "Constant.h"


@implementation MonthViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.monthPlannerView.dateFormat = @"dd MMM\nYYYY";
}

#pragma mark - MGCMonthPlannerViewController

- (void)monthPlannerViewDidScroll:(MGCMonthPlannerView *)view
{
	[super monthPlannerViewDidScroll:view];
	
	NSDate *date = [self.monthPlannerView dayAtPoint:self.monthPlannerView.center];
	if (date && [self.delegate respondsToSelector:@selector(calendarViewController:didShowDate:)]) {
		[self.delegate calendarViewController:self didShowDate:date];
	}
}


//overide method in MGCMonthPlannerEKViewController.m
 - (void)monthPlannerView:(MGCMonthPlannerView*)view didSelectDayCellAtDate:(NSDate *)date
 {
     //[super monthPlannerView:view didSelectDayCellAtDate:date]; // it calls monthPlannerView: didSelectDayCellAtDate: in MGCMonthPlannerEKViewController.m
     
     // check if can run method in this context.
     if ([self.delegate respondsToSelector:@selector(monthViewController:didSelectDayCellAtDate:)]) {
         // call monthViewController:didSelectDayCellAtDate: in MainViewController.m
         [self.delegate monthViewController:self didSelectDayCellAtDate:date];
     }
 }

- (NSAttributedString*)monthPlannerView:(MGCMonthPlannerView *)view attributedStringForDayHeaderAtDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
    }
    
    dateFormatter.dateFormat = @"d";
    NSString *dayStr = [dateFormatter stringFromDate:date];
    
    NSString *str = dayStr;
    /*  // it makes the first date of the month like Jan 1
    if (dayStr.integerValue == 1) {
        dateFormatter.dateFormat = @"MMM d";
        str = [dateFormatter stringFromDate:date];
    }
    */
    UIFont *font = [UIFont systemFontOfSize:isiPad ? 15 : 12];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{ NSFontAttributeName: font }];
    
   if ([self.calendar mgc_isDate:date sameDayAsDate:[NSDate date]]) {
        UIFont *boldFont = [UIFont boldSystemFontOfSize:isiPad ? 15 : 12];
        
        MGCCircleMark *mark = [MGCCircleMark new];
        mark.yOffset = boldFont.descender - mark.margin;
       
       [attrStr addAttributes:@{ NSFontAttributeName: boldFont, NSForegroundColorAttributeName: [UIColor whiteColor], MGCCircleMarkAttributeName: mark} range:[str rangeOfString:dayStr]];
        
       [attrStr processCircleMarksInRange:NSMakeRange(0, attrStr.length)];
   }

    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.alignment = NSTextAlignmentRight;
    para.tailIndent = -6;
    
    [attrStr addAttributes:@{ NSParagraphStyleAttributeName: para } range:NSMakeRange(0, attrStr.length)];

    return attrStr;
}

- (NSAttributedString*)monthPlannerView:(MGCMonthPlannerView *)view attributedStringForLunarDateAtDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
    }
    
    dateFormatter.dateFormat = @"d";

    NSDateComponents *comps = [self.calendar components:NSCalendarUnitWeekday fromDate:date];
    
    int weekday = (int) [comps weekday];
    
    // if it is Sunday
    if ( weekday % 7 == 1 ) {
        NSCalendar *lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setCalendar:lunarCalendar];
        
        dateFormatter.dateFormat = @"M.d";
        
        NSString *dayStr = [dateFormatter stringFromDate:date];
        
        NSString *str = dayStr;
        
        UIFont *font = [UIFont systemFontOfSize:isiPad ? 8 : 6];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{ NSFontAttributeName: font }];
        
        NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
        para.alignment = NSTextAlignmentLeft;
        para.headIndent = 6;
        
        [attrStr addAttributes:@{ NSParagraphStyleAttributeName: para } range:NSMakeRange(0, attrStr.length)];
        
        return attrStr;

    }
        return nil;
}

#pragma mark - CalendarViewControllerNavigation

- (NSDate*)centerDate
{
	MGCDateRange *visibleRange = [self.monthPlannerView visibleDays];
	if (visibleRange)
	{
		NSUInteger dayCount = [self.calendar components:NSCalendarUnitDay fromDate:visibleRange.start toDate:visibleRange.end options:0].day;
		NSDateComponents *comp = [NSDateComponents new];
		comp.day = dayCount / 2;
		NSDate *centerDate = [self.calendar dateByAddingComponents:comp toDate:visibleRange.start options:0];
		return [self.calendar mgc_startOfWeekForDate:centerDate];
	}
	return nil;
}

- (void)moveToDate:(NSDate*)date animated:(BOOL)animated
{
    if (!self.monthPlannerView.dateRange || [self.monthPlannerView.dateRange containsDate:date]) {
        [self.monthPlannerView scrollToDate:date alignment:MGCMonthPlannerScrollAlignmentWeekRow animated:animated];
    }
}

- (void)moveToNextPageAnimated:(BOOL)animated
{
	NSDate *date = [self.calendar mgc_nextStartOfMonthForDate:self.monthPlannerView.visibleDays.start];
	[self moveToDate:date animated:animated];
}

- (void)moveToPreviousPageAnimated:(BOOL)animated
{
	NSDate *date = [self.calendar mgc_startOfMonthForDate:self.monthPlannerView.visibleDays.start];
	if ([self.monthPlannerView.visibleDays.start isEqualToDate:date]) {
		NSDateComponents *comps = [NSDateComponents new];
		comps.month = -1;
		date = [self.calendar dateByAddingComponents:comps toDate:date options:0];
	}
	[self moveToDate:date animated:animated];
}

@end
