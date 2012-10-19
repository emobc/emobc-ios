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
#import "CachedImage.h"

/**
 * CLASS SUMMARY
 * MapItem has dates which define a item from a Map
 * Map contain MapItem
 */

@interface MapItem : NSObject {
//Objects
	NSString* title;
	NSString* address;
	CachedImage* image;
	CachedImage* icon;
	double lat;
	double lon;
	NextLevel* nextLevel;
}

@property(nonatomic, copy) NSString* title;
@property(nonatomic, copy) NSString* address;
@property(nonatomic, retain) CachedImage* image;
@property(nonatomic, retain) CachedImage* icon;
@property(nonatomic, assign) double lat;
@property(nonatomic, assign) double lon;
@property(nonatomic, retain) NextLevel* nextLevel;

@end