//
//  BibliParisSecondViewController.h
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface BibliParisSecondViewController : UIViewController
{
    IBOutlet UIWebView *pretsWebView;
    IBOutlet UITabBarItem *tabbaritem;
    IBOutlet UIView *sousview;
}

//UI elements
@property (nonatomic, retain) UIWebView *pretsWebView;
@property (nonatomic, retain) UITabBarItem *tabbaritem;
@property (nonatomic, retain) UIView *sousview;

@end
