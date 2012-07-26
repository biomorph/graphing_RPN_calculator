//
//  CalculatorBrains.h
//  Calculator
//
//  Created by Ravi Alla on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrains : NSObject
-(void) pushOperand: (NSString *) operand;
-(double) performOperation: (NSString*) operation;
-(void) performClear;
-(NSString *) performBackSpace: (NSString *) display;
-(NSArray *) performUndo;

//program is always guaranteed to be a Property List
@property (readonly) id program;

+ (double) runprogram : (id)program;
+ (NSString *) descriptionOfProgram:(id)program:(NSMutableArray *)operationArray;
+ (double) runprogram:(id)programusingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *) variablesUsedInProgram:(id) program;

@end
