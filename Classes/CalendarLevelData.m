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

#import "CalendarLevelData.h"


@implementation CalendarLevelData

@synthesize allEvents;
@synthesize monthEvents;
@synthesize dayEvents;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >=30200
#define KAL_IPAD_VERSION (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else 
#define KAL_IPAD_VERSION (NO)
#endif


- (void)dealloc {
	
    [allEvents release];
	[monthEvents release];
	[dayEvents release];
    [super dealloc];
}

-(id) init {
	if (self = [super init]) {    
		// inicializa el diccionario de eventos
		allEvents = [[[NSMutableDictionary dictionary] init] retain];
		monthEvents = [[[NSMutableDictionary dictionary] init] retain];
		dayEvents = [[[NSMutableArray array] init] retain];
	}	
	return self;
}

/**
 * Add new event into allEvent (event dictionary) 
 * Point that dictionary key will be event date and value will be a list of all events with that date
 *
 * @param newEvent Event to be added
 */
- (void) addEvents:(AppEvents*) newEvent{
	/*
	 * We are going to check if the key has a entry intro the table
	 * If table contains the key, we'll get the list (value) to add the new event
	 * otherwise we'll create a new entry 
	 */
	NSMutableArray *listEvent;  
	listEvent = [allEvents objectForKey:newEvent.eventDate];
	if([listEvent count] == 0){
		listEvent = [[NSMutableArray array]init];
		[listEvent addObject:newEvent];
		
	}else{
		[listEvent addObject:newEvent];
	}
		
		[allEvents setObject:listEvent forKey:newEvent.eventDate];
		
}

+ (CalendarLevelData *)dataSource
{
	return [[[[self class] alloc] init] autorelease];
}


/**
 * Return an event from a given position into de calendar
 * It will be taken from dayEvent
 *
 * @param indexPath position into de cell
 *
 * @retrun Event selected
 */

- (AppEvents *)eventAtIndexPath:(NSIndexPath *)indexPath
{	
	return [dayEvents objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance
/**
 * Asks the data source for a cell to insert in a particular location of the table view. (required)
 *
 * @param tableView A table-view object requesting the cell.
 * @param indexPath An index path locating a row in tableView.
 *
 * @return An object inheriting from UITableViewCell that the table view can use for the specified row. 
 * An assertion is raised if you return nil.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"MyCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
	}
	//get the event from a specific position from a given path 
	AppEvents *event = [self eventAtIndexPath:indexPath];	
	//if you want to show an image into cell from list below, descoment this line and asing a ImageName
	//cell.imageView.image = [UIImage imageNamed:[ImageName]];
	
	//this is the text shown into the list below		
	cell.textLabel.text = [[event.timeEvent stringByAppendingString:@" "] stringByAppendingString:event.titleEvent] ;
	
	//code speceific if device is an iPad
	CGFloat fontSize = KAL_IPAD_VERSION ? 27.f : 20.f;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:fontSize]; 
	return cell;
}

/**
 * Tells the data source to return the number of rows in a given section of a table view. (required)
 *
 * Tell dayEvents size (to show just one cell to one event into the list below)
 *
 * @param tableView The table-view object requesting this information
 * @param section An index number identifying a section in tableView
 *
 * @return The number of rows in section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [dayEvents count];
}

#pragma mark KalDataSource protocol conformance
/**
 * Init monthEvent again to can add new event from a new month
 * Called when a different month is showed
 *
 * @param fromDate Beginign date from interval
 * @param toDate Ending date from interval
 * @param delegate Point where and who is going to call it as a callback
 *
 * @see loadEventsFrom
 */
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate {
	[monthEvents removeAllObjects];
	[self loadEventFrom:fromDate to:toDate delegate:delegate];
}

/**
 * Call to know the events contained between a given date interval
 *
 * @param fromDate Beginign date from interval
 * @param toDate Ending date from interval
 *
 * @return events between two diffrents dates
 */
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate {
	return [self eventsFrom:fromDate to:toDate];
}

/**
 * Search into monthEvents (contains all events from a given month) which events are between two dates
 *
 * @param fromDate Beginign date from interval
 * @param toDate Ending date from interval
 */
- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
	NSLog(@"Fetching event from the database between %@ and %@...", fromDate, toDate);
	
	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:@"dd"];
	
	int *day = [[format stringFromDate:fromDate] integerValue];
	 
	dayEvents = [monthEvents objectForKey:[NSString stringWithFormat:@"%i", day]];
	
}

/**
 * Remove all items from dayEvent to be abble to show differents one when we change month view
 */
- (void)removeAllItems {
	dayEvents = [[NSMutableArray array]init];
}

#pragma mark -
/**
 * Called to know the events contained between a given date interval
 *
 * @param fromDate Beginign date from interval
 * @param toDate Ending date from interval
 *
 * @return events between two diffrents dates
 */
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate {
	return dayEvents;	
}

/**
 * Scan allEvent (event dictionary) and save just events which are between the two given date
 *
 * @param fromDate Beginign date from interval
 * @param toDate Ending date from interval
 * @param delegate Point where and who is going to call it as a callback
 *
 * @see loadedDataSource 
 */
- (void)loadEventFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate {
	NSLog(@"Fetching holidays from the database between %@ and %@...", fromDate, toDate);

	NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:@"MMMM"];
	
	
	int *monthFDate = [[self toNumber:[format stringFromDate:fromDate]] integerValue];
	int *monthTDate = [[self toNumber:[format stringFromDate:toDate]] integerValue];
	
	[format setDateFormat:@"dd"];
	int dayFDate =[[format stringFromDate:fromDate] integerValue];
	int dayTDate = [[format stringFromDate:toDate] integerValue];
	
	//take all key in dictionary
	NSArray *keys = [allEvents allKeys];
	
	for (NSString *key in keys) {
		int *subKey= [[key substringWithRange:NSMakeRange(3, 2)] integerValue];//así me quedo con el correspondiente al mes
		NSString *stringDay = [key substringWithRange:NSMakeRange(0, 2)];
		int dayKey = [stringDay integerValue];
		
		//check if month is between months from given dates
		if ((subKey >= monthFDate) & (subKey <=monthTDate)) {// if it's, check if day is between days from given date
			if (subKey == monthTDate){ //if read month is the same month that month from toDate
				[format setDateFormat:@"dd"];
				
				if (dayKey <= dayTDate) {
					NSMutableArray *listEvent = [[NSMutableArray array]init]; 
					
					//events is into range so we can add it into monthEvent
					listEvent = [allEvents objectForKey:key];
					int intDay = [stringDay integerValue];
					[monthEvents setObject:listEvent forKey:[NSString stringWithFormat:@"%i", intDay]]; //guardo como key el dia del mes, como valor una lista de eventos
									
				}
			}else{ //if read month isn't the same month that month from toDate
				[format setDateFormat:@"dd"];
				
				if ((subKey==monthFDate)&(dayKey >= dayFDate)|(subKey!=monthFDate)&(subKey!=monthTDate)) {
				NSMutableArray *listEvent = [[NSMutableArray array]init]; 
				
				//events is into range so we can add it into monthEvent
				listEvent = [allEvents objectForKey:key];
				int intDay = [stringDay integerValue];
				[monthEvents setObject:listEvent forKey:[NSString stringWithFormat:@"%i", intDay]];  //key: day(month day) value: list events
				
				
				}
			}
		}
		
	}
	// call to delegate to draw calendar
	[delegate loadedDataSource:self date:monthEvents];
	
}

/**
 * Return the month number from a name month
 *
 * @param month Name month
 *
 * @return Number for each month, if name isn't right return -1
 */
-(NSString*) toNumber:(NSString*) month{
	NSString *number;
	if ([month isEqualToString:@"January"]) {
		number = @"01";
	}else if ([month isEqualToString:@"February"]) {
		number = @"02";
	}else if ([month isEqualToString:@"March"]) {
		number = @"03";
	}else if ([month isEqualToString:@"April"]) {
		number = @"04";
	}else if ([month isEqualToString:@"May"]) {
		number = @"05";
	}else if ([month isEqualToString:@"June"]) {
		number = @"06";
	}else if ([month isEqualToString:@"July"]) {
		number = @"07";
	}else if ([month isEqualToString:@"August"]) {
		number = @"08";
	}else if ([month isEqualToString:@"September"]) {
		number = @"09";
	}else if ([month isEqualToString:@"October"]) {
		number = @"10";
	}else if ([month isEqualToString:@"November"]) {
		number = @"11";
	}else if ([month isEqualToString:@"December"]) {
		number = @"12";
	}else number = @"-01";
	return number;
}

@end