//
//  HistoryViewController.m
//  RaspX
//
//  Created by vito on 5/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "TemperatureFetcher.h"
#import "SessionState.h"

@implementation HistoryViewController {
    NSMutableArray *dataForPlot;
    CPTXYGraph *graph;
    NSDate *refDate;
    NSTimeInterval oneDay;
    TemperatureFetcher *fetcher;
}

@synthesize hostView, toolbar, settingsButton, nonConnectedView, loadingLabel;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SessionState *state = [SessionState sharedInstance];
    
    //toggle view depending on connectivity state
    if([state connected]) {
        [nonConnectedView setHidden:YES];
        
        //make sure fetcher is good
        if(fetcher == nil || ![[fetcher serverName] isEqualToString:state.serverName]) {
            fetcher = [[TemperatureFetcher alloc] initWithServer:[state serverName]];
        }
    } else {        
        //GOOD
        [nonConnectedView setHidden:NO];
        
#if MOCK_MODE == 1
        if(fetcher == nil || ![[fetcher serverName] isEqualToString:state.serverName]) {
            fetcher = [[TemperatureFetcher alloc] initWithServer:[state serverName]];
        }
        [nonConnectedView setHidden:YES];
#endif
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initPlot];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    num = [[dataForPlot objectAtIndex:index] valueForKey:key];
    
    return num;
}

-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)index
{
    CPTPlotSymbol *symbol = (id)[NSNull null];
    
    return symbol;
}

#pragma mark - Chart behavior
-(void)initializeData: (NSMutableArray *)data
{
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:[data count]];
    NSDictionary *firstEntity = [data objectAtIndex:0];
    NSDate *firstDate = [self parseStringToDate:[firstEntity objectForKey:@"timestamp"]];
    
    refDate = firstDate;
    
    NSUInteger i;
    for ( i = 0; i < [data count]; i++ ) {
        NSDictionary *entity = [data objectAtIndex:i];
        NSTimeInterval x = oneDay*i;
        id y = [NSNumber numberWithDouble:[[entity objectForKey:@"value"] doubleValue]];
        [contentArray addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSDecimalNumber numberWithFloat:x], @"x", 
          y, @"y", 
          nil]];
    }
    
    dataForPlot = contentArray;
}

-(NSDate *) parseStringToDate: (NSString *) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}

-(void)initPlot {
    //global const
    oneDay = 24 * 60 * 60;
    
    [[self loadingLabel] setHidden:NO];
    [[self hostView] setHidden:YES];
    
    [fetcher getHistory:^(NSMutableArray *data) {
        [self initializeData:data];
        [self configureHost];
        [self setupGraph];
        [self setupAxes];
        [self setupScatterPlots];
        
        [[self loadingLabel] setHidden:YES];
        [[self hostView] setHidden:NO];
    }];
    
    
//    [self configureLegend];
}

-(void)configureHost {    
    // 1 - Set up view frame
    CGRect parentRect = self.view.bounds;
//    CGSize toolbarSize = self.toolbar.bounds.size;
//    parentRect = CGRectMake(parentRect.origin.x, 
//                            (parentRect.origin.y + toolbarSize.height), 
//                            parentRect.size.width, 
//                            (parentRect.size.height - toolbarSize.height));
    // 2 - Create host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.view addSubview:self.hostView];
    
    [self.view bringSubviewToFront:settingsButton];
}

-(void)setupGraph
{
    // Create graph and apply a dark theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
    hostView.hostedGraph = graph;
    
    // Graph title
    graph.title = @"Temperature history";
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color                = [CPTColor grayColor];
    textStyle.fontName             = @"Helvetica-Bold";
    textStyle.fontSize             = 18.0;
    graph.titleTextStyle           = textStyle;
    graph.titleDisplacement        = CGPointMake(0.0, 10.0);
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    
    // Graph padding
    graph.paddingLeft   = 20.0;
    graph.paddingTop    = 20.0;
    graph.paddingRight  = 20.0;
    graph.paddingBottom = 20.0;
}

//-(void)configureLegend {  
//    // 1 - Get graph instance
//    CPTGraph *graph = self.hostView.hostedGraph;
//    // 2 - Create legend
//    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
//    // 3 - Configure legend
//    theLegend.numberOfColumns = 1;
//    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
//    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
//    theLegend.cornerRadius = 5.0;
//    // 4 - Add legend to graph
//    graph.legend = theLegend;     
//    graph.legendAnchor = CPTRectAnchorRight;
//    CGFloat legendPadding = -(self.view.bounds.size.width / 8);
//    graph.legendDisplacement = CGPointMake(legendPadding, 0.0);
//}

-(void)setupAxes
{
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction = YES;
    
    // Grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.75;
    majorGridLineStyle.lineColor = [[CPTColor colorWithGenericGray:0.2] colorWithAlphaComponent:0.75];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 0.25;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1];
    
    // Axes
    // Label x axis with a fixed interval policy
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    x.majorIntervalLength = CPTDecimalFromFloat(oneDay);
    x.minorTicksPerInterval       = 0;
    x.preferredNumberOfMajorTicks = 5;
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    x.title                       = @"Date";
    x.titleOffset                 = 30.0;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1");
    
    // Label y with an automatic label policy.
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
//    y.minorTicksPerInterval       = 5;
//    y.majorIntervalLength         = CPTDecimalFromInt(50);
    y.majorTickLength             = 10.0;
    y.preferredNumberOfMajorTicks = 10;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.labelOffset                 = -45.0;
    y.title                       = @"Temperature";
    y.titleOffset                 = -60.0;
    
    // added for date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    timeFormatter.referenceDate = refDate;
    axisSet.xAxis.labelFormatter = timeFormatter;
}

-(void)setupScatterPlots
{
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    
    dataSourceLinePlot.identifier     = graph.title;
    dataSourceLinePlot.cachePrecision = CPTPlotCachePrecisionDouble;
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 2.0;
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    // Set plot delegate, to know when symbols have been touched
    // We will display an annotation when a symbol is touched
    dataSourceLinePlot.delegate                        = self;
    dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0;
    
    // Auto scale the plot space to fit the plot data
    // Compress ranges so we can scroll
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    [plotSpace scaleToFitPlots:[NSArray arrayWithObject:dataSourceLinePlot]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromDouble(5.00)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromDouble(30.0)];
    plotSpace.yRange = yRange;
    
    int numberOfDays = [self getDateSpan] + 1;
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(oneDay*numberOfDays)];
    plotSpace.globalXRange = globalXRange;
    
    double maxTemperature = [self getMaxTemp];
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-5.0) length:CPTDecimalFromDouble(maxTemperature + 10.0)];
    plotSpace.globalYRange = globalYRange;
}

-(double)getMaxTemp {
    double maxTemp = 0.0;
    
    for(int i=0; i<dataForPlot.count; i++) {
        NSDictionary *entity = [dataForPlot objectAtIndex:i];
        double temp = [[entity objectForKey:@"y"] doubleValue];
        if(temp > maxTemp) {
            maxTemp = temp;
        }
    }
    
    return maxTemp;
}

-(int)getDateSpan {
    SessionState *state = [SessionState sharedInstance];
    
    return [HistoryViewController daysBetweenDate:[state fromDate] andDate:[state toDate]];
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

-(IBAction)goBack:(id)sender {
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

@end
