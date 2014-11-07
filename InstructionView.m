//
//  InstructionView.m
//  Shop-Menu
//
//  Created by james.dunay on 11/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "UIImageView+Gestures.h"
#import "InstructionView.h"
#import "Instruction.h"

@interface InstructionView()

@property(nonatomic) NSInteger currentInstructionIndex;
@property(nonatomic, strong) UILabel* instructionLabel;
@property(nonatomic, strong) UIImageView* gestureImageView;

@end

@implementation InstructionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setup{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:.9];
    
    self.currentInstructionIndex = 0;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNextInstruction)];
    [self addGestureRecognizer:tap];
    
    UILabel* tapToContinue = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
    tapToContinue.text = @"Tap to continue";
    tapToContinue.textColor = [UIColor whiteColor];
    tapToContinue.textAlignment = NSTextAlignmentCenter;
    tapToContinue.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    tapToContinue.tag = 100;
    [self addSubview:tapToContinue];
}


-(void)showNextInstruction{

    [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        if (view.tag != 100) {
            
        [UIView animateWithDuration:.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             view.alpha = 0;
                         } completion:^(BOOL finished) {
                             [view removeFromSuperview];
                         }];
        }
    }];
    
    
    if (self.instructions.count <= self.currentInstructionIndex) {
        [UIView animateWithDuration:.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.alpha = 0;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }else{

        Instruction* currentInstruction = self.instructions[self.currentInstructionIndex];
        
        if (currentInstruction.text) {
            
            
            CGFloat offset = -150;
            if (currentInstruction.gesture != 0) {
                offset = -100;
            }
            
            self.instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, self.frame.size.height/2 + offset, self.frame.size.width - 50, 200)];
            self.instructionLabel.text = currentInstruction.text;
            self.instructionLabel.textAlignment = NSTextAlignmentCenter;
            self.instructionLabel.textColor = [UIColor whiteColor];
            self.instructionLabel.numberOfLines = 0;
            self.instructionLabel.alpha = 0;
            self.instructionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f];
            [self addSubview:self.instructionLabel];
        }
        
        
        if (currentInstruction.gesture){
            self.gestureImageView = [UIImageView create:currentInstruction.gesture withRepeatCount:0];
            self.gestureImageView.frame = CGRectMake((self.frame.size.width -100)/2, self.frame.size.height/4, 100, 100);
            self.gestureImageView.alpha = 0;
            [self addSubview:self.gestureImageView];
            
        }
        
        
        [UIView animateWithDuration:.3f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.gestureImageView.alpha = 1;
                             self.instructionLabel.alpha = 1;
                         } completion:^(BOOL finished) {
                         }];
        
        
    
        self.currentInstructionIndex++;
    }
}


-(void)setInstructions:(NSArray *)instructions{
    _instructions = instructions;
    self.currentInstructionIndex = 0;
    [self showNextInstruction];
}

-(NSArray*)createInstructionsFromArray:(NSArray*)instructionDicts{
    NSMutableArray* instructionsArray = [[NSMutableArray alloc] init];
    [instructionDicts enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL *stop) {
        Instruction* instruction = [[Instruction alloc] initWithDict:dict];
        [instructionsArray addObject:instruction];
    }];
    return [instructionsArray copy];
}



@end
