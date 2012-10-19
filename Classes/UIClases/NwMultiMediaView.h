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

#import <UIKit/UIKit.h>
#import "NwController.h"

/**
 * CLASS SUMMARY
 * NwMultiMediaView allows user to create a multimedia menu
 * NwMultiMediaView give us basic multimedia options like photos, voice or share content in twitter
 */

@interface NwMultiMediaView : UIView {
	
//Outlets	
	IBOutlet UIButton* closeButton;
	IBOutlet UIButton* photosButton;
	IBOutlet UIButton* shareButton;
	IBOutlet UIButton* videosButton;
	IBOutlet UIButton* voiceButton;
	IBOutlet UIButton* feedbackButton;
	
	id <NwControllerDelegate> delegate;
}

@property (retain) id delegate;

//Acctions
	-(IBAction) closeButtonPress:(id)sender;
	-(IBAction) photosButtonPress:(id)sender;
	-(IBAction) shareButtonPress:(id)sender;
	-(IBAction) videosButtonPress:(id)sender;
	-(IBAction) voiceButtonPress:(id)sender;
	-(IBAction) feedbackButtonPress:(id)sender;

@end
