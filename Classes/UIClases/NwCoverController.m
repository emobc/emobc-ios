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

#import "NwCoverController.h"
#import "AppButton.h"
#import "NwButton.h"
#import "Cover.h"
#import "NwUtil.h"
#import "eMobcViewController.h"

@implementation NwCoverController

@synthesize mainController;
@synthesize coverBgImage;
@synthesize coverTitleImage;
@synthesize contentCoverTitleImage;
@synthesize buttonFacebook;
@synthesize buttonTwitter;
@synthesize landscapeView;
@synthesize portraitView;
@synthesize theCover;


/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
    [super viewDidLoad];
	
	theCover = [[NwUtil instance] readCover];
		
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(orientationChanged:) 
												 name:@"UIDeviceOrientationDidChangeNotification" 
											   object:nil];
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else {
		self.view = self.portraitView;
	}
	
	if(![theCover.titleFileName isEqualToString:@""] && theCover.titleFileName !=nil){
		[self createCoverTitleImage];
	}
	
	[self createButtons];
	
	[self buttonsTwitterFacebook];
}


/**
 * Create button in a dinamic way changing the possition for each one
 */
-(void) createButtons{
	loadContent = FALSE;
	
	int x = 0;
	int y = 0;
	int a = 0;
	int b = 0;
		
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			x = 362;
			y = 400;
			a = 522;
			b = 400;
		}else{
			x = 234;
			y = 500;
			a = 394;
			b = 500;
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			x = 80;
			y = 170;
			a = 240;
			b = 170;
		}else{
			x = 0;
			y = 200;
			a = 160;
			b = 200;
		}				
	}	
	
	int count = [theCover.buttons count];
	NwButton *button;
	for (int i = 0; i < count; i++) {
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		AppButton* theButton = [theCover.buttons objectAtIndex:i];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:theButton.fileName ofType:nil inDirectory:k];
		
		UIImage* buttonImage = [UIImage imageWithContentsOfFile:imagePath];
		
		int width, height;
		
		if(![theButton.fileName isEqualToString:@""] && theButton.fileName != nil){
			width = buttonImage.size.width;
			height = buttonImage.size.height;
		}else{
			width = 150;
			height = 40;
		}
		
		//create the button
		button = [NwButton buttonWithType:UIButtonTypeCustom];
		button.nextLevel = theButton.nextLevel;
		
		int modulo = i%2;
		
		if(modulo == 0){
			button.frame = CGRectMake(x, y, width, height);
			y += height;
		}else{
			button.frame = CGRectMake(a, b, width, height);
			b += height;
		}
		
		if(![theButton.fileName isEqualToString:@""] && theButton.fileName != nil){
			[button setImage:buttonImage forState:UIControlStateNormal];
			//button.adjustsImageWhenHighlighted = NO;
		}else{
			//set the button's title
			[button setTitle:theButton.title forState:UIControlStateNormal];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		}
		
		//listen for clicks
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		button.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:button];
	}
}

-(void) createCoverTitleImage{
	NSString *k = [eMobcViewController whatDevice:k];
	
	NSString *titleImagePath = [[NSBundle mainBundle] pathForResource:theCover.titleFileName ofType:nil inDirectory:k];
	
	coverTitleImage = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:titleImagePath]];
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			contentCoverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 350)];
			
			if(coverTitleImage.image.size.width > 1024 || coverTitleImage.image.size.height > 350){
				coverTitleImage.frame = CGRectMake(0, 0, 1024, 350);
			}else{
				coverTitleImage.frame = CGRectMake((1024 - coverTitleImage.image.size.width)/2, (350 - coverTitleImage.image.size.height)/2, coverTitleImage.image.size.width, coverTitleImage.image.size.height);
			}
		}else{
			contentCoverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 350)];
			
			if(coverTitleImage.image.size.width > 768 || coverTitleImage.image.size.height > 350){
				coverTitleImage.frame = CGRectMake(0, 0, 768, 350);
			}else{
				coverTitleImage.frame = CGRectMake((768 - coverTitleImage.image.size.width)/2, (350 - coverTitleImage.image.size.height)/2, coverTitleImage.image.size.width, coverTitleImage.image.size.height);
			}
		}
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			contentCoverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 140)];
			
			if(coverTitleImage.image.size.width > 480 || coverTitleImage.image.size.height > 140){
				coverTitleImage.frame = CGRectMake(0, 0, 480, 140);
			}else{
				coverTitleImage.frame = CGRectMake((480 - coverTitleImage.image.size.width)/2, (140 - coverTitleImage.image.size.height)/2, coverTitleImage.image.size.width, coverTitleImage.image.size.height);
			}
		}else{
			contentCoverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
			
			if(coverTitleImage.image.size.width > 320 || coverTitleImage.image.size.height > 140){
				coverTitleImage.frame = CGRectMake(0, 0, 320, 140);
			}else{
				coverTitleImage.frame = CGRectMake((320 - coverTitleImage.image.size.width)/2, (140 - coverTitleImage.image.size.height)/2, coverTitleImage.image.size.width, coverTitleImage.image.size.height);
			}
		}
	}
		
	coverTitleImage.contentMode = UIViewContentModeScaleAspectFit;
		
	[self.view addSubview:contentCoverTitleImage];
	[contentCoverTitleImage addSubview:coverTitleImage];
}

-(void) buttonFacebookPress:(id)sender {
	[self startSpinner];
	[mainController mostrarWevActivityUrl:theCover.facebook];
}

-(void) buttonTwitterPress:(id)sender {
	[self startSpinner];
	[mainController mostrarWevActivityUrl:theCover.twitter];
}

-(void) buttonsTwitterFacebook{

	if(![theCover.facebook isEqualToString:@""] && theCover.facebook != nil){
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePathF = [[NSBundle mainBundle] pathForResource:theCover.facebookImage ofType:nil inDirectory:k];
		
		UIImage* buttonImageF = [UIImage imageWithContentsOfFile:imagePathF];
		
		int widthF, heightF;
		
		if(![theCover.facebookImage isEqualToString:@""] && theCover.facebookImage != nil){
			widthF = buttonImageF.size.width;
			heightF = buttonImageF.size.height;
		}else{
			widthF = 50;
			heightF = 50;
		}
		
		//create the button
		buttonFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
		
		//set the position of the button
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(widthF > 50 || heightF > 50){
					buttonFacebook.frame = CGRectMake(914, 713, 50, 50);
				}else{
					buttonFacebook.frame = CGRectMake(914 + (50 - widthF)/2, 713 + (50 - heightF)/2, widthF, heightF);
				}
			}else{
				
				if(widthF > 50 || heightF > 50){
					buttonFacebook.frame = CGRectMake(658, 969, 50, 50);
				}else{
					buttonFacebook.frame = CGRectMake(658 + (50 - widthF)/2, 969 + (50 - heightF)/2, widthF, heightF);
				}
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(widthF > 50 || heightF > 50){
					buttonFacebook.frame = CGRectMake(425, 190, 50, 50);
				}else{
					buttonFacebook.frame = CGRectMake(425 + (50 - widthF)/2, 190 + (50 - heightF)/2, widthF, heightF);
				}
				
			}else{
				if(widthF > 50 || heightF > 50){
					buttonFacebook.frame = CGRectMake(210, 430, 50, 50);
				}else{
					buttonFacebook.frame = CGRectMake(210 + (50 - widthF)/2, 430 + (50 - heightF)/2, widthF, heightF);
				}
			}				
		}	
				
		//listen for clicks
		[buttonFacebook addTarget:self action:@selector(buttonFacebookPress:) forControlEvents:UIControlEventTouchUpInside];
		
		if(![theCover.facebookImage isEqualToString:@""] && theCover.facebookImage != nil){
			[buttonFacebook setImage:buttonImageF forState:UIControlStateNormal];
			buttonFacebook.adjustsImageWhenHighlighted = NO;
			buttonFacebook.imageView.contentMode = UIViewContentModeScaleAspectFit;
		}else{
			//set the button's title
			[buttonFacebook setTitle:@"fb" forState:UIControlStateNormal];
		}
				
		[self.view addSubview:buttonFacebook];
	}
	

	if(![theCover.twitter isEqualToString:@""] && theCover.twitter != nil){
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePathT = [[NSBundle mainBundle] pathForResource:theCover.twitterImage ofType:nil inDirectory:k];
		
		UIImage* buttonImageT = [UIImage imageWithContentsOfFile:imagePathT];
		
		int widthT, heightT;
		
		if(![theCover.twitterImage isEqualToString:@""] && theCover.twitterImage != nil){
			widthT = buttonImageT.size.width;
			heightT = buttonImageT.size.height;
		}else{
			widthT = 50;
			heightT = 50;
		}				
		
		//create the button
		buttonTwitter = [UIButton buttonWithType:UIButtonTypeCustom];
		
		//set the position of the button
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(widthT > 50 || heightT > 50){
					buttonTwitter.frame = CGRectMake(969, 713, 50, 50);
				}else{
					buttonTwitter.frame = CGRectMake(969 + (50 - widthT)/2, 713 + (50 - heightT)/2, widthT, heightT);
				}
			}else{
				if(widthT > 50 || heightT > 50){
					buttonTwitter.frame = CGRectMake(713, 969, 50, 50);
				}else{
					buttonTwitter.frame = CGRectMake(713 + (50 - widthT)/2, 969 + (50 - heightT)/2, widthT, heightT);
				}
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(widthT > 50 || heightT > 50){
					buttonTwitter.frame = CGRectMake(425, 245, 50, 50);
				}else{
					buttonTwitter.frame = CGRectMake(425 + (50 - widthT)/2, 245 + (50 - heightT)/2, widthT, heightT);
				}
				
			}else{
				if(widthT > 50 || heightT > 50){
					buttonTwitter.frame = CGRectMake(265, 430, 50, 50);
				}else{
					buttonTwitter.frame = CGRectMake(265 + (50 - widthT)/2, 430 + (50 - heightT)/2, widthT, heightT);
				}
			}				
		}	
				
		//listen for clicks
		[buttonTwitter addTarget:self action:@selector(buttonTwitterPress:) forControlEvents:UIControlEventTouchUpInside];
		
		if(![theCover.twitterImage isEqualToString:@""] && theCover.twitterImage != nil){
			[buttonTwitter setImage:buttonImageT forState:UIControlStateNormal];
			buttonTwitter.adjustsImageWhenHighlighted = NO;
			buttonTwitter.imageView.contentMode = UIViewContentModeScaleAspectFit;
		}else{
			//set the button's title
			[buttonTwitter setTitle:@"twitter" forState:UIControlStateNormal];
		}

		[self.view addSubview:buttonTwitter];
	}
}


/**
 * Create an indicate
 */
-(void)createIndicator {

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
	myAnimatedView = nil;
}

/**
 * Create Animate
 */
-(void) createAnimationCover {
    
	animation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
	animation.backgroundColor = [UIColor blackColor];
    animation.alpha = 0.8;
	
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
                         nil];
    
    UIImageView *myAnimatedView = [UIImageView alloc];
    [myAnimatedView initWithFrame:CGRectMake(35, 110, 250, 218)];
    myAnimatedView.animationImages = myImages;
    myAnimatedView.animationDuration = 2.0; // seconds
    myAnimatedView.animationRepeatCount = 1; // 0 = loops forever
    [myAnimatedView startAnimating];
    [animation addSubview:myAnimatedView];

    
	[myAnimatedView release];
	myAnimatedView = nil;
}

-(void) orientationChanged:(NSNotification *)object{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation ){
		return;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object: nil];
	
	currentOrientation = orientation;
	
	[self performSelector:@selector(orientationChangedMethod) withObject: nil afterDelay: 0];
}

-(void) orientationChangedMethod{
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else{
		self.view = self.portraitView;
	}
	
	if(loadContent == FALSE){
		loadContent = TRUE;
				
		if(![theCover.titleFileName isEqualToString:@""] && theCover.titleFileName != nil){
			[self createCoverTitleImage];
		}
		
		[self createButtons];
		
		[self buttonsTwitterFacebook];
	}
}


/**
 * Sent to the view controller when the application receives a memory warning
 */
-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.mainController = nil;
	self.coverBgImage = nil;
	self.coverTitleImage = nil;
}


-(void)dealloc {
	[coverBgImage release];
	[coverTitleImage release];
	[buttonTwitter release];
	[buttonFacebook release];
	
    [super dealloc];
}


/**
 * Load nextNevel when button is pressed
 *
 * @see buttonPressed
 */
-(void)buttonPressed : (id)sender {
	[self startSpinner];
	NextLevel* nextLevel = [sender nextLevel];
	
	[mainController loadNextLevel:nextLevel];
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
 * Start animation
 */
-(void) startAnimation {
	// Add it into the spinnerView
	[self.view addSubview:animation];
    [NSThread sleepForTimeInterval:5.0];
	// Start it spinning! Don't miss this step
	//	[indicator startAnimating];
}

/**
 * Stop animation
 */
-(void) stopAnimation {
    //[indicator stopAnimating];
    [animation removeFromSuperview];
}

/**
 * Start Spinner
 */
-(void) startSpinner {
	// Add it into the spinnerView
	[self.view addSubview:indicator];
	// Start it spinning! Don't miss this step
	//	[indicator startAnimating];
}

/**
 * Remove spinner indicator
 */
-(void)removeSpinner {
    //[indicator stopAnimating];
    [indicator removeFromSuperview];
}

@end