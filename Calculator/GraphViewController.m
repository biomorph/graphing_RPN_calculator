//
//  GraphViewController.m
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrains.h"
#import "SplitViewBarButtonItemPresenter.h" //protocol for splitview

@interface GraphViewController () <GraphViewDataSource, SplitViewBarButtonItemPresenter> //set myself as delegate for  protocols from GraphView

@property (nonatomic, weak) IBOutlet GraphView * graphView; //outlet for GraphView
@property (nonatomic, weak) NSMutableArray * operationsArray; //array of operations stored here
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar; // toolBar for iPad splitView
@end

@implementation GraphViewController

@synthesize graphTitle = _graphTitle;
@synthesize ipadLineOrDot = _ipadLineOrDot;
@synthesize lineOrDot = _lineOrDot;
@synthesize graphView = _graphView;
@synthesize programStack = _programStack;
@synthesize operationsArray = _operationsArray;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolBar = _toolBar;
@synthesize graphNavigationBar = _graphNavigationBar;


//programStack lazy instantiation
- (id) programStack {
    if (!_programStack)_programStack=[[NSArray alloc]init];
    return _programStack;
}


// method for setting up a tool bar button to bring up calculator view
- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem{
    if (_splitViewBarButtonItem !=splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        if(_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolBar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

//graphview setter where we also implement the gestures
-(void) setGraphView:(GraphView *)graphView{
    _graphView = graphView;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tap.numberOfTapsRequired = 3;
    
    [self.graphView addGestureRecognizer:tap];
    
   
    
    self.graphView.dataSource = self;
    self.graphView.dotOrLine = self;
    
    self.graphNavigationBar.title = [CalculatorBrains descriptionOfProgram:self.programStack :self.operationsArray];

}

// button method to change graph display from line to dot for iPad
- (IBAction)iPadLineOrDotPressed:(id)sender {
    if ([self.ipadLineOrDot.title isEqualToString:@"LineGraph"])
        self.ipadLineOrDot.title = @"DotGraph";
    else self.ipadLineOrDot.title = @"LineGraph";
    [self.graphView setNeedsDisplay];
}

// button method to change graph display from line to dot for iPhone
- (IBAction)lineOrDotPressed:(id)sender {
    if ([self.lineOrDot.title isEqualToString:@"LineGraph"])
    self.lineOrDot.title = @"DotGraph";
    else self.lineOrDot.title = @"LineGraph";
    [self.graphView setNeedsDisplay];
}


// method which gets program which is passed from CalculatorViewController during a segue
- (void) getProgram : (id)program {
    self.programStack = program;
    [self.graphView setNeedsDisplay];
}

// this is a GraphViewDataSource protocol method (declared in graphView.h) which asks CalculatorBrain for a result when passed an x, its value and corresponding programStack
- (double)graphPoints:(GraphView *) sender:(double)xValue {
    
    NSDictionary * variableValues= [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithDouble:xValue],@"x", nil];
    
    double result = [CalculatorBrains runprogram:self.programStack :variableValues];
    return result;   
    
}

// this method gets the graphDescription from CalculatorBrain, it is passed an array of operations during segue from CalculatorViewController
- (void)graphDescription:(NSMutableArray*) operations{
    self.operationsArray = operations;
    self.graphTitle.title = [CalculatorBrains descriptionOfProgram:self.programStack :self.operationsArray];

}

// this is a GraphViewDataSource protocol method (declared in graphView.h) that checks status of the line o rDot status of the lineOrDot buttons
- (NSString *) dotOrLine:(GraphView *)sender{
    if (self.lineOrDot.title)
    return self.lineOrDot.title;
    else return self.ipadLineOrDot.title;
}


// supports all autorotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

@end
