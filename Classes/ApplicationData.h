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
#import "AppLevel.h"

/**
 * CLASS SUMMARY
 * ApplicationData has dates which define all framework application (dates from app.xml)
 */

#define APP_FILE @"app.xml"

@interface ApplicationData : NSObject {
	
//Objetos	
	NSString *title;
	NSString *coverFileName;
	NSString *pointLevelId;
	NSString *pointDataId;
	NSString *topMenu;
	NSString *bottomMenu;
	NSString *backgroundMenu;

	NSMutableArray *levels;
	NSMutableDictionary *levelMap;

	NSString *banner;
	NSString *bannerPos;
	NSString *bannerId;
	
	NSString *stylesFileName;
	NSString *formatsFileName;
	NSString *profileFileName;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *coverFileName;
@property (nonatomic, copy) NSString *pointLevelId;
@property (nonatomic, copy) NSString *pointDataId;
@property (nonatomic, copy) NSString *topMenu;
@property (nonatomic, copy) NSString *bottomMenu;
@property (nonatomic, copy) NSString *backgroundMenu;
@property (nonatomic, copy) NSString *banner;
@property (nonatomic, copy) NSString *bannerPos;
@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, copy) NSString *stylesFileName;
@property (nonatomic, copy) NSString *formatsFileName;
@property (nonatomic, copy) NSString *profileFileName;


//Metodos
	-(AppLevel*) getLevelByNumber:(int) levelNumber;
	-(AppLevel*) getLevelById:(NSString*) levelId;
	-(int) getLevelsCount;
	// Agregar un nuevo nivel a la lista de niveles
	- (void) addLevel:(AppLevel*) newLevel;

@end
