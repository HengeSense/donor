//
//  HSAddStationReviewViewController.m
//  Donor
//
//  Created by Sergey Seroshtan on 22.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSAddStationReviewViewController.h"

#import "DYRateView.h"
#import "HSStationInfo.h"

#import "HSViewUtils.h"
#import "UIView+HSLayoutManager.h"

#import "HSUIResources.h"

#pragma mark - UI text view constants
static const NSUInteger kReviewTextSymbolsMax = 200;

#pragma mark - UI keyboard and it's animation constants
static const CGFloat kViewShiftedByKeyboardDuration = 0.3f;
static const CGFloat kTabBarHeight = 55.0f;

#pragma mark - Layout constants
static const CGFloat kSectionsVerticalPadding = 10.0f;

@interface HSAddStationReviewViewController () <UITextViewDelegate>

@property (nonatomic, strong) HSStationInfo *stationInfo;
@property (nonatomic, assign) BOOL isKeyboardShown;

@end

@implementation HSAddStationReviewViewController

#pragma mark - Initialization
- (id)initWithStationInfo:(HSStationInfo *)stationInfo {
    THROW_IF_ARGUMENT_NIL(stationInfo);
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.stationInfo = stationInfo;
    }
    return self;
}

#pragma mark - UI lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerKeyboardEventsObservers];
    [self layoutRootView];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.isKeyboardShown) {
        [self.reviewTextView resignFirstResponder];
    }
    [self unregisterKeyboardObservers];
    [super viewWillDisappear:animated];
}

#pragma mark - UI actions
- (IBAction)addReview:(id)sender {
}

#pragma mark - UITextViewDelegate protocol implementation
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else if (textView.text.length > (kReviewTextSymbolsMax - 1)) {
        if ([text isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > kReviewTextSymbolsMax) {
        textView.text = [textView.text stringByReplacingCharactersInRange:
                NSMakeRange(kReviewTextSymbolsMax, textView.text.length - kReviewTextSymbolsMax) withString:@""];
    }
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureUI {
    self.title = @"Мой отзыв";
    [self configureNavigationBar];
    [self configureContentView];
    [self configureRootView];
}

- (void)configureNavigationBar {
}

- (void)configureContentView {
    // Station title
    self.stationNameLabel.text = self.stationInfo.name;
    
    // Rate
    self.stationRateView.editable = YES;
    self.stationRateView.padding = 10.0f;
    self.stationRateView.backgroundColor = [UIColor clearColor];
    self.stationRateView.emptyStarImage = [UIImage imageNamed:@"ratedStarEmpty"];
    self.stationRateView.fullStarImage = [UIImage imageNamed:@"ratedStarFill"];

    self.reviewTextView.backgroundColor = [UIColor clearColor];
    self.reviewTextView.text = @"";
    
    [self.addReviewButton setTitleColor:[HSUIResources contentButtonTitleNormalColor]
            forState:UIControlStateNormal];
    [self.addReviewButton setTitleColor:[HSUIResources contentButtonTitlePressedColor]
            forState:UIControlStateHighlighted];
    
    [self.addReviewButton setBackgroundImage:[UIImage imageNamed:@"content_button_normal"]
            forState:UIControlStateNormal];
    [self.addReviewButton setBackgroundImage:[UIImage imageNamed:@"content_button_pressed"]
            forState:UIControlStateHighlighted];
}

- (void)configureRootView {
    [self.rootScrollView addSubview:self.contentView];
}

#pragma mark - UI layout
- (void)layoutUI {
    [self layoutContentView];
}

- (void)layoutContentView {
    /* Vertical alignment */
    // Station name section
    CGFloat curY = kSectionsVerticalPadding;
    [HSViewUtils setFrameForLabel:self.stationNameLabel atYcoordChange:&curY];
    
    // Under station name container
    curY += kSectionsVerticalPadding;
    [HSViewUtils setFrameForView:self.underStationNameLabelView atYcoordChange:&curY];
    
    // Additional info
    [HSViewUtils setFrameForView:self.additionalInfoView atYcoordChange:&curY];
    
    // Add review button
    curY += kSectionsVerticalPadding;
    [HSViewUtils setFrameForView:self.addReviewButton atYcoordChange:&curY];
    
    [self.contentView changeFrameHeight:curY];
}

- (void)layoutRootView {
    [self.rootScrollView adjustAsContentView];
    self.rootScrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - Keyboard interaction
- (void)registerKeyboardEventsObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
    self.isKeyboardShown = NO;
}

- (void)unregisterKeyboardObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.isKeyboardShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.isKeyboardShown) {
        return;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGRect viewFrame = self.rootScrollView.frame;
    
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView animateWithDuration:kViewShiftedByKeyboardDuration animations:^{
        self.rootScrollView.frame = viewFrame;
        CGRect reviewTextViewFrame =
                [self.reviewTextView convertRect:self.reviewTextView.frame toView:self.rootScrollView];
        [self.rootScrollView scrollRectToVisible:reviewTextViewFrame animated:YES];
    }];
    self.isKeyboardShown = YES;
}
- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.isKeyboardShown) {
        return;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect viewFrame = self.rootScrollView.frame;
    
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView animateWithDuration:kViewShiftedByKeyboardDuration animations:^{
        self.rootScrollView.frame = viewFrame;
        [self.rootScrollView scrollRectToVisible:viewFrame animated:YES];
    }];
    self.isKeyboardShown = NO;
}

- (void)viewDidUnload {
    [self setStationNameLabel:nil];
    [self setUnderStationNameLabelView:nil];
    [super viewDidUnload];
}
@end
