//
//  MenuViewController.m
//  Shop-Menu
//
//  Created by james.dunay on 9/12/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "MenuViewController.h"
#import "InstructionView.h"
#import "UIImageView+Gestures.h"

@interface MenuViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* screenShadow;
@property (nonatomic, strong) NSArray* examples;
@property (nonatomic, strong) BottomMenu* bottomMenu;

@property (nonatomic, strong) UILabel* logout;
@property (nonatomic, strong) UILabel* settings;

@property (nonatomic, strong) InstructionView* instructionView;

@end

static CGFloat overviewScreenDimensionMultiplyer = 3.5f;

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.settings = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.frame.size.width, 64)];
    self.settings.text = @"SETTINGS";
    self.settings.textAlignment = NSTextAlignmentLeft;
    self.settings.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
    self.settings.textColor = [UIColor darkGrayColor];
    self.settings.alpha = 0;
    [self.view addSubview:self.settings];
    
    self.logout = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width - 20, 64)];
    self.logout.text = @"LOGOUT";
    self.logout.textAlignment = NSTextAlignmentRight;
    self.logout.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
    self.logout.textColor = [UIColor darkGrayColor];
    self.logout.alpha = 0;
    [self.view addSubview:self.logout];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setDelegate:self];
    [self.scrollView setClipsToBounds:NO];
    
    [self defaultScrollViewSetup];
    
    self.examples = @[@[@"Obsess", @"BUY"], @[@"Consign", @""], @[@"Shop", @"Consign"], @[@"My Threads", @"Popular"], @[@"", @"Recent Searches"]];
    
    [self createViewsWithImages:@[@"shop", @"consign", @"me", @"feed", @"search",]];
    [self.view addSubview:self.scrollView];
    
    self.screenShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.screenShadow setBackgroundColor:[UIColor blackColor]];
    [self.screenShadow setAlpha:.1];
    [self.view addSubview:self.screenShadow];
    
    self.bottomMenu = [[BottomMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70)];
    self.bottomMenu.mBottomMenuDelegate = self;
    self.bottomMenu.displayOverviewYCoord = self.view.frame.size.height - (self.view.frame.size.height/overviewScreenDimensionMultiplyer) + 64;
    self.bottomMenu.screenHeight = self.view.frame.size.height;
    self.bottomMenu.defaultFrameSize = CGSizeMake(self.view.frame.size.width, 70);
    [self.view addSubview:self.bottomMenu];
    
    
//    Remove to set to default Selected position on load
//    [self.bottomMenu defaultToShopPressed];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.f];
    
    CATransform3D theTransform = self.view.layer.sublayerTransform;
    theTransform.m34 = 1.0 / -500;
    self.view.layer.sublayerTransform = theTransform;
    
    [self showInstruction];
}

-(void)showInstruction{
    
    //    Need service class for instructions
    
    InstructionView* instructionView = [[InstructionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [instructionView setup];
    
    NSDictionary* tapDict = @{@"text" : @"Tap Interaction\n\nPress any of the numbers to begin your selection.",
                                @"gesture" : @(GestureTap)};
    
    NSDictionary* swipeDict = @{@"text" : @"Swipe Gesture\n\nSwipe the menu icon to jump between sections.",
                              @"gesture" : @(GestureSwipe)};
    
    NSDictionary* longPressDict = @{@"text" : @"Long Press\n\nTouch and hold the menu icon to display all options.",
                              @"gesture" : @(GestureLongPress)};
    
    instructionView.instructions = [instructionView createInstructionsFromArray:@[tapDict, swipeDict, longPressDict]];
    [self.view addSubview:instructionView];
}


-(void)defaultScrollViewSetup{
    [self.scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height)];
    [self.scrollView setUserInteractionEnabled:NO];
}

-(void)createViewsWithImages:(NSArray *)imageStrings{

    [imageStrings enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL *stop) {
        UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * idx, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [background setImage:[UIImage imageNamed:imageStrings[idx]]];
        background.tag = idx;
        
        if (idx % 2) {
            background.backgroundColor = [UIColor colorWithWhite:0.7f alpha:1.f];
        }else{
            background.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
        }
        
        [self.scrollView addSubview:background];
    }];
}


#pragma Mark Delegate Methods From Menu

-(void)displayAllScreensWithStartingDisplayOn:(CGFloat)startingPosition{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CGFloat widthReduction = (self.view.frame.size.width/overviewScreenDimensionMultiplyer);
    CGFloat heightReduction = (self.view.frame.size.height/overviewScreenDimensionMultiplyer);
    
    CGSize reducedSize = CGSizeMake(self.view.frame.size.width - widthReduction, self.view.frame.size.height - heightReduction);
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView* view, NSUInteger idx, BOOL *stop) {
        
        view.clipsToBounds = YES;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:8.0f];
        animation.duration = .17;
        [view.layer addAnimation:animation forKey:@"cornerRadius"];
        [view.layer setCornerRadius:8.0];
        
        CGFloat newXPos = (reducedSize.width + 10)  * idx + 5;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedView:)];
        [view addGestureRecognizer:tap];
        
        view.userInteractionEnabled = YES;
        
        void(^animations)(void) = ^{
            
            self.logout.alpha = 1;
            self.settings.alpha = 1;
            
            view.frame = CGRectMake(newXPos, 64, reducedSize.width, reducedSize.height);
            [view setNeedsUpdateConstraints];
            [self.scrollView setFrame:CGRectMake((widthReduction/2) - 5, 0, reducedSize.width + 10, self.scrollView.frame.size.height)];
            self.scrollView.contentOffset = CGPointMake(startingPosition * (reducedSize.width + 10), 0);
        };
        
        [UIView animateWithDuration:.25f
                              delay:0.f
             usingSpringWithDamping:.98
              initialSpringVelocity:11
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:animations
                         completion:^(BOOL finished) {
                             
                         }];
    }];
    
    self.scrollView.contentSize = CGSizeMake((self.scrollView.subviews.count-2) * (reducedSize.width + 10), self.scrollView.contentSize.height);
    self.scrollView.userInteractionEnabled = YES;
}

-(void)didSwitchToIndex:(int)pageIndex{
 
    CGFloat xPoint = pageIndex*320;
    [UIView animateWithDuration:.2f animations:^{
        [self.scrollView setContentOffset:CGPointMake(xPoint, 0)];
    }];
}

-(void)fadeToIndex:(int)pageIndex{
    //Killed fade out to remove flicker. Also seemed unnecessary
    
    [UIView animateWithDuration:.1f animations:^{
        [self.scrollView setAlpha:0.f];
    } completion:^(BOOL finished){
        CGFloat xPoint = pageIndex * 320;
        [self.scrollView setContentOffset:CGPointMake(xPoint, 0)];
        [UIView animateWithDuration:.2f animations:^{
            [self.scrollView setAlpha:1.f];
        }];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentOffSet = scrollView.contentOffset.x;
    [self.bottomMenu scrollOverviewButtonsWithPercentage:contentOffSet/scrollView.frame.size.width];
}

-(void)manualOffsetScrollview:(CGFloat)offset{
    
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + offset, 0);
    self.scrollView.contentOffset = newOffset;
}

-(void)darkenScreen{
    [UIView animateWithDuration:.2
                          delay:.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.screenShadow setAlpha:.1];
                     } completion:nil];
}

-(void)lightenScreen{
    [UIView animateWithDuration:.4
                          delay:.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.screenShadow setAlpha:0];
                     } completion:nil];
}

-(void)selectedView:(UITapGestureRecognizer*)tap{

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    NSInteger selectedTag = [tap view].tag;
    [self.bottomMenu returnMenuToSelected:selectedTag];
    
    [UIView animateWithDuration:.25f
                          delay:0.f
         usingSpringWithDamping:.98
          initialSpringVelocity:11
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self defaultScrollViewSetup];
                         [self resetScrollViewSubviews];
                         self.scrollView.contentOffset = CGPointMake(320 * selectedTag, 0);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


-(void)resetScrollViewSubviews{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIImageView* view, NSUInteger idx, BOOL *stop) {
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat:0.f];
        animation.duration = .17;
        [view.layer addAnimation:animation forKey:@"cornerRadius"];
        [view.layer setCornerRadius:0.f];
        
        view.userInteractionEnabled = NO;
        view.frame = CGRectMake(self.view.frame.size.width * idx, 0, self.view.frame.size.width, self.view.frame.size.height);

        self.logout.alpha = 0;
        self.settings.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
