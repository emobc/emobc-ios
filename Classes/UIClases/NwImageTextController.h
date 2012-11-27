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
	UITextView *textDesccription;
	UIButton *nextButton;
	UIButton *prevButton;
	
	AVAudioPlayer *player;
	NSMutableArray *fulltext;
	
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
	
	NSInteger sizeTop;
	NSInteger sizeBottom;
	NSInteger sizeHeaderText;
}

@property(nonatomic, retain) ImageTextDescriptionLevelData* data;
@property(nonatomic, retain) UIImageView *imageDescription;
@property(nonatomic, retain) UITextView *textDesccription;
@property(nonatomic, retain) UIButton* nextButton;
@property(nonatomic, retain) UIButton* prevButton;
@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;

@property (nonatomic) NSInteger sizeTop;
@property (nonatomic) NSInteger sizeBottom;
@property (nonatomic) NSInteger sizeHeaderText;

//Acciones
	-(void) buttonNextPress:(id)sender;
	-(void) buttonPrevPress:(id)sender;

	-(void) nextButtonCreate;	
	-(void) prevButtonCreate;

//Metodos
	-(void) loadImageText;

	-(void) loadThemesComponents;
	-(void) loadThemes;

	-(IBAction) shareButtonPress:(id)sender;

	-(void) createTextView;
	-(void) createImageView;

@end