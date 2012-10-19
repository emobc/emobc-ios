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
#import "AppStyles.h"

/**
 * CLASS SUMMARY
 * StylesLevelData saves all necesary dates to define differents styles, they aren't going to define a especific view,
 * instead of that, StylesLevelData is going to define a style for each view
 * StylesLevelData has all dates which are going to be saves by StylesParser
 */

@interface StylesLevelData : NSObject {
@private
	
//Objects
	NSMutableArray *styles;
	NSMutableDictionary *stylesMap;
}

@property(nonatomic, retain) NSMutableArray *styles;
@property(nonatomic, retain) NSMutableDictionary *stylesMap;

//Methods
	-(void) addStyles:(AppStyles*) newStyles;

@end