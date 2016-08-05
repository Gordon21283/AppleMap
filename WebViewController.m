//
//  WebViewController.m
//  AppleMap
//
//  Created by Gordon Kung on 7/21/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import "WebViewController.h"

@interface UIViewController ()

@end


@implementation WebViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSURL *nsurl=[NSURL URLWithString:self.url];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    
    [self.view addSubview:self.webView];


}

@end
