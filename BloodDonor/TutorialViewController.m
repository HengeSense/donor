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
        CGRect frame = scrollView.frame;
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
    
    if (scrollView.contentOffset.x >= 1960)
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

- (void)pageControlPageDidChange
{
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

- (IBAction)doneButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect f = CGRectMake(0, 448, 320, 36);
    pageControl = [[PageControl alloc] initWithFrame:f];
    pageControl.numberOfPages = 7;
    pageControl.currentPage = 0;
    pageControl.dotColorCurrentPage = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    pageControl.dotColorOtherPage = [UIColor colorWithRed:79.0f/255.0f green:59.0f/255.0f blue:52.0f/255.0f alpha:1.0f];
    pageControl.delegate = self;
    [self.navigationController.tabBarController.view addSubview:pageControl];
    
    for (int i = 0; i < pageControl.numberOfPages; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorialImage%d", i + 1]];
        [imageArray addObject:[[[UIImageView alloc] initWithImage:image] autorelease]];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [imageArray release];
    [pageControl release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
