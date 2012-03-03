//
//  BibliParisLoginViewController.m
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BibliParisLoginViewController.h"
#import "Reachability.h"
#import "BibliParisAppDelegate.h"
#import "BibliParisSecondViewController.h"
#import "BibliParisThirdViewController.h"

@interface BibliParisLoginViewController ()

@end

@implementation BibliParisLoginViewController

@synthesize idView;
@synthesize optionsView;
@synthesize idText;
@synthesize mdpText;
@synthesize idSwitch;
@synthesize connexionButton;
@synthesize activityindicator;

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad Login View\n");
    [super viewDidLoad];
    
    [activityindicator setHidden:TRUE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donneeschargees:) name:@"donneeschargees" object:nil];
    
    // Modification des View avec des bords arrondis et noirs
    [idView.layer setMasksToBounds:YES];
    
    idView.layer.cornerRadius = 9.0;
    idView.layer.borderColor = [UIColor blackColor].CGColor;
    idView.layer.borderWidth = 2.0;
    
    [optionsView.layer setMasksToBounds:YES];
    
    optionsView.layer.cornerRadius = 9.0;
    optionsView.layer.borderColor = [UIColor blackColor].CGColor;
    optionsView.layer.borderWidth = 2.0;
    
    // Modification du bouton de connexion
    connexionButton.layer.masksToBounds = YES;
    connexionButton.layer.cornerRadius = 8.0;
    connexionButton.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.6].CGColor;
    connexionButton.layer.borderWidth = 1.5;
    
    // Sets a gradient on button's background
    CAGradientLayer *shineLayer;
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = connexionButton.layer.bounds;
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:0.8f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.6f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.2f],
                            [NSNumber numberWithFloat:0.4f],
                            [NSNumber numberWithFloat:0.6f],
                            [NSNumber numberWithFloat:0.8f],
                            nil];
    [connexionButton.layer addSublayer:shineLayer];
    
    // Dans les préférences, si c'est la 1ère fois que l'appli est lancée, le switch est à ON
	NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	if ([userPrefs boolForKey:@"first_run"] == 0)
        {
		// First run
		[userPrefs setBool:1 forKey:@"first_run"];
        [userPrefs setBool:1 forKey:@"id_setting"];
		[userPrefs synchronize];
        }
	
    else
        {
        // Get switch value in user preferences
        BOOL idSetting = [userPrefs boolForKey:@"id_setting"];
        
        if (idSetting) 
            {
            [idSwitch setOn:YES animated:NO];
                
            // On renseigne les champs identifiant et mot de passe, et on lance le login directement
                NSLog(@"Get prefs\n");
            idText.text = [userPrefs objectForKey:@"id"];
            mdpText.text = [userPrefs objectForKey:@"mdp"];
                
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];
            }
        else
            [idSwitch setOn:NO animated:NO]; 
        }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"donneeschargees"
                                                  object: nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationPortrait)
        return YES;
    else
        return NO;
}

// Pour se remettre sur l'écran si on touche en dehors du clavier
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [idText resignFirstResponder];
    [mdpText resignFirstResponder];
}

// Pour quitter le clavier si on appuie sur Done
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}



- (IBAction)connexionAction:(id)sender;
{
    NSLog(@"connexionAction");
    
    [activityindicator setHidden:FALSE];
    [activityindicator startAnimating];
    
    BOOL mdpvalid=TRUE;
    BOOL idvalid=TRUE;
    BOOL connected=TRUE;
    
    // Test de la connexion internet
    if(![self connected])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Problème réseau"
                              message:@"Vérifiez que vous êtes bien connecté à internet"
                              delegate:self 
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];   
        [alert show];
        connected = FALSE;
    }

    
    // Ensuite on teste si l'identifiant et le mot de passe sont au bon format
    if (connected && idText.text.length != 14)
        {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Login impossible"
                              message:@"Votre identifiant n'est pas sur 14 chiffres"
                              delegate:self 
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];   
        [alert show];
        idvalid = FALSE;
        }
    
    if (idvalid && connected)
        {
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"ddMMyyyy"];
        NSDate *date = [dateFormat dateFromString:mdpText.text];
        if(date == nil) // S'il ne retourne pas une date, c'est parce que ce n'en est pas une
            {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Login impossible"
                                  message:@"Votre mot de passe n'est pas une date au format AAAAMMJJ"
                                  delegate:self 
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];   
            [alert show];
            mdpvalid = FALSE;
            }
        }
        
    // Si l'identifiant et le mot de passe sont au bon format
    if (connected && idvalid && mdpvalid)
    {
        // On conserve les données, ou pas
        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        if(idSwitch.on)
            {
            [userPrefs setObject:idText.text forKey:@"id"];
            [userPrefs setObject:mdpText.text forKey:@"mdp"];
            }
        else {
            [userPrefs setObject:@"" forKey:@"id"];
            [userPrefs setObject:@"" forKey:@"mdp"];
        }
        [userPrefs synchronize];    

        // On signale à l'AppDelegate que l'utilisateur veut se logger
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];
    }
}

-(void)donneeschargees:(NSNotification *) notification
{    
    // On débranche vers le TabBarController
    [self performSegueWithIdentifier:@"donneeschargeessegue" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // on identifie le bon segue
    if ([[segue identifier] isEqualToString:@"donneeschargeessegue"])
    {
        BibliParisAppDelegate *appDelegate = (BibliParisAppDelegate *)[[UIApplication sharedApplication] delegate]; 
        
        // on récupère la référence au tabbarcontroller
        UITabBarController *tbc = [segue destinationViewController];
        
        // Pour afficher le nombre de prêts sur le tabbar
        BibliParisSecondViewController *vc2 = [tbc.viewControllers objectAtIndex:1];
        vc2.tabbaritem.badgeValue = [NSString stringWithFormat:@"%d", appDelegate.numberofprets];
        
        // Pour afficher le nombre de réservations sur le tabbar
        BibliParisThirdViewController *vc3 = [tbc.viewControllers objectAtIndex:2];
        vc3.tabbaritem.badgeValue = [NSString stringWithFormat:@"%d", appDelegate.numberofreservations];
    }
}

-(IBAction) switchValueChanged
{
    NSLog(@"switchValueChanged");
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
	[userPrefs setBool:idSwitch.on forKey:@"id_setting"];
	[userPrefs synchronize];
}


// Test internet connectivity
- (BOOL)connected 
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}

@end
