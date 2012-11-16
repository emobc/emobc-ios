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

#import "NwListController.h"
#import "NwListMultiLineCell.h"
#import "ListItem.h"
#import "eMobcViewController.h"
#import "NwUtil.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"


@implementation NwListController

//Datos parseados del fichero list.xml
@synthesize data;

@synthesize listTableView;
@synthesize listImageView;
@synthesize listLabel;
@synthesize descrLabel;
@synthesize listNextImageView;

@synthesize varStyles;
@synthesize varFormats;
@synthesize background;

//background
@synthesize imageMap;
@synthesize pathList;
@synthesize imageToShow;

static NSString *cellIdentifier = @"NwTableCell";

#pragma mark -
#pragma mark View lifecycle

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	loadContent = FALSE;
	
	//init data structures
 	contentArray = [[NSMutableArray alloc] init];

	//images backGround
	imageMap = [[[NSMutableDictionary dictionary]init]retain];
	pathList = [[[NSMutableArray array]init]retain];
	imageToShow = [[[NSMutableArray array]init]retain];
	
	
	if(data != nil){
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"LIST_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		//add items to array
		[contentArray addObjectsFromArray:data.items];		
	}else {
		titleLabel.text = @"eMobc";
		self.geoRefString = @"";
	}
	
	//init finished, now we're going to loadd images but we'l do it in the background
	NSOperationQueue *queue = [NSOperationQueue new];
	NSInvocationOperation *operation;
	for (int i = 0; i<[data.items count]; i++) {
		ListItem *theItem = [data.items objectAtIndex:i];
		if(!theItem.itemImage.isLocal){ //if the image isn't local ask if it exists in the system
			UIImage *image = [imageMap objectForKey:theItem.text];
			if(image == nil){  //if image doesn't exist in the syestem
				operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage:) object:theItem];
				[queue addOperation:operation];
				[operation release];
			}	
		}
	}
	
	[queue release];
	
	[self restoreScrollPosition];
}

/**
 * Load themes from xml to components
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
			
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
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
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 1024, 630)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 768, 886)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 480, 320)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 320, 480)];
			}				
		}
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:varStyles.backgroundFileName ofType:nil inDirectory:k];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		//[self.view addSubview:background];
		//[self.view sendSubviewToBack:background];
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


/**
 * Load images in the background used cache system
 *
 * @param theItem Item who has a image to be showen
 *
 * @see imageCached
 */
-(void) loadImage:(ListItem *)theItem {
	//load image 
	UIImage *image = [theItem.itemImage imageContent];
	
	//save image into imageMap for future references
	[imageMap setObject:image forKey:theItem.text];
	
	//add image into queue imageToShow
	[imageToShow addObject:image];
}



/**
 * Show image into a specific cell
 *
 * @param tableView It is necessary to taken the cell which we want to show the image
 *
 * @see NwListMultiLineCell
 *
 * @return NwListMultiLineCell nwCell with the new image on it
 */
-(UITableViewCell*) displayImage:(UITableView *)tableView {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NwListMultiLineCell *nwCell = (NwListMultiLineCell*)cell;
		UIImage *imageC = [self.imageToShow objectAtIndex:0];
	
	[self.imageToShow removeObjectAtIndex:0];
	nwCell.listImageView.image = imageC;
	return cell;
	
}

/**
 * Called when the controller’s view is released from memory.
 * And save scroll Position
 *
 * @see saveScrollPosition
 */
- (void)viewDidUnload {
	//NSLog(@"Posicion del scrolle: %lf", listTableView.contentOffset.y);
	[self saveScrollPosition];

    [super viewDidUnload];
}

/**
 * Notifies the view controller that its view is about to be dismissed, covered, or otherwise hidden from view
 *
 * @param animated If YES, the disappearance of the view is being animated
 *
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


/**
 * Notifies the view controller that its view was dismissed, covered, or otherwise hidden from view
 *
 * @param animated If YES, the disappearance of the view was animated
 *
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if([imageToShow count]>0) [self displayImage:tableView];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if([imageToShow count]>0) [self displayImage:tableView];
    return [contentArray count];
}


/**
 * Asks the data source for a cell to insert in a particular location of the table view. (required)
 * Furthermore this method asing image into cell because when system call tableView:cellForRowAtIndexPath:
 * imagesToShow will have at least the first images to show
 *
 * @param tableView A table-view object requesting the cell.
 * @param indexPath An index path locating a row in tableView.
 *
 * @return An object inheriting from UITableViewCell that the table view can use for the specified row. 
 * An assertion is raised if you return nil.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	//NSOperationQueue *queue = [NSOperationQueue new];
	
	ListItem* theItem = [contentArray objectAtIndex:indexPath.row];

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	/*NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(loadImage:) 
																			  object:cell];*/
	
	if (cell == nil) {
		if (data.cellXib == nil) {
			cell = [[[NwListMultiLineCell alloc] initWithStyle:UITableViewCellStyleDefault 
											   reuseIdentifier:cellIdentifier] autorelease];			
		}else {
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:data.cellXib 
																	 owner:self 
																   options:nil];
			cell = [topLevelObjects objectAtIndex:0];	
			UIView* bgColorView = [[UIView alloc] init];
			[bgColorView setBackgroundColor:[UIColor blueColor]];
			cell.selectedBackgroundView = bgColorView;
			[bgColorView release];	
		}
	}

	
	if (data.cellXib == nil) {
		NwListMultiLineCell *nwCell = (NwListMultiLineCell*)cell;
		
		nwCell.listLabel.text = [theItem.text uppercaseString];
		if(theItem.textDescr != nil){
			nwCell.descrLabel.text = theItem.textDescr;
		}
	   
		//nwCell.listImageView.image = [theItem.itemImage imageContent];
		
		//if there is a local imagen, we'll load it directly
		if(theItem.itemImage.isLocal)
			nwCell.listImageView.image = [theItem.itemImage imageContent]; 
		
		else{
			UIImage *image = [self.imageMap objectForKey:theItem.text];
			/*if(image == nil){
                nwCell.listImageView.image = [UIImage imageNamed:@"loader.gif"];
                [pathList addObject:indexPath];
				NSLog(@"Añado la operacion");
                [queue addOperation:operation]; 
                //[operation release];
			}else */
				nwCell.listImageView.image = image;
		}
	}else {
		UILabel *lbl1;
        UIFont * font = [UIFont fontWithName:@"Ubuntu-Medium" size:14];
        UIFont * fontDescr = [UIFont fontWithName:@"Ubuntu-Medium" size:12];
		lbl1 = (UILabel *)[cell viewWithTag:1];
		if (lbl1 != nil) {
			lbl1.text = [theItem.text uppercaseString];
            lbl1.font = font;
			if(theItem.textDescr != nil){
				UILabel* lbl2;
				lbl2 = (UILabel*)[cell viewWithTag:2];
				if (lbl2 != nil) {
					lbl2.text = theItem.textDescr;		
                    lbl2.font = fontDescr;
				}
			}
			
			UIImageView *img3;
			img3 = (UIImageView*)[cell viewWithTag:3];
			
			//img3.image =  [theItem.itemImage imageContent];
			
			if(theItem.itemImage.isLocal)
				img3.image =  [theItem.itemImage imageContent];
			
			else{
				UIImage *image = [self.imageMap objectForKey:theItem.text];
				/*if(image == nil){
					img3.image = [UIImage imageNamed:@"loader.gif"];
					[pathList addObject:indexPath];
					[queue addOperation:operation]; 
					//[operation release];
				} else */
					img3.image = image;
			}
		}		
	}
	
	[self restoreScrollPosition];

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
 *
 * @note tableView:heightForRowAtIndexPath: is callback system, we have taken advantage to it and we use it to call 
 * displayImage method even more, to show image into correct place we need the cell and we can reach it though tableView
 * so we not just use the callback otherwise we use tableView atribute
 *
 * @see displayImage
 */ 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UIFont* fontDescr = [UIFont fontWithName:@"Ubuntu-Medium" size:10];
	CGSize constraintSize = CGSizeMake(150.0f, MAXFLOAT);
	CGSize labelSize = [descrLabel.text sizeWithFont:fontDescr 
								   constrainedToSize:constraintSize
									   lineBreakMode:UILineBreakModeWordWrap];
    if ([eMobcViewController isIPad])
        return 103 + labelSize.height;	
    else
        return 53 + labelSize.height;	
}


/**
 * Tells the delegate that the specified row is now deselected
 *
 * @param tableView A table-view object informing the delegate about the row deselection
 * @param indexPath An index path locating the deselected row in tableView
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	ListItem* theItem = [contentArray objectAtIndex:indexPath.row];
	NextLevel* nl = theItem.nextLevel;
	
	if (nl != nil && mainController != nil) {
		[self saveScrollPosition];
		[self startSpinner];
		[mainController loadNextLevel:nl];
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

- (void)dealloc {
    [super dealloc];
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
	
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		if(![mainController.appData.backgroundMenu isEqualToString:@""]){
			[self loadBackgroundMenu];
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
		
		
		//init finished, now we're going to loadd images but we'l do it in the background
		NSOperationQueue *queue = [NSOperationQueue new];
		NSInvocationOperation *operation;
		for (int i = 0; i<[data.items count]; i++) {
			ListItem *theItem = [data.items objectAtIndex:i];
			if(!theItem.itemImage.isLocal){ //if the image isn't local ask if it exists in the system
				UIImage *image = [imageMap objectForKey:theItem.text];
				if(image == nil){  //if image doesn't exist in the syestem
					operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage:) object:theItem];
					[queue addOperation:operation];
					[operation release];
				}	
			}
		}
		
		[queue release];
	}
}


/**
 * Save scroll positon intoa extern file to be abble to take it when view be called again
 */
- (void) saveScrollPosition {
	NSMutableDictionary* posiciones = [[NSMutableDictionary dictionary] init];
	
	NSNumber* x = [[NSNumber alloc] initWithFloat:listTableView.contentOffset.x];
	NSNumber* y = [[NSNumber alloc] initWithFloat:listTableView.contentOffset.y];
	
	[posiciones setObject:x forKey:@"x"];
	[posiciones setObject:y forKey:@"y"];

	NSString *cachedFileName = [NSString stringWithFormat:@"List_%@.scroll", data.dataId];
	
	//save it into a local file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:cachedFileName];
	
	[posiciones writeToFile:path atomically: YES];
}

/**
 * Restore scroll position
 */
- (void) restoreScrollPosition {
	NSString *cachedFileName = [NSString stringWithFormat:@"List_%@.scroll", data.dataId];
	
	//Save into a local file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:cachedFileName];
	
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	NSNumber* x = [plistDict objectForKey:@"x"];
	NSNumber* y = [plistDict objectForKey:@"y"];
	
	CGPoint savedPosition = CGPointMake([x floatValue], [y floatValue]);
	[listTableView setContentOffset:savedPosition animated:YES];
}


@end