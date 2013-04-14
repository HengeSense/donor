/*--------------------------------------------------*/

#import "ItsBetaFacebook.h"
#import "ItsBetaGraphUser.h"

/*--------------------------------------------------*/
#if defined(TARGET_OS_IPHONE)
/*--------------------------------------------------*/

#import "NSString+ItsBeta.h"
#import "NSDictionary+ItsBeta.h"
#import "NSURL+ItsBeta.h"

/*--------------------------------------------------*/

#define ITS_BETA_REQUEST_PERMISSIONS_URL @"https://m.facebook.com/dialog/oauth/?response_type=token&client_id=%@&redirect_uri=%@&scope=%@"

/*--------------------------------------------------*/

@interface ItsBetaFacebook () {
    NSString* _accessToken;
    NSMutableDictionary< ItsBetaGraphUser >* _user;
    NSError* _lastError;
}

- (void) localizeView:(UIView*)view withSubviews:(BOOL)withSubviews;
- (void) close;

@end

/*--------------------------------------------------*/

@implementation ItsBetaFacebook

- (id) init {
    self = [super init];
    if(self != nil) {
        _user = NS_SAFE_RETAIN([NSMutableDictionary graphUser]);
        _clientId = NS_SAFE_RETAIN(@"264918200296425");
        _redirectURL = NS_SAFE_RETAIN(@"http://www.itsbeta.com");
        _scope = [NSArray arrayWithObjects:@"publish_stream", @"publish_actions", nil];
        _scope = NS_SAFE_RETAIN(_scope);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_webView);
    NS_SAFE_RELEASE(_activityIndicator);
    NS_SAFE_RELEASE(_parentController);
    
    NS_SAFE_RELEASE(_clientId);
    NS_SAFE_RELEASE(_redirectURL);
    NS_SAFE_RELEASE(_scope);
    
    NS_SAFE_RELEASE(_accessToken);
    NS_SAFE_RELEASE(_user);
    NS_SAFE_RELEASE(_lastError);
        
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self localizeView:[self view] withSubviews:YES];
    [self request];
}

- (void) viewDidUnload {
    [self setWebView:nil];
    [self setActivityIndicator:nil];
    [self setParentController:nil];

    [super viewDidUnload];
}

#pragma mark - Public methods

- (void) request {
    if([self isViewLoaded] == YES) {
        NSString* url = [NSString stringWithFormat:ITS_BETA_REQUEST_PERMISSIONS_URL, _clientId, _redirectURL, [_scope componentsJoinedByString:@","]];
        if(url != nil) {
            [[self webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        }
    } else {
        [self view];
    }
}

#pragma mark - Private methods

- (void) localizeView:(UIView*)view withSubviews:(BOOL)withSubviews {
    if([view isKindOfClass:[UILabel class]] == YES) {
        UILabel* label = (UILabel*)view;
        [label setText:NSLocalizedString([label text], [label text])];
    } else if([view isKindOfClass:[UIButton class]] == YES) {
        UIButton* button = (UIButton*)view;
        NSString* titleNormal = [button titleForState:UIControlStateNormal];
        NSString* titleHighlighted = [button titleForState:UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(titleNormal, titleNormal) forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(titleHighlighted, titleHighlighted) forState:UIControlStateHighlighted];
    } else if([view isKindOfClass:[UINavigationBar class]] == YES) {
        UINavigationBar* navigationBar = (UINavigationBar*)view;
        UINavigationItem* navigationItem = [navigationBar topItem];
        [navigationItem setTitle:NSLocalizedString([navigationItem title], [navigationItem title])];
    }
    if(withSubviews == YES) {
        for(UIView* subview in [view subviews]) {
            [self localizeView:subview withSubviews:YES];
        }
    }
}

- (void) close {
    if(([_accessToken length] > 0) && ([_user count] > 0)) {
        if(_successCallback != nil) {
            _successCallback(_accessToken, _user);
        }
    } else {
        if(_failureCallback != nil) {
            if(_lastError == nil)
            {
                NSError* error = [NSError errorWithDomain:ItsBetaErrorDomain
                                                     code:ItsBetaErrorFacebookAuth
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           NSLocalizedString(@"Facebook.Fail.Session", @""), NSLocalizedDescriptionKey,
                                                           nil]];
                NS_SAFE_SETTER(_lastError, error);
            }
            _failureCallback(_lastError);
        }
    }
    NS_SAFE_RELEASE(_accessToken);
    NS_SAFE_RELEASE(_lastError);
    if([_parentController presentedViewController] == self)
    {
        [_parentController dismissModalViewControllerAnimated:YES];
    }
    NS_SAFE_RELEASE(_parentController);
}

#pragma mark - IBActions

- (IBAction) closePressed:(id)sender {
    [self close];
}

#pragma mark - UIWebViewDelegate

- (BOOL) webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)type {
    if(type == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    if([[[request URL] absoluteString] hasPrefix:_redirectURL] == YES) {
        NSDictionary* components = [[request URL] fragmentComponents];
        NS_SAFE_SETTER(_accessToken, [[components objectForKey:@"access_token"] objectAtIndex:0]);
        if(_accessToken != nil) {
            [_activityIndicator startAnimating];
            NSURLRequest* graphRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", _accessToken]]];
            [NSURLConnection sendAsynchronousRequest:graphRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
                                       if(error == nil) {
                                           NSDictionary* graph = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                           if(error == nil) {
                                               [_user setValuesForKeysWithDictionary:graph];
                                           }
                                       }
                                       if(error != nil) {
                                           NS_SAFE_SETTER(_lastError, error);
                                       }
                                       [_activityIndicator stopAnimating];
                                       [self close];
                                   }];
        }
        return NO;
    }
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView*)webView {
    [_activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView*)webView {
    NSString* content = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    if([content length] > 0) {
        if([_parentController presentedViewController] != self) {
            [_parentController presentModalViewController:self animated:YES];
        }
    }
    [_activityIndicator stopAnimating];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    if(error != nil) {
        NS_SAFE_SETTER(_lastError, error);
    }
    // [self close];
}

@end

/*--------------------------------------------------*/
#endif
/*--------------------------------------------------*/
