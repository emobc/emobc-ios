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

#import "ApplicationData.h"

@implementation ApplicationData

@synthesize title;
@synthesize coverFileName;
@synthesize pointLevelId;
@synthesize pointDataId;
@synthesize topMenu;
@synthesize bottomMenu;
@synthesize backgroundMenu;
@synthesize banner;
@synthesize bannerPos;
@synthesize bannerId;
@synthesize stylesFileName;
@synthesize formatsFileName;
@synthesize profileFileName;


-(id)init {
	if (self = [super init]) {  
		levels = [[[NSMutableArray array] init] retain];
		levelMap = [[[NSMutableDictionary dictionary] init] retain];
	}	
	return self;
}

-(void) dealloc {
	[title release];
	[coverFileName release];
	[pointLevelId release];
    [pointDataId release];
	[topMenu release];
	[bottomMenu release];
	[backgroundMenu release];
	
	[banner release];
	[bannerPos release];
	[bannerId release];
	
	[stylesFileName release];
	[formatsFileName release];
	[profileFileName release];
	
	[super dealloc];
}

/**
 * Add a new levet into levels list and level map
 */
- (void) addLevel:(AppLevel*) newLevel {
	[levels addObject:newLevel];
	
	if (newLevel.levelId != nil) {
		[levelMap setObject:newLevel forKey:newLevel.levelId];	
	}
}

/**
 * Get level with a given number 
 *
 * @param levelNumber
 */
-(AppLevel*) getLevelByNumber:(int) levelNumber {
	return [levels objectAtIndex:levelNumber];
}

/**
 * Get level with a given Id
 *
 * @param levelId
 */
-(AppLevel*) getLevelById:(NSString*) levelId {
	return [levelMap valueForKey:levelId];
}

/**
 * Levels count
 */
-(int) getLevelsCount {
	return [levels count];
}

@end