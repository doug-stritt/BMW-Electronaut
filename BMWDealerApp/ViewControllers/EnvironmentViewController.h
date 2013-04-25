//
//  EnvironmentViewController.h
//  BMWDealerApp
//
//  Created by Doug Strittmatter on 9/6/11.
//  Copyright 2011 Spies & Assassins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSScrollView.h"
#import "DSSliderController.h"

typedef enum environmentTypeTag
{
	kEnvironmentTree,
    kEnvironmentTV,
    kEnvironmentWasher,
    kEnvironmentGarbage
} EnvironmentType;

@interface EnvironmentViewController : UIViewController <UIScrollViewDelegate> {
    
    IBOutlet DSScrollView *dsScrollView;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblSubtitle;
    IBOutlet UIImageView *imgViewMainTitle;
    IBOutlet UIButton *btnHelp;
    
    // slider
    IBOutlet DSSliderController *dsDialSlider;
    IBOutlet UIButton *btnDayYear;
    BOOL isDaySelected;
    BOOL hasSliderOpened;
    
    float flShoeScrollViewX;
    NSMutableArray *_pageViews;
    NSMutableArray *arrShoeImageNames;
	NSUInteger _currentPageIndex;
	NSUInteger _currentPhysicalPageIndex;
	BOOL _pageLoopEnabled;
	BOOL _rotationInProgress;
    BOOL hasRotationHappened;
    CGPoint prev;
    CGPoint startLocation;
}

@property (nonatomic, retain) NSMutableArray *pageViews;
@property (nonatomic, readonly) NSUInteger currentPageIndex;
@property (nonatomic) NSUInteger physicalPageIndex;

- (NSUInteger)physicalPageForPage:(NSUInteger)page;
- (NSUInteger)pageForPhysicalPage:(NSUInteger)physicalPage;
- (NSUInteger)numberOfPages;

- (IBAction)dayYearButtonSelected:(id)sender;
- (IBAction)helpButtonSelected:(id)sender;
- (IBAction)showEVVideo:(id)sender;
- (void)updateEnvironmentLabel;
-(void) animateScrollView;

@end
