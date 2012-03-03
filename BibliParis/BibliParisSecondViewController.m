//
//  BibliParisSecondViewController.m
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BibliParisSecondViewController.h"
#import "BibliParisAppDelegate.h"

@interface BibliParisSecondViewController ()

@end

@implementation BibliParisSecondViewController

@synthesize pretsWebView;
@synthesize tabbaritem;
@synthesize sousview;

- (void)viewDidLoad
{
    BibliParisAppDelegate *appDelegate = (BibliParisAppDelegate *)[[UIApplication sharedApplication] delegate];    
    
    //NSLog(@"prets : %@",appDelegate.pretsString);
    [pretsWebView loadHTMLString:appDelegate.pretsString baseURL:NULL];
    
    // Modification des View avec des bords arrondis et noirs
    [sousview.layer setMasksToBounds:YES];
    
    sousview.layer.cornerRadius = 5.0;
    sousview.layer.borderColor = [UIColor blackColor].CGColor;
    sousview.layer.borderWidth = 1.5;
    
    sousview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
