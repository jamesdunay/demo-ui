//
//  PlateStack.m
//  Shop-Menu
//
//  Created by james.dunay on 10/2/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "PlateStack.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat plateMargin = 30;

@interface PlateStack()

@property(nonatomic) CGFloat firstX;
@property(nonatomic) CGFloat firstY;

@property(nonatomic) UIView* dismissedPlate;
@property(nonatomic) UIPanGestureRecognizer* panGesture;

@property(nonatomic, retain) NSMutableArray* plates;
@property(nonatomic, strong) UIColor* startingPlateColor;

@end


@implementation PlateStack

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createInitalPlates];
    }
    
    return self;
}

-(void)createInitalPlates{

    self.plates = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++) {
        UIView* plate = [[UIView alloc] initWithFrame:CGRectMake(plateMargin, 64, self.frame.size.width - (plateMargin*2), 370)];
        [plate setBackgroundColor:[UIColor colorWithWhite:.9f - (CGFloat)i/10 alpha:1.f]];
        [plate.layer setBackgroundColor:[[UIColor colorWithWhite:.9f - (CGFloat)i/10 alpha:1.f] CGColor]];
        plate.layer.zPosition = -50 * i;
        plate.layer.position = CGPointMake(plate.center.x, plate.center.y + 30 * i);
        [self.plates addObject:plate];
        [self addSubview:plate];
        [self sendSubviewToBack:plate];
    }
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTopPlate:)];
    [self.panGesture setDelegate:self];
    
    [(UIView*)[self.plates firstObject] addGestureRecognizer:self.panGesture];
    
    CATransform3D theTransform = self.layer.sublayerTransform;
    theTransform.m34 = 1.0 / -500;
    self.layer.sublayerTransform = theTransform;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


-(void)panTopPlate:(UIPanGestureRecognizer *)gesture{
    
    CGPoint translatedPoint = [gesture translationInView:self];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        self.firstX = [[gesture view] center].x;
        self.firstY = [[gesture view] center].y;
        self.startingPlateColor = [[gesture view] backgroundColor];
    }
    
    //Reset View center to match finger swiping
    translatedPoint = CGPointMake(self.firstX, self.firstY  + translatedPoint.y);
    [[gesture view] setCenter:translatedPoint];

    //USE THE Xpos to smooth this out
    if (self.firstY + 30 < translatedPoint.y || self.firstY - 30 > translatedPoint.y) {
        ((UIScrollView*)self.superview).scrollEnabled = NO;
    }
    
    //Adjusts color of plates based on drag
    if (self.firstY - translatedPoint.y >= 70) {
        [[gesture view] setBackgroundColor:[UIColor greenColor]];
    }else if(self.firstY - translatedPoint.y <= -70){
        [[gesture view] setBackgroundColor:[UIColor redColor]];
    }else{
        [[gesture view] setBackgroundColor:self.startingPlateColor];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        CGPoint endingLocation = [gesture translationInView:self];
        
        CGFloat velocityX = (0.2*[gesture velocityInView:self].x);
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        if (endingLocation.y <= -70) {
            [self removePlateUpWithDuration:animationDuration];
        }else if(endingLocation.y >= 70){
            [self removePlateDownWithDuration:animationDuration];
        }else{
            void (^animations)(void) = ^{
                [[gesture view] setCenter:CGPointMake(self.firstX, self.firstY)];
            };
            
            [UIView animateWithDuration:animationDuration animations:animations completion:nil];
        }
        
        ((UIScrollView*)self.superview).scrollEnabled = YES;
    }
}

-(void)removePlateUpWithDuration:(CGFloat)duration{
    
    self.dismissedPlate = [self.plates firstObject];
    
    void (^animations)() = ^{
        [self.dismissedPlate setFrame:CGRectMake(0, self.dismissedPlate.frame.origin.y, 320, 64)];
        [self.dismissedPlate setAlpha:0.f];
    };
    
    [UIView animateWithDuration:duration animations:animations completion:^(BOOL finished){
        [self sendSubviewToBack:self.plates.firstObject];

        [self advancePlates];
    }];
}

-(void)removePlateDownWithDuration:(CGFloat)duration{
    
    self.dismissedPlate = [self.plates firstObject];
    void (^animations)() = ^{
        [self.dismissedPlate setFrame:CGRectMake(self.dismissedPlate.frame.origin.x, self.frame.size.height, self.dismissedPlate.frame.size.width, self.dismissedPlate.frame.size.height)];
        [self.dismissedPlate setAlpha:0.f];
    };
    
    [UIView animateWithDuration:duration animations:animations completion:^(BOOL finished){
        [self sendSubviewToBack:self.plates.firstObject];
        [self advancePlates];
    }];
}


-(void)advancePlates{
    
    [self.dismissedPlate removeGestureRecognizer:self.panGesture];
    [self.plates removeObject:self.dismissedPlate];
    //If you want to cycle plates, you need to add the top back to the bottom.
//    [self.plates addObject:self.dismissedPlate];
    [self.dismissedPlate removeFromSuperview];
    
    [[self.plates firstObject] addGestureRecognizer:self.panGesture];
    
    void(^animations)(void) = ^{
        [self.plates enumerateObjectsUsingBlock:^(UIView* plate, NSUInteger idx, BOOL *stop) {
            plate.frame = CGRectMake(30, 64, 260, 370);

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            animation.fromValue = [NSNumber numberWithFloat:plate.layer.zPosition];
            animation.toValue = [NSNumber numberWithFloat:-50 * (NSInteger)idx];
            animation.duration = .3;
            [plate.layer addAnimation:animation forKey:@"zPosition"];
            plate.layer.zPosition = -50 * (NSInteger)idx;
            plate.layer.position = CGPointMake(plate.center.x, plate.center.y + 30 * idx);
            
        }];
    };
    
    void(^alphaBackview)(void) = ^{
        [[self.plates lastObject] setAlpha:1.f];
    };
    
    [UIView animateWithDuration:.3 animations:animations];
    [UIView animateWithDuration:.5 animations:alphaBackview];
}

@end


















