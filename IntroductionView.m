//
//  IntroductionView.m
//  Shop-Menu
//
//  Created by james.dunay on 11/4/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "IntroductionView.h"

@interface IntroductionView()

@property(nonatomic, strong)UILabel* appTitleTwoLabel;
@property(nonatomic, strong)UILabel* appTitleOneLabel;

@property(nonatomic, strong)UILabel* descriptionOneLabel;
@property(nonatomic, strong)UILabel* descriptionTwoLabel;


@property(nonatomic, strong)NSArray* sectionOne;
@property(nonatomic, strong)NSArray* sectionTwo;

@end


static CGFloat startingXPositionOne = 200;
static CGFloat startingXPositionTwo = -200;

static CGFloat spacing = 10;


@implementation IntroductionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.appTitleOneLabel = [self createLabelWithText:@"TRR"];
        self.appTitleOneLabel.frame = CGRectMake(self.frame.size.width/2 + startingXPositionOne, self.frame.size.height/2 - 50, 0, 0);
        self.appTitleOneLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.f];
        [self.appTitleOneLabel sizeToFit];
        
        self.appTitleTwoLabel = [self createLabelWithText:@"Shop 2.0"];
        self.appTitleTwoLabel.frame = CGRectMake(self.frame.size.width/2 + startingXPositionTwo, self.frame.size.height/2 - 50, 0, 0);
        self.appTitleTwoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.f];
        [self.appTitleTwoLabel sizeToFit];
        
        
        self.descriptionOneLabel = [self createLabelWithText:@"Testing"];
        self.descriptionOneLabel.frame = CGRectMake(self.frame.size.width/2 + startingXPositionOne, self.frame.size.height/2 - 50, 0, 0);
        self.descriptionOneLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25.f];
        [self.descriptionOneLabel sizeToFit];
        
        self.descriptionTwoLabel = [self createLabelWithText:@"Environment"];
        self.descriptionTwoLabel.frame = CGRectMake(self.frame.size.width/2 + startingXPositionTwo, self.frame.size.height/2 - 50, 0, 0);
        self.descriptionTwoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.f];
        [self.descriptionTwoLabel sizeToFit];
        
        self.sectionOne = @[self.appTitleOneLabel, self.appTitleTwoLabel];
        self.sectionTwo = @[self.descriptionOneLabel, self.descriptionTwoLabel];
        
        [self animateSection:self.sectionOne onComplete:^{
          [self performSelector:@selector(animateSecondText) withObject:self afterDelay:1.5];
        }];
    }
    return self;
}

-(void)animateSecondText{
    [self reverseAnimateSection:self.sectionOne onComplete:^{}];
    
    [self animateSection:self.sectionTwo onComplete:^{
        [self performSelector:@selector(endIntroduction) withObject:self afterDelay:1.5f];
    }];
}

-(void)endIntroduction{
    [self reverseAnimateSection:self.sectionTwo onComplete:^{
        [self.kIntroductionViewDelegate completedIntroduction];
    }];
}

-(UILabel*)createLabelWithText:(NSString*)text{
    
    UILabel* label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.text = text;
    label.alpha = 0.f;
    [self addSubview:label];
    
    return label;
}

-(void)animateSection:(NSArray*)section onComplete:(void(^)(void))complete{
    
    __block CGFloat fullTextWidth;
    __block CGFloat availableXPosition;
    
    [section enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
        fullTextWidth = fullTextWidth + label.frame.size.width;
    }];
    

    void(^animations)(void)= ^{
        [section enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
            BOOL isOdd = idx % 2;
            if (isOdd) {
                label.frame = CGRectMake(availableXPosition + spacing, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }else{
                label.frame = CGRectMake((self.frame.size.width - fullTextWidth)/2-spacing, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }
            availableXPosition = label.frame.origin.x + label.frame.size.width;
        }];
    };
    
    void(^alphaAnimations)(void)= ^{
        [section enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
            label.alpha = 1;
        }];
    };
    
    [UIView animateWithDuration:1.f
                          delay:0.2f
         usingSpringWithDamping:1.f
          initialSpringVelocity:2.f
                        options:UIViewAnimationOptionCurveLinear
                     animations:animations
                     completion:^(BOOL finished) {
                         complete();
                     }];
    
    
    [UIView animateWithDuration:.3
                          delay:.4f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:alphaAnimations
                     completion:nil];
}



-(void)reverseAnimateSection:(NSArray*)section onComplete:(void(^)(void))complete{
    
    void(^alphaAnimations)(void)= ^{
        [section enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
            label.alpha = 0;
        }];
    };
    
    void(^animations)(void)= ^{
        [section enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *stop) {
            BOOL isOdd = idx % 2;
            if (isOdd) {
                label.frame = CGRectMake(self.frame.size.width/2 + startingXPositionTwo, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }else{
                label.frame = CGRectMake(self.frame.size.width/2 + startingXPositionOne, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            }
        }];
    };
    
    [UIView animateWithDuration:.6f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:animations
                     completion:^(BOOL finished) {
                         complete();
                     }];
    
    [UIView animateWithDuration:.3
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:alphaAnimations
                     completion:nil];
}

@end
