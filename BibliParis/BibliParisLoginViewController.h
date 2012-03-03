//
//  BibliParisLoginViewController.h
//  BibliParis
//
//  Created by Jocelyn Nourry on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface BibliParisLoginViewController : UIViewController
{
    IBOutlet UIView *idView;
    IBOutlet UIView *optionsView;
    IBOutlet UITextField *idText;
    IBOutlet UITextField *mdpText;
    IBOutlet UISwitch *idSwitch;
    IBOutlet UIButton *connexionButton;

}

//UI elements
@property (nonatomic, retain) UIView *idView;
@property (nonatomic, retain) UIView *optionsView;
@property (nonatomic, retain) UITextField *idText;
@property (nonatomic, retain) UITextField *mdpText;
@property (nonatomic, retain) UISwitch *idSwitch;
@property (nonatomic, retain) UIButton *connexionButton;

- (IBAction)connexionAction:(id)sender;

@end
