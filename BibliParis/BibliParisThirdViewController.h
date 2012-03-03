//
//  BibliParisThirdViewController.h
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface BibliParisThirdViewController : UIViewController
{
    IBOutlet UIWebView *reservationsWebView;
    IBOutlet UITabBarItem *tabbaritem;
    IBOutlet UIView *sousview;

}

//UI elements
@property (nonatomic, retain) UIWebView *reservationsWebView;
@property (nonatomic, retain) UITabBarItem *tabbaritem;
@property (nonatomic, retain) UIView *sousview;


@end
