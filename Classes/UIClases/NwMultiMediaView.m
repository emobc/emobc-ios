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

#import "NwMultiMediaView.h"


@implementation NwMultiMediaView

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

/*****************************/
// Menu Multimedia Buttons
/****************************/

/**
 * Close Multimedia Menu
 *
 * @see nwMMcloseButtonPress
 */
-(IBAction) closeButtonPress:(id)sender {
	if([[self delegate] respondsToSelector:@selector(nwMMcloseButtonPress)]) {
		[[self delegate] nwMMcloseButtonPress];
	}
}

/**
 * Load nwMMphotosButtonPress method
 *
 * @see nwMMphotosButtonPress
 */
-(IBAction) photosButtonPress:(id)sender {
	if([[self delegate] respondsToSelector:@selector(nwMMphotosButtonPress)]) {
		[[self delegate] nwMMphotosButtonPress];
	}
}

/**
 * Carga la funcion nwMMshareButtonPress
 *
 * @see nwMMshareButtonPress
 */
- (IBAction) shareButtonPress:(id)sender{
	if([[self delegate] respondsToSelector:@selector(nwMMshareButtonPress)]) {
		[[self delegate] nwMMshareButtonPress];
	}
}

/**
 * Load nwMMvideosButtonPress method
 *
 * @see nwMMvideosButtonPress
 */
-(IBAction) videosButtonPress:(id)sender {
	if([[self delegate] respondsToSelector:@selector(nwMMvideosButtonPress)]) {
		[[self delegate] nwMMvideosButtonPress];
	}
}

/**
 * Load nwMMvoiceButtonPress method
 *
 * @see nwMMvoiceButtonPress
 */
-(IBAction) voiceButtonPress:(id)sender {
	if([[self delegate] respondsToSelector:@selector(nwMMvoiceButtonPress)]) {
		[[self delegate] nwMMvoiceButtonPress];
	}
}

/**
 * Load nwMMfeedbackButtonPress method
 *
 * @see nwMMfeedbackButtonPress
 */
-(IBAction) feedbackButtonPress:(id)sender {
	if([[self delegate] respondsToSelector:@selector(nwMMfeedbackButtonPress)]) {
		[[self delegate] nwMMfeedbackButtonPress];
	}
}

@end