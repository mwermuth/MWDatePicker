//
//  MWDatePicker.m
//  MWDatePicker
//
//  Created by Marcus on 06.06.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import "MWDatePicker.h"

@interface MWDatePicker()

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

@implementation MWDatePicker



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.fontColor = [UIColor blackColor];
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

        shouldUseShadows = YES;
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
    [self fillWithCalendar];
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
    
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectRow:inComponent:)]) {
        [self.delegate datePicker:self didSelectRow:row inComponent:component];
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
    
    if([self.delegate respondsToSelector:@selector(datePicker:didClickRow:inComponent:)]){
        [self.delegate datePicker:self didClickRow:indexPath.row inComponent:component];
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
    
    rowHeight = 50;
    
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
        if ([self.delegate respondsToSelector:@selector(datePicker:backgroundViewForComponent:)]) {
            table.backgroundView = [self.delegate datePicker:self backgroundViewForComponent:i];
        } else if ([self.delegate respondsToSelector:@selector(datePicker:backgroundColorForComponent:)]) {
            table.backgroundColor = [self.delegate datePicker:self backgroundColorForComponent:i];
        } else {
            table.backgroundColor = [UIColor whiteColor];
        }
        ++i;
    }
    
    // picker background
    if ([self.delegate respondsToSelector:@selector(backgroundViewForDatePicker:)]) {
        self.backgroundView = [self.delegate backgroundViewForDatePicker:self];
        
        // add and send to back
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
    } else if ([self.delegate respondsToSelector:@selector(backgroundColorForDatePicker:)]) {
        self.backgroundColor = [self.delegate backgroundColorForDatePicker:self];
    }
    else{
        self.backgroundColor = [UIColor whiteColor];
    }
    
    // optional overlay
    if ([self.delegate respondsToSelector:@selector(overlayViewForDatePickerSelector:)]) {
        self.overlay = [self.delegate overlayViewForDatePickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(overlayColorForDatePickerSelector:)]) {
        self.overlay = [[UIView alloc] init];
        self.overlay.backgroundColor = [self.delegate overlayColorForDatePickerSelector:self];
    }
    
    if (self.overlay) {
        
        // ignore user input on selector
        self.overlay.userInteractionEnabled = NO;
        
        // fill parent
        self.overlay.frame = self.bounds;
        [self addSubview:self.overlay];
    }
    
    // custom selector?
    if ([self.delegate respondsToSelector:@selector(viewForDatePickerSelector:)]) {
        self.selector = [self.delegate viewForDatePickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(viewColorForDatePickerSelector:)]) {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [self.delegate viewColorForDatePickerSelector:self];
        self.selector.alpha = 0.3;
    } else {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [UIColor blackColor];
        self.selector.alpha = 0.3;
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

#pragma mark - Date Configuration

- (void)fillWithCalendar{
    minutes = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    hours = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:1971];
    NSCalendar *calendar = self.calendar;
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    NSDate *curDate = [calendar dateFromComponents:comps];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    
    [comps2 setDay:31];
    [comps2 setMonth:12];
    [comps2 setYear:2100];
    NSDate *endDate = [calendar dateFromComponents:comps2];
    
    day = [NSMutableArray array];
    while([curDate timeIntervalSince1970] <= [endDate timeIntervalSince1970]) //you can also use the earlier-method
    {
        [day addObject:curDate];
        curDate = [NSDate dateWithTimeInterval:86400 sinceDate:curDate];
    }
    
}

- (void)updateWithMinimumDate{
    
    [day removeAllObjects];
    
    NSCalendar *calendar = self.calendar;
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    
    [comps2 setDay:31];
    [comps2 setMonth:12];
    [comps2 setYear:2100];
    NSDate *endDate = [calendar dateFromComponents:comps2];
    NSDate *minDatecopy = [minDate copy];
    
    day = [NSMutableArray array];
    while([minDatecopy timeIntervalSince1970] <= [endDate timeIntervalSince1970]) //you can also use the earlier-method
    {
        [day addObject:minDatecopy];
        minDatecopy = [NSDate dateWithTimeInterval:86400 sinceDate:minDatecopy];
    }

}


- (NSInteger) numberOfComponents
{
    return 3;
}


- (NSInteger) numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [day count];
    }
    else if (component == 1){
        return [hours count];
    }
    else if (component == 2){
        return [minutes count];
    }
    
    return 0;
}

- (void) setDataForView:(UIView *)view row:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *label = (UILabel *) view;
    
    
    if (component == 0) {
        
        NSDate *d = [day objectAtIndex:row];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EE dd.MMM";
        
        label.text = [dateFormatter stringFromDate:d];
        
    }
    else if (component == 1){
        label.text = [hours objectAtIndex:row%24];
        
    }
    else if (component == 2){
        label.text = [minutes objectAtIndex:row%60];
        
    }
}

- (UIView *) viewForComponent:(NSInteger)component inRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (component) {
        case 0:
            label.textColor = self.fontColor;
            label.font = [UIFont systemFontOfSize:19.0];
            break;
        case 1:
            label.textColor = self.fontColor;
            label.font = [UIFont systemFontOfSize:33.0];
            break;
        case 2:
            label.textColor = self.fontColor;
            label.font = [UIFont systemFontOfSize:33.0];
            break;
    }
    
    return label;
}


- (CGFloat) widthForComponent:(NSInteger)component
{
    CGFloat width = self.frame.size.width;
    
    switch (component) {
        case 0:
            width *= 0.55;
            break;
        case 1:
            width *= 0.25;
            break;
        case 2:
            width *= 0.25;
            break;
        default:
            return 0; // never
    }
    
    return round(width);
}


#pragma mark - Date Method

- (void)setMinimumDate:(NSDate *)minimumDate{
    
    minDate = minimumDate;
    
    NSDate *cur =[self getDate];
    
    [self removeContent];
    [self addContent];
    
    [self updateDelegateSubviews];
    [self updateWithMinimumDate];
    [self setDate:cur animated:NO];
    [self reloadData];
    
}

- (NSDate *)minimumDate{
    return minDate;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated{
    
    self.calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *dateComponents = [self.calendar components:(NSHourCalendarUnit  | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    
    [self selectRow:hour inComponent:1 animated:YES];
    [self selectRow:minute inComponent:2 animated:YES];
    
    NSTimeInterval secondsBetween;
    if (minDate != nil) {
        secondsBetween = [date timeIntervalSinceDate:minDate];
    }
    else{
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:1];
        [comps setMonth:1];
        [comps setYear:1971];
        
        NSDate *date2 = [self.calendar dateFromComponents:comps];
        
        secondsBetween = [date timeIntervalSinceDate:date2];

    }
    
    int numberOfDays = secondsBetween / 86400;
    
    [self selectRow:numberOfDays inComponent:0 animated:YES];
}

- (NSDate*)getDate{
    
    NSInteger comp0 = [self selectedRowInComponent:0];
    NSTimeInterval secondsBetween = comp0 * 86400;
    
    NSDate *start;
    if (minDate != nil) {
        start = minDate;
    }
    else{
        start = [self dateWithYear:1971 month:1 day:1 hour:0 minute:0];
    }

    NSDate *selectedWithOut = [NSDate dateWithTimeInterval:secondsBetween sinceDate:start];
    
    self.calendar.timeZone = [NSTimeZone localTimeZone];

    NSDateComponents *components = [self.calendar components: NSUIntegerMax fromDate:selectedWithOut];
    [components setHour: ([self selectedRowInComponent:1]%24)];
    [components setMinute: [self selectedRowInComponent:2]%60];
    
    return [self.calendar dateFromComponents: components];
    
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
    self.calendar.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Paris"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:yearS];
    [components setMonth:monthS];
    [components setDay:dayS];
    [components setHour:hourS];
    [components setMinute:minuteS];
    return [self.calendar dateFromComponents:components];
}


- (void)setShouldUseShadows:(BOOL)useShadows{
    
    shouldUseShadows = useShadows;
    [self update];
}

@end
