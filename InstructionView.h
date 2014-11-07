//
//  InstructionView.h
//  Shop-Menu
//
//  Created by james.dunay on 11/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionView : UIView
@property(nonatomic, strong)NSArray* instructions;

-(void)setup;
-(NSArray*)createInstructionsFromArray:(NSArray*)instructionDicts;

@end
