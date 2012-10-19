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
@synthesize background;
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

	theCover = [[NwUtil instance] readCover];
	
	[self crearBotones];

}


/**
 * Create button in a dinamic way changing the possition for each one
 */
-(void) crearBotones{
	loadContent = FALSE;
	
	facebookUrl = theCover.facebook;
	twitterUrl = theCover.twitter;
	wwwUrl = theCover.www;
	
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			coverBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
			coverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 1024, 450)];
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
		}else{
			coverBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			coverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, 768, 350)];
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			coverBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
			coverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 26, 320, 140)];
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
		}else{
			coverBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			coverTitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, 320, 140)];
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		}				
	}
	
	NSString *backPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"images/cover/backgroundCover"];
	backPath = [eMobcViewController addIPadImageSuffixWhenOnIPad:backPath];
	background.image = [UIImage imageWithContentsOfFile:backPath];
	[self.view addSubview:background];
 
	
	NSString *bgPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:theCover.backgroundFileName];
	bgPath = [eMobcViewController addIPadImageSuffixWhenOnIPad:bgPath];
	coverBgImage.image = [UIImage imageWithContentsOfFile:bgPath];
	[self.view addSubview:coverBgImage];
	
			
	NSString *titleImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:theCover.titleFileName];
	titleImagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:titleImagePath];
	coverTitleImage.image = [UIImage imageWithContentsOfFile:titleImagePath];
	[self.view addSubview:coverTitleImage];

	
	//Posicionado en 2 columnas
	//Tamaño 1 columna
	int	x = 0;
	int y = 0;
	
	//Tamaño 2 columna
	int a = 0;
	int b = 0;
	
	//Tamaño boton para pulsar.
	int width = 0;
	int height = 0;
	

	if([eMobcViewController isIPad]){
		width = 300;
		height = 76;
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			x = 207;
			y = 505;
			
			a = 517;
			b = 425;
		}else{
			x = 88;
			y = 550;
			
			a = 398;
			b = 469;
		}				
	}else {
		width = 150;
		height = 38;
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			x = 85;
			y = 170;
			
			a = 245;
			b = 125;
		}else{
			x = 7;
			y = 255;

			a = 164;
			b = 210;
		}				
	}
	
	
	int count = [theCover.buttons count];
	NwButton *button;
	for(int i=0; i < count;i++){
		if(i >= 1){
			
			if([eMobcViewController isIPad]){
				y += 83;
			}else{
				y += 45;
			}
		}
		
		//Segunda columna
		if(i > 2){
			
			if([eMobcViewController isIPad]){
				b += 83;
			}else{
				b += 45;
			}
		}
		
		AppButton* theButton = [theCover.buttons objectAtIndex:i];
		
		//create the button
		button = [NwButton buttonWithType:UIButtonTypeCustom];
		button.nextLevel = theButton.nextLevel;
		
		
		//set the position of the button
		//Al cargar la segunda columna se cargan los botones con coordenadas distinctas
		if (i>2){
			button.frame = CGRectMake(a, b, width, height);
		}else{
			button.frame = CGRectMake(x, y, width, height);
		}
				
		//set the button's title
		[button setTitle:theButton.title forState:UIControlStateNormal];
		
	
		//listen for clicks
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:theButton.fileName];
		
		imagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePath];
		UIImage* buttonImage = [UIImage imageWithContentsOfFile:imagePath];
		
		[button setImage:buttonImage forState:UIControlStateNormal];
		button.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		//add the button to the view
		
		[self.view addSubview:button];
        
	}
	
	[self buttonsTwitterFacebook];
	
    [self createAnimationCover];
	[self createIndicator];
    
	//[self startAnimation];
	//[NSThread sleepForTimeInterval:5.0];
    //[self stopAnimation];
}

-(void) buttonFacebookPress:(id)sender {
	[self startSpinner];
	[mainController mostrarWevActivityUrl:facebookUrl];
}

-(void) buttonTwitterPress:(id)sender {
	[self startSpinner];
	[mainController mostrarWevActivityUrl:twitterUrl];
}

-(void) buttonsTwitterFacebook{
	//create the button
	buttonFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonFacebook.frame = CGRectMake(884, 698, 60, 60);
		}else{
			buttonFacebook.frame = CGRectMake(628, 954, 60, 60);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonFacebook.frame = CGRectMake(450, 240, 30, 30);
		}else{
			buttonFacebook.frame = CGRectMake(240, 450, 30, 30);
			
		}				
	}	
	
	//set the button's title
	//[button setTitle:@"facebook" forState:UIControlStateNormal];
	
	//listen for clicks
	[buttonFacebook addTarget:self action:@selector(buttonFacebookPress:) forControlEvents:UIControlEventTouchUpInside];
	
	NSString *imagePathF = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"images/cover/facebook.png"];
	imagePathF = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePathF];
	
	UIImage* buttonImageF = [UIImage imageWithContentsOfFile:imagePathF];
	
	[buttonFacebook setImage:buttonImageF forState:UIControlStateNormal];
	buttonFacebook.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	//add the button to the view
	[self.view addSubview:buttonFacebook];
	
	
	
	//create the button
	buttonTwitter = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonTwitter.frame = CGRectMake(954, 698, 60, 60);
		}else{
			buttonTwitter.frame = CGRectMake(698, 954, 60, 60);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonTwitter.frame = CGRectMake(450, 280, 30, 30);
		}else{
			buttonTwitter.frame = CGRectMake(280, 450, 30, 30);
			
		}				
	}	
	
	
	//set the button's title
	//[button setTitle:@"twitter" forState:UIControlStateNormal];
	
	//listen for clicks
	[buttonTwitter addTarget:self action:@selector(buttonTwitterPress:) forControlEvents:UIControlEventTouchUpInside];
	
	NSString *imagePathT = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"images/cover/twitter.png"];
	imagePathT = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePathT];
	
	UIImage* buttonImageT = [UIImage imageWithContentsOfFile:imagePathT];
	
	[buttonTwitter setImage:buttonImageT forState:UIControlStateNormal];
	buttonTwitter.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	//add the button to the view
	[self.view addSubview:buttonTwitter];

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
		[self crearBotones];
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
	[background release];
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
