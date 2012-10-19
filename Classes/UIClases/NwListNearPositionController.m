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

#import "NwListNearPositionController.h"
#import "NearUtil.h"
#import "NwListMultiLineCell.h"
#import "eMobcViewController.h"


@implementation NwListNearPositionController

@synthesize items;
@synthesize mapController;


#pragma mark -
#pragma mark View lifecycle

/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
    [super viewDidLoad];
	loadContent = FALSE;
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(orientationChanged:) 
												 name:@"UIDeviceOrientationDidChangeNotification" 
											   object:nil];
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
    // Return the number of sections.
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
    // Return the number of rows in the section.
    return [items count];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Customize the appearance of table view cells.
    static NSString *cellIdentifier = @"Cell";
    
    NwListMultiLineCell *cell = (NwListMultiLineCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NwListMultiLineCell alloc] initWithStyle:UITableViewCellStyleDefault 
										   reuseIdentifier:cellIdentifier] autorelease];
    }
    
	NearUtil* util = (NearUtil*)[items objectAtIndex:indexPath.row];

	cell.listLabel.text = util.item.title;
	NSString* distString = [NSString stringWithFormat:@"Distancia: %1.2f Km", (util.distance/1000.0f)]; 
	cell.descrLabel.text = distString;
	
	if (util.item.image != nil) {
		cell.listImageView.image = [util.item.image imageContent];
	}else {
		//Poner imagen por defecto
		cell.listImageView.image = [UIImage imageNamed:@"punto.png"];
	}
	    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

/*
 ***************************************** Delegate ********************************************
 Delegate has information about how tabe has to behavior according to events
 */

/**
 * Asks the delegate for the height to use for a row in a specified location
 *
 * @param tableView The table-view object requesting this information
 * @param indexPath An index path that locates a row in tableView
 *
 * @return A floating-point value that specifies the height (in points) that row should be
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NearUtil* theItem = [items objectAtIndex:indexPath.row];
	
	UIFont* fontDescr = [UIFont fontWithName:@"Ubuntu-Medium" size:14];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
	NSString* distString = [NSString stringWithFormat:@"Distancia: %1.2f Km", (theItem.distance/1000.0f)]; 
    CGSize labelSize = [distString sizeWithFont:fontDescr 
							  constrainedToSize:constraintSize 
								  lineBreakMode:UILineBreakModeWordWrap];
	
	return 98 + labelSize.height;	
}

/**
 * Tells the delegate that the specified row is now deselected
 *
 * @param tableView A table-view object informing the delegate about the row deselection
 * @param indexPath An index path locating the deselected row in tableView
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	NearUtil* util = [items objectAtIndex:indexPath.row];
	
	[mainController loadNextLevel:util.item.nextLevel];
}


/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 *
 * @param interfaceOrientation The orientation of the application’s user interface after the rotation. 
 * The possible values are described in UIInterfaceOrientation.
 *
 * @return YES if the view controller supports the specified orientation or NO if it does not
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
    return YES;
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
	
}


#pragma mark -
#pragma mark Memory management

/**
 * Sent to the view controller when the application receives a memory warning
 */
-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

/**
 * Called when the controller’s view is released from memory.
 */
-(void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(void)dealloc {
    [super dealloc];
}

@end