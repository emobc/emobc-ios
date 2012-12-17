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

#import "NwButtonsController.h"
#import "AppButton.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"
#import "NwButton.h"
#import "eMobcViewController.h"
#import "NwUtil.h"

@implementation NwButtonsController

@synthesize data;
@synthesize styleData;
@synthesize formatData;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;
@synthesize sizeTop;
@synthesize sizeBottom;

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
   	[super viewDidLoad];
	sizeTop = 0;
	sizeBottom = 0;
	
	sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
	sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
	
	if (data != nil) {
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"BUTTONS_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		loadContent = FALSE;
		
		
		if(![mainController.appData.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
		
		if(![mainController.appData.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
		
		//[self loadButtons];
		[self createButtons];
	}
}



/**
 * Create button in a dinamic way changing the possition for each one
 */
-(void) createButtons{
	loadContent = FALSE;
	
	int x = 0;
	int y = 100;
	int a = 120;
	int b = 100;
	
	
	int count = [data.buttons count];
	NwButton *button;
	for (int i = 0; i < count; i++) {
		
		NSString *k = [eMobcViewController whatDevice:k];

		AppButton* theButton = [data.buttons objectAtIndex:i];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:theButton.fileName ofType:nil inDirectory:k];
		
		UIImage* buttonImage = [UIImage imageWithContentsOfFile:imagePath];
		
		
		//create the button
		button = [NwButton buttonWithType:UIButtonTypeCustom];
		button.nextLevel = theButton.nextLevel;
		
		int modulo = i%2;
		
		if(modulo == 0){
			button.frame = CGRectMake(x, y, buttonImage.size.width, buttonImage.size.height);
			y += buttonImage.size.height;
		}else{
			button.frame = CGRectMake(a, b, buttonImage.size.width, buttonImage.size.height);
			b +=  buttonImage.size.height;
		}
		
		//set the button's title
		if([theButton.fileName isEqualToString:@""]){
			[button setTitle:theButton.title forState:UIControlStateNormal];
		}
		
		//listen for clicks
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[button setImage:buttonImage forState:UIControlStateNormal];
		//button.adjustsImageWhenHighlighted = NO;
		button.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:button];
	}
}



/**
 * Load buttons into differents possitions
 */
-(void)loadButtons{
	// load buttons position
	int x = 40;
	int y = sizeTop + 40;
	
	int width = 50;
	int height = 28;
	
	int count = [data.buttons count];
	
	for(int i=0; i < count;i++) {
		if (i % 2 == 0) {
			if (i > 0) {
				y += 90;			
			}
			x = 40; 
		}else {
			x = 150;
		}
		
		AppButton* theButton = [data.buttons objectAtIndex:i];
		
		//create the button
		NwButton *button = [NwButton buttonWithType:UIButtonTypeCustom];
		button.nextLevel = theButton.nextLevel;
		
		//set the position of the button
		button.frame = CGRectMake(x, y, width, height);
		
		//set the button's title
		if([theButton.fileName isEqualToString:@""]){
			[button setTitle:theButton.title forState:UIControlStateNormal];
		}
		
		//listen for clicks
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:theButton.fileName ofType:nil inDirectory:k];
		
		UIImage* buttonImage = [UIImage imageWithContentsOfFile:imagePath];
		
		[button setBackgroundImage:buttonImage forState:UIControlStateNormal];

		
		//add the button to the view
		[self.view addSubview:button];
		
	}	
}


/**
 * Show differents view depending on orientation
 *
 * @param object
 */
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
	
		if(![mainController.appData.backgroundMenu isEqualToString:@""]){
			[self loadBackgroundMenu];
		}
		
		if(![mainController.appData.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
	
		if(![mainController.appData.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
	
		//publicity
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
	
		//[self loadButtons];
		[self createButtons];
	}
}


/**
 * Load themes from xml into components
 */
-(void)loadThemesComponents {
	for(int x = 0; x < varStyles.listComponents.count; x++){
		NSString *var = [varStyles.listComponents objectAtIndex:x];
		
		NSString *type = [varStyles.mapFormatComponents objectForKey:var];
		
		varFormats = [mainController.theFormat.formatsMap objectForKey:type];
		UILabel *myLabel;
		
	
		NSLog(@"top: %d", sizeTop);
		if([var isEqualToString:@"header"]){
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 20)];
				}				
			}
			
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
			
			myLabel.textColor =  [UIColor colorWithRed:100 green:20 blue:10 alpha:1];
			
			//myLabel.textColor = [UIColor whiteColor];
			myLabel.textAlignment = UITextAlignmentCenter;
			
			[self.view addSubview:myLabel];
			[myLabel release];
		}
	}
}


/**
 * Load themes
 */
-(void) loadThemes {
	if(![varStyles.backgroundFileName isEqualToString:@""]) {
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			}				
		}
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:varStyles.backgroundFileName ofType:nil inDirectory:k];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
	}else{
		self.view.backgroundColor = [UIColor whiteColor];
	}
	[background release];
	
	if(![varStyles.components isEqualToString:@""]) {
		NSArray *separarComponents = [varStyles.components componentsSeparatedByString:@";"];
		NSArray *assignment;
		NSString *component;
		
		for(int i = 0; i < separarComponents.count - 1; i++){
			assignment = [[separarComponents objectAtIndex:i] componentsSeparatedByString:@"="];
			
			component = [assignment objectAtIndex:0];
			NSString *format = [assignment objectAtIndex:1];
			
			[varStyles.mapFormatComponents setObject:format forKey:component];
			
			if(![component isEqual:@"selection_list"]){
				[varStyles.listComponents addObject:component];
			}else{
				varStyles.selectionList = format;
			}
		}
		[self loadThemesComponents];
	}
}



/**
 * If button is pressed, it loades next level 
 *
 * @see loadNextLevel
 */
-(void)buttonPressed : (id)sender {
	NextLevel* nextLevel = [sender nextLevel];
	[mainController loadNextLevel:nextLevel];	
}

/**
 * Sent to the view controller when the application receives a memory warning
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
    [super viewDidUnload];
   
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end