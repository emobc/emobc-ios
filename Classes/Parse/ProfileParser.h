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
#import "NextLevel.h"
#import "NwParser.h"

#import "ProfileLevelData.h"
#import "NwAppField.h"

/**
 * CLASS SUMMARY
 * ProfileParser read profile.xml and save dates
 */

@interface ProfileParser : NwParser {
	
	ProfileLevelData* profile;
	//Objects	
	NwAppField *currField;
	NextLevel* currentNextLevel;	
}

@property (nonatomic, retain) ProfileLevelData* profile;
@property (nonatomic, retain) NwAppField *currField; 
@property (nonatomic, retain) NextLevel* currentNextLevel;

@end