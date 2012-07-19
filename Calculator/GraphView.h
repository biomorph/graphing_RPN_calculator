//
//  GraphView.h
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDataSource
- (double)graphPoints:(GraphView *) sender:(double)xValue; //gets me y value for a passed xValue (pixel)
- (NSString *) dotOrLine: (GraphView *) sender; //gets me the status of the lineOrDot button
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
- (void) pinch:(UIPinchGestureRecognizer *)gesture;
- (void) pan:(UIPanGestureRecognizer *)gesture;
- (void) tripleTap:(UITapGestureRecognizer *)gesture;

@property (nonatomic, weak) id  <GraphViewDataSource> dataSource; //my model for GraphView
@property (nonatomic) id <GraphViewDataSource> dotOrLine; //property which holds status of lineOrDot button


@end
