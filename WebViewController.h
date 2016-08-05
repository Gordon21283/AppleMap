//
//  WebViewController.h
//  AppleMap
//
//  Created by Gordon Kung on 7/21/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>


@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSString * url;
@property(strong,nonatomic) WKWebView *webView;

@end
