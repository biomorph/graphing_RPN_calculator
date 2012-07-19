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
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController () <GraphViewDataSource, SplitViewBarButtonItemPresenter> 

@property (nonatomic, weak) IBOutlet GraphView * graphView;
@property (nonatomic, weak) NSMutableArray * operationsArray;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@end

@implementation GraphViewController
@synthesize graphDescription = _graphDescription;

@synthesize graphSwitch = _graphSwitch;
@synthesize graphView = _graphView;
@synthesize programStack = _programStack;
@synthesize operationsArray = _operationsArray;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolBar = _toolBar;


- (id) programStack {
    if (!_programStack)_programStack=[[NSArray alloc]init];
    return _programStack;
}


- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem{
    if (_splitViewBarButtonItem !=splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        if(_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolBar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

-(void) setGraphView:(GraphView *)graphView{
    _graphView = graphView;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    tap.numberOfTapsRequired = 3;
    
    [self.graphView addGestureRecognizer:tap];
    
    [self.graphView setNeedsDisplay];
    self.graphView.dataSource = self;
    self.graphView.dotOrLine = self;
    self.graphDescription.text = [CalculatorBrains descriptionOfProgram:self.programStack :self.operationsArray];
    //self.navigationDescription.title = [CalculatorBrains descriptionOfProgram:self.programStack :self.operationsArray];
}


- (IBAction)graphDotOrLine {
    [self.graphView setNeedsDisplay];
}

- (void) getProgram : (id)program {
    self.programStack = program;
    [self.graphView setNeedsDisplay];
}

- (double)graphPoints:(GraphView *) sender:(double)xValue {
    
    
    NSDictionary * variableValues= [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithDouble:xValue],@"x", nil];
    
    double result = [CalculatorBrains runprogram:self.programStack :variableValues];
    return result;
   
    
}

- (void)graphDescription:(NSMutableArray*) operations{
    self.operationsArray = operations;

}

- (BOOL) dotOrLine:(GraphView *)sender{
    return self.graphSwitch.on;
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}



@end
