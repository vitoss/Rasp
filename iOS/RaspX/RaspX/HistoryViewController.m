//
//  HistoryViewController.m
//  RaspX
//
//  Created by vito on 5/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"

@implementation HistoryViewController {
    NSMutableArray *dataForPlot;
    CPTXYGraph *graph;
}

@synthesize hostView, toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
-(void)initializeData
{
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
    
    for ( NSUInteger i = 0; i < 100; i++ ) {
        NSNumber *x = [NSNumber numberWithDouble:i * 0.05];
        NSNumber *y = [NSNumber numberWithDouble:10.0 * rand() / (double)RAND_MAX - 5.0];
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    
    dataForPlot = contentArray;
}

-(void)initPlot {
    [self initializeData];
    [self configureHost];
    [self setupGraph];
    [self setupAxes];
    [self setupScatterPlots];
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
}

-(void)setupGraph
{
    // Create graph and apply a dark theme
    graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
    hostView.hostedGraph = graph;
    
    // Graph title
    graph.title = @"This is the Graph Title";
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
    x.minorTicksPerInterval       = 7;
    x.preferredNumberOfMajorTicks = 5;
    x.majorGridLineStyle          = majorGridLineStyle;
    x.minorGridLineStyle          = minorGridLineStyle;
    x.title                       = @"Date";
    x.titleOffset                 = 30.0;
    
    // Label y with an automatic label policy.
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy              = CPTAxisLabelingPolicyAutomatic;
    y.minorTicksPerInterval       = 10;
    y.preferredNumberOfMajorTicks = 8;
    y.majorGridLineStyle          = majorGridLineStyle;
    y.minorGridLineStyle          = minorGridLineStyle;
    y.labelOffset                 = 10.0;
    y.title                       = @"Temperature";
    y.titleOffset                 = 30.0;
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
    [xRange expandRangeByFactor:CPTDecimalFromDouble(0.75)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromDouble(0.75)];
    plotSpace.yRange = yRange;
    
    CPTPlotRange *globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-1.0) length:CPTDecimalFromDouble(10.0)];
    plotSpace.globalXRange = globalXRange;
    CPTPlotRange *globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-5.0) length:CPTDecimalFromDouble(10.0)];
    plotSpace.globalYRange = globalYRange;
}


@end
