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

#import "StylesLevelData.h"


@implementation StylesLevelData

@synthesize styles;
@synthesize stylesMap;

-(void)dealloc {
    [styles release];
	[stylesMap release];
	
    [super dealloc];
}

-(id)init {
	if (self = [super init]) {  
		styles = [[[NSMutableArray array] init] retain];
		stylesMap = [[[NSMutableDictionary dictionary] init] retain];
	}	
	return self;
}

/**
 * Add a new style intro styles list
 * Even more add it into a styles map
 */
-(void) addStyles:(AppStyles*) newStyles{
	[styles addObject:newStyles];
	
	if(newStyles.typeId != nil){
		[stylesMap setObject:newStyles forKey:newStyles.typeId];
	}
}

@end