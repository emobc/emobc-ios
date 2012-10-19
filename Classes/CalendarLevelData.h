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
#import "AppEvents.h"
#import "Kal.h"

/**
 * CLASS SUMMARY
 * CalendarLevelData saves all necesary dates to define calendar view
 * CalendarLevelData has all dates which are going to be saves by CalendarParser
 *
 * CalendarLevelData is a little special because it doesn't just have date from parser
 * it will take events from allEvents and save into monthEvents and dayEvents
 * we do it to make CalendarController easier, maybe logic from controller will be too simple because all it work is show nextLevel when
 * an event is selected while logic from LevelData is handle all dates and UITableView have
 */

@interface CalendarLevelData : DataItem <KalDataSource>{
	//Contains all events defined in calendar.xml
	NSMutableDictionary *allEvents; // key:dateEvent Value: event list
	//Contains all events from a month
	NSMutableDictionary *monthEvents; //key:day (month day) Value: event list
	//Contains all event from a especific day
	NSMutableArray *dayEvents;
}


@property (nonatomic, copy) NSMutableDictionary *allEvents;
@property (nonatomic, copy) NSMutableDictionary *monthEvents;
@property (nonatomic, copy) NSMutableArray *dayEvents;

- (void) addEvents:(AppEvents*) newEvent;

+ (CalendarLevelData *)dataSource;
- (AppEvents *)eventAtIndexPath:(NSIndexPath *)indexPath;  // exposed for HolidayAppDelegate so that it can implement the UITableViewDelegate protocol.
-(NSString*) toNumber:(NSString*) month;


@end
