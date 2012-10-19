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

#import "ImageListLevelData.h"


@implementation ImageListLevelData

@synthesize image;
@synthesize items;

-(id) init {
	if (self = [super init]) {    
		// Initialize Arrray
		items = [[[NSMutableArray array] init] retain];
		image = nil;
	}	
	return self;
}

-(void) dealloc{
	[image release];
	[items release];
	[super dealloc];
}

/**
 * Add ListItem into item list
 *
 * @param newItem
 *
 */
- (void) addListItem:(ListItem*) newItem{
	[items addObject:newItem];	
}


/**
 * Find all images
 *
 * @return List with all found images
 */
- (NSMutableArray*) findAllImages{
	NSMutableArray* retArray = [[NSMutableArray alloc]init];
	
	[retArray addObject:image];
	
	return retArray;
}

@end
