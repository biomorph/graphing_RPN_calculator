//
//  CalculatorBrains.m
//  Calculator
//
//  Created by Ravi Alla on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrains.h"

@interface CalculatorBrains()
@property (strong, nonatomic) NSMutableArray * programStack;
@end

@implementation CalculatorBrains

@synthesize programStack = _programStack;
- (NSMutableArray *)programStack
{ 
    if (_programStack == nil ){_programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}


- (void) pushOperand: (NSString *) operand{
    if ([operand doubleValue])
    {
    [self.programStack addObject:[NSNumber numberWithDouble:[operand doubleValue]]];
    }
    else 
    {
        [self.programStack addObject:operand];
    }
}


-(id)program
{
    return [self.programStack copy];
}


+ (NSString *)singleOrDoubleOperandOperations:(NSString *)operation{
    
    //This class method checks if a passed operation accepts one or two operands
    
    NSSet * singleOperandOperations = [[NSSet alloc] initWithObjects:@"sqrt",@"cos",@"sin", nil];
    NSSet * doubleOperandOperations = [[NSSet alloc] initWithObjects:@"+",@"-",@"*",@"/", nil];
    if ([singleOperandOperations containsObject:operation]) 
    {
        return @"single";
    }
    else if ([doubleOperandOperations containsObject:operation])
    {
        return @"double";
    }
    else 
    {
        return @"π";
    }
}

+ (BOOL)isAnOperation:(NSString *)operation{
    
    //This class method checks if a string passed is an operation or not
    
    NSSet *Operations = [[NSSet alloc] initWithObjects:@"sqrt",@"cos",@"sin",@"+",@"-",@"*",@"/", nil];
    if ([Operations containsObject:operation]) 
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}

+ (NSString *) descriptionOfProgram:(id)program:(NSMutableArray*)operationArray{
    
    //This class method accepts a copy of current program stack and an array of operations entered and displays user friendly description
    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack:operationArray];
}

+ (NSString *) descriptionOfTopOfStack: (NSMutableArray*)stack:(NSMutableArray *)operationArray{
    
    //This class method is called from descriptionOfProgram method to do the actual description part
   
    NSArray *originalStack = [stack copy];
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    NSString * description =[[NSString alloc]initWithFormat:@""];
    
    //If topOfStack is a number return just the number
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        description = [NSString stringWithFormat:@"%@",topOfStack];
    }
    
    else if ([topOfStack isKindOfClass:[NSString class]]){
            NSString* operationOrVariable = topOfStack;
        
            
        //Here we are checking if the topOfStack is an operation and if it is a single or double operation and recursively call descriptionOfTopOfStack on current stack
        if ([CalculatorBrains isAnOperation:operationOrVariable] && [[CalculatorBrains singleOrDoubleOperandOperations:operationOrVariable] isEqualToString:@"double"]){
                NSString *operand1=[self descriptionOfTopOfStack:stack:operationArray];
                NSString *operand2=[self descriptionOfTopOfStack:stack:operationArray];
                NSString *previousOperation = [CalculatorBrains returnPreviousOperation:operationArray];
                
                 //Here I am checking the precedence of current operation with respect to the previous operation and assigning parantheses appropriately     
                if ([CalculatorBrains precedenceOfOperations:previousOperation]<[CalculatorBrains precedenceOfOperations:operationOrVariable]) 
                {
                    description = [NSString stringWithFormat:@"%@%@(%@)", operand2,operationOrVariable, operand1];
                }
                else 
                {
                    description = [NSString stringWithFormat:@"%@%@%@", operand2,operationOrVariable, operand1];
                }
                
            }
        
            else if ([CalculatorBrains isAnOperation:operationOrVariable] && [[CalculatorBrains singleOrDoubleOperandOperations:operationOrVariable] isEqualToString:@"single"]) 
            {
                
                description = [NSString stringWithFormat:@"%@(%@)",operationOrVariable,[self descriptionOfTopOfStack:stack:operationArray]];
            }
        
            //If topOfStack is a variable just return the variable (x,y or foo)
            else if ([[CalculatorBrains variablesUsedInProgram:originalStack] containsObject:operationOrVariable])
            {
                description = [NSString stringWithFormat:@"%@",operationOrVariable];
            }
            //If topOfStack is π just return the string π
            else if([operationOrVariable isEqualToString:@"π"])
            {
                description = [NSString stringWithFormat:@"%@",operationOrVariable];
            }

}

    return description;
    
}

+ (NSString *) returnPreviousOperation: (NSArray *) stack{
    
//This class method accepts an array of operations and returns the previous operation
    
    NSString * previousOperation;
    
    //Checking number of elements in the operation array and returning the immediately preceding operation
    if([stack count]>1)
    {
    previousOperation = [stack objectAtIndex:[stack count]-2];
    }
    
    else 
    {
        previousOperation = [stack lastObject];
    }
    return previousOperation;
}

+ (double) precedenceOfOperations: (NSString *)operation {
    
//This Class Method accepts an operation and returns a precedence value. * and / are assigned a precedence of 1, + and - precedence 0, single operand operations precedence 2
    
    double precedence = 0;
    
    if ([[CalculatorBrains singleOrDoubleOperandOperations:operation] isEqualToString:@"single"]) 
    {
        precedence = 2;
    }
    
    else if ([operation isEqualToString:@"*"] || [operation isEqualToString:@"/"]) 
    {
        precedence = 1;
    } 
    
    return precedence;
}


+ (double) popOperandOffStack: (NSMutableArray *)stack

//This Class Method pops operands off a mutablecopy of programStack and does the actual calculations by recursively calling itself

{
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString* operation = topOfStack;
        if ([operation isEqualToString:@"+"])
        {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } 
        
        else if ([operation isEqualToString:@"*"])
        {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } 
        
        else if ([operation isEqualToString:@"-"])
        {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } 
        
        else if ([operation isEqualToString:@"/"])
        {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        }
        
        else if ([operation isEqualToString:@"cos"])
        {
            result = cos([self popOperandOffStack:stack]);
        }
        
        else if ([operation isEqualToString:@"sin"])
        {
            result = sin([self popOperandOffStack:stack]);
        }
        
        else if ([operation isEqualToString:@"sqrt"])
        {
            double operand = [self popOperandOffStack:stack];
            if (operand >0) {
               result = sqrt(operand);
            }
             else result = 0;
        }
        
        else if ([operation isEqualToString:@"π"])
        {
            result = M_PI;
        }

    }
    return result;
    
}

+ (double) runprogram:(id)program 

//This Class Method takes a copy of the programStack and returns the result

{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}



+ (double) runprogram:(id)programusingVariableValues :(NSDictionary *)variableValues

//This Class Method takes a copy of the programStack and an NSDictionary of variables names (NSString) as keys and preassigned values (NSNumbers) as values to calculate results of programStacks with variables

{
    NSMutableArray *variableStack = [[NSMutableArray alloc] init];
    NSSet *variables = [[NSSet alloc]init];
    
    if ([programusingVariableValues isKindOfClass:[NSArray class]])
    {
        variableStack=[programusingVariableValues mutableCopy];
        variables = [CalculatorBrains variablesUsedInProgram:programusingVariableValues];
    }
    
    NSUInteger index = 0;
    
    //Enumerate the elements of the passed programStack
    for (id elementsOfStack in programusingVariableValues){
    
    //Check if the NSSet of variables contains each element in the programStack    
    if ([variables containsObject:elementsOfStack]){
        
        //Check if the elements that are variables have a value assigned in the NSDictionary passed to this method, if so replace the variable with its value
        if ([variableValues valueForKey:elementsOfStack])
        {
        [variableStack replaceObjectAtIndex:index withObject:[variableValues valueForKey:elementsOfStack]];
        }
        //If no values are found for a variable (key) replace that object with zero in the program
        else 
        {
            [variableStack replaceObjectAtIndex:index withObject:[NSNumber numberWithDouble:0]];
        }    
    }
        
        index++;
    }
    return [self popOperandOffStack:variableStack];

}

+ (NSSet*) variablesUsedInProgram:(id)program 

//This Class Method accepts a copy of the programStack and finds the variables in it and makes an NSSet of the variables

{
    NSMutableArray *variables = [[NSMutableArray alloc] init];
    
    if ([program isKindOfClass:[NSArray class]]) {
        
        //enumerate the operands in the programstack
        for (NSString * operand in program){
            
            //Check if the operand is a string and if it equals x,y or foo
            if ([operand isKindOfClass:[NSString class]] && [operand isEqualToString: @"x"])
            {
                [variables addObject:@"x"];
            }
        } 
    }
    NSSet * variableSet = [[NSSet alloc]initWithArray:variables];
    return variableSet;
}

-(double) performOperation: (NSString*) operation{

//This instance method takes an operation pressed and performs the operation by calling runprogram which inturn calls popOperandOffStack
    
    [self.programStack addObject:operation];
    return [CalculatorBrains runprogram:self.program];
}

-(void) performClear{
    
//This instance method clears the programStack    
    
    [self.programStack removeAllObjects];
}

-(NSString *) performBackSpace: (NSString *) display {
    
//This instance method takes the display string and deletes last character and returns the resulting string
    
    NSString * newdisplay = [display substringToIndex:[display length]-1];    
    return newdisplay;

}
-(NSArray *) performUndo{
    
//This instance method removes the last object from the programStack and returns a copy
    
   [self.programStack removeLastObject];
    return [self.programStack copy];
}

    
@end

