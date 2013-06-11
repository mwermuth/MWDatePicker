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
	// Do any additional setup after loading the view, typically from a nib.
    
    MWDatePicker *datePicker = [[MWDatePicker alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-110, 55, 220, 135)];
    [datePicker setDelegate:self];
    [datePicker setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [datePicker setFontColor:[UIColor blackColor]];
    [datePicker setShouldUseShadows:NO];
    [datePicker update];
    
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
    return [UIColor whiteColor];
}


- (UIColor *) datePicker:(MWDatePicker *)picker backgroundColorForComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [UIColor whiteColor];
        case 1:
            return [UIColor whiteColor];
        case 2:
            return [UIColor whiteColor];
        default:
            return 0; // never
    }
}


- (UIColor *) viewColorForDatePickerSelector:(MWDatePicker *)picker
{
    return [UIColor clearColor];
}

@end
