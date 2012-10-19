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

#import "NwImageGalleryController.h"
#import "ImageGalleryItem.h"
#import "NwUtil.h"
#import "SearchItem.h"
#import "eMobcViewController.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"


@interface NwImageGalleryController (Private)

- (void) update;

@end

@implementation NwImageGalleryController

@synthesize data;
@synthesize labelImageCount;
@synthesize scroll;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;
 


/////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// Default Methods //////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

/**
 * Image configuration
 *
 * @param images
 */
-(void) setImages:(NSArray *) images {
	if(imageSet) [imageSet release];
 
	imageSet = [images retain];
 
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			view1.frame = CGRectMake(0, 0, 900, 600);
			view2.frame = CGRectMake(900, 0, 900, 600);
		}else {
			view1.frame = CGRectMake(0, 0, 768, 800);
			view2.frame = CGRectMake(768, 0, 768, 800);
		}
	}else{
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			view1.frame = CGRectMake(0, 0, 320, 174);
			view2.frame = CGRectMake(320, 0, 320, 174);
		}else {
			view1.frame = CGRectMake(0, 0, 320, 334);
			view2.frame = CGRectMake(320, 0, 320, 334);
		}
	}
	
	
	ImageGalleryItem *item1 = [imageSet objectAtIndex:0];

	[view1 setImage:[item1.image imageContent] forState:UIControlStateNormal];
	view1.nextLevel = item1.nextLevel;
 
	if ([imageSet count] > 1) {
		ImageGalleryItem *item2 = [imageSet objectAtIndex:1];
 
		[view2 setImage:[item2.image imageContent] forState:UIControlStateNormal];
		view2.nextLevel = item2.nextLevel;
	}
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			scroll.contentSize = CGSizeMake([imageSet count]*900, 600);
			
		}else {
			scroll.contentSize = CGSizeMake([imageSet count]*768, 800);
		}
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			scroll.contentSize = CGSizeMake([imageSet count]*320, 174);
			
		}else {
			scroll.contentSize = CGSizeMake([imageSet count]*320, 334);
		}
	}
}


/**
 * Update images and button possitions 
 *
 * @see imagenPressed
 */
-(void) update {	
	CGFloat pageWidth;
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			pageWidth = 900;
		}else{
			pageWidth = 768;
		}
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			pageWidth = 320;
		}else{
			pageWidth = 320;
		}
	}
		
	float currPos = scroll.contentOffset.x;
	
	int selectedPage = roundf(currPos / pageWidth);
 
	float truePosition = selectedPage*pageWidth;
 
	int zone = selectedPage % 2;
 
	BOOL view1Active = zone == 0;
 
	NwButton *nextView = view1Active ? view2 : view1;
 
	int nextpage = truePosition > currPos ? selectedPage-1 : selectedPage+1;
 
	if(nextpage >= 0 && nextpage < [imageSet count]){
		if((view1Active && nextpage == view1Index) || (!view1Active && nextpage == view2Index)) return;

		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				nextView.frame = CGRectMake(nextpage*900, 0, 900, 600);
			}else{
				nextView.frame = CGRectMake(nextpage*768, 0, 768, 800);
			}
		}else{
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				nextView.frame = CGRectMake(nextpage*320, 0, 320, 174);
			}else{
				nextView.frame = CGRectMake(nextpage*320, 0, 320, 334);
			}
		}
		
		ImageGalleryItem *item = [imageSet objectAtIndex:nextpage];
		
		[nextView setImage:[item.image imageContent] forState:UIControlStateNormal];
		nextView.nextLevel = item.nextLevel;
 
		//listen for clicks
		[nextView addTarget:self action:@selector(imagenPressed:) forControlEvents:UIControlEventTouchUpInside];
 
		NSString* messageCountImages = [NSString stringWithFormat: @"Imagen %d/%d", (nextpage+1), [data.items count]];
		labelImageCount.text = messageCountImages;
 
		if(view1Active){
			view1Index = nextpage;
			if(nextpage == view1Index){
				
			}
		}else{
			view2Index = nextpage;
		}
	}
}


/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	loadContent = FALSE;
   
	//Init view into landscape orientation when devide didn't move
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}
	
	[self loadsView];
}

/**
 * Configure scroll properties
 */
-(void) propiedadesScroll{
	scroll = [[UIScrollView alloc] init];
	scroll.scrollEnabled = YES;
	scroll.pagingEnabled = YES;
	scroll.directionalLockEnabled = YES;
	scroll.showsVerticalScrollIndicator = NO;
	scroll.showsHorizontalScrollIndicator = NO;
	scroll.delegate = self;
	scroll.autoresizesSubviews = YES;
	
	//check if device is an iPad
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			scroll.frame = CGRectMake(62, 128, 900, 600);
		}else {
			scroll.frame = CGRectMake(0, 128, 768, 800);
		}
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			scroll.frame = CGRectMake(80, 108, 320, 174);
		}else {
			scroll.frame = CGRectMake(0, 108, 320, 334);
		}
	}
}

/**
 * Load Gallery View with all of its properties
 *
 * @see scrollProperties
 * @see showAllImages
 * @see ImageGalleyItem
 * @see CachedImage
 */
-(void) loadsView {
	
	[self propiedadesScroll];
	[self.view addSubview:scroll];
	[scroll release];
	
	view1 = [NwButton buttonWithType:UIButtonTypeCustom];
	[scroll addSubview:view1];
	
	view2 = [NwButton buttonWithType:UIButtonTypeCustom];
	[scroll addSubview:view2];	
	
	if(data != nil){
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"IMAGE_GALLERY_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		if (data.showAllImages) {
			NSMutableArray *searchArray = [[NwUtil instance] findAllImages];
			
			for (SearchItem* searchItem in searchArray)	{
				ImageGalleryItem* theImageItem = [[ImageGalleryItem alloc] init];
				
				
				theImageItem.image = [[CachedImage alloc] initWithFileName:searchItem.text];
				theImageItem.nextLevel = searchItem.nextLevel;
				
				[data addImageItem:theImageItem];
			}
			[searchArray release];
		}
		
		NSString* messageCountImages = [NSString stringWithFormat: @"Imagen 1/%d", [data.items count]];
		labelImageCount.text = messageCountImages;
		
		[self setImages:data.items];
	}else {
		self.titleLabel.text = @"eMobc";
	}
    
	[self.view bringSubviewToFront:labelImageCount];
}

/**
 * Load theme form xml into components
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
 * Depending on orientation show differents views
 *
 * @param object
 */
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
	
		[self loadsView];
	}
}


/**
 * call method to load next Level when image is pressed
 *
 * @see loadNextLevel
 */
-(void)imagenPressed: (id)sender {
	NextLevel* nextLevel = [sender nextLevel];
	if (nextLevel != nil) {
		[self startSpinner];
		[mainController loadNextLevel:nextLevel];
	}	
}


/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// UIScrollView Delegate ///////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

/**
 * Tells the delegate when the user scrolls the content view within the receiver
 *
 * @param scrollView The scroll-view object in which the scrolling occurred
 */
-(void) scrollViewDidScroll:(UIScrollView *) scrollView {	
	[self update];
}

/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation
 *
 * @param toInterfaceOrientation The orientation of the application’s user interface after the rotation. 
 *  The possible values are described in UIInterfaceOrientation.
 *
 * @return YES if the view controller supports the specified orientation or NO if it does not
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


/**
 * Called when the controller’s view is released from memory.
 */
-(void)viewDidUnload {
    [super viewDidUnload];
}

/**
 * Sent to the view controller when the application receives a memory warning
 */
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
	[varStyles release];
	[varFormats release];
	[labelImageCount release];
	
	if(imageSet) 
		[imageSet release];
	
	[scroll release];
	[view1 release];
	[view2 release];
    [super dealloc];
}

@end