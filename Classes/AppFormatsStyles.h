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

/**
 * CLASS SUMMARY
 * AppFormatsStyles has dates which define a format
 */

@interface AppFormatsStyles : NSObject {
@private
	
//Objetos
	NSString *name;
	NSString *textColor;
	NSString *textSize;
	NSString *textStyle;
	NSString *typeFace;
	NSString *cacheColorHint;
	NSString *backgroundSelectionFileName;
	NextLevel *nextLevel;
}

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *textColor;
@property(nonatomic, copy) NSString *textSize;
@property(nonatomic, copy) NSString *textStyle;
@property(nonatomic, copy) NSString *typeFace;
@property(nonatomic, copy) NSString *cacheColorHint;
@property(nonatomic, copy) NSString *backgroundSelectionFileName;
@property(nonatomic, retain) NextLevel *nextLevel;

@end