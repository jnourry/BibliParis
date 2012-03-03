//
//  BibliParisAppDelegate.m
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BibliParisAppDelegate.h"
#import "BibliParisLoginViewController.h"

@implementation BibliParisAppDelegate

@synthesize window = _window;
@synthesize infosString;
@synthesize pretsString;
@synthesize reservationsString;
@synthesize numberofprets;
@synthesize numberofreservations;

BOOL loginOK=FALSE;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"login" object:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive\n");
    
    // On teste si le dernier accès date de moins de 30 mns, auquel cas on retourne sur l'écran login
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    NSDate *lastdate = [userPrefs objectForKey:@"last_Date"];
    if (lastdate != nil)
        {
        double timeInterval = [lastdate timeIntervalSinceNow];
        NSLog(@"timeInterval : %f",timeInterval);
        if (-timeInterval > 600)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil]; 
        }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"login"
                                                  object: nil];
}

-(void)login:(NSNotification *) notification
{
    NSLog(@"login");
    
    // On récupère l'identifiant et le mot de passe sur l'écran de login
    BibliParisLoginViewController *loginView = (BibliParisLoginViewController *)self.window.rootViewController;
    
    NSString *tmpid = loginView.idText.text;
    NSString *tmpmdp = loginView.mdpText.text;
    
    // Start request
    NSURL *url = [NSURL URLWithString:@"http://b14-sigbermes.apps.paris.fr/CDA/pages/logon.aspx"];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"EXPLOITATION" forKey:@"INSTANCE"];
    
    [request setPostValue:tmpid forKey:@"name"];
    [request setPostValue:tmpmdp forKey:@"pwd"];
    
    [request setPostValue:@"http://b14-sigbermes.apps.paris.fr/medias/medias.aspx?instance=EXPLOITATION" forKey:@"PAGERETOUR"];
    [request setPostValue:@"RELOAD_PORTAL" forKey:@"EVENTS"];
    
    
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)accesDetail
{
    NSLog(@"accesDetail");
    
    // Start request
    NSURL *url = [NSURL URLWithString:@"http://b14-sigbermes.apps.paris.fr/clientBookline/recherche/dossier_lecteur.asp"];
    
    // On récupère l'identifiant et le mot de passe sur l'écran de login
    BibliParisLoginViewController *loginView = (BibliParisLoginViewController *)self.window.rootViewController;
    
    NSString *tmpid = loginView.idText.text;
    NSString *codebarre = [NSString stringWithFormat:@"BPVP.%@", tmpid];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"EXPLOITATION" forKey:@"INSTANCE"];
    [request setPostValue:@"CANVAS" forKey:@"OUTPUT"];
    
    [request setPostValue:codebarre forKey:@"CodeBarre"];
    //[request setPostValue:@"20101981" forKey:@"Password"];
    [request setPostValue:@"FALSE" forKey:@"DISPLAYMENU"];
    [request setPostValue:@"VPCO" forKey:@"strCodeDocBase"];
    
    [request setDelegate:self];
    
    [request startAsynchronous];
        
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    NSLog(@"requestFinished");
    NSLog(@"responseStatusCode : %i",request.responseStatusCode);
    
    if (request.responseStatusCode == 200)
    {
        if(!loginOK)
        {
            NSString *loginString = [request responseString];
            //NSLog(@"Login : \n%@",loginString);
            NSRange range = [loginString rangeOfString:@"Vous avez actuellement"];
            if(range.location != NSNotFound)
                {
                loginOK = TRUE;
                [self accesDetail];
                }
            else {
                //problème d'identifiant ou de mot de passe
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Login impossible"
                                      message:@"Votre identifiant et/ou votre mot de passe est erroné"
                                      delegate:self 
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];   
                [alert show];
            }
        }
        else
            [self loadData:request];
                    
    }
    else
    {
        NSString *statusMessage = [request responseStatusMessage];
        NSLog(@"statusMessage : %@",statusMessage);
    }

    
}


- (void)loadData:(ASIHTTPRequest *)request
{ 
    // Use when fetching text data
    NSString *htmlString = [request responseString];
    BOOL infosOK=FALSE;
    BOOL pretsOK=FALSE;
    BOOL reservationsOK=FALSE;
    
    // Parsing the HTML string
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
    if (error) 
        {
        NSLog(@"Error: %@", error);
        return;
        }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *tableNodes = [bodyNode findChildTags:@"table"];
    for (HTMLNode *tableNode in tableNodes) 
    {
        // 1er web view
        if ([[tableNode getAttributeNamed:@"summary"] isEqualToString:@"Informations générales"]) 
        {
            infosString = [tableNode rawContents];
            infosString = [infosString stringByReplacingOccurrencesOfString:@"summary" withString:@"summary style=\"font-size:30px;\""];
            infosString = [infosString stringByReplacingOccurrencesOfString:@"Informations générales" withString:@""];
            // On enlève le pied et l'entête
            infosString = [infosString stringByReplacingOccurrencesOfString:@"<tr><td class=\"CONTENT_ENTETE\"><p></p></td></tr>" withString:@""];
            infosString = [infosString stringByReplacingOccurrencesOfString:@"<tr><td class=\"CONTENT_PIED\"><p></p></td></tr>" withString:@""];
            infosOK = TRUE;
            
        }
        
        // 2ème web view
        if ([[tableNode getAttributeNamed:@"summary"] isEqualToString:@"Prêt(s) en cours"]) 
        {
            pretsString = [tableNode rawContents];
            pretsString = [pretsString stringByReplacingOccurrencesOfString:@"Prêt(s) en cours" withString:@""];
            pretsString = [pretsString stringByReplacingOccurrencesOfString:@"cellspacing=\"0\"" withString:@"cellspacing=\"5\""];
            pretsString = [pretsString stringByReplacingOccurrencesOfString:@"cellpadding=\"0\"" withString:@"cellpadding=\"10\""];
            pretsString = [pretsString stringByReplacingOccurrencesOfString:@"summary" withString:@"summary style=\"font-size:30px;\""];
            // On enlève le pied et l'entête
            pretsString = [pretsString stringByReplacingOccurrencesOfString:@"<tr><td class=\"CONTENT_ENTETE\"><p></p></td></tr>" withString:@""];
            pretsString = [pretsString stringByReplacingOccurrencesOfString:@"<tr><td class=\"CONTENT_PIED\"><p></p></td></tr>" withString:@""];
            
            // On supprime également la dernière colonne
            pretsString = [pretsString stringByReplacingOccurrencesOfString:@"<td>Prolonger le prêt</td>" withString:@""];
            // il faut aussi la colonne avec les liens hypertext
            pretsString = [self removeHyperlinks:pretsString];
                
            // On cherche le  suivant pour vérifier que le tableau n'est pas vide
            NSRange range = [pretsString rangeOfString:@"Date de retour prévue"];
            if(range.location != NSNotFound)
            {
                NSArray * portions = [pretsString componentsSeparatedByString:@"</tr>"];
                NSUInteger numberoflinebreaks = [portions count] - 1;
                if (numberoflinebreaks > 3) 
                    numberofprets = numberoflinebreaks - 3;
                else 
                    numberofprets = 0;
            }
            else
            {
                // pas de prêt en cours, on grossit la police HTML
                numberofprets = 0;
                pretsString = [pretsString stringByReplacingOccurrencesOfString:@"summary style=\"font-size:20px;\"" withString:@"summary style=\"font-size:40px;\""];
            }
                        
            pretsOK = TRUE;
        }
        
        // 3ème web view
        if ([[tableNode getAttributeNamed:@"summary"] isEqualToString:@"Informations sur vos documents réservés"]) 
        {
            reservationsString = [tableNode rawContents];
            reservationsString = [reservationsString stringByReplacingOccurrencesOfString:@"Informations sur vos documents réservés" withString:@""];
            reservationsString = [reservationsString stringByReplacingOccurrencesOfString:@"cellspacing=\"0\"" withString:@"cellspacing=\"5\""];
            reservationsString = [reservationsString stringByReplacingOccurrencesOfString:@"summary" withString:@"summary style=\"font-size:20px;\""];
            // On enlève le pied et l'entête
            reservationsString = [reservationsString stringByReplacingOccurrencesOfString:@"<tr><td class=\"CONTENT_ENTETE\"><p></p></td></tr>" withString:@""];
            reservationsString = [reservationsString stringByReplacingOccurrencesOfString:@"<tr><td class=\"CONTENT_PIED\"><p></p></td></tr>" withString:@""];
            
            // NON TESTE !!!!
            // On cherche le substring suivant pour vérifier que le tableau n'est pas vide
            NSRange range = [reservationsString rangeOfString:@"Titre"];
            if(range.location != NSNotFound)
            {
                NSArray * portions = [reservationsString componentsSeparatedByString:@"</tr>"];
                NSUInteger numberoflinebreaks = [portions count] - 1;
                if (numberoflinebreaks > 3) 
                    numberofreservations = numberoflinebreaks - 3;
                else 
                    numberofreservations = 0;
            }
            else
            {
                // pas de réservations en cours, on grossit la police HTML
                numberofreservations = 0;
                reservationsString = [reservationsString stringByReplacingOccurrencesOfString:@"summary style=\"font-size:20px;\"" withString:@"summary style=\"font-size:40px;\""];
            }
            
            reservationsOK = TRUE;
        }
        
    }
    
    if(pretsOK && infosOK && reservationsOK)
        {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"donneeschargees" object:nil]; 
        NSLog(@"donneeschargees");
            
        // On sauvegarde le timestamp des dernières données chargées
        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        NSDate *lastDate = [NSDate date];
        
        [userPrefs setObject:lastDate forKey:@"last_Date"];
        [userPrefs synchronize]; 
        }

}


- (void)requestFailed:(ASIHTTPRequest *)request
{    
    NSError *error = [request error];
    NSLog(@"requestFailed");
    NSLog(@"error : %@",error);
}

- (NSString *)removeHyperlinks:(NSString *)string {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:string];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<td><p" intoString:NULL] ; 
        
        // find end of tag
        [theScanner scanUpToString:@"/p></td>" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        string = [string stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@/p></td>", text]
                                               withString:@""];        
        
    } // while //
    
    return string;
    
}

@end
