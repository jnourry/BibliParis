//
//  BibliParisAppDelegate.h
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HTMLParser.h"

@interface BibliParisAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *infosString;
    NSString *pretsString;
    NSString *reservationsString;
    NSInteger numberofprets;
    NSInteger numberofreservations;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *infosString;
@property (strong, nonatomic) NSString *pretsString;
@property (strong, nonatomic) NSString *reservationsString;
@property NSInteger numberofprets;
@property NSInteger numberofreservations;

@end
