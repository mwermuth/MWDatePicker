//
//  MWViewController.m
//  MWDatePicker
//
//  Created by Marcus on 08.05.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import "MWViewController.h"

@interface MWViewController ()

@end

@implementation MWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MWDatePicker *datePicker = [[MWDatePicker alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-110, 55, 220, 135)];
    [datePicker setDelegate:self];
    
    // Set the type of Calendar the Dates should live in
    [datePicker setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [datePicker setFontColor:[UIColor whiteColor]];
    [datePicker update];
    
    // Set the Minimum Date you want to show to the user
    [datePicker setMinimumDate:[NSDate date]];
    
    // Set the Date the Picker should show at the beginning
    [datePicker setDate:[NSDate date] animated:YES];

    [self.view addSubview:datePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MWPickerDelegate

- (UIColor *) backgroundColorForDatePicker:(MWDatePicker *)picker
{
    return [UIColor blackColor];
}


- (UIColor *) datePicker:(MWDatePicker *)picker backgroundColorForComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [UIColor blackColor];
        case 1:
            return [UIColor blackColor];
        case 2:
            return [UIColor blackColor];
        default:
            return 0; // never
    }
}


- (UIColor *) viewColorForDatePickerSelector:(MWDatePicker *)picker
{
    return [UIColor grayColor];
}

-(void)datePicker:(MWDatePicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%@",[picker getDate]);
}

@end
