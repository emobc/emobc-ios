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
#import <AVFoundation/AVFoundation.h>
#import "ImageTextDescriptionLevelData.h"
#import "NwController.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"

/**
 * CLASS SUMMARY
 * NwImageTextController is image+text viewController so It is going to handle the image+text View
 * this view allows user show a image in the top of the view and a text after it
 *
 * @note NwImageTextController need data to work, this dates is taken from image_text.xml and then saves into data.
 */

@interface NwImageTextController : NwController <AVAudioPlayerDelegate> {
	
//Objetos
	ImageTextDescriptionLevelData* data;
	bool playing;
	
//Outlets
	UIImageView *imageDescription;
	UIImageView *imageDescriptionLandscape;
	UITextView *textDesccription;
	UITextView *textDesccriptionLandscape;
	UIButton *nextButton;
	UIButton *nextButtonLandscape;
	UIButton *prevButton;
	UIButton *prevButtonLandscape;
	
	AVAudioPlayer *player;
	NSMutableArray *fulltext;
	
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;

}

@property(nonatomic, retain) ImageTextDescriptionLevelData* data;
@property(nonatomic, retain) IBOutlet UIImageView *imageDescription;
@property(nonatomic, retain) IBOutlet UIImageView *imageDescriptionLandscape;
@property(nonatomic, retain) IBOutlet UITextView *textDesccription;
@property(nonatomic, retain) IBOutlet UITextView *textDesccriptionLandscape;
@property(nonatomic, retain) IBOutlet UIButton* nextButton;
@property(nonatomic, retain) IBOutlet UIButton* nextButtonLandscape;
@property(nonatomic, retain) IBOutlet UIButton* prevButton;
@property(nonatomic, retain) IBOutlet UIButton* prevButtonLandscape;

@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;

//Acciones
	-(IBAction) buttonNextPress:(id)sender;
	-(IBAction) buttonPrevPress:(id)sender;

//Metodos
	-(void) loadImageText;

	-(void) loadThemesComponents;
	-(void) loadThemes;

	-(IBAction) shareButtonPress:(id)sender;

@end