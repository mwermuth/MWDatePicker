//
//  MWNumberPicker.m
//  MWNumberPicker
//
//  Created by Marcus on 06.06.13.
//  Adapted by John Pope
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import "MWNumberPicker.h"


@interface MWNumberPicker()

@property (nonatomic, strong)NSMutableArray *tables;
@property (nonatomic, strong)NSMutableArray *selectedRowIndexes;
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)UIView *overlay;
@property (nonatomic, strong)UIView *selector;


- (void)addContent;
- (void)removeContent;
- (void)updateDelegateSubviews;

- (NSInteger)componentFromTableView:(UITableView*)tableView;
- (void)alignTableViewToRowBoundary:(UITableView*)tableView;

@end

@implementation MWNumberPicker



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        /* To emulate infinite scrolling...
         
         The table data was doubled to join the head and tail.
         When the user scrolls backwards to 1/8th of the new table, user is at the 1/4th of actual data, so we scroll to 5/8th of the new table where the cells are exactly the same.
         
         Similarly, when user scrolls to 6/8th of the table, we will scroll back to 3/8th where the cells are same.
         
         In simple words, when user reaches 1/4th of the first part of table, we scroll to 1/4th of the second part, when he reaches 3/4th of the second part of table, we scroll to the 3/4 of first part. This is done simply by subtracting OR adding half the length of the new table.
         
         (C) Anup Kattel, you can copy this code, please leave these comments if you don't mind.
         */
        autoScrolling = NO;

        digits = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
        
        self.fontColor = [UIColor blackColor];
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

        shouldUseShadows = NO;
    }
    return self;
}

- (void) dealloc{
    
    self.tables = nil;
    self.selectedRowIndexes = nil;
    
    self.backgroundView = nil;
    self.overlay = nil;
    self.selector = nil;
    
}

- (void)update{
    [self removeContent];
    [self addContent];
    [self updateDelegateSubviews];
    [self reloadData];
}


- (UITableView *)tableViewForComponent:(NSInteger)component{
    
    return [self.tables objectAtIndex:component];
}

- (NSInteger) selectedRowInComponent:(NSInteger)component{
    
    return [[self.selectedRowIndexes objectAtIndex:component] integerValue];
}

-(void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    
    [self.selectedRowIndexes replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    
    UITableView *table = [self.tables objectAtIndex:component];
    
    const CGPoint alignedOffset = CGPointMake(0, row*table.rowHeight - table.contentInset.top);
    [table setContentOffset:alignedOffset animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(numberPicker:didSelectRow:inComponent:)]) {
        [self.delegate numberPicker:self didSelectRow:row inComponent:component];
    }
}

-(void) reloadData{
    
    for (UITableView *table in self.tables) {
        [table reloadData];
    }
}


-(void) reloadDataInComponent:(NSInteger)component{
    
    [[self.tables objectAtIndex:component] reloadData];
}


#pragma mark - UITableView DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    const NSInteger component = [self componentFromTableView:tableView];
    return [self numberOfRowsInComponent:component];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"PickerCell";
    static const NSInteger tag = 4223;
    
    const NSInteger component = [self componentFromTableView:tableView];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIView *view = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [UIView new];
        cell.backgroundColor = [UIColor clearColor];
        
        const CGRect viewRect = cell.contentView.bounds;
        
        view = [self viewForComponent:component inRect:viewRect];

        
        view.frame = viewRect;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.tag = tag;
        cell.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        [cell.contentView addSubview:view];
    }
    else{
        
        view = [cell.contentView viewWithTag:tag];
    }
    
    [self setDataForView:view row:indexPath.row inComponent:component];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    const NSInteger component = [self componentFromTableView:tableView];
    
    if([self.delegate respondsToSelector:@selector(numberPicker:didClickRow:inComponent:)]){
        [self.delegate numberPicker:self didClickRow:indexPath.row inComponent:component];
    }

    [self selectRow:indexPath.row inComponent:component animated:YES];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self alignTableViewToRowBoundary:(UITableView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self alignTableViewToRowBoundary:(UITableView *)scrollView];
}

#pragma mark - Content managemet

- (void)addContent{
    
    if (IS_IPAD) {
            rowHeight = 100;
    }else{
        rowHeight = 50;
    }

    
    centralRowOffset = (self.frame.size.height - rowHeight)/2;
    
    const NSInteger components = [self numberOfComponents];
    
    self.tables = [[NSMutableArray alloc] init];
    self.selectedRowIndexes = [[NSMutableArray alloc] init];
    
    CGRect tableFrame = CGRectMake(0, 0, 0, self.bounds.size.height);
    for (NSInteger i = 0; i<components; ++i) {
        
        tableFrame.size.width = [self widthForComponent:i];

        
        UITableView *table = [[UITableView alloc] initWithFrame:tableFrame];
        table.rowHeight = rowHeight;
        table.contentInset = UIEdgeInsetsMake(centralRowOffset, 0, centralRowOffset, 0);
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        
        table.dataSource = self;
        table.delegate = self;
        table.tag = i;
        [self addSubview:table];
        
        [self.tables addObject:table];
        [self.selectedRowIndexes addObject:[NSNumber numberWithInteger:0]];
        
        tableFrame.origin.x += tableFrame.size.width-5;
    }
    
    if (shouldUseShadows) {
        UIView *upperShadow = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height*1/3)];
        //[v setBackgroundColor:[UIColor greenColor]];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = upperShadow.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [upperShadow.layer insertSublayer:gradient atIndex:0];
        [upperShadow setUserInteractionEnabled:NO];
        
        [self addSubview:upperShadow];
        
        UIView *lowerShadow = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.bounds.size.height-self.bounds.size.height*1/3, self.bounds.size.width, self.bounds.size.height*1/3)];
        //[v setBackgroundColor:[UIColor greenColor]];
        CAGradientLayer *gradient2 = [CAGradientLayer layer];
        gradient2.frame = lowerShadow.bounds;
        gradient2.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [lowerShadow.layer insertSublayer:gradient2 atIndex:0];
        [lowerShadow setUserInteractionEnabled:NO];
        
        [self addSubview:lowerShadow];
    }


}


- (void)removeContent
{
    // remove tables
    for (UITableView *table in self.tables) {
        [table removeFromSuperview];
    }
    self.tables = nil;
    
    // remove indexes
    self.selectedRowIndexes = nil;
    
    // remove background
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    // remove overlay
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    
    // remove selector
    [self.selector removeFromSuperview];
    self.selector = nil;
}


- (void)updateDelegateSubviews
{
    // remove delegate subviews
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    [self.selector removeFromSuperview];
    self.selector = nil;
    
    // component background view/color
    NSUInteger i = 0;
    for (UITableView *table in self.tables) {
        if ([self.delegate respondsToSelector:@selector(numberPicker:backgroundViewForComponent:)]) {
            table.backgroundView = [self.delegate numberPicker:self backgroundViewForComponent:i];
        } else if ([self.delegate respondsToSelector:@selector(numberPicker:backgroundColorForComponent:)]) {
            table.backgroundColor = [self.delegate numberPicker:self backgroundColorForComponent:i];
        } else {
            table.backgroundColor = [UIColor blackColor];
        }
        ++i;
    }
    
    // picker background
    if ([self.delegate respondsToSelector:@selector(backgroundViewForNumberPicker:)]) {
        self.backgroundView = [self.delegate backgroundViewForNumberPicker:self];
        
        // add and send to back
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
    } else if ([self.delegate respondsToSelector:@selector(backgroundColorForNumberPicker:)]) {
        self.backgroundColor = [self.delegate backgroundColorForNumberPicker:self];
    }
    else{
        self.backgroundColor = [UIColor blackColor];
    }
    
    // optional overlay
    if ([self.delegate respondsToSelector:@selector(overlayViewForNumberPickerSelector:)]) {
        self.overlay = [self.delegate overlayViewForNumberPickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(overlayColorForNumberPickerSelector:)]) {
        self.overlay = [[UIView alloc] init];
        self.overlay.backgroundColor = [self.delegate overlayColorForNumberPickerSelector:self];
    }
    
    if (self.overlay) {
        
        // ignore user input on selector
        self.overlay.userInteractionEnabled = NO;
        
        // fill parent
        self.overlay.frame = self.bounds;
        [self addSubview:self.overlay];
    }
    
    // custom selector?
    if ([self.delegate respondsToSelector:@selector(viewForNumberPickerSelector:)]) {
        self.selector = [self.delegate viewForNumberPickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(viewColorForNumberPickerSelector:)]) {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [self.delegate viewColorForNumberPickerSelector:self];
       self.selector.alpha = 0.0;
    } else {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [UIColor redColor];
        self.selector.alpha = 0.0;
    }
    
    // ignore user input on selector
    self.selector.userInteractionEnabled = NO;
    
    // override selector frame
    CGRect selectorFrame;
    selectorFrame.origin.x = 0;
    selectorFrame.origin.y = centralRowOffset;
    selectorFrame.size.width = self.frame.size.width;
    selectorFrame.size.height = rowHeight;
    self.selector.frame = selectorFrame;
    
    [self addSubview:self.selector];

    
}

// TODO make this dynamic
- (NSInteger) numberOfComponents
{
    return 7;
}


- (NSInteger) numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
          return 9;
    }
    else if (component == 1){
         return [digits count];
    }
    else if (component == 2){
        return [digits count];
    }
    
    return [digits count];;
}

- (void) setDataForView:(UIView *)view row:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *label = (UILabel *) view;
    
    
    if (component == 0) {
        
      label.text = [digits objectAtIndex:row%60];
        
    }
    else if (component == 1){
     label.text = [digits objectAtIndex:row%60];
        
    }
    else if (component == 2){
        label.text = [digits objectAtIndex:row%60];
        
    }
    label.text = [digits objectAtIndex:row%60];
    
}

- (UIView *) viewForComponent:(NSInteger)component inRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = self.fontColor;
    if (IS_IPAD) {
            label.font = [UIFont systemFontOfSize:120];
    }else{
        label.font = [UIFont systemFontOfSize:60];
    }
    return label;
}


- (CGFloat) widthForComponent:(NSInteger)component
{
    CGFloat width = self.frame.size.width/[self numberOfComponents];
    

    return round(width );
}


#pragma mark - Number Picker Method


- (void)setNumber:(NSNumber*)num animated:(BOOL)animated{
    autoScrolling = YES;

    int x=0;
    for (UITableView *tv in self.tables) {
         [self selectRow:0 inComponent:x animated:NO]; //reset this - to do work out how to hide rows
        x++;
    }
    int number = [num intValue];

    NSMutableArray *arr = [NSMutableArray array];
    
    while ( number != 0 ) {
        int right_digit = number % 10;
        // NSLog (@"arr:%@", arr);
        [arr addObject:[NSNumber numberWithInt:right_digit]];
        number /= 10;
    }
    
    int i=[[self tables] count]-1;
    for (NSNumber *num in arr) {
        [self selectRow:[num intValue] inComponent:i animated:animated];
        i--;
    }
   // autoScrolling = NO; - need to delay this
}




#pragma mark - Other methods

- (NSInteger)componentFromTableView:(UITableView *)tableView
{
    return [self.tables indexOfObject:tableView];
}

- (void)alignTableViewToRowBoundary:(UITableView *)tableView
{
    const CGPoint relativeOffset = CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
    const NSUInteger row = round(relativeOffset.y / tableView.rowHeight);
    
    const NSInteger component = [self componentFromTableView:tableView];
    [self selectRow:row inComponent:component animated:YES];
}

- (NSDate *)dateWithYear:(NSInteger)yearS month:(NSInteger)monthS day:(NSInteger)dayS hour:(NSInteger)hourS minute:(NSInteger)minuteS {
    return [NSDate date];
}


- (void)setShouldUseShadows:(BOOL)useShadows{
    
    shouldUseShadows = useShadows;
    [self update];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    if (autoScrolling) {
           return; // we're time bombing
    }
 
    CGFloat currentOffsetX = scrollView_.contentOffset.x;
    CGFloat currentOffSetY = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height;
    
    //don't allow infinite scrolling back on first row
    if (scrollView_.tag == [self.tables count] -1) {
    
        // if all the selected indexes are 0!!!
        if (currentOffSetY > ((contentHeight * 6)/ 8.0)) {
            scrollView_.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY - (contentHeight/2)));
        }
        return;
    }
    //When the user scrolls backwards to 1/8th of the new table, user is at the 1/4th of actual data, so we scroll to 5/8th of the new table where the cells are exactly the same.
    if (currentOffSetY < (contentHeight / 8.0)) {
        scrollView_.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY + (contentHeight/2)));
    }
    //Similarly, when user scrolls to 6/8th of the table, we will scroll back to 3/8th where the cells are same.

    if (currentOffSetY > ((contentHeight * 6)/ 8.0)) {
        scrollView_.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY - (contentHeight/2)));
    }
   

    
}

static CGFloat kFlipAnimationUpdateInterval = 0.5; // = 2 times per second
#pragma mark update timer


- (void)start;
{
    if (self.animationTimer == nil) {
        [self setupUpdateTimer];
    }
}

- (void)stop;
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

- (void)setupUpdateTimer;
{
    self.animationTimer = [NSTimer timerWithTimeInterval:kFlipAnimationUpdateInterval
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimer:(NSTimer*)timer;
{
    [self updateValuesAnimated:YES];
}

- (void)updateValuesAnimated:(BOOL)animated;
{
 
    int number = masterDigit;
    NSLog (@"%i", masterDigit);
    NSMutableArray *arr = [NSMutableArray array];
    
    while ( number != 0 ) {
        int right_digit = number % 10;
       // NSLog (@"arr:%@", arr);
        [arr addObject:[NSNumber numberWithInt:right_digit]];
        number /= 10;
    }
    
    masterDigit++;

    int i=[[self tables] count]-1;
    for (NSNumber *num in arr) {
        [self selectRow:[num intValue] inComponent:i animated:YES];
        i--;
    }
    
    
 
}




@end
