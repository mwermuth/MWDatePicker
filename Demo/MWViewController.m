//
//  MWViewController.m
//  MWNumberPicker
//
//  Created by Marcus on 08.05.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import "MWViewController.h"
#import "MWNumberPicker.h"


@interface MWViewController ()

@end

@implementation MWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    MWNumberPicker *numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
    [numberPicker setDelegate:self];
    
    [numberPicker setFontColor:[UIColor whiteColor]];
    [numberPicker update];
    
    //[numberPicker start];

    [numberPicker setNumber:[NSNumber numberWithInt:12000] animated:YES];
    [self.view addSubview:numberPicker];
    
}




#pragma mark - MWMWNumberPickerPickerDelegate

- (UIColor *) backgroundColorForNumberPicker:(MWNumberPicker *)picker
{
    return [UIColor blackColor];
}


- (UIColor *) numberPicker:(MWNumberPicker *)picker backgroundColorForComponent:(NSInteger)component
{
    
 return [UIColor blackColor];
}


- (UIColor *) viewColorForNumberPickerSelector:(MWNumberPicker *)picker
{
    return [UIColor clearColor];
}

-(void)numberPicker:(MWNumberPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
}

@end
