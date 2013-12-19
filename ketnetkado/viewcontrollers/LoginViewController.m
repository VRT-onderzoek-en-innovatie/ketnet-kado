//
//  LoginViewController.m
//  ketnetkado
//
//  Created by Martijn Vandenberghe on 12/12/13.
//  Copyright (c) 2013 VRT Onderzoek en Innovatie. All rights reserved.
//

#import "LoginViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05achtergrond"]]];
    
	if ([self setupScrollView]) {
		[self setupUitleg];
		[self setupTextFields];
		[self setupLoginButton];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View setup

- (BOOL)setupScrollView {
	loginScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
																	 0,
																	 CGRectGetHeight(self.view.bounds),
																	 CGRectGetWidth(self.view.bounds))];
	[loginScrollView setContentSize:CGSizeMake(CGRectGetHeight(self.view.bounds),
											   CGRectGetWidth(self.view.bounds) + 140)];
	[loginScrollView setBackgroundColor:[UIColor clearColor]];
	[loginScrollView setScrollEnabled:NO];
	[loginScrollView setScrollsToTop:YES];
	[loginScrollView setBounces:YES];
	[self.view addSubview:loginScrollView];
	
	return YES;
}

- (void)setupUitleg {
    UILabel *uitleg = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                25,
                                                                self.view.frame.size.height,
                                                                30)];
    [uitleg setText:@"Log in met je Ketprofiel"];
    [uitleg setFont:[UIFont fontWithName:@"Ovink-Black" size:20.0]];
    [uitleg setTextAlignment:NSTextAlignmentCenter];
    [uitleg setTextColor:UIColorFromRGB(0xed145b)];
    [loginScrollView addSubview:uitleg];
}

- (void)setupLoginButton  {
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds),
                                                          200,
                                                          214,
                                                          104)];
    
    [btnLogin addTarget:self
                     action:@selector(logGebruikerIn)
           forControlEvents:UIControlEventTouchUpInside];
	[btnLogin setBackgroundImage:[UIImage imageNamed:@"05loginbutton"] forState:UIControlStateNormal];
	[btnLogin setBackgroundImage:[UIImage imageNamed:@"05loginbutton_pressed"] forState:UIControlStateHighlighted];
	[btnLogin setTag:3];
    [loginScrollView addSubview:btnLogin];
    [loginScrollView bringSubviewToFront:btnLogin];
}

- (void)setupTextFields {
    txtUsername = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 348/2,
                                                                50,
                                                                348,
                                                                114)];
    [txtUsername setFont:[UIFont fontWithName:@"Ovink-Black" size:20.0]];
    [txtUsername setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05username"]]];
	[txtUsername setPlaceholder:@"Gebruikersnaam"];
	[txtUsername setClearsOnBeginEditing:YES];
//	[txtUsername setClearButtonMode:UITextFieldViewModeWhileEditing];
	[txtUsername setTag:1];
	[txtUsername setDelegate:self];
	[txtUsername setReturnKeyType:UIReturnKeyNext];
    
    UIView *spacerViewUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 10)];
    [txtUsername setLeftViewMode:UITextFieldViewModeAlways];
    [txtUsername setLeftView:spacerViewUser];
    
    [loginScrollView addSubview:txtUsername];
    [loginScrollView bringSubviewToFront:txtUsername];
    
    txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMidY(self.view.bounds) - 348/2,
                                                                125,
                                                                348,
                                                                114)];
    [txtPassword setFont:[UIFont fontWithName:@"Ovink-Black" size:20.0]];
    [txtPassword setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"05paswoord"]]];
	[txtPassword setPlaceholder:@"Wachtwoord"];
	[txtPassword setClearsOnBeginEditing:YES];
//	[txtPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    [txtPassword setSecureTextEntry:YES];
	[txtPassword setTag:2];
	[txtPassword setDelegate:self];
	[txtPassword setReturnKeyType:UIReturnKeyDone];
    
    UIView *spacerViewPass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 10)];
    [txtPassword setLeftViewMode:UITextFieldViewModeAlways];
    [txtPassword setLeftView:spacerViewPass];
    
    [loginScrollView addSubview:txtPassword];
    [loginScrollView bringSubviewToFront:txtPassword];
}

- (void)toonBezig {
    UIView *bezigView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 self.view.frame.size.height,
                                                                 self.view.frame.size.width)];
    [bezigView setBackgroundColor:UIColorFromRGB(0x3cc0f0)];
    
    UILabel *bezigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    self.view.frame.size.height/2 - 50/2 - 50,
                                                                    self.view.frame.size.width,
                                                                    50)];
    [bezigLabel setText:@"We melden je nu aan bij Ketnet..."];
    [bezigLabel setFont:[UIFont fontWithName:@"Ovink-Black" size:25.0]];
    [bezigLabel setTextAlignment:NSTextAlignmentCenter];
    [bezigLabel setTextColor:[UIColor whiteColor]];
	[bezigView addSubview:bezigLabel];
	
	UIActivityIndicatorView *bezigSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[bezigSpinner setFrame:CGRectMake(self.view.frame.size.width/2 - 100/2,
									  self.view.frame.size.height/2 - 100/2 + 20,
									  100,
									  100)];
	[bezigView addSubview:bezigSpinner];
	[bezigSpinner startAnimating];
    
    [bezigView setTag:99];
    [bezigView setAlpha:0];
    [self.view addSubview:bezigView];
    [self.view bringSubviewToFront:bezigView];
    [UIView animateWithDuration:0.25
                     animations:^{
                         [bezigView setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)verbergBezig {
    for (UIView *subView in [self.view subviews]) {
        if (subView.tag == 99) {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 [subView setAlpha:0];
                             }
                             completion:^(BOOL finished) {
                                 [subView removeFromSuperview];
                             }];
        }
    }
}

#pragma mark - Acties

- (void)logGebruikerIn {
	[self toonBezig];
	
    NSLog(@"<LoginViewController> Login starten...");
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    loginManager = appDelegate.loginManager;
    [loginManager setDelegate:self];
    [loginManager logGebruikerInMetGebruikersnaam:txtUsername.text enPaswoord:txtPassword.text];
}

- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[loginScrollView setScrollEnabled:YES];
	
	if (textField.tag == 1) {
		//Niks doen
	}
	else {
		//Offset bijschakelen
		[loginScrollView setContentOffset:CGPointMake(0, 125)];
	}
	
	return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
		if (nextTag == 2) {
			[loginScrollView setContentOffset:CGPointMake(0, 125)];
		}
		if (nextTag == 3) {
			[textField resignFirstResponder];
			[loginScrollView setContentOffset:CGPointMake(0, 0)];
			[self logGebruikerIn];
		}
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
		[loginScrollView setContentOffset:CGPointMake(0, 0)];
	}
	return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - LoginManager delegate

- (void)isIngelogdMetGebruikersGegevens:(NSDictionary *)gebruikersGegevens {
    [self verbergBezig];
    
    NSLog(@"<LoginViewController> Gebruikersgegevens (%@) ontvangen, doorgaan met upload...", gebruikersGegevens);
	
	if ([self.delegate respondsToSelector:@selector(inloggenBeeindigdMetGebruikersGegevens:)]) {
		[self.delegate inloggenBeeindigdMetGebruikersGegevens:gebruikersGegevens];
	}
	
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:^{
                                                          NSLog(@"<LoginViewController> Gegevens doorgegeven.");
                                                      }];
}

- (void)isNietIngelogdMetFout:(NSError *)fout {
    [self verbergBezig];
    
    NSLog(@"<LoginViewController> Foutmelding tonen");
    UIAlertView *foutmelding = [[UIAlertView alloc] initWithTitle:@"Oeps!"
                                                          message:@"Je gebruikersnaam of je paswoord zijn niet helemaal juist. Vul je ze even opnieuw in?"
                                                         delegate:self
                                                cancelButtonTitle:@"Ja"
                                                otherButtonTitles:nil];
    [foutmelding show];
}

@end
