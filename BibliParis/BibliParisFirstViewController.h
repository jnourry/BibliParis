//
//  BibliParisFirstViewController.h
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface BibliParisFirstViewController : UIViewController
{
    IBOutlet UIWebView *infosWebView;
    IBOutlet UIView *sousview;

}

//UI elements
@property (nonatomic, retain) UIWebView *infosWebView;
@property (nonatomic, retain) UIView *sousview;

@end
