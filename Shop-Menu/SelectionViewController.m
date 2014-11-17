//
//  SelectionViewController.m
//  Shop-Menu
//
//  Created by james.dunay on 11/4/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "SelectionViewController.h"
#import "IntroductionView.h"
#import "MenuViewController.h"
#import "FeedOptionOneViewController.h"
#import "FeedOptionTwoViewController.h"
#import "UIImageView+Gestures.h"
#import "InstructionView.h"

@interface SelectionViewController ()

@property(nonatomic, strong)IntroductionView* introView;
@property(nonatomic, strong)NSDictionary* controllersAndNames;
@property(nonatomic, strong)UITableView* tableView;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:.75f alpha:1.f];
    
    self.controllersAndNames = @{@"Collapsible TabBar" : [[MenuViewController alloc] init],
//                                 @"Horizontal Feed Interactions  -  0.2" : [[FeedOptionOneViewController alloc] init],
//                                 @"Vertical Feed Interactions  -  0.2" : [[FeedOptionTwoViewController alloc] init]
                                 };
    
    self.introView = [[IntroductionView alloc] initWithFrame:self.view.frame];
    self.introView.kIntroductionViewDelegate = self;
    [self.view addSubview:self.introView];
    
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = self.view.frame;
    self.tableView.contentInset = UIEdgeInsetsMake(self.view.frame.size.height/2 - 100, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0;
    [self.view addSubview:self.tableView];
}

-(void)completedIntroduction{
    
    [UIView animateWithDuration:.35f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.introView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.introView removeFromSuperview];
                         [self addControllerButtons];
                         [self showInstruction];
                     }];
}

-(void)showInstruction{
    
//    Need service class for instructions
    
    InstructionView* instructionView = [[InstructionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [instructionView setup];
    
    NSDictionary* secondDict = @{@"text" : @"We look forward to heaing your feedback.",
                                @"gesture" : @(0)};
    
    NSDictionary* introDict = @{@"text" : @"Welcome to The RealReal testing environment.\n\nThis app will help us develop and explore mobile interations and behaviors.",
                                @"gesture" : @(0)};

    NSDictionary* doubleTapDict = @{@"text" : @"Triple Tap\n\n The screen at any point to return to this page.",
                                    @"gesture" : @(GestureDoubleTap)};
    
    instructionView.instructions = [instructionView createInstructionsFromArray:@[introDict, secondDict, doubleTapDict]];
    [self.view addSubview:instructionView];
}

-(void)addControllerButtons{
    [UIView animateWithDuration:.2 animations:^{
        self.tableView.alpha = 1;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.controllersAndNames.allKeys.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }

    NSUInteger row = [indexPath row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.controllersAndNames.allKeys objectAtIndex:row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray* keys = [self.controllersAndNames allKeys];
    UIViewController* viewController = self.controllersAndNames[keys[indexPath.row]];
    viewController.view.frame = self.view.frame;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)popNav{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end