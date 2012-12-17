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

#import "NwImageListController.h"
#import "NwListTextCell.h"
#import "eMobcViewController.h"
#import "NwUtil.h"

#import "AppFormatsStyles.h"
#import "AppStyles.h"

@implementation NwImageListController

@synthesize imgListTableView;
@synthesize imgListImageView;
@synthesize contentImageView;
@synthesize data;

@synthesize varStyles;
@synthesize varFormats;
@synthesize background;

@synthesize sizeTop;
@synthesize sizeBottom;
@synthesize sizeHeaderText;
@synthesize swSize;

/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
    [super viewDidLoad];
	
	loadContent = FALSE;
	
	[self loadImageList];
}

/**
 * Load list 
 */
-(void) loadImageList{
	contentArray = [[NSMutableArray alloc] init];
	
	swSize = 0;
	sizeTop = 0;
	sizeBottom = 0;
	sizeHeaderText = 20;
	
	sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
	sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
	
	if (data != nil) {
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"IMAGE_LIST_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		imgListImageView = [[UIImageView alloc] init];
		imgListImageView.image = [data.image imageContent];
		[contentArray addObjectsFromArray:data.items];
		
		int width, height;
		
		width = imgListImageView.image.size.width;
		height = imgListImageView.image.size.height;
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				if(width < 512 && height < (768 - sizeTop - sizeBottom - sizeHeaderText)){
					swSize = 1;
					int posY = ((768 - sizeTop - sizeBottom - sizeHeaderText) - height)/2;
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText + posY , width, height)];
				}else{
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 512, 768 - sizeTop - sizeBottom - sizeHeaderText)];
				}
				
				if(swSize == 1){
					imgListImageView.frame = CGRectMake(0, 0, width, height);
				}else{
					imgListImageView.frame = CGRectMake(0, 0, 512, 768 - sizeTop - sizeBottom - sizeHeaderText);
				}
			}else{
				if(width < 768 && height < 400){
					swSize = 1;
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText + 5, width, height)];
					sizeTop += imgListImageView.image.size.height + sizeHeaderText + 10;
				}else{
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 768, 400)];
					sizeTop += 405 + sizeHeaderText;
				}
				
				if(swSize == 1){
					imgListImageView.frame = CGRectMake((768 - width)/2, 0, width, height);
				}else{
					imgListImageView.frame = CGRectMake(0, 0, 768, 400);
				}
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				
				if(width < 240 && height < (320 - sizeTop - sizeBottom - sizeHeaderText)){
					swSize = 1;
					int posY = ((320 - sizeTop - sizeBottom - sizeHeaderText) - height)/2;
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText + posY , width, height)];
				}else{
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 240, 320 - sizeTop - sizeBottom - sizeHeaderText)];
				}
				
				if(swSize == 1){
					imgListImageView.frame = CGRectMake(0, 0, width, height);
				}else{
					imgListImageView.frame = CGRectMake(0, 0, 240, 320 - sizeTop - sizeBottom - sizeHeaderText);
				}
			}else{
				if(width < 320 && height < 160){
					swSize = 1;
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText + 5, width, height)];
					sizeTop += height + sizeHeaderText + 10;
				}else{
					contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 320, 160)];
					sizeTop += 165 + sizeHeaderText;
				}
				
				if(swSize == 1){
					imgListImageView.frame = CGRectMake((320 - width)/2, 0, width, height);
				}else{
					imgListImageView.frame = CGRectMake(0, 0, 320, 160);
				}
			}				
		}
		
		imgListImageView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:contentImageView];
		[contentImageView addSubview:imgListImageView];
		
		[self createTableView];

	}else {
		titleLabel.text = @"Neurowork";
		self.geoRefString = @"";
	}	

}


-(void) createTableView{
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(swSize == 1){
				imgListTableView = [[[UITableView alloc] initWithFrame:CGRectMake(imgListImageView.image.size.width + 5, sizeTop + sizeHeaderText, 1024 - imgListImageView.image.size.width, 768 - sizeTop - sizeBottom - sizeHeaderText) style:UITableViewStylePlain] autorelease];
			}else{
				imgListTableView = [[[UITableView alloc] initWithFrame:CGRectMake(512, sizeTop + sizeHeaderText, 512, 768 - sizeTop - sizeBottom - sizeHeaderText) style:UITableViewStylePlain] autorelease];
			}
			
		}else{
			imgListTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 1024 - sizeTop - sizeBottom) style:UITableViewStylePlain] autorelease];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(swSize == 1){
				imgListTableView = [[[UITableView alloc] initWithFrame:CGRectMake(imgListImageView.image.size.width + 5, sizeTop + sizeHeaderText, 480 - imgListImageView.image.size.width, 320 - sizeTop - sizeBottom - sizeHeaderText) style:UITableViewStylePlain] autorelease];
			}else{
				imgListTableView = [[[UITableView alloc] initWithFrame:CGRectMake(240, sizeTop + sizeHeaderText, 240, 320 - sizeTop - sizeBottom - sizeHeaderText) style:UITableViewStylePlain] autorelease];
			}
			
		}else{
			imgListTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 480 - sizeTop - sizeBottom) style:UITableViewStylePlain] autorelease];
		}				
	}
	
	imgListTableView.dataSource = self;
	imgListTableView.delegate = self;
	
	[self.view addSubview:imgListTableView];
}


-(void) loadThemesComponents {
	
	for(int x = 0; x < varStyles.listComponents.count; x++){
		NSString *var = [varStyles.listComponents objectAtIndex:x];
		
		NSString *type = [varStyles.mapFormatComponents objectForKey:var];
		
		varFormats = [mainController.theFormat.formatsMap objectForKey:type];
		UILabel *myLabel;
		
		if([var isEqualToString:@"header"]){
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 20)];
				}				
			}
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
			myLabel.textColor = [UIColor blackColor];
			myLabel.textAlignment = UITextAlignmentCenter;
			
		}
		[self.view addSubview:myLabel];
		[myLabel release];
	}
}


/**
 Carga los temas
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
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:varStyles.backgroundFileName ofType:nil inDirectory:k];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
		[background release];
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
 * Sent to the view controller when the application receives a memory warning
 */
-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Table view data source
/*
 *************************** Data Source ***************************
 It has information about table content which table have to show
 Cell number, section number and cell content
 */


/**
 * Tells the data source to return the number of rows in a given section of a table view. (required)
 *
 * @param tableView The table-view object requesting this information
 * @param section An index number identifying a section in tableView
 *
 * @return The number of rows in section
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [contentArray count];	
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
    static NSString *CellIdentifier = @"CellText";
    NwListTextCell *cell = (NwListTextCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NwListTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	ListItem* theItem = [contentArray objectAtIndex:indexPath.row];
	cell.listLabel.text = [theItem.text uppercaseString];
	
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
	return 90;
}


/**
 * Tells the delegate that the specified row is now deselected
 *
 * @param tableView A table-view object informing the delegate about the row deselection
 * @param indexPath An index path locating the deselected row in tableView
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {

	ListItem* theItem = [contentArray objectAtIndex:newIndexPath.row];
	NextLevel* nl = theItem.nextLevel;
	[contentArray release];
	
	if (nl != nil && mainController != nil) {
		[self startSpinner];
		[mainController loadNextLevel:nl];
	}	
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
	
	if(loadContent == FALSE){
		loadContent = TRUE;
	
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
	
		[self loadImageList];
	}	
}

-(void)dealloc {
    [super dealloc];
}

@end