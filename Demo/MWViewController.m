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
    
    UIButton *btnScan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnScan setTitle:@"timer" forState:UIControlStateNormal];
    [btnScan setBackgroundColor:[UIColor redColor]];
    [btnScan setFrame:CGRectMake(115,190,90,90)];
    [btnScan addTarget:self action:@selector(timerStart)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];

    
    [self.view setBackgroundColor:[UIColor blackColor]];
     numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    [numberPicker setDelegate:self];
    
    [numberPicker setFontColor:[UIColor whiteColor]];
    [numberPicker update];
    
    //

    [numberPicker setNumber:[NSNumber numberWithInt:12000] animated:YES];
    
    [self performSelector:@selector(changeNumber) withObject:nil afterDelay:2];
    
    [self.view addSubview:numberPicker];
    

    
}
-(void)timerStart{
    [numberPicker setNumber:[NSNumber numberWithInt:0] animated:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [numberPicker start];
}
-(void)changeNumber{
    // max 7 digits
    
    [numberPicker setNumber:[NSNumber numberWithInt:3557842] animated:YES];
    [self performSelector:@selector(changeNumber2) withObject:nil afterDelay:2];
}
-(void)changeNumber2{
    // max 7 digits
    
    [numberPicker setNumber:[NSNumber numberWithInt:9432577] animated:YES];
    [self performSelector:@selector(changeNumber3) withObject:nil afterDelay:1];
}
-(void)changeNumber3{
    // max 7 digits
    
    [numberPicker setNumber:[NSNumber numberWithInt:121112] animated:YES];
    [self performSelector:@selector(changeNumber) withObject:nil afterDelay:2];
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
