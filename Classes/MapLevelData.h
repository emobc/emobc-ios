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
#import "DataItem.h"
#import "MapItem.h"

/**
 * CLASS SUMMARY
 * MapLevelData saves all necesary dates to define Map view
 * MapLevelData has all dates which are going to be saves by MapParser
 */

@interface MapLevelData : DataItem {
	BOOL localizeMe;
	BOOL showAllPositions;
	NSMutableArray* items;
	NSString* currentPositionIconFileName;

}

@property (nonatomic, copy) NSMutableArray* items;
@property (nonatomic, assign) BOOL localizeMe;
@property (nonatomic, assign) BOOL showAllPositions;
@property (nonatomic, copy) NSString* currentPositionIconFileName;


- (void) addPosition:(MapItem*) newItem;

@end
