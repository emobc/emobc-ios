/**
 *  Copyright 2012 Neurowork Consulting S.L.
 *
 *  This file is part of eMobc.
 *
 *  eMobcViewController.m
 *  eMobc IOS Framework
 *
 *  eMobc is free software: you can redistribute it and/or modify
 *  it under the terms of the Affero GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  eMobc is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Affero GNU General Public License
 *  along with eMobc.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "NwController.h"
#import "TopMenuData.h"
#import "BottomMenuData.h"
#import "NwUtil.h"
#import "eMobcViewController.h"


@implementation NwController

@synthesize landscapeView;
@synthesize portraitView;

@synthesize backButton;
@synthesize homeButton;

@synthesize mainController;
@synthesize geoRefString;

@synthesize titleLabel;
@synthesize titleLabelLandscape;

@synthesize yocBanner_;
@synthesize admobBanner_;
@synthesize backgroundMenu;

@synthesize theButtons;

@synthesize theTopMenu;
@synthesize theBottomMenu;


/**
 * Inicia el spinner(indicador)
 */
-(void) startSpinner {
	// Add it into the spinnerView
	[self.view addSubview:indicator];
	// Start it spinning! Don't miss this step
}

/**
 * Para y borra el spinner(indicador)
 */
-(void)removeSpinner {
    [indicator removeFromSuperview];
}

/**
 * Called when the controller’s view is released from memory.
 */
-(void)viewDidLoad {
	[super viewDidLoad];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(orientationChanged:) 
												 name:@"UIDeviceOrientationDidChangeNotification" 
											   object:nil];
	

	UIFont * font = [UIFont fontWithName:@"Ubuntu-Bold" size:10];
	self.titleLabel.font = font;
	self.titleLabelLandscape.font = font;
	
	mmView = [[NwMultiMediaView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[mmView setDelegate:self];	
	
	[self createIndicator];

	//publicity
	if(![mainController.appData.banner isEqualToString:@""] && ![mainController.appData.bannerPos isEqualToString:@""] && ![mainController.appData.bannerId isEqualToString:@""]){
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
	}
	
	//Init view into landscape way when display didn't move
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSFileManager *gestorArchivos = [NSFileManager defaultManager];
	NSString *rutaArchivo = [documentsDirectory stringByAppendingPathComponent:@"Form_Profile.data"];

	if([gestorArchivos fileExistsAtPath:rutaArchivo]){
		
		if(![mainController.appData.topMenu isEqualToString:@""]) {
			[self callTopMenu];
		}
		
		if(![mainController.appData.bottomMenu isEqualToString:@""]) {
			[self callBottomMenu];
		}
	}

}


-(void) loadBackgroundMenu{
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			backgroundMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
		}else{
			backgroundMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			backgroundMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
		}else{
			backgroundMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		}				
	}
	
	NSString *imagePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:mainController.appData.backgroundMenu];
	
	imagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePath];

	imagePath = [eMobcViewController addLandscapeImageSuffix:imagePath];
	
	backgroundMenu.image = [UIImage imageWithContentsOfFile:imagePath];
	
	[self.view addSubview:backgroundMenu];
	[backgroundMenu release];
}

/**
 * Create a Menu at the bottom of the View
 */
-(void) callBottomMenu {
	
	int x = 0;
	
	theBottomMenu = [[NwUtil instance] readBottomMenu];
	
	if (mainController.currentNextLevel.levelId != nil) {
		theButtons = [theBottomMenu.menuActions objectForKey:mainController.currentNextLevel.levelId];
	}else if (mainController.currentNextLevel.levelId == nil) {
		theButtons = [theBottomMenu.menuActions objectForKey:@"Default"];
		
	}
	
	if (theButtons == nil) {
		theButtons = [theBottomMenu.menuActions objectForKey:@"Default"];
	}
	
	int count = [theButtons.action count];
	
	for (int i = 0; i < count; i++) {
		AppMenu* theButton = [theButtons.action objectAtIndex:i];
		
		NwButton *button = [NwButton buttonWithType:UIButtonTypeCustom];
		button.nextLevel = theButton.nextLevel;
		
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:theButton.imageName ofType:nil inDirectory:k];
		
		UIImage* buttonImage = [UIImage imageWithContentsOfFile:imagePath];
		
		int width, height;
		
		if(![theButton.imageName isEqualToString:@""] && theButton.imageName != nil){
			width = buttonImage.size.width;
			height = buttonImage.size.height;
		}else{
			width = 80;
			height = 38;
		}
		
		if(i != 0){
			x = x + width + theButton.leftMargin; 
		}
		
		
		//set the position of the button
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 80 || height > 38){
					button.frame = CGRectMake(x, 725, 80, 38);
				}else{
					button.frame = CGRectMake(x, 768 - height, width, height);
				}
			}else{
				if(width > 80 || height > 38){
					button.frame = CGRectMake(x, 981, 80, 38);
				}else{
					button.frame = CGRectMake(x, 1024 - height, width, height);
				}
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 80 || height > 38){
					button.frame = CGRectMake(x, 287, 80, 38);
				}else{
					button.frame = CGRectMake(x, 320 - height, width, height);
				}
			}else{
				if(width > 80 || height > 38){
					button.frame = CGRectMake(x, 447, 80, 38);
				}else{
					button.frame = CGRectMake(x, 480 - height, width, height);
				}
			}				
		}
		
		
		if([theButton.systemAction isEqualToString:@""] || [theButton.systemAction isEqualToString:@"sideMenu"]){
			//listen for clicks
			[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		}else{	
			if([theButton.systemAction isEqualToString:@"back"]){
				[button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			}else if([theButton.systemAction isEqualToString:@"home"]){
				[button addTarget:self action:@selector(homeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			}
		}
		
		if(![theButton.imageName isEqualToString:@""]){
			[button setImage:buttonImage forState:UIControlStateNormal];
			button.adjustsImageWhenHighlighted = NO;
			button.imageView.contentMode = UIViewContentModeScaleAspectFit;
		}else{
			//set the button's title
			[button setTitle:theButton.title forState:UIControlStateNormal];
		}
		
		//add the button to the view
		[self.view addSubview:button];
	}
}

/**
 * Create a Menu at the top of the View
 */

-(void) callTopMenu{
	
	int x = 5;
	
	theTopMenu = [[NwUtil instance] readTopMenu];
	
	if (mainController.currentNextLevel.levelId != nil) {
		theButtons = [theTopMenu.menuActions objectForKey:mainController.currentNextLevel.levelId];
	}else if (mainController.currentNextLevel.levelId == nil) {
		theButtons = [theTopMenu.menuActions objectForKey:@"Default"];
		
	}
	
	if (theButtons == nil) {
		theButtons = [theTopMenu.menuActions objectForKey:@"Default"];
	}
	
	int count = [theButtons.action count];
	
	for (int i = 0; i < count; i++) {
		AppMenu* theButton = [theButtons.action objectAtIndex:i];
		
		NwButton *button = [NwButton buttonWithType:UIButtonTypeCustom];
		button.nextLevel = theButton.nextLevel;
		
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:theButton.imageName ofType:nil inDirectory:k];
		
		UIImage* buttonImage = [UIImage imageWithContentsOfFile:imagePath];
		
		int width, height;
		
		if(![theButton.imageName isEqualToString:@""] && theButton.imageName != nil){
			width = buttonImage.size.width;
			height = buttonImage.size.height;
		}else{
			width = 50;
			height = 28;
		}
		
		if(i != 0){
			x = x + width + theButton.leftMargin; 
		}
		
		
		//set the position of the button
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 50 || height > 28){
					button.frame = CGRectMake(x, 5, 50, 28);
				}else{
					button.frame = CGRectMake(x, 5, width, height);
				}
			}else{
				if(width > 50 || height > 28){
					button.frame = CGRectMake(x, 5, 50, 28);
				}else{
					button.frame = CGRectMake(x, 5, width, height);
				}
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width > 50 || height > 28){
					button.frame = CGRectMake(x, 5, 50, 28);
				}else{
					button.frame = CGRectMake(x, 5, width, height);
				}
			}else{
				if(width > 50 || height > 28){
					button.frame = CGRectMake(x, 5, 50, 28);
				}else{
					button.frame = CGRectMake(x, 5, width, height);
				}
			}				
		}
		
		
		if([theButton.systemAction isEqualToString:@""] || [theButton.systemAction isEqualToString:@"sideMenu"]){
			//listen for clicks
			[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		}else{	
			if([theButton.systemAction isEqualToString:@"back"]){
				[button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			}else if([theButton.systemAction isEqualToString:@"home"]){
				[button addTarget:self action:@selector(homeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			}
		}
		
		if(![theButton.imageName isEqualToString:@""]){
			[button setImage:buttonImage forState:UIControlStateNormal];
			button.adjustsImageWhenHighlighted = NO;
			button.imageView.contentMode = UIViewContentModeScaleAspectFit;
		}else{
			//set the button's title
			[button setTitle:theButton.title forState:UIControlStateNormal];
		}
		
		//add the button to the view
		[self.view addSubview:button];
	}
}


/**
 * Back to Cover (home) when homeButton is pressed
 */
-(void)homeButtonPress:(id)sender {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	 [mainController loadCover];	
}

/**
 * Show a level back when backButton is pressed
 */
-(void)backButtonPress:(id)sender {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self startSpinner];
	
	[mainController goBack];	
}

/**
 * Show a NextLevel when button is pressed
 */
-(void)buttonPressed:(id)sender {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	NextLevel* nextLevel = [sender nextLevel];
	[mainController loadNextLevel:nextLevel];	
}


/**
 * Create an indicate
 */
-(void) createIndicator {

	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	 // Set the resizing mask so it's not stretched
	 indicator.autoresizingMask = 
	 UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin |
	 UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
	 
	 // Place it in the middle of the view
	 indicator.center = self.view.center;
	 
/*
	indicator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	indicator.backgroundColor = [UIColor blackColor];
    indicator.alpha = 0.8;
	
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"alert01-ani01.png"],
                         [UIImage imageNamed:@"alert01-ani02.png"],
                         [UIImage imageNamed:@"alert01-ani03.png"],
                         [UIImage imageNamed:@"alert01-ani04.png"],
                         [UIImage imageNamed:@"alert01-ani05.png"],
                         [UIImage imageNamed:@"alert01-ani06.png"],
                         [UIImage imageNamed:@"alert01-ani07.png"],
                         [UIImage imageNamed:@"alert01-ani08.png"],
                         [UIImage imageNamed:@"alert01-ani09.png"],
                         [UIImage imageNamed:@"alert01-ani10.png"],
                         [UIImage imageNamed:@"alert01-ani11.png"],
                         [UIImage imageNamed:@"alert01-ani12.png"],
                         [UIImage imageNamed:@"alert01-ani13.png"],
                         [UIImage imageNamed:@"alert01-ani14.png"],
                         [UIImage imageNamed:@"alert01-ani15.png"],
                         [UIImage imageNamed:@"alert01-ani16.png"],
                         nil];
    
    UIImageView *myAnimatedView = [UIImageView alloc];
    [myAnimatedView initWithFrame:CGRectMake(35, 110, 250, 218)];
    myAnimatedView.animationImages = myImages;
    myAnimatedView.animationDuration = 2.0; // seconds
    myAnimatedView.animationRepeatCount = 0; // 0 = loops forever
    [myAnimatedView startAnimating];
    [indicator addSubview:myAnimatedView];

	[myAnimatedView release];
	myAnimatedView = nil;*/
}

-(void)dealloc {
	[landscapeView release];
	[portraitView release];
	[titleLabel release];
	[titleLabelLandscape release];
	[backButton release];
	[homeButton release];
	[backgroundMenu release];
	
    // We clean everything
    // Setting the delegate to nil is very important, because if you don't do it, the ad can still call your delegate, even if it's been deallocated (the delegate is not retained by the ad).
    self.yocBanner_.delegate = nil;
	self.admobBanner_.delegate = nil;
    
    // Free the memory...
    self.yocBanner_ = nil;
	self.admobBanner_ = nil;
    	
	[indicator release];
	[backgroundMenu release];
    [super dealloc];
}

/**
 * create an admob banner
 */

-(void) createAdmobBanner {
	// Create a view of the standard size at the bottom of the screen.
	// Available AdSize constants are explained in GADAdSize.h.
	CGPoint origin;	
	
	if([eMobcViewController isIPad]){
		if([mainController.appData.bannerPos isEqualToString:@"top"])
			origin = CGPointMake(0, 0);
		else if ([mainController.appData.bannerPos isEqualToString:@"bottom"])
			origin = CGPointMake(0.0, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height-58.0);
	}else{
		if([mainController.appData.bannerPos isEqualToString:@"top"])
			origin = CGPointMake(0, 0);
		else if([mainController.appData.bannerPos isEqualToString:@"bottom"])
			origin = CGPointMake(0.0, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height-38.0);
	}
	
	admobBanner_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
	
	if([eMobcViewController isIPad]){
		if([mainController.appData.bannerPos isEqualToString:@"top"])
			admobBanner_.center = CGPointMake(self.view.center.x, 84);
		else if([mainController.appData.bannerPos isEqualToString:@"bottom"])
			admobBanner_.center = CGPointMake(self.view.center.x, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height - 15);
	}else{
		if([mainController.appData.bannerPos isEqualToString:@"top"])
			admobBanner_.center = CGPointMake(self.view.center.x, 65);
		else if([mainController.appData.bannerPos isEqualToString:@"bottom"])
			admobBanner_.center = CGPointMake(self.view.center.x, self.view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeBanner).height - 15);
	}
	

	// Specify the ad's "unit identifier." This is your AdMob Publisher ID.
	admobBanner_.adUnitID = mainController.appData.bannerId;
	
	// Let the runtime know which UIViewController to restore after taking
	// the user wherever the ad goes and add it to the view hierarchy.
	admobBanner_.rootViewController = self;
	[self.view addSubview:admobBanner_];
	
	// Initiate a generic request to load it with an ad.
	[admobBanner_ loadRequest:[GADRequest request]];
	
}

/**
 * create a yoc banner
 */
-(void) createYocBanner {
	int yTop = 0;
	int yBottom = 0;
	
	if(![mainController.appData.topMenu isEqualToString:@""]){
		if([eMobcViewController isIPad])
			yTop += 58;
		else
			yTop += 38;
	}
	
	if(![mainController.appData.bottomMenu isEqualToString:@""]){
		if([eMobcViewController isIPad])
			yBottom += 58;
		else
			yBottom += 38;
	}	
	
	//banner create
	// be carefull with banner postion
	if([mainController.appData.bannerPos isEqualToString:@"top"])
		self.yocBanner_ = [[SmartAdServerView alloc] initWithFrame:CGRectMake(0, yTop, self.view.frame.size.width, 50) 
															loader:SmartAdServerViewLoaderActivityIndicatorStyleWhite];
	else if([mainController.appData.bannerPos isEqualToString:@"bottom"])
		self.yocBanner_ = [[SmartAdServerView alloc] initWithFrame:
						   CGRectMake(0, self.view.frame.size.height-50-yBottom, self.view.frame.size.width, 50) 
															loader:SmartAdServerViewLoaderActivityIndicatorStyleWhite];
	
	//banner ID
	[SmartAdServerView setSiteID:(int)mainController.appData.bannerId];
	
    // A banner is usually unlimited, because it stays in place in the application. Unlike the interstitial, it isn't blocking the UI, so it doesn't need to be removed.
    self.yocBanner_.unlimited = YES;
    
    
    // In this example, we just display a simple banner. However, a trafic manager can program an expandable format on this placement.
    // In order to anticipate this, we specify that we want the expand ads to expand from the top.
    self.yocBanner_.expandsFromTop = YES;
	
    
    // We want the banner to stay full width on the device rotation, or on the superview resizing.
    self.yocBanner_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // We set ourself as the delegate, to support clicks, and to be warned by the different events such as if the ad download fails,...
    self.yocBanner_.delegate = self;
	
    
    
    // We ask the view to call an ad, without any timeout. We don't want a timeout in this case because the banner doesn't block the application, so it's not necessary to remove it when the conneciton is bad, we can wait.
    [self.yocBanner_ loadFormatId:7462 pageId:@"220924" master:YES target:nil timeout:5.0];
    
    // We could add the view to "self.view", but this would hide part of the content. If you work with tableview, it's an interesting option to set the banner as the tableview's  header view. If you work with a regular view, or if you want to have the ad always visible, you need prepare some place for it.
    [self.view addSubview:self.yocBanner_];
	
}


/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 *
 * @param interfaceOrientation The orientation of the application’s user interface after the rotation. 
 * The possible values are described in UIInterfaceOrientation.
 *
 * @return YES if the view controller supports the specified orientation or NO if it does not
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
    return YES;
}

/**
 * show multimedia menu
 */
-(void) mostrarMenuMultimedia {

	NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"NwMultiMediaMenu" 
														owner:mmView 
													  options:nil];
	
	UIView *theEditView = [nibObjects objectAtIndex:0];
	menuView = theEditView;
    
    /*
    
    [UIView beginAnimations:@"suck" context:NULL];
    [UIView setAnimationTransition:103 forView:self.view cache:YES];
    [UIView setAnimationPosition:CGPointMake(320, 480)];
    [self.view addSubview:theEditView];
    //[self.view removeFromSuperview];
    [UIView commitAnimations];*/
    
    /*
    [UIView beginAnimations:@"curlUp" context:NULL];
    [UIView _setAnimationFilter:200 forView:self.view];
    [UIView _setAnimationFilterValue:100];
    [self.view addSubview:theEditView];
    [UIView commitAnimations];
     */
    
    [self.view addSubview:theEditView];
}

#pragma mark -
#pragma mark - SmartAdServerView delegate methods

//Methods to complete and to follow SmartAdServerView delegate methods (yoc publicity)
-(void)sasView:(SmartAdServerView *)adView didDownloadAdInfo:(SmartAdServerAd *)adInfo {
}

-(void)sasViewDidLoadAd:(SmartAdServerView *)adView {
}

-(void)sasViewDidDisappear:(SmartAdServerView *)adView {
}


-(void)sasViewDidFailToLoadAd:(SmartAdServerView *)adView {
    if(adView == self.yocBanner_) {
        // Here you can customize what you want to happen in case of failure.
        // In this case, we simply remove the view.
        [self.yocBanner_ removeFromSuperview]; 
    }
    // We don't need to do this for the interstitial, because if "unlimited" is set to "NO", it will be automatically removed.
}

#pragma mark - NwControllerDelegate delegate methods

/**
 * Close multimedia Menu
 */

-(void) nwMMcloseButtonPress {
	[menuView removeFromSuperview];
}


#pragma mark -
#pragma mark iPhone-iPad Support

/**
 * Return if device is an iPad
 *
 * @return YES if device is an iPad NO otherwise
 */
+ (BOOL)isIPad{
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            return YES;
        }
    }
    return NO;
}

@end