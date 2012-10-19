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
#import "NwSideMenuController.h"
#import "TopMenuData.h"
#import "BottomMenuData.h"
#import "NwUtil.h"
#import "eMobcViewController.h"
#import "FormatsStylesLevelData.h"

@implementation NwSideMenuController

@synthesize landscapeView;
@synthesize portraitView;

@synthesize mainController;


/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
	[super viewDidLoad];
	
	//self.view.backgroundColor = [UIColor redColor];
	
	ApplicationData* theMenu = [[NwUtil instance] readApplicationData];
	
	//FormatsStylesLevelData* theFormat =[[NwUtil instance] readFormats];
	
	// Init view into landScape orientation when device didn't move
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
		
	}

	if(![theMenu.topMenu isEqualToString:@""]){
		[self callTopMenu];
	}
}

/**
 * Create topMenu into the View
 */

-(void) callTopMenu{
	//Botones dinamicos
	TopMenuData* theTopMenu = [[NwUtil instance] readTopMenu];
	
	int width = 0;
	int x = 10;
	int y = 10;
	
	int count = [theTopMenu.action count];
	
	for(int i=0; i < count;i++) {
		
		AppButton* theButton = [theTopMenu.action objectAtIndex:i];

		if([theButton.systemAction isEqualToString:@"sideMenu"]){
			//create the button
			NwButton *button = [NwButton buttonWithType:UIButtonTypeCustom];
			button.nextLevel = theButton.nextLevel;
			
			if(i != 0){
				x = width + theButton.leftMargin; 
			}
			
			width = theButton.widthButton;			
			int height = theButton.heightButton;
			
			//set the position of the button
			button.frame = CGRectMake(x, y, width, height);
			
			//set the button's title
			if([theButton.imageName isEqualToString:@""]){
				[button setTitle:theButton.title forState:UIControlStateNormal];
			}
			
			[button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
						
			NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:theButton.imageName];
			UIImage* buttonImage = [UIImage imageWithContentsOfFile:imagePath];
			
			[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
			
			//add the button to the view
			[self.view addSubview:button];
		}
	}	
}

/**
 * Go back in the view stack
 * This method take you a level back
 * 
 * @see goBack into eMobcViewController class
 */ 
-(void)backButtonPress:(id)sender {
	[mainController goBack];
}

-(void)dealloc {
    [super dealloc];
}

/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation
 *
 * @param InterfaceOrientation The orientation of the application’s user interface after the rotation. 
 *  The possible values are described in UIInterfaceOrientation.
 * 
 * @return YES if the view controller supports the specified orientation or NO if it does not
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
    return YES;
}


/**
 * Depending on the orientation show differents views
 *
 * @param object
 */
-(void) orientationChanged:(NSNotification*) object {
	UIDeviceOrientation deviceOrientation = [[object object] orientation];
		
	if (deviceOrientation == UIDeviceOrientationPortrait || deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
		self.view = self.portraitView;
	}else {
		self.view = self.landscapeView;
	}
	
	ApplicationData* theMenu = [[NwUtil instance] readApplicationData];
	
	if(![theMenu.topMenu isEqualToString:@""]){
		[self callTopMenu];
	}

}

@end