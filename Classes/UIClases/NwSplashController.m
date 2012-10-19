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

#import "NwSplashController.h"
#import "eMobcViewController.h"


@implementation NwSplashController


/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Load method after 5 seconds
	[self performSelector:@selector(unloadSplash) 
			   withObject:nil 
			   afterDelay:2.0f];
}


/**
 * Load method loadCover present in eMobcViewController file
 * 
 * @see loadCover
 */
-(void) unloadSplash {
	[mainController loadCover];
}


/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation
 *
 * @param interfaceOrientation The orientation of the application’s user interface after the rotation. 
 *  The possible values are described in UIInterfaceOrientation.
 * 
 * @see UIInterfaceOrientation
 * @return YES if the view controller supports the specified orientation or NO if it does not.
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return FALSE;
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
