//
//  TutorialViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 06.09.12.
//
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

- (void)loadScrollViewWithPage:(int)page;

@end

@implementation TutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        imageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= pageControl.numberOfPages)
    {
        doneButton.hidden = NO;
        return;
    }
    else
        doneButton.hidden = YES;
	
    UIImageView *imageView = [imageArray objectAtIndex:page];
	
    if (nil == imageView.superview)
    {
        CGRect frame = imageView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed)
        return;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    int tutorialEndOffsetX = pageWidth * (pageControl.numberOfPages - 1);
    if (scrollView.contentOffset.x > tutorialEndOffsetX)
    {
        [self doneButtonClick:nil];
        return;
    }
        
    pageControl.currentPage = page;
	
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)doneButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageControl.numberOfPages = 6;
    pageControl.currentPage = 0;
    [self.navigationController.tabBarController.view addSubview:pageControl];
    
    for (int i = 0; i < pageControl.numberOfPages; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"BloodDonor_tutorial_%d", i + 1]];
        [imageArray addObject:[[UIImageView alloc] initWithImage:image]];
    }
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pageControl.numberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    pageControl.currentPage = 0;
	
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
