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

/**
 * CLASS SUMMARY
 * NextLevels contais data of the next view which can be shown
 * All (or nearly all) LevelData has nextLevel
 */

@interface NextLevel : NSObject {
	
//Variables
	int levelNumber;
	int dataNumber;

//Objetos
	NSString *levelId;
	NSString *dataId;

}

@property(nonatomic, assign) int levelNumber;
@property(nonatomic, copy) NSString *levelId;
@property(nonatomic, assign) int dataNumber;
@property(nonatomic, copy) NSString *dataId;


//Metodos
	-(id) initWithData:(NSString*) levelId dataId:(NSString*) dataId;

@end