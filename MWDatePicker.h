//
//  MWDatePicker.h
//  MWDatePicker
//
//  Created by Marcus on 06.06.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol MWPickerDataSource;
@protocol MWPickerDelegate;

@interface MWDatePicker : UIView <UITableViewDelegate, UITableViewDataSource> {
    
    CGFloat rowHeight;
    CGFloat centralRowOffset;
    
    NSArray *minutes;
    NSArray *hours;
    NSMutableArray *day;
    
    BOOL shouldUseShadows;
    
}

@property (nonatomic, strong) id<MWPickerDelegate> delegate;
@property (nonatomic, copy)NSCalendar *calendar;

@property (nonatomic, strong)UIColor *fontColor;

- (UITableView *)tableViewForComponent:(NSInteger)component;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (void)reloadData;
- (void)update;
- (void)reloadDataInComponent:(NSInteger)component;

- (void)setShouldUseShadows:(BOOL)useShadows;

- (NSDate*)getDate;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end


@protocol MWPickerDelegate <NSObject>

@optional

- (void)datePicker:(MWDatePicker*)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)datePicker:(MWDatePicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component;

- (UIView *)backgroundViewForDatePicker:(MWDatePicker*)picker;
- (UIColor *)backgroundColorForDatePicker:(MWDatePicker*)picker;

- (UIView *)datePicker:(MWDatePicker*)picker backgroundViewForComponent:(NSInteger)component;
- (UIColor *)datePicker:(MWDatePicker*)picker backgroundColorForComponent:(NSInteger)component;

- (UIView *)overlayViewForDatePickerSelector:(MWDatePicker *)picker;
- (UIColor *)overlayColorForDatePickerSelector:(MWDatePicker *)picker;

- (UIView *)viewForDatePickerSelector:(MWDatePicker *)picker;
- (UIColor *)viewColorForDatePickerSelector:(MWDatePicker *)picker;

@end
