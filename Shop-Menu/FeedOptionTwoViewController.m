//
//  FeedOptionTwoViewController.m
//  Shop-Menu
//
//  Created by james.dunay on 10/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "FeedOptionTwoViewController.h"
#import "FeedItemCell.h"
#import "EditFeed.h"
#import "FakeNavView.h"

static NSString *TagCellIdentifer = @"TagCellIdentifer";
static NSString *FeedCellIdentifer = @"FeedCellIdentifer";

typedef NS_ENUM(NSInteger, ViewState) {
    ViewStateNormal = 0,
    ViewStateEdit
};

@interface FeedOptionTwoViewController ()

@property(nonatomic, strong)UITableView* tableView;
@property(nonatomic, strong)NSArray* data;
@property(nonatomic, strong)NSIndexPath* selectedIndexPath;
@property(nonatomic)ViewState viewState;
@property(nonatomic, strong)UIButton* editFeedButton;
@property(nonatomic, strong)EditFeed* editFeed;
@property(nonatomic, strong)FakeNavView* navView;
@property(nonatomic)CGFloat cellHeight;

@end

@implementation FeedOptionTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellHeight = 0;
    
    self.data = @[[[FeedItemCell alloc] init], [[FeedItemCell alloc] init], [[FeedItemCell alloc] init], [[TagCell alloc] init], [[FeedItemCell alloc] init], [[FeedItemCell alloc] init]];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.separatorColor = [UIColor clearColor];

    self.selectedIndexPath = [[NSIndexPath alloc] init];
    [self.view addSubview:self.tableView];
    
    self.editFeed = [[EditFeed alloc] initWithFrame:self.view.frame];
    [self.editFeed setAlpha:0.f];
    [self.view addSubview:self.editFeed];
    
    self.navView = [[FakeNavView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    self.navView.currentTitle = @"FEED";
    [self.view addSubview:self.navView];
    
    self.editFeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editFeedButton setBackgroundColor:[UIColor blueColor]];
    [self.editFeedButton setFrame:CGRectMake(self.view.frame.size.width - 67, 20, 40, 40)];
    [self.editFeedButton addTarget:self action:@selector(toggleEditFeed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editFeedButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.data[indexPath.row] isKindOfClass:[FeedItemCell class]]) {
        return 400.f;
    }else if(![indexPath isEqual:self.selectedIndexPath]){
        return self.cellHeight;
    }else{
        return 300.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.data[indexPath.row] isKindOfClass:[FeedItemCell class]]) {
        FeedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedCellIdentifer];
        if (cell == nil){
            cell = [[FeedItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedCellIdentifer];
        }
            return cell;
    }else{
        TagCell *cell = [tableView dequeueReusableCellWithIdentifier:TagCellIdentifer];
        if (cell == nil){
            cell = [[TagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TagCellIdentifer];
            cell.tagCellDelegate = self;
        }
            return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.data[indexPath.row] isKindOfClass:[TagCell class]]) {
        TagCell* tagCell = (TagCell*)[tableView cellForRowAtIndexPath:indexPath];

        self.selectedIndexPath = indexPath;
        [UIView animateWithDuration:.4
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [tagCell cellExpanded];
                             [tableView beginUpdates];
                             [tableView endUpdates];
                         } completion:nil];
    }
}

-(void)closeTagCell{

    TagCell* tagCell = (TagCell*)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    self.selectedIndexPath = nil;
    [UIView animateWithDuration:.4
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [tagCell cellExpanded];
                         [self.tableView beginUpdates];
                         [self.tableView endUpdates];
                     } completion:nil];
}


-(void)toggleEditFeed{

    if (self.viewState == ViewStateNormal) {
        self.navView.currentTitle = @"EDIT";
        [self.editFeed setAlpha:1.f];
        [self.editFeed showItems];
        
        void(^animations)(void) = ^{
            [self.tableView setFrame:CGRectMake(0, 400, self.view.frame.size.width, self.view.frame.size.height)];
            [self.tableView setAlpha:0.f];
        };
        [UIView animateWithDuration:.5 animations:animations];
        self.viewState = ViewStateEdit;
    }else{
        self.navView.currentTitle = @"FEED";
        void(^animations)(void) = ^{
            [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [self.tableView setAlpha:1.f];

            self.editFeed.alpha = 0.f;
        };
        
        [UIView animateWithDuration:.3 animations:animations];
        self.viewState = ViewStateNormal;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(UITableViewCell* cell, NSUInteger idx, BOOL *stop) {
        if (cell.reuseIdentifier == TagCellIdentifer) {
            NSIndexPath* tagCellPath = [self.tableView indexPathForCell:cell];

            CGRect cellRect = [self.tableView rectForRowAtIndexPath:tagCellPath];
            CGRect rectInTableView = [self.tableView convertRect:cellRect toView:[self.tableView superview]];
        
            if (rectInTableView.origin.y <= 400 && !((TagCell*)cell).isOpen) {
                [self.tableView beginUpdates];
                self.cellHeight = 100;
                [self.tableView endUpdates];
                [((TagCell*)cell) openCell];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end