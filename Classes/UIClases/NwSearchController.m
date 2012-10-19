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

#import "NwSearchController.h"
#import "OverlayViewController.h"
#import "NwUtil.h"
#import "SearchItem.h"
#import "NwSearchCell.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"

@implementation NwSearchController

@synthesize tableView;
@synthesize tableViewLandscape;
@synthesize searchBar;
@synthesize searchBarLandscape;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;

#pragma mark -
#pragma mark View lifecycle

/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
    [super viewDidLoad];
	
	loadContent = FALSE;
	varStyles = [mainController.theStyle.stylesMap objectForKey:@"SEARCH_ACTIVITY"];
	
	if(varStyles != nil) {
		[self loadThemes];
	}
	

	//Initialize the array.
	listOfItems = [[NSMutableArray alloc] init];
	
	//Initialize the copy array.
	copyListOfItems = [[NSMutableArray alloc] init];
	
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBarLandscape.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
}


#pragma mark -
#pragma mark Table view data source

/*
 *************************** Data Source ***************************
 It has information about table content which table have to show
 Cell number, section number and cell content
 */

/**
 * Asks the data source to return the number of sections in the table view.
 *
 * @param An object representing the table view requesting this information
 * 
 * @return The number of sections in tableView. The default value is 1
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


/**
 * Tells the data source to return the number of rows in a given section of a table view. (required)
 *
 * @param tableView The table-view object requesting this information
 * @param section An index number identifying a section in tableView
 *
 * @return The number of rows in section
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (searching)
		return [copyListOfItems count];
	else {
		return 0;
	}
}

/**
 *Asks the data source for the title of the header of the specified section of the table view
 *
 * @param tableView The table-view object asking for the title
 * @param section An index number identifying a section of tableView
 *
 * @return A string to use as the title of the section header. If you return nil , the section will have no title
 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(searching)
		return @"Resultados";
	
	return @"Búsqueda";
}


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
    // Customize the appearance of table view cells.
    static NSString *CellIdentifier = @"CellText";
    NwSearchCell *cell = (NwSearchCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NwSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	if(searching) {
		SearchItem* searchItem = [copyListOfItems objectAtIndex:indexPath.row];
		cell.listLabel.text = [searchItem.text uppercaseString];
	}else {		
		SearchItem* searchItem = [listOfItems objectAtIndex:indexPath.row];
		cell.listLabel.text = [searchItem.text uppercaseString];
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
/*
 ******************************* Delegate *******************************
 Delegate has information about how tabe has to behavior according to events
 */


/**
 * Tells the delegate that the specified row is now deselected
 *
 * @param tableView A table-view object informing the delegate about the row deselection
 * @param indexPath An index path locating the deselected row in tableView
 *
 * @see loadNextLevel
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Get the selected country
	
	SearchItem *selectedItem = nil;
	
	if(searching){		
		selectedItem = [copyListOfItems objectAtIndex:indexPath.row];
	}else {
		selectedItem = [listOfItems objectAtIndex:indexPath.row];
	}
	[self startSpinner];
	[mainController loadNextLevel:selectedItem.nextLevel];
}

/**
 *Tells the delegate that a specified row is about to be selected.
 *
 * @param theTableView A table-view object informing the delegate about the impending selection
 * @param indexPath An index path locating the row in tableView
 *
 * @return An index-path object that confirms or alters the selected row
 */

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}


/**
 * Asks the delegate for the type of standard accessory view to use as a disclosure control for the specified row. 
 * Deprecated in IOS 3.0
 *
 * @param tableView The table-view object requesting the accessory-view type
 * @param indexPath An  index path locating the row in tableView
 *
 * @return return a constant for the accesory standard type to the view
 */

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	//return UITableViewCellAccessoryDetailDisclosureButton;
	return UITableViewCellAccessoryDisclosureIndicator;
}

/**
 * Tells the delegate that the user tapped the accessory (disclosure) view associated with a given row
 *
 * @param tableView The table-view object informing the delegate of this event
 * @param indexPath An index path locating the row in tableView
 */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark UISearchBarDelegate delegate methods
/*
 ******************************* Delegate *******************************
 Delegate has information about how tabe has to behavior according to events
 */

/**
 * Tells the delegate when the user begins editing the search text
 *
 * @param theSearchBar The search bar that is being edited
 *
 * @see doneSearching_Clicked
 */
-(void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	//This method is called again when the user clicks back from teh detail view.
	//So the overlay is displayed on the results, which is something we do not want to happen.
	if(searching)
		return;
	
	//Add the overlay view.
	if(ovController == nil)
		ovController = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:[NSBundle mainBundle]];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovController.view.frame = frame;	
	ovController.view.backgroundColor = [UIColor grayColor];
	ovController.view.alpha = 0.5;
	
	ovController.rvController = self;
	
	[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	[self.tableViewLandscape insertSubview:ovController.view aboveSubview:self.parentViewController.view];
	
	searching = YES;
	letUserSelectRow = NO;
	self.tableView.scrollEnabled = NO;
	self.tableViewLandscape.scrollEnabled = NO;
	
	//Add the done button.
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];
}

/**
 * Tells the delegate that the user changed the search text
 *
 * @param theSearchBar The search bar that is being edited
 * @param searchText The current text in the search text field
 *
 * @see searchTableView
 */
-(void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		[ovController.view removeFromSuperview];
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		self.tableViewLandscape.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		[self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		[self.tableViewLandscape insertSubview:ovController.view aboveSubview:self.parentViewController.view];
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
		self.tableViewLandscape.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
	[self.tableViewLandscape reloadData];
}


/**
 * Tells the delegate that the search button was tapped
 *
 * @param theSearchBar The search bar that was tapped
 *
 * @see searchTableView
 */
-(void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
    [searchBar resignFirstResponder];
	[searchBarLandscape resignFirstResponder];
}


/**
 * Tells the delegate that the cancel button was tapped.
 *
 * @param theSearchBar The search bar that was tapped
 */
-(void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar { 
    [searchBar resignFirstResponder];
	[searchBarLandscape resignFirstResponder];
}


/**
 * Check framework dates looking for a specific text
 *
 * @see searchText
 */
- (void) searchTableView {
	
	
	 NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NwUtil instance] searchText:searchText];
	
	//Comprobacion con el if para comprobar si es landscape o portrait
	/*NSString *searchText = searchBarLandscape.text;
	NSMutableArray *searchArray = [[NwUtil instance] searchText:searchText];*/
	
	for (SearchItem* searchItem in searchArray)
	{
		NSLog(@"%@", searchItem.text);
		[copyListOfItems addObject:searchItem];
	}

	[searchArray release];
	searchArray = nil;
}

/**
 * Hide keyboard and remove the superview added before
 *
 * @param sender
 */
-(void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	searchBarLandscape.text = @"";
	[searchBarLandscape resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	self.tableViewLandscape.scrollEnabled = YES;
	
	[ovController.view removeFromSuperview];
	[ovController release];
	ovController = nil;
	
	[self.tableView reloadData];
	[self.tableViewLandscape reloadData];
}




/**
 * Load themes from xml into components
 */
-(void)loadThemesComponents {
	
	for(int x = 0; x < varStyles.listComponents.count; x++){
		NSString *var = [varStyles.listComponents objectAtIndex:x];
		
		NSString *type = [varStyles.mapFormatComponents objectForKey:var];
		
		varFormats = [mainController.theFormat.formatsMap objectForKey:type];
		UILabel *myLabel;
		
		if([var isEqualToString:@"header"]){
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, 320, 20)];
				}				
			}
			
			myLabel.text = @"Buscador eMobc";
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			myLabel.textColor = [UIColor whiteColor];
			myLabel.textAlignment = UITextAlignmentCenter;
			
			[self.view addSubview:myLabel];
			[myLabel release];
		}
	}
}


/**
 * Load themes
 */
-(void) loadThemes {
	if(![varStyles.backgroundFileName isEqualToString:@""]) {
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			}				
		}
		
		NSString *imagePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:varStyles.backgroundFileName];
		
		imagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePath];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
	}else{
		self.view.backgroundColor = [UIColor whiteColor];
	}
	
	if(![varStyles.components isEqualToString:@""]) {
		NSArray *separarComponents = [varStyles.components componentsSeparatedByString:@";"];
		NSArray *assignment;
		NSString *component;
		
		for(int i = 0; i < separarComponents.count - 1; i++){
			assignment = [[separarComponents objectAtIndex:i] componentsSeparatedByString:@"="];
			
			component = [assignment objectAtIndex:0];
			NSString *format = [assignment objectAtIndex:1];
			
			//[varStyles.mapFormatComponents setObject:component forKey:format];
			[varStyles.mapFormatComponents setObject:format forKey:component];
			
			if(![component isEqual:@"selection_list"]){
				[varStyles.listComponents addObject:component];
			}else{
				varStyles.selectionList = format;
			}
		}
		[self loadThemesComponents];
	}
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
		
		if(![mainController.appData.backgroundMenu isEqualToString:@""]){
			[self loadBackgroundMenu];
		}
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
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
	}	
}


#pragma mark -
#pragma mark Memory management

/**
 * Sent to the view controller when the application receives a memory warning
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end