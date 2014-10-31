//
//  BottomMenu.m
//  Shop-Menu
//
//  Created by james.dunay on 9/12/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "BottomMenu.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuButton : UIButton
typedef enum : NSUInteger {
    ButtonStateDisplayed = (1 << 0),
    ButtonStateSelected = (1 << 1),
} ButtonState;
@property (nonatomic) int rowPosition;
@property(nonatomic) ButtonState buttonState;
@end

@implementation MenuButton
@end

static CGFloat displayYCoord = 30;

@interface BottomMenu()


@property(nonatomic) CGFloat firstX;
@property(nonatomic) CGFloat firstY;

@property(nonatomic) CGFloat lastXOffset;

@property (nonatomic, strong)NSMutableArray* buttons;
@property (nonatomic, strong)NSMutableArray* buttonConstaints;
@property (nonatomic, strong)NSArray* colors;
@property(nonatomic, strong) NSLayoutConstraint *constraintOne;
@property(nonatomic, strong) NSLayoutConstraint *constraintTwo;
@property(nonatomic, strong) NSLayoutConstraint *constraintThree;
@property(nonatomic, strong) NSLayoutConstraint *constraintFour;
@property(nonatomic, strong) NSLayoutConstraint *constraintFive;
@property(nonatomic, strong) NSLayoutConstraint *bottomPosition;


@end

@implementation BottomMenu

typedef enum : NSUInteger {
    MenuStateDefault = (1 << 0),
    MenuStateDisplayed = (1 << 1),
    MenuStateFullyOpened = (1 << 2),
} MenuState;


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMenuItems:@[@"", @"", @"", @"", @""]];
        [self setupConstraints];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateConstraints];
}

-(void)setupConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [self.buttons enumerateObjectsUsingBlock:^(MenuButton *button, NSUInteger idx, BOOL *stop) {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:button
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.f
                                                             constant:self.frame.size.width/5 ]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:button
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.f
                                                             constant:0]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:button
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.f
                                                             constant:0]];
    }];
    
    self.constraintOne = [NSLayoutConstraint constraintWithItem:self.buttons[0] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:0];
    self.constraintTwo = [NSLayoutConstraint constraintWithItem:self.buttons[1] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:self.frame.size.width/5 * 1];
    self.constraintThree = [NSLayoutConstraint constraintWithItem:self.buttons[2] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:self.frame.size.width/5 * 2];
    self.constraintFour = [NSLayoutConstraint constraintWithItem:self.buttons[3] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:self.frame.size.width/5 * 3];
    self.constraintFive = [NSLayoutConstraint constraintWithItem:self.buttons[4] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.f constant:self.frame.size.width/5 * 4];
    
    [self addConstraints:@[self.constraintOne, self.constraintTwo, self.constraintThree, self.constraintFour, self.constraintFive]];
    [self addConstraints:[constraints copy]];
    
    self.buttonConstaints = [[NSMutableArray alloc] initWithObjects:self.constraintOne, self.constraintTwo, self.constraintThree, self.constraintFour, self.constraintFive, nil];
}


- (void)createMenuItems:(NSArray*)menuItems{
    
    self.buttons = [[NSMutableArray alloc] init];
    
    [menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        MenuButton* button = [MenuButton buttonWithType:UIButtonTypeCustom];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        button.tag = idx;
        button.buttonState = ButtonStateDisplayed;
        [button setTitle:[NSString stringWithFormat:@"%d", idx] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedMenuItem:)];
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSelectedButton:)];
        pan.delegate = self;
        
        [button addGestureRecognizer:tap];
        [button addGestureRecognizer:pan];
        
        button.backgroundColor = [UIColor whiteColor];
        [self.buttons addObject:button];
        [self addSubview:button];
    }];
}


- (void)touchedMenuItem:(id)sender {

    switch ([(MenuButton*)[sender view] buttonState]) {
        case ButtonStateDisplayed:
            [(MenuButton*)[sender view] setButtonState:ButtonStateSelected];
            
            [(MenuButton*)[sender view] setBackgroundColor:[UIColor clearColor]];
            [self addBorderToView:((MenuButton*)[sender view])];
            
            [self bringSubviewToFront:(MenuButton*)[sender view]];
            [self collapseAllButtons];
            [self.mBottomMenuDelegate fadeToIndex:[(MenuButton*)[sender view]tag]];
            break;
            
        case ButtonStateSelected:
            [self displayAllButtons];
            break;
            
        default:
            break;
    }
}


- (void)collapseAllButtons{
    
    [self.mBottomMenuDelegate lightenScreen];
    
    void (^alphaAnimation)() = ^{
                [self hideNonSelectedMenuItems];
    };
    
    [self.buttons enumerateObjectsUsingBlock:^(MenuButton *button, NSUInteger idx, BOOL *stop) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:32.0f];
        animation.duration = .17;
        [button.layer addAnimation:animation forKey:@"cornerRadius"];
        [button.layer setCornerRadius:32.0];
    }];
    
    void (^animations)(void) = ^{
        self.constraintOne.constant = self.frame.size.width/5 * 1;
        self.constraintTwo.constant = self.frame.size.width/5 * 1.5;
        self.constraintThree.constant = self.frame.size.width/5 * 2;
        self.constraintFour.constant = self.frame.size.width/5 * 2.5;
        self.constraintFive.constant = self.frame.size.width/5 * 3;
        
        self.frame = CGRectMake(0, self.frame.origin.y - displayYCoord, self.frame.size.width, 65);
        
        [self.buttonConstaints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ([(MenuButton*)constraint.firstItem isEqual:self.buttons[[self indexOfActiveButton]]]) {
                constraint.constant = self.frame.size.width/5 * 2;
            }
        }];
        
        [self layoutIfNeeded];
    };
    
    [UIView animateWithDuration:.65f
                          delay:0.f
         usingSpringWithDamping:.7
          initialSpringVelocity:12
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:animations
                     completion:^(BOOL finished) {
                         
                     }];

    [UIView animateWithDuration:0.10
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:alphaAnimation
                     completion:^(BOOL finished){}
     ];
}

- (void)displayAllButtons{
    
    [self.mBottomMenuDelegate darkenScreen];
    
    void (^animations)(void) = ^{};
    animations = ^{
        [self showAllButtons];
        self.constraintOne.constant = self.frame.size.width/5 * 0;
        self.constraintTwo.constant = self.frame.size.width/5 * 1;
        self.constraintThree.constant = self.frame.size.width/5 * 2;
        self.constraintFour.constant = self.frame.size.width/5 * 3;
        self.constraintFive.constant = self.frame.size.width/5 * 4;
        
        self.frame = CGRectMake(0, self.frame.origin.y + displayYCoord, self.frame.size.width, 70);
        [self layoutIfNeeded];
    };
    
    [UIView animateWithDuration:.25f
                          delay:0.f
         usingSpringWithDamping:.98
          initialSpringVelocity:11
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:animations
                     completion:^(BOOL finished) {}];
}



-(void)panSelectedButton:(UIPanGestureRecognizer *)gesture{
    CGPoint translatedPoint = [gesture translationInView:self];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        self.firstX = [[gesture view] center].x;
        self.firstY = [[gesture view] center].y;
    }
    
    //Matching swipe with scrollview
    [self.mBottomMenuDelegate manualOffsetScrollview:(self.lastXOffset - translatedPoint.x)];
    self.lastXOffset = translatedPoint.x;
    
    //Reset View center to match finger swiping
    translatedPoint = CGPointMake(self.firstX + translatedPoint.x, self.firstY);
    [[gesture view] setCenter:translatedPoint];
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        CGPoint endingLocation = [gesture translationInView:self];
        if (endingLocation.x <= -50) {
            [self switchToPageNext:YES];
        }else if (endingLocation.x >= 50) {
            [self switchToPageNext:NO];
        }
        
        CGFloat velocityX = (0.2*[gesture velocityInView:self].x);
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        void (^animations)(void) = ^{
            [[gesture view] setCenter:CGPointMake(self.firstX, self.firstY)];
        };
        
        [UIView animateWithDuration:animationDuration animations:animations completion:nil];
        
        self.lastXOffset = 0;
    }
}

-(void)switchToPageNext:(BOOL)next{
    
    NSInteger targetedButton = next ? next : -1;
    NSInteger activeIndex = [self indexOfActiveButton];
    
    MenuButton* activeButton = self.buttons[activeIndex];
    MenuButton* nextButton = self.buttons[activeIndex+targetedButton];

    [self removeBorderToView:activeButton];
    [self addBorderToView:nextButton];
    
    [activeButton setButtonState:ButtonStateDisplayed];
    [nextButton setButtonState:ButtonStateSelected];
    
    [self bringSubviewToFront:nextButton];
    void (^animations)(void) = ^{
        
        [self.buttonConstaints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
            if ([(MenuButton*)constraint.firstItem isEqual:self.buttons[[self indexOfActiveButton]]]) {
                constraint.constant = self.frame.size.width/5 * 2;
            }
        }];
        activeButton.alpha = 0;
        nextButton.alpha = 1;
    };
    
    [UIView animateWithDuration:.2 animations:animations completion:nil];
    
    [self.mBottomMenuDelegate didSwitchToIndex:nextButton.tag];
}

-(void)showAllButtons{
    [self.buttons enumerateObjectsUsingBlock:^(MenuButton* button, NSUInteger idx, BOOL *stop) {
        button.buttonState = ButtonStateDisplayed;
        [button.layer setCornerRadius:0.f];
        button.backgroundColor = [UIColor whiteColor];
        [self removeBorderToView:button];
        button.alpha = 1.f;
    }];
}

-(void)hideNonSelectedMenuItems{
    [self.buttons enumerateObjectsUsingBlock:^(MenuButton* button, NSUInteger idx, BOOL *stop) {
        if (button.buttonState != ButtonStateSelected) {
            button.alpha = 0.f;
            button.backgroundColor = [UIColor clearColor];
        }
    }];
}

-(void)addBorderToView:(UIView*)view{
    
    if (view.tag == 1 || view.tag == 3) {
        [(UIButton*)view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.layer.borderColor = [[UIColor whiteColor] CGColor];
        view.layer.borderWidth = 2.f;
    }else{
        [(UIButton*)view setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        view.layer.borderWidth = 2.f;
    }
}

-(void)removeBorderToView:(UIView*)view{
    [(UIButton*)view setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    view.layer.borderColor = [[UIColor clearColor] CGColor];
    view.layer.borderWidth = 0.f;
}

-(NSUInteger)indexOfActiveButton{
//Needs Polish
    __block NSUInteger index = 0;
    [self.buttons enumerateObjectsUsingBlock:^(MenuButton* button, NSUInteger idx, BOOL *stop) {
        if (button.buttonState == ButtonStateSelected) {
            index = idx;
        }
    }];
    
    return index;
}

- (CGFloat)screenDivisionSize{
    return self.frame.size.width/12;
}


@end






