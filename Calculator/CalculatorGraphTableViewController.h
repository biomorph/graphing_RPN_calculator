//
//  CalculatorGraphTableViewController.h
//  Calculator
//
//  Created by Ravi Alla on 7/25/12.
//
//

#import <UIKit/UIKit.h>

@class CalculatorGraphTableViewController;
@protocol CalculatorProgramTableViewControllerDelegate

- (void) calculatorProgramTableViewController :(CalculatorGraphTableViewController *) sender
                                  choseProgram:(id) program;


@end

@interface CalculatorGraphTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *programs; //of CalculatorBrains program
@property (nonatomic, weak) id <CalculatorProgramTableViewControllerDelegate> delegate;
@end
