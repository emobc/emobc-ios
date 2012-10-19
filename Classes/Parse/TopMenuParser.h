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
#import "TopMenuData.h"
#import "Cover.h"
#import "AppButton.h"
#import "NextLevel.h"
#import "NwParser.h"

/**
 * CLASS SUMMARY
 * TopMenuParser read top_menu.xml and save dates
 */

@interface TopMenuParser : NwParser {	
	// Application Data
	TopMenuData* topMenu;
	Cover* cover;
	AppButton* currentButton;
	NextLevel* currentNextLevel;
}

@property (nonatomic, retain) TopMenuData* topMenu;
@property (nonatomic, retain) Cover *cover;
@property (nonatomic, retain) AppButton *currentButton;
@property (nonatomic, retain) NextLevel* currentNextLevel;

@end