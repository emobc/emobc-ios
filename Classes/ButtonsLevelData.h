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
#import "AppButton.h"

/**
 * CLASS SUMMARY
 * ButtonsLevelData saves all necesary dates to define buttons into the view.
 * ButtonsLevelData doesn't going to define a view, It's going to define buttons which can have diferrents views like cover view
 * WebLevelData has all dates which are going to be saves by WebParser
 */

@interface ButtonsLevelData : DataItem {
@private
	NSMutableArray *buttons;	
}

@property(nonatomic, retain) NSMutableArray *buttons;

- (void) addButton:(AppButton*) newButton;

@end