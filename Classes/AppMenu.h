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
 * AppMenu has dates which define a button from cover or buttons set view
 * Cover and ButtonsLevelData contain AppMenu
 */

@interface AppMenu : NSObject {
@private
	
//Objetos
	NSString *title;
	NSString *imageName;
	NSString *systemAction;
	int leftMargin;
	NextLevel *nextLevel;
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *systemAction;
@property(nonatomic, assign) int leftMargin;
@property(nonatomic, retain) NextLevel *nextLevel;

@end