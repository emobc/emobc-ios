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

#import <Foundation/Foundation.h>
#import "StylesLevelData.h"
#import "AppStyles.h"

#import "AppButton.h"
#import "NextLevel.h"
#import "NwParser.h"

/**
 * CLASS SUMMARY
 * StlesParser read style.xml and save dates
 */

@interface StylesParser : NwParser {	
//Objects
	StylesLevelData* style;
	AppStyles* currentStyles;
	
	AppButton* currentButton;
	
	NextLevel* currentNextLevel;
}

@property (nonatomic, retain) StylesLevelData* style;
@property (nonatomic, retain) AppStyles* currentStyles;

@property (nonatomic, retain) AppButton *currentButton;

@property (nonatomic, retain) NextLevel* currentNextLevel;

@end