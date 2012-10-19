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

#import "AppLevelData.h"


@implementation AppLevelData

@synthesize items;
@synthesize itemsMap;

-(id) init {
	if (self = [super init]) {    
		// Initialize Cover Data
		items = [[[NSMutableArray array] init] retain];
		itemsMap = [[[NSMutableDictionary dictionary] init] retain];
	}	
		
	return self;
}

-(void)dealloc {
	[items release];
	[itemsMap release];
	[super dealloc];
}

/**
 * Add an DaraItem into AppLevelData
 *
 * @param item
 */
-(void)addItem:(DataItem*) item{
	[items addObject:item];
	if (item.dataId != nil) {
		[itemsMap setObject:item forKey:item.dataId];	
	}
}

/**
 * Return DataItem with a dataNumber
 *
 * @param dataNumber
 * 
 * @return DataItem
 */
-(DataItem*) dataItemByNumber:(int) dataNumber{
	return [items objectAtIndex:dataNumber];
}


/**
 * Return DataItem with a dataId
 *
 * @param dataId
 * 
 * @return DataItem
 */

-(DataItem*) dataItemById:(NSString*) dataId{
	return [itemsMap valueForKey:dataId];
}

@end