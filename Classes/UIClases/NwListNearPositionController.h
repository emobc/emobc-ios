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

#import <UIKit/UIKit.h>
#import "NwMapController.h"

/**
 * CLASS SUMMARY
 * NwListNearPositionController doesn't controller any View.
 * It's goal is help NwControllerView to find near position to a given geoReference
 */
@class eMobcViewController;

@interface NwListNearPositionController : NwController<UITableViewDelegate, UITableViewDataSource> {

//Objetos
	NSArray* items;
	NwMapController* mapController;

//Outlets
	IBOutlet UITableView* listTableView;
	IBOutlet UITableView* listTableViewLandscape;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
}

@property(nonatomic, assign) NSArray* items;
@property(nonatomic, retain) NwMapController* mapController;

@end