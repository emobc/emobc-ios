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

#import "ListLevelData.h"


@implementation ListLevelData

@synthesize items;
@synthesize cellXib;

-(id) init {
	if (self = [super init]) {    
		// Initialize Arrray
		items = [[[NSMutableArray array] init] retain];
		cellXib = nil;
	}	
	return self;
}

-(void) dealloc{
	[items release];
	[cellXib release];
	[super dealloc];
}

/**
 * Add new ListItem into items list
 *
 * @param newItem
 */
- (void) addListItem:(ListItem*) newItem{
	[items addObject:newItem];	
}


@end
