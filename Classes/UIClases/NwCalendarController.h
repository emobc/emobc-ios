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
#import "CalendarLevelData.h"
#import "NwController.h"
#import "kal.h"

/**
 * CLASS SUMMARY
 * NwCalendarController is calendar viewController so It is going to handle calendar
 *
 * @note calendarController need data to work, this dates is taken from calendar.xml and then saves it into data.
 * @note This view is a little special because we don't use just our ViewController, we use two controllers one to handle the view and another 
 * to handle calendar logic.
 */

@interface NwCalendarController : NwController<UITableViewDelegate,UIApplicationDelegate> {	
	
//Objetos
	CalendarLevelData* data;

//Calendar controller 
	KalViewController *kal;
	
	UINavigationController *navController;
//IBOutLet	

	id dataSource;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
}

@property(nonatomic, retain) CalendarLevelData* data;

-(void) kalInitialization;

@end