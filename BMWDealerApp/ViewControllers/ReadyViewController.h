//
//  ReadyViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 8/29/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageControl.h"

#define RESERVATION_URL @"http://bmwactivatethefuture.com/register"
#define LEGAL_URL @"http://www.bmwusa.com/Standard/Content/PrivacyPolicy"
#define STAY_INFORMED_URL @"https://www.bmwusa.com/Secured/content/Forms/ActiveELeadModal.aspx"

@interface ReadyViewController : UIViewController <UIAlertViewDelegate, PageControlDelegate>
{
	IBOutlet UIView * tabView;
	
	IBOutlet UIButton * buttonReservation;
	IBOutlet UIButton * buttonConsultation;
	IBOutlet UIButton * buttonLease;
    IBOutlet UIButton *btnReserveNow;
    IBOutlet UIButton *btnStayInformed;
	
	IBOutlet UIView * contentViewReservation;
	IBOutlet UIView * contentViewConsultation;
	IBOutlet UIView * contentViewLease;
    
    IBOutlet UILabel *lblResereLeft;
    IBOutlet UILabel *lblResereCenterTop;
    IBOutlet UILabel *lblResereCenterMiddle;
	
	NSArray * tabs;
	
	IBOutlet UIView * webViewContainer;
	IBOutlet UIWebView * webView;
	
	UIButton * currentButton;
	UIView * currentContentView;
    
    PageControl *pageController;
}

@property (nonatomic, retain) PageControl *pageController;

- (IBAction)tabButtonPressed:(id)sender;
- (IBAction)reserveNowButtonPressed:(id)sender;
- (IBAction)stayInformedButtonPressed:(id)sender;
- (IBAction)leaseTermsButtonPressed:(id)sender;
- (IBAction)legalButtonPressed:(id)sender;

- (IBAction)webViewContainerBackButtonPressed:(id)sender;

- (void)toggleWebView:(NSURL *)url;

- (void)changeToTabViewContent:(NSInteger)tabId;
- (void)bounceTabViewContent:(BOOL)directionLeft;

@end
