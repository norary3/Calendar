//
//  MGCCalendarHeaderCell.h
//  Calendar
//
//  Copyright © 2016 Julien Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGCCalendarHeaderCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *dayNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *dayNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *lunarLabel;
@property (nonatomic, strong) NSDate *date;

@end
