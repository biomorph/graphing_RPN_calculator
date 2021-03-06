//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ravi Alla on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrains.h"
#import "GraphViewController.h"
#import "SplitViewBarButtonItemPresenter.h" //splitView protocol

@interface CalculatorViewController ()<UISplitViewControllerDelegate> //setting myself as a delegate of splitViewController
@property (nonatomic) BOOL ifUserInTheMiddleOfTyping; //Property to check if user is in the middle of typing 
@property (nonatomic, strong) CalculatorBrains * brain; //Property to create an instance of the CalculatorBrains Class
@property (nonatomic, strong) NSDictionary *VariableValues;//NSDictionary property to hold the variables and corresponding values for test cases
@property (nonatomic) BOOL doesProgramHaveVariables;//Property to check if a program has any variables in it
@property (nonatomic,strong) NSMutableArray *operationArray;//NSMutableArray property to store pressed operations, use this for description and removing extraneous brackets

@property (nonatomic, weak) GraphViewController *graphController;
@end
@implementation CalculatorViewController

@synthesize brain = _brain;
@synthesize display = _display;
@synthesize descriptionDisplay = _descriptionDisplay;
@synthesize ifUserInTheMiddleOfTyping = _ifUserInTheMiddleOfTyping;
@synthesize VariableValues = _VariableValues;
@synthesize doesProgramHaveVariables;
@synthesize operationArray = _operationArray;
@synthesize graphController = _graphController;


- (NSMutableArray *)operationArray
//Lazy instantiation of the operationArray
{
    if (_operationArray == nil ){_operationArray = [[NSMutableArray alloc] init];
    }
    return _operationArray;
}


- (CalculatorBrains *) brain 
//Lazy instantiation of the brain property
{
    if (!_brain) _brain = [[CalculatorBrains alloc] init];
    return _brain;
}



- (IBAction)digitPressed:(UIButton *)sender 
//When digits are pressed their titles are appended to the display string
{
    NSString *digit = sender.currentTitle;
    if (self.ifUserInTheMiddleOfTyping)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else 
    {
        self.display.text = digit;
        self.ifUserInTheMiddleOfTyping = YES;
        
    }
}


- (IBAction)variablePressed:(UIButton *)sender 
//When variables are pressed their titles are appended to the display text, description text and are pushed onto the programStack
{
    NSString *variable = sender.currentTitle;
    [self.brain pushOperand:variable];
    id program = [self.brain program];
    self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingString:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
    self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
    
    if ([self.descriptionDisplay.text length] > 35)
    {
        self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
    }
    self.doesProgramHaveVariables = YES; //If a variable button is pressed program has a variable
}


- (IBAction)decimalPressed:(UIButton *)sender 
//This button implements the case of a decimal press
{
    NSString *decimal = sender.currentTitle;
    if (!self.ifUserInTheMiddleOfTyping){self.display.text = @"0";} //this sets the display to zero after enterPressed and if decimal is pressed(so that NSRange doesn't pick up decimals from the typed decimal #s in display)
    NSRange decimalPoint = [self.display.text rangeOfString:decimal];
    if (decimalPoint.length == 0)
    {//getting the length of decimal point
    self.display.text = [self.display.text stringByAppendingFormat:@"."];
    self.ifUserInTheMiddleOfTyping = YES;
    }    

}


- (IBAction)clear:(id)sender 
//This button calls performClear method in the brain to clear out the programStack
{
    self.display.text = @"0"; //set display to 0
    self.descriptionDisplay.text=@"";
    self.ifUserInTheMiddleOfTyping=NO;//if clearing user is not in the middle of typing
    [self.brain performClear];// call the perform clear method from brain
    self.doesProgramHaveVariables = NO;
    [self.operationArray removeAllObjects];

}


- (IBAction)undo 
//This button calls performUndo method in the brain to clear out the previous operand in programStack
{
    if (self.ifUserInTheMiddleOfTyping) 
    //If user is in the middle of typing it just removes the last typed operand from the display until the display is empty at which point it displays the result of the current program
    {
        
        if([self.display.text length]>1)
        self.display.text = [self.brain performBackSpace:self.display.text];
       else {
         self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrains runprogram:[self.brain program]]];  
           self.ifUserInTheMiddleOfTyping = NO;
       }
    }
    
    else 
    //If the user is not in the middle of typing it goes into the programStack and removes the last object
    {
        NSArray * newstack = [self.brain performUndo];
        self.display.text = [NSString stringWithFormat:@"%g",[CalculatorBrains runprogram:newstack]];
        self.descriptionDisplay.text = [CalculatorBrains descriptionOfProgram:newstack:self.operationArray];
    }
}

- (IBAction)backSpace:(id)sender 
//This button calls performBackSpace from the brain which deletes the last item in the display and when display is empty displays zero, kinda redundant with the undo button
{
    if ([self.display.text length]>1)
    { //backspace goes through till there is one character left
    self.display.text =[self.brain performBackSpace:self.display.text];// call the performBackSpace method
    }
    else 
    { //when one character is left change that character to 0 when backspace is pressed
        self.display.text = @"0";
    }
}


- (IBAction)changeSign:(id)sender 
//This button should've been implemented in the brain but I figured oh what the hell!!!
{
        self.display.text = [NSString stringWithFormat:@"%g",-[self.display.text doubleValue]];//take the display text and convert it to a double and change sign and cast it as a string and put back in display
}



- (IBAction)enterPressed 
//This button pushes whatever is in the display onto the programstack, and onto the description display
{
    [self.brain pushOperand:self.display.text];
    id program = [self.brain program];
    self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingString:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
    self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
    
    if ([self.descriptionDisplay.text length] > 35)
    {
        self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
    }
    self.ifUserInTheMiddleOfTyping = NO;
}



- (IBAction)operationPressed:(UIButton *)sender 
//This button executes the performOperation method in the brain when an operation is pressed and has enough operands to work on. It only works when there are no variables in the stack, if there are variables the operation is just pushed onto the programstack
{
    if (self.ifUserInTheMiddleOfTyping) [self enterPressed];
    [self.operationArray addObject:sender.currentTitle];//Here I am making an operation array to pass to the description methods in the brain to help with proper description without extraneous brackets
    
    //If there are no variables get the result of the programStack and display in the display and in the userfriendly description areas.
    if (!self.doesProgramHaveVariables) 
    {
    double result = [self.brain performOperation:sender.currentTitle];
        id program = [self.brain program];
        self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingString:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
        self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
        
        if ([self.descriptionDisplay.text length] > 35)
        {
            self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
        }

    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    }
    
    //If there are variables in the stack push the operation onto the programstack and wait till one of the test buttons is pushed
    else 
    {
        [self.brain pushOperand:sender.currentTitle];
        id program = [self.brain program];
        self.descriptionDisplay.text=[self.descriptionDisplay.text stringByAppendingString:[CalculatorBrains descriptionOfProgram:program:self.operationArray]];
        self.descriptionDisplay.text = [self.descriptionDisplay.text stringByAppendingFormat:@","];
        
        if ([self.descriptionDisplay.text length] > 35)
        {
            self.descriptionDisplay.text = [self.descriptionDisplay.text substringFromIndex:([self.descriptionDisplay.text length]-35)];
        }
    }
}


// getting the detail view
- (GraphViewController *) splitViewGraphViewController {
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]]) {
        gvc = nil;
    }
    return gvc;
}

// action method that performs segue in iPhone (if part) and target action for iPad (else part)
- (IBAction)graphPressed:(id)sender {
    if (![self splitViewGraphViewController]) {
        [self performSegueWithIdentifier:@"ShowGraph" sender:sender];    }
    else {
        [[self splitViewGraphViewController] getProgram:[self.brain program]];
        [[self splitViewGraphViewController] graphDescription:self.operationArray];
    }
}


//preparing for segue only on iPhone, here is where I pass the current program and array of operations to the GraphViewController
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowGraph"]){
        
    GraphViewController *nextView = segue.destinationViewController;
    [nextView getProgram:[self.brain program]];
    [nextView graphDescription:self.operationArray];
    }
}

//perform autorotation only when splitViewController is present (iPad). I was too lazy to implement for iPhone
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if([self splitViewController]) return YES;
    else {
     return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    }

}


- (void) awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}


// hiding the splitViewController when in portrait mode and displaying only in landscape mode
- (BOOL) splitViewController:(UISplitViewController *)svc 
    shouldHideViewController:(UIViewController *)vc 
               inOrientation:(UIInterfaceOrientation)orientation
{
    BOOL buttonDance = NO;
    if (![self splitViewBarButtonItemPresenter]) {
        buttonDance = NO;
    }
    else if(UIInterfaceOrientationIsPortrait(orientation)) buttonDance =YES;

    return buttonDance;
}

// presents a popover bar button in GraphViewController
- (void) splitViewController:(UISplitViewController *)svc 
      willHideViewController:(UIViewController *)aViewController 
           withBarButtonItem:(UIBarButtonItem *)barButtonItem 
        forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Calculator"; 
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;

}

// removing the bar button item in the GraphViewController 
- (void) splitViewController:(UISplitViewController *)svc 
      willShowViewController:(UIViewController *)aViewController 
   invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}


// returns the detail view controller only if implements the SplitViewBarButtonItemPresenter protocol, which GraphViewController does
- (id <SplitViewBarButtonItemPresenter>) splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]){
        detailVC = nil;
    }
return detailVC;
}

@end