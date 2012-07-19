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


@property (weak, nonatomic) IBOutlet UIBarButtonItem *graphTitle; //graphTitle for iPad
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ipadLineOrDot;//graphSwitch for iPad

@property (weak, nonatomic) IBOutlet UIBarButtonItem *lineOrDot; //graphSwitch for iPhone
@property (weak, nonatomic) IBOutlet UINavigationItem *graphNavigationBar;//graph Title for iPhone

- (void) getProgram : (id)program; //method to get me the program from brain
- (void) graphDescription:(NSMutableArray*) operations; //method to get me array of operations for description from brain
@property (nonatomic, strong) id programStack; //programStack from brain local copy
@end
