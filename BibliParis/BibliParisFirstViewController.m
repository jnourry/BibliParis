//
//  BibliParisFirstViewController.m
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BibliParisFirstViewController.h"
#import "BibliParisAppDelegate.h"

@interface BibliParisFirstViewController ()

@end

@implementation BibliParisFirstViewController

@synthesize infosWebView;
@synthesize sousview;

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad login");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donneeschargees:) name:@"donneeschargees" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:@"applicationDidBecomeActive" object:nil];
    
    BibliParisAppDelegate *appDelegate = (BibliParisAppDelegate *)[[UIApplication sharedApplication] delegate];
    [infosWebView loadHTMLString:appDelegate.infosString baseURL:NULL];
    
    // Modification des View avec des bords arrondis et noirs
    [sousview.layer setMasksToBounds:YES];
    
    sousview.layer.cornerRadius = 5.0;
    sousview.layer.borderColor = [UIColor blackColor].CGColor;
    sousview.layer.borderWidth = 1.5;
    
    sousview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"donneeschargees"
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"applicationDidBecomeActive"
                                                  object: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)donneeschargees:(NSNotification *) notification
{   
    BibliParisAppDelegate *appDelegate = (BibliParisAppDelegate *)[[UIApplication sharedApplication] delegate];    
    //NSLog(@"infos : %@",appDelegate.infosString);
    [infosWebView loadHTMLString:appDelegate.infosString baseURL:NULL];
}


-(void)applicationDidBecomeActive:(NSNotification *) notification
{   
    // Dans ce cas, on revient vers l'écran de login
    [self.parentViewController performSegueWithIdentifier:@"backtologin" sender:nil];
}
@end
