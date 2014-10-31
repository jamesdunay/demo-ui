//
//  MenuViewController.m
//  Shop-Menu
//
//  Created by james.dunay on 9/12/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property(nonatomic, strong) UIImageView* screenShadow;
@property(nonatomic, strong) NSArray* examples;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height)];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setUserInteractionEnabled:NO];
        
        self.examples = @[@[@"Obsess", @"BUY"], @[@"Consign", @""], @[@"Shop", @"Consign"], @[@"My Threads", @"Popular"], @[@"", @"Recent Searches"]];
        
        [self createViewsWithColors:@[@"Shop", @"Consign", @"Me", @"Feed", @"Search",]];
        [self.view addSubview:self.scrollView];
        
        self.screenShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.screenShadow setBackgroundColor:[UIColor blackColor]];
        [self.screenShadow setAlpha:.6];
        [self.view addSubview:self.screenShadow];
        
        BottomMenu* bottomMenu = [[BottomMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 70)];
        bottomMenu.mBottomMenuDelegate = self;
        [self.view addSubview:bottomMenu];
    }
    return self;
}

-(void)createViewsWithColors:(NSArray *)colors{

    [colors enumerateObjectsUsingBlock:^(NSString* title, NSUInteger idx, BOOL *stop) {
        UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * idx, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 184, 300, 200)];
        [titleLabel setText:title];
        [titleLabel setTextColor:[UIColor lightGrayColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [background addSubview:titleLabel];
        
        
        UILabel* leftItem = [[UILabel alloc] initWithFrame:CGRectMake(10, 480, 110, 50)];
        [leftItem setTextAlignment:NSTextAlignmentCenter];
        [leftItem setBackgroundColor:[UIColor colorWithWhite:.95f alpha:1.f]];
        [leftItem setText:self.examples[idx][0]];
//        [background addSubview:leftItem];
        
        UILabel* rightItem = [[UILabel alloc] initWithFrame:CGRectMake(200, 480, 110, 50)];
        [rightItem setTextAlignment:NSTextAlignmentCenter];
        [rightItem setBackgroundColor:[UIColor colorWithWhite:.95f alpha:1.f]];
        [rightItem setText:self.examples[idx][1]];
//        [background addSubview:rightItem];
        
        if (idx % 2) {
            background.backgroundColor = [UIColor colorWithWhite:0.7f alpha:1.f];
            [titleLabel setTextColor:[UIColor whiteColor]];
        }
        
        [self.scrollView addSubview:background];
    }];
}

#pragma Mark Delegate Methods From Menu

-(void)didSwitchToIndex:(int)pageIndex{
 
    CGFloat xPoint = pageIndex*320;
    [UIView animateWithDuration:.2f animations:^{
        [self.scrollView setContentOffset:CGPointMake(xPoint, 0)];
    }];
}

-(void)fadeToIndex:(int)pageIndex{
    //Killed fade out to remove flicker. Also seemed unnecessary
    
    [UIView animateWithDuration:.1f animations:^{
//        [self.scrollView setAlpha:0.f];
    } completion:^(BOOL finished){
        CGFloat xPoint = pageIndex * 320;
        [self.scrollView setContentOffset:CGPointMake(xPoint, 0)];
        [UIView animateWithDuration:.2f animations:^{
//            [self.scrollView setAlpha:1.f];
        }];
    }];
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
                         [self.screenShadow setAlpha:.3];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
