//
//  MWDatePicker.h
//  MWDatePicker
//
//  Created by Marcus on 06.06.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCHelper.h"

@protocol MWPickerDataSource;
@protocol MWPickerDelegate;

@interface MWDatePicker : UIView<UITableViewDelegate, UITableViewDataSource> {
    
    CGFloat rowHeight;
    CGFloat centralRowOffset;
    
}

@property (nonatomic, ah_weak) id<MWPickerDataSource> dataSource;
@property (nonatomic, ah_weak) id<MWPickerDelegate> delegate;
@property (nonatomic, strong)NSCalendar *calendar;

- (UITableView *)tableViewForComponent:(NSInteger)component;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (void)reloadData;
- (void)reloadDataInComponent:(NSInteger)component;

@end

@protocol MWPickerDataSource <NSObject>

- (NSInteger)numberOfComponentsInDatePicker:(MWDatePicker *)picker;
- (NSInteger)datePicker:(MWDatePicker *)picker numberOfRowsInComponent:(NSInteger)component;


- (UIView *)datePicker:(MWDatePicker *)picker viewForComponent:(NSInteger)component inRect:(CGRect)rect;
- (void)datePicker:(MWDatePicker *)picker setDataForView:(UIView*)view row:(NSInteger)row inComponent:(NSInteger)component;

@optional

- (UIView *)__attribute__((deprecated)) datePicker:(MWDatePicker *)picker viewForComponent:(NSInteger)component;

- (CGFloat)heightForRowInDatePicker:(MWDatePicker *)picker;

- (CGFloat)datePicker:(MWDatePicker*)picker widthForComponent:(NSInteger)component;

@end

@protocol MWPickerDelegate <NSObject>

@optional

- (void)datePicker:(MWDatePicker*)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)datePicker:(MWDatePicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component;

- (UIView *)backgroundViewForDatePicker:(MWDatePicker*)picker;
- (UIColor *)backgroundColorForDatePicker:(MWDatePicker*)picker;

- (UIView *)datePicker:(MWDatePicker*)picker backgroundViewForComponent:(NSInteger)component;
- (UIColor *)datePicker:(MWDatePicker*)picker bdackgroundColorForComponent:(NSInteger)component;

- (UIView *)overlayViewForDatePickerSelector:(MWDatePicker *)picker;
- (UIColor *)overlayColorForDatePickerSelector:(MWDatePicker *)picker;

- (UIView *)viewForDatePickerSelector:(MWDatePicker *)picker;
- (UIColor *)colorForDatePickerSelector:(MWDatePicker *)picker;

@end
