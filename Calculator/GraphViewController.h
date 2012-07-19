//
//  GraphViewController.h
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"


@interface GraphViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIBarButtonItem *graphTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ipadLineOrDot;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *lineOrDot;
@property (weak, nonatomic) IBOutlet UINavigationItem *graphNavigationBar;

- (void) getProgram : (id)program;
- (void) graphDescription:(NSMutableArray*) operations;
@property (nonatomic, strong) id programStack;
@end
