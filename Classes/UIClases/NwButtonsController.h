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
#import "ButtonsLevelData.h"
#import "NwController.h"
#import "NextLevel.h"
#import "StylesLevelData.h"
#import "FormatsStylesLevelData.h" 
#import "AppStyles.h"
#import "AppFormatsStyles.h"


/**
 * CLASS SUMMARY
 * NwButtonsController is button viewController so It is going to handle buttons
 * It's going to load menu when and where we have pointed
 *
 * @note buttonsController need data to work, this dates is taken from buttons.xml and then saves into data.
 */

@interface NwButtonsController : NwController <UIWebViewDelegate> {

//Objetos
	ButtonsLevelData* data;	
	
//Format and Styles	
	StylesLevelData* styleData;
	FormatsStylesLevelData* formatData; 
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
}

@property(nonatomic, retain) ButtonsLevelData* data;
@property(nonatomic, retain) StylesLevelData* styleData;
@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;
@property(nonatomic, retain) FormatsStylesLevelData* formatData;

//Methods
	-(void) loadButtons;
	-(void) loadThemesComponents;
	-(void) loadThemes;

@end