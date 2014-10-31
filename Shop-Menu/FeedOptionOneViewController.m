//
//  FeedOptionOneViewController.m
//  Shop-Menu
//
//  Created by james.dunay on 10/1/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "FeedOptionOneViewController.h"
#import "PlateStack.h"
#import "EditFeed.h"

static NSInteger numberOfProducts = 4;

typedef NS_ENUM(NSInteger, ViewState) {
    ViewStateNormal = 0,
    ViewStateEdit
};

@interface FeedOptionOneViewController ()

@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic, strong)UIButton* editFeedButton;
@property(nonatomic, strong)NSLayoutConstraint* bottomButtonConstraint;
@property(nonatomic)ViewState viewState;
@property(nonatomic, strong)EditFeed* editFeed;

@property(nonatomic, strong) UIImageView* adjustableButton;

@end

@implementation FeedOptionOneViewController

- (void)viewDidLoad {
    
    self.viewState = ViewStateNormal;
    
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width * numberOfProducts, self.view.frame.size.height)];
    [self.scrollView setPagingEnabled:YES];
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < numberOfProducts; i++) {
        if(i == 2){
            PlateStack* plateStack  = [[PlateStack alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            [self.scrollView addSubview:plateStack];
        }else{
            FeedDetailView* detailView = [[FeedDetailView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height)];
            detailView.kFeedDetailViewDelegate = self;
            detailView.scrollView = self.scrollView;
            [self.scrollView addSubview:detailView];
        }
    }
    [self setupDetailViewsAndConstraints];
    
    self.editFeed = [[EditFeed alloc] initWithFrame:self.view.frame];
    [self.editFeed setAlpha:0.f];
    [self.view addSubview:self.editFeed];
    
    self.editFeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editFeedButton setBackgroundColor:[UIColor blueColor]];
    [self.editFeedButton setFrame:CGRectMake(self.view.frame.size.width - 67, 20, 40, 40)];
    [self.editFeedButton addTarget:self action:@selector(toggleEditFeed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editFeedButton];
}


-(void)setupDetailViewsAndConstraints{
    
    self.adjustableButton = [[UIImageView alloc] init];
    UIImageView* iconTwo = [[UIImageView alloc] init];
    
    [self.adjustableButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [iconTwo setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.adjustableButton setBackgroundColor:[UIColor redColor]];
    [iconTwo setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:self.adjustableButton];
    [self.view addSubview:iconTwo];
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[iconTwo][_adjustableButton]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_adjustableButton, iconTwo)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[iconTwo]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(iconTwo)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_adjustableButton]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_adjustableButton)
                                      ]];
    
    
    self.bottomButtonConstraint = [NSLayoutConstraint constraintWithItem:self.adjustableButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:self.view.frame.size.width/2
                            ];
    
    [constraints addObject:self.bottomButtonConstraint];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.adjustableButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:64.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:iconTwo
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:64.f
                            ]];
    
    [self.view addConstraints:constraints];
}


-(void)toggleEditFeed{
    
    if (self.viewState == ViewStateNormal) {
        [self.editFeed setAlpha:1.f];
        [self.editFeed showItems];
        
        void(^animations)(void) = ^{
            [self.scrollView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
            [self.scrollView setAlpha:0.f];
            self.bottomButtonConstraint.constant = self.view.frame.size.width;
            
            [self.view layoutIfNeeded];
        };
        [UIView animateWithDuration:.5 animations:animations];
        self.viewState = ViewStateEdit;
    }else{
        void(^animations)(void) = ^{
            [self.scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.scrollView setAlpha:1.f];
            self.bottomButtonConstraint.constant = self.view.frame.size.width/2;
            [self.view layoutIfNeeded];
            self.editFeed.alpha = 0.f;
        };
        
        [UIView animateWithDuration:.5 animations:animations];
        self.viewState = ViewStateNormal;
    }
}


-(void)toggleFocusWithState:(DetailViewState)itemViewState{

    void(^animations)(void) = ^{};
    if (itemViewState == detailViewStateNormal) {
        animations = ^{
            self.editFeedButton.alpha = 1.f;
            self.adjustableButton.alpha = 1.f;
        };
    }else if (itemViewState == detailViewStateTagsDisplayed){
        animations = ^{
            self.editFeedButton.alpha = 0.f;
            self.adjustableButton.alpha = 0.f;
        };
    }
    
    [UIView animateWithDuration:.2 animations:animations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
