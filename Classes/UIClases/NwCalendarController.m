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

#import "NwCalendarController.h"
#import "Kal.h"
#import "eMobcViewController.h"

@implementation NwCalendarController

//Datos parseados del fichero calendar.xml
@synthesize data;


/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
	[super viewDidLoad];		
	
	if (data != nil) {
		self.titleLabel.text = data.headerText;
	}
	
	[self kalInitialization];
}

-(void) kalInitialization{
	/*
	 *    Kal Initialization
	 *
	 * When the calendar is first displayed to the user, Kal will automatically select today's date.
	 * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
	 * instead of -[KalViewController init].
	 */
	
	kal = [[KalViewController alloc] init];
	kal.title = data.headerText;
	
	dataSource = data;
	kal.dataSource = dataSource;
	kal.delegate = self;
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			kal.view.frame = CGRectMake(221, 128, 582, 582);
		}else{
			kal.view.frame = CGRectMake(0, 128, 768, 838);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			kal.view.frame = CGRectMake(0, 38, 320, 244);
		}else{
			kal.view.frame = CGRectMake(0, 88, 320, 354);
			
		}				
	}
	
	[self.view addSubview:kal.view];
}

/**
 * Action handler for the navigation bar's right bar button item.
 */
- (void)showAndSelectToday {
	[kal showAndSelectDate:[NSDate date]];
}

/**
 * Sent to the view controller when the application receives a memory warning
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[kal release];
    [super dealloc];
}


#pragma mark UITableViewDelegate protocol conformance

/**
 * Display a details screen for the selected row.
 *
 * @param tableView A table-view object informing the delegate about the new row selection.
 * @param indexPath An index path locating the new selected row in tableView.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	AppEvents *event = [data eventAtIndexPath:indexPath];
	
	//Load nextLevel with dates from event selected
	NextLevel* nextLevel = [[NextLevel alloc] initWithData:event.nextLevel.levelId dataId:event.nextLevel.dataId];
	[mainController loadNextLevel:nextLevel];
}

-(void) orientationChanged:(NSNotification *)object{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation ){
		return;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object: nil];
	
	currentOrientation = orientation;
	
	[self performSelector:@selector(orientationChangedMethod) withObject: nil afterDelay: 0];
}

-(void) orientationChangedMethod{
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else{
		self.view = self.portraitView;
	}
	
	if(loadContent == FALSE){
		loadContent = TRUE;
				
		if(![mainController.appData.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
		if(![mainController.appData.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
		
		//publicity
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
		
		[self kalInitialization];
	}	
}

@end