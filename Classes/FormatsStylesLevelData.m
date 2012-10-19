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

#import "FormatsStylesLevelData.h"


@implementation FormatsStylesLevelData

@synthesize formats;
@synthesize formatsMap;

-(void)dealloc {
	[formats release];
	[formatsMap release];
	
    [super dealloc];
}

-(id)init {
	if (self = [super init]) {  
		formats = [[[NSMutableArray array] init] retain];
		formatsMap = [[[NSMutableDictionary dictionary] init] retain];
	}	
	return self;
}

/**
 * Add a new format intro format tyles list
 * Even more add it into a format map
 */
-(void) addFormatsStyles:(AppFormatsStyles*) newFormatsStyles{
	[formats addObject:newFormatsStyles];

	if(newFormatsStyles.name != nil){
		[formatsMap setObject:newFormatsStyles forKey:newFormatsStyles.name];

	}
}
@end