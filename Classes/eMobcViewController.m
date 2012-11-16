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

#import "eMobcViewController.h"
#import "NwButton.h"
#import "NwUtil.h"
#import "NwSearchController.h"
#import "SearchItem.h"
#import <AVFoundation/AVFoundation.h>

@implementation eMobcViewController

@synthesize coverController;
@synthesize currentController;
@synthesize currentMenuController;
@synthesize currentNextLevel;
@synthesize appData;
@synthesize theStyle;
@synthesize theFormat;


/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];	
	
	levelsStack = [[NSMutableArray array] retain];
	currentNextLevel = nil;
	

	//init appData, read app.xml
	appData = [[NwUtil instance] readApplicationData];
	
	//CHECK: Controla si la aplicacion tiene o no profile.
	if(appData.profileFileName == nil || [appData.profileFileName isEqualToString:@""]){
		if([appData.pointLevelId isEqualToString:@""] == NO && [appData.pointDataId isEqualToString:@""] == NO){
			NextLevel* StartPointNL = [[NextLevel alloc] initWithData: appData.pointLevelId dataId: appData.pointDataId];
			[self loadNextLevel:StartPointNL];
			[StartPointNL release];
		}else {
			[self loadCover];
		}
		
	}else{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSFileManager *gestorArchivos = [NSFileManager defaultManager];
		NSString *rutaArchivo = [documentsDirectory stringByAppendingPathComponent:@"Form_Profile.data"];
		
		if(![gestorArchivos fileExistsAtPath:rutaArchivo]){
			[self loadProfileFirstTime];
		}else{
			if([appData.pointLevelId isEqualToString:@""] == NO && [appData.pointDataId isEqualToString:@""] == NO){
				NextLevel* StartPointNL = [[NextLevel alloc] initWithData: appData.pointLevelId dataId: appData.pointDataId];
				[self loadNextLevel:StartPointNL];
				[StartPointNL release];
			}else {
				[self loadCover];
			}
		}
	}
    
    //[NSThread sleepForTimeInterval:1.0];
    
	
	//O se utiliza el loadCover o el loadSplash, nunca al mismo tiempo.
	//You have to use loadCover o loadSplash, but you can never usea them at the same time
	
	//Show view with landscape orientation when display didn't move
	//if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
	//	self.view = self.currentController.landscapeView;
	//}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	if (self.coverController.view.superview == nil) {
		self.coverController = nil;
	}
	// Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	self.coverController = nil;
	self.currentController = nil;
	self.currentMenuController = nil;
	self.currentNextLevel = nil;
	[super viewDidUnload];
}

- (void)dealloc {

	[coverController release];	
	[currentController release];
	[currentMenuController release];
	[currentNextLevel release];

    [super dealloc];
}

/*FRAMEWORK METHODS*/

/**
 * Load the Level (NextLevel).
 *
 * @param nextLevel level square with each type of View
 */
- (void) loadNextLevel:(NextLevel*) nextLevel{
	if (nextLevel == nil) {
		return;
	}
		
	if([self showNextLevel:nextLevel]){
		// Add NextLevel to the Stack
		[levelsStack addObject:nextLevel];
	}
}

/**
 * Show a level back into the stack
 *
 * @see showNextLevel
 * @see loadCover
 */
- (void) goBack {
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	/*
	// If stack is empty, call Cover
	 */
	if ([levelsStack count] == 0) {
		if([appData.pointLevelId isEqualToString:@""] == NO && [appData.pointDataId isEqualToString:@""] == NO){
			NextLevel* StartPointNL = [[NextLevel alloc] initWithData: appData.pointLevelId dataId:appData.pointDataId];
			[self loadNextLevel:StartPointNL];
		}else {
			[self loadCover];
		}
		//[self loadCover];
	}else {
		/*
		// If the stack isn't empty, you have to take and show it
		 */
		[levelsStack removeLastObject];
		NextLevel* nextLevel = [levelsStack lastObject];
		if(nextLevel != nil){
			[self showNextLevel:nextLevel];
		}else{
			if([appData.pointLevelId isEqualToString:@""] == NO && [appData.pointDataId isEqualToString:@""] == NO){
				NextLevel* StartPointNL = [[NextLevel alloc] initWithData: appData.pointLevelId dataId:appData.pointDataId];
				[self loadNextLevel:StartPointNL];
			}else {
				[self loadCover];
			}
			//[self loadCover];
		}
	}	
}


/**
 * Load Cover 
 *
 * @see loadNextLevel
 */
- (void) loadCover{
	
	theStyle = [[NwUtil instance] readStyles];
	theFormat =[[NwUtil instance] readFormats];
	
	[self removeAllActivitiesViews];

	NwCoverController *controller = [NwCoverController alloc];
	
	controller.mainController = self;
	self.coverController = controller;
	
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwCoverController"];
	
	[controller initWithNibName:controllerNibName
						 bundle:nil];
	
	[self loadController:coverController withAnimation:NO];	
	[controller release];

	
}


/**
 * Load Splash
 *
 * @see loadController
 */
- (void) loadSplash{
	[self removeAllActivitiesViews];
	
	NwSplashController *controller = [NwSplashController alloc];
	
	controller.mainController = self;
	
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwSplashController"];
	
	[controller initWithNibName:controllerNibName 
						 bundle:nil];
	
	[self loadController:coverController withAnimation:NO];	
	[controller release];
}

/**
 * Show the NextLevel. Depending on the type View we load differents methods
 *
 * @param nextLevel
 *
 * @return TRUE if there is a level
 *
 * @see loadImageTextNextLevel
 * @see loadImageListNextLevel
 * @see loadListNextLevel
 * @see loadImageZoomNextLevel
 * @see loadImageGalleryNextLevel
 * @see loadButtonsNextLevel
 * @see loadFormNextLevel
 * @see loadMapNextLevel
 * @see loadVideoNextLevel
 * @see loadWebNextLevel
 * @see loadQRNextLevel
 */
- (bool) showNextLevel:(NextLevel*) nextLevel{
	if (nextLevel == nil) {
		return false;
	}
	
	AppLevel* appLevel = nil;
	
	if(nextLevel.levelId != nil){
		appLevel = [appData getLevelById:nextLevel.levelId];
	}else {
		appLevel = [appData getLevelByNumber:nextLevel.levelNumber];
	}
	
	SEL loadSelector = nil;
	
	if([nextLevel.levelId isEqualToString:@"emobc"] && [nextLevel.dataId isEqualToString:@"profile"]){
		[self loadProfile];
	}else if([nextLevel.levelId isEqualToString:@"emobc"] && [nextLevel.dataId isEqualToString:@"search"]){
		[self loadSearchNextLevel];
	}else{
		
		if (appLevel != nil) {
			
			LoadUtil* util = nil;
			util = [[LoadUtil alloc] initWithValues:appLevel nextLevel:nextLevel];
			
			
			switch (appLevel.type) {
				case IMAGE_TEXT_DESCRIPTION_ACTIVITY:
					loadSelector = @selector(loadImageTextNextLevel:);
					break;
				case IMAGE_LIST_ACTIVITY:
					loadSelector = @selector(loadImageListNextLevel:);
					break;
				case LIST_ACTIVITY:
					loadSelector = @selector(loadListNextLevel:);
					break;
				case IMAGE_ZOOM_ACTIVITY:
					loadSelector = @selector(loadImageZoomNextLevel:);
					break;
				case IMAGE_GALLERY_ACTIVITY:
					loadSelector = @selector(loadImageGalleryNextLevel:);
					break;
				case BUTTONS_ACTIVITY:
					loadSelector = @selector(loadButtonsNextLevel:);
					break;
				case FORM_ACTIVITY:
					loadSelector = @selector(loadFormNextLevel:);
					break;
				case MAP_ACTIVITY:
					loadSelector = @selector(loadMapNextLevel:);
					break;
				case VIDEO_ACTIVITY:
					loadSelector = @selector(loadVideoNextLevel:);
					break;
				case WEB_ACTIVITY:
					loadSelector = @selector(loadWebNextLevel:);
					break;
				case PDF_ACTIVITY:
					loadSelector = @selector(loadPdfNextLevel:);
					break;
				case QR_ACTIVITY:
					loadSelector = @selector(loadQRNextLevel:);
					break;	
				case CALENDAR_ACTIVITY:
					loadSelector = @selector(loadCalendarNextLevel:);
					break;	
				case QUIZ_ACTIVITY:
					loadSelector = @selector(loadQuizNextLevel:);
					break;	
				case CANVAS_ACTIVITY:
					loadSelector = @selector(loadCanvasNextLevel:);
					break;	
				case AUDIO_ACTIVITY:
					loadSelector = @selector(loadAudioNextLevel:);
					break;	
				default:
					break;
			}
			
			
			if (loadSelector != nil) {
				[NSThread detachNewThreadSelector: loadSelector 
										 toTarget: self 
									   withObject: util];			
			}
			/*
			 //save current level
			 */
			self.currentNextLevel = nextLevel;
			
			return true;
			
		}else {
			
			NSString* message;
			 
			 message = [NSString stringWithFormat:@"No existe nivel %@",nextLevel.levelId];
			 
			 UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Mostrar Nivel" 
			 message:message 
			 delegate:self 
			 cancelButtonTitle:@"Ok"
			 otherButtonTitles:nil] autorelease];
			 [alert show];
		}
	}

	return false;
}

/**
 * Remove all subView with their activities
 */
-(void) removeAllActivitiesViews {
	for (UIView *view in self.view.subviews) {
		[view removeFromSuperview];
	}	
}

/**
 * Load current controller, the current controller could be any controller of any view
 */
- (void) loadCurrentController{
	[self loadController:currentController 
		   withAnimation:YES];
}

#pragma mark -
#pragma mark Load Activities Levels

/**
 * Load the data from image_gallery.xml into ImageGalleryLevelData and also call NwImageGalleryController
 *
 * @param util
 *
 * @see loadImageGalleryController
 * 
 */
- (void) loadImageGalleryNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	ImageGalleryLevelData* theData = [[NwUtil instance] readImageGalleryData:util];	
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadImageGalleryController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from image_text.xml into ImageTextLevelData and also call NwImageTextController
 *
 * @param util
 *
 * @see loadImageTextController
 */
- (void) loadImageTextNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	ImageTextDescriptionLevelData* theData = [[NwUtil instance] readImageTextDescriptionData:util.appLevel 
																				   nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadImageTextController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}



/**
 * Load the data from image_list.xml into ImageListLevelData and also call NwImageListController
 *
 * @param util
 *
 * @see loadImageListController
 */
- (void) loadImageListNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	ImageListLevelData* theData = [[NwUtil instance] readImageListData:util.appLevel 
															 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadImageListController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
	
}

/**
 * Load the data from list.xml into ListLevelData and also call NwListController
 *
 * @param util
 *
 * @see loadListController
 */
-(void) loadListNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	ListLevelData* theData = [[NwUtil instance] readListData:util.appLevel 
												   nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadListController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}

/**
 * Load the data from zoom_image.xml into ZoomImageLevelData and also call NwImageZoomController
 *
 * @param util
 *
 * @see loadImateGalleryController
 * 
 */
- (void) loadImageZoomNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	ImageZoomLevelData* theData = [[NwUtil instance] readImageZoomData:util.appLevel 
															 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadImageZoomController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from buttons.xml into ButtonsLevelData and also call NwButtonsController
 *
 * @param util
 *
 * @see loadButtonsController
 * 
 */
- (void) loadButtonsNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	ButtonsLevelData* theData = [[NwUtil instance] readButtonsData:util.appLevel
														 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadButtonsController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}

/**
 * Load the data from form.xml into FormLevelData and also call NwFormController
 *
 * @param util
 *
 * @see loadFormController
 */
- (void) loadFormNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	FormLevelData* theData = [[NwUtil instance] readFormData:util.appLevel
												   nextLevel:util.nextLevel];
	
	theData.parentNextLevel = self.currentNextLevel;
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadFormController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from map.xml into MapLevelData and also call NwMapController
 *
 * @param util
 *
 * @see loadMapController
 */
- (void) loadMapNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	MapLevelData* theData = [[NwUtil instance] readMapData:util.appLevel
												 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadMapController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from video.xml into VideoLevelData and also call NwVideoController
 *
 * @param util
 *
 * @see loadVideoController
 */
- (void) loadVideoNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	VideoLevelData* theData = [[NwUtil instance] readVideoData:util.appLevel 
													 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];

	[self performSelectorOnMainThread:@selector(loadVideoController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from web.xml into WebLevelData and also call NwWebController
 *
 * @param util
 *
 * @see loadWebController
 */
- (void) loadWebNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	WebLevelData* theData = [[NwUtil instance] readWebData:util.appLevel 
												 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];

	[self performSelectorOnMainThread:@selector(loadWebController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from pdf.xml into ImagePdfLevelData and also call NwPdfController
 *
 * @param util
 *
 * @see loadPdfController
 */
- (void) loadPdfNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	PdfLevelData* theData = [[NwUtil instance] readPdfData:util.appLevel 
												 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadPdfController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from lector_QR.xml into QRLevelData and also call NwQRController
 *
 * @param util
 *
 * @see loadQRController
 */
- (void) loadQRNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	QRLevelData* theData = [[NwUtil instance] readQRData:util.appLevel 
											   nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];

	[self performSelectorOnMainThread:@selector(loadQRController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from calendar.xml into CalendarLevelData and also call NwCalendarController
 *
 * @param util
 *
 * @see loadCalendarController
 */
- (void) loadCalendarNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//Read calendar.xml and save it into theData (CalendarLevelData type)
	CalendarLevelData* theData = [[NwUtil instance] readCalendarData:util.appLevel 
														   nextLevel:util.nextLevel];
	
	//Charge data into controlerUtil
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	//loadCalendarController and we init its data with controlerUtil data
	[self performSelectorOnMainThread:@selector(loadCalendarController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


/**
 * Load the data from buttons.xml into ButtonsLevelData and also call NwButtonsController
 *
 * @param util
 *
 * @see loadQuizController
 * 
 */
- (void) loadQuizNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	QuizLevelData* theData = [[NwUtil instance] readQuizData:util.appLevel
												   nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadQuizController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}

/**
 * Load the data from canvas.xml into CanvasLevelData and also call NwCanvasController
 *
 * @param util
 *
 * @see loadCanvasController
 */
- (void) loadCanvasNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	CanvasLevelData* theData = [[NwUtil instance] readCanvasData:util.appLevel 
													   nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadCanvasController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}

/**
 * Load the data from audio.xml into AudioLevelData and also call NwAudioController
 *
 * @param util
 *
 * @see loadAudioController
 */
- (void) loadAudioNextLevel:(LoadUtil*) util{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	AudioLevelData* theData = [[NwUtil instance] readAudioData:util.appLevel 
													 nextLevel:util.nextLevel];
	
	LoadControlerUtil* controlerUtil = nil;
	controlerUtil = [[LoadControlerUtil alloc] initWithValues:util.appLevel 
													  theData:theData];
	
	[util release];
	
	[self performSelectorOnMainThread:@selector(loadAudioController:) 
						   withObject:controlerUtil 
						waitUntilDone:NO];

	[pool drain];
}


#pragma mark -
#pragma mark Load Activity Controllers

/**
 * Load the data from profile.xml into FormLevelData and also call NwProfileController
 *
 * @param util
 *
 */
- (void) loadProfileFirstTime{
	NwProfileController *controller = [NwProfileController alloc];
	
	controller.mainController = self;
	self.currentController = controller;
	
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwProfileController"];
	
	[controller initWithNibName:controllerNibName
						 bundle:nil];
	
	[self loadController:currentController withAnimation:NO];	
	[controller release];
}

/**
 * Load the data from profile.xml into FormLevelData and also call NwProfileController
 *
 * @param util
 *
 */
- (void) loadProfile{
	NwProfileController *controller = [NwProfileController alloc];
	
	controller.mainController = self;
	self.currentController = controller;
	
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwProfileController"];
	
	[controller initWithNibName:controllerNibName
						 bundle:nil];
	
	[self loadController:currentController withAnimation:NO];	
	[controller release];
}


/**
 * Load the data from image_gallery.xml into ImageGalleryLevelData and also call NwImageGalleryController
 *
 * @param util
 *
 * @see loadSearchController
 * 
 */
- (void) loadSearchNextLevel{
	NwSearchController* controller = [NwSearchController alloc];
	
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwSearchController"];
	
	[controller initWithNibName:controllerNibName 
						 bundle:nil];
	
	
	controller.mainController = self;
	[self loadController:controller withAnimation:YES];	
}

/**
 * Load NwImageGalleryController with all data ready to use
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadImageGalleryController:(LoadControlerUtil*)  theControlerUtil{
	NwImageGalleryController *controller = [NwImageGalleryController alloc];

	controller.data = (ImageGalleryLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwImageGalleryController"]; 
	
	[controller initWithNibName:controllerNibName 
						 bundle:nil];

	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];
	[controller release];
	[theControlerUtil release];
	
}

/**
 * Load NwImageTextController with all data ready to use
 * even asing nib file to controller
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadImageTextController:(LoadControlerUtil*)  theControlerUtil{
	NwImageTextController* controller = [NwImageTextController alloc];
	
	NSString* controllerNibName;
	
	if([theControlerUtil.appLevel.levelXib length] == 0){
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwImageTextController"];
	}else{
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:theControlerUtil.appLevel.levelXib];		
	}	
	 
	[controller initWithNibName:controllerNibName 
						 bundle:nil];
	
	controller.data = (ImageTextDescriptionLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwImageListController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadImageListController:(LoadControlerUtil*)  theControlerUtil{
	NwImageListController *controller = [NwImageListController alloc];
	
	NSString* controllerNibName;
	if([theControlerUtil.appLevel.levelXib length] == 0){
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwImageListController"];
	}else{
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:theControlerUtil.appLevel.levelXib];		
	}
		
	[controller initWithNibName:controllerNibName 
						 bundle:nil];
	controller.data = (ImageListLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwListGalleryController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadListController:(LoadControlerUtil*)  theControlerUtil{
	NwListController *controller = [NwListController alloc];
	NSString* controllerNibName;
	if([theControlerUtil.appLevel.levelXib length] == 0){
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwListController"];
	}else{
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:theControlerUtil.appLevel.levelXib];		
	}
	
	[controller initWithNibName:controllerNibName 
						 bundle:nil];
	controller.data = (ListLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwImageZoomGalleryController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadImageZoomController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwImageZoomController"]; 
	
	NwImageZoomController *controller = [[NwImageZoomController alloc] initWithNibName:controllerNibName 
																				bundle:nil];
	controller.data = (ImageZoomLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwListGalleryController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadButtonsController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwButtonsController"];
	
	NwButtonsController *controller = [[NwButtonsController alloc] initWithNibName:controllerNibName 
																			bundle:nil];
	
	controller.data = (ButtonsLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwFormController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadFormController:(LoadControlerUtil*)  theControlerUtil{
    NwFormController *controller = [NwFormController alloc];

	NSString* controllerNibName;
	if([theControlerUtil.appLevel.levelXib length] == 0){
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwFormController"];
	}else{
		controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:theControlerUtil.appLevel.levelXib];		
	}
	
	[controller initWithNibName:controllerNibName 
						 bundle:nil];	
	controller.data = (FormLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwMapController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadMapController:(LoadControlerUtil*)  theControlerUtil{

	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwMapController"]; 
	
	NwMapController *controller = [[NwMapController alloc] initWithNibName:controllerNibName
																	bundle:nil];
	controller.data = (MapLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwVideoController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadVideoController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwVideoController"]; 
	
	NwVideoController *controller = [[NwVideoController alloc] initWithNibName:controllerNibName
																		bundle:nil];
	controller.data = (VideoLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwWebController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadWebController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwWebController"]; 
	NwWebController *controller = [[NwWebController alloc] initWithNibName:controllerNibName
																	bundle:nil];
	controller.data = (WebLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}

/**
 * Load NwPdfController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadPdfController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwPdfController"]; 
	NwPdfController *controller = [[NwPdfController alloc] initWithNibName:controllerNibName
																	bundle:nil];
	controller.data = (PdfLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;

	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwQRController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadQRController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwQRController"]; 
	
	NwQRController *controller = [[NwQRController alloc] initWithNibName:controllerNibName
																  bundle:nil];
	controller.data = (QRLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];

}

/**
 * Load NwCalendarController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadCalendarController:(LoadControlerUtil*)  theControlerUtil{
	//Getting nib name

	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwCalendarController"]; 
	//Init controller (NwCalendarController) with a specific nib name
	NwCalendarController *controller = [[NwCalendarController alloc] initWithNibName:controllerNibName
																	bundle:nil];
	controller.data = (CalendarLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	//Asing the NwController (currentController) the new controller of the new view 
	self.currentController = controller;
	
	//load and show controller whit a transition
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}

/**
 * Load NwListGalleryController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadQuizController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwQuizController"];
	
	NwQuizController *controller = [[NwQuizController alloc] initWithNibName:controllerNibName 
																	  bundle:nil];
	
	controller.data = (QuizLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}


/**
 * Load NwCanvasController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadCanvasController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwCanvasController"]; 
	NwCanvasController *controller = [[NwCanvasController alloc] initWithNibName:controllerNibName
																	bundle:nil];
	controller.data = (CanvasLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}

/**
 * Load NwPdfController with all data ready to use
 * even asing nib file to controller
 *
 * @param theControlerUtil
 *
 * @see loadController
 */
- (void) loadAudioController:(LoadControlerUtil*)  theControlerUtil{
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwAudioController"]; 
	NwAudioController *controller = [[NwAudioController alloc] initWithNibName:controllerNibName
																	bundle:nil];
	controller.data = (AudioLevelData*)theControlerUtil.data;
	controller.mainController = self;
	
	self.currentController = controller;
	
	[self loadController:currentController withAppLevel:theControlerUtil.appLevel];	
	[controller release];
	[theControlerUtil release];
}



#pragma mark -
#pragma mark Misc

-(void) mostrarUrl:(NSString*)urlString{
	NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
}


/**
 * Load web content show into the cover
 *
 * @param urlString La url a la que hay que acceder
 *
 * @see loadController
 */
-(void) mostrarWevActivityUrl:(NSString*)urlString{	
	for (UIView *view in self.view.subviews) {
		[view removeFromSuperview];
	}
	
	WebLevelData* theData = [[WebLevelData alloc] init];
	theData.webUrl = urlString;
	
	NSString* controllerNibName = [eMobcViewController addIPadSuffixWhenOnIPad:@"NwWebController"];
	NwWebController *controller = [[NwWebController alloc] initWithNibName:controllerNibName
																	bundle:nil];
	
	controller.data = theData;
	controller.mainController = self;
	[theData release];
	
	self.currentController = controller;
	[controller release];
	
	[self loadController:currentController withAnimation:YES];
}

-(void) tts:(NSString*)text{
}


/**
 * Show all application georeferences 
 *
 * @see loadController
 */
- (void) showAllGeoReferences{

	NwMapController* controller = [[NwMapController alloc]init];
	
	MapLevelData *theData = [[MapLevelData alloc] init];
	
	theData.showAllPositions = YES;
	
	controller.data = theData;
	controller.mainController = self;
	
	[controller release];
	[self loadController:controller withAnimation:YES];	
	
	[theData release];	
}

/**
 * Load differents types of transition 
 * The way we use to change views
 *
 * @param controller Controller which have to make the transition 
 * @param appLevel Level which we give the transition
 *
 * @see loadController
 */
- (void) loadController:(UIViewController*)controller withAppLevel:(AppLevel*)appLevel{
	if (appLevel != nil) {
        
       if ([appLevel.transitionName isEqualToString:@"FlipLeft"]) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelay:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self view] cache:YES]; 
            [self.view insertSubview:controller.view atIndex:0];
            [self.view bringSubviewToFront:controller.view];
            
            [UIView commitAnimations];
        } else if ([appLevel.transitionName isEqualToString:@"FlipRight"]) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelay:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[self view] cache:YES];  
            [self.view insertSubview:controller.view atIndex:0];
            [self.view bringSubviewToFront:controller.view];
            
            [UIView commitAnimations];
        } else if ([appLevel.transitionName isEqualToString:@"CurlDown"]) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelay:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self view] cache:YES]; 
            [self.view insertSubview:controller.view atIndex:0];
            [self.view bringSubviewToFront:controller.view];
            
            [UIView commitAnimations];

        }else if ([appLevel.transitionName isEqualToString:@"CurlUp"]) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelay:0.5];
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view] cache:YES];
            [self.view insertSubview:controller.view atIndex:0];
            [self.view bringSubviewToFront:controller.view];
            
            [UIView commitAnimations];
			
        } else if ([appLevel.transitionName isEqualToString:@"None"]) {
            /*[UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelay:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[self view] cache:YES]; */
            [self.view insertSubview:controller.view atIndex:0];
            [self.view bringSubviewToFront:controller.view];
            
            //[UIView commitAnimations];
            
        } else if ([appLevel.transitionName isEqualToString:@"FlipView"]) {
               /* self.transition = [transitionsArray objectAtIndex:3];	
                [[HMGLTransitionManager sharedTransitionManager] setTransition:transition];
                [[HMGLTransitionManager sharedTransitionManager] beginTransition:self.view];
                
                [self.view insertSubview:controller.view atIndex:0];
                [self.view bringSubviewToFront:controller.view];
                
                [[HMGLTransitionManager sharedTransitionManager] commitTransition];*/
        } else {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelay:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view] cache:YES];
            [self.view insertSubview:controller.view atIndex:0];
            [self.view bringSubviewToFront:controller.view];
            
            [UIView commitAnimations];
        }
         
	}else {
		[self.view insertSubview:controller.view atIndex:0];
		[self.view bringSubviewToFront:controller.view];
	}
}

/**
 * Load animated (if they are) transitions
 *
 * @param controller Controller which have to make the transition
 * @param withAnimation TRUE if there is animation
 */
- (void) loadController:(UIViewController*)controller withAnimation:(BOOL)withAnimation{
    
	if (withAnimation == YES) {
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationDelay:0.5];
		
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self view] cache:YES];
        
		[self.view insertSubview:controller.view atIndex:0];
		[self.view bringSubviewToFront:controller.view];
		
		[UIView commitAnimations];
    }else {
		[self.view insertSubview:controller.view atIndex:0];
		[self.view bringSubviewToFront:controller.view];
	}
/*
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    [self.view setTransform:rotate]; //Rotate the containerViewParent.
    
    [self.view addSubview:controller.view]; 
    
    rotate = CGAffineTransformMakeRotation(3.14/2);
    [controller.view setTransform:rotate];//Rotate the containerView.
   
    //[self.view insertSubview:controller.view atIndex:0];
    [self.view addSubview:controller.view]; //Add it to the self.containerViewParent.
    [self.view addSubview:controller.view];
    
    [UIView beginAnimations:@"page transition" context:nil];
    [UIView setAnimationDuration:2.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView commitAnimations];*/
}


#pragma mark -
#pragma mark iPhone-iPad Support

/**
 * Check if device is iPad o iPhone
 *
 * @return TRUE if device is an iPad
 */
+ (BOOL)isIPad{
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            return YES;
        }
    }
    return NO;
}

/**
 * Add to .xib file a suffix if device is iPad
 *
 * @param resourceName .xib file name
 *
 * @return .xib name file + suffix
 */
+ (NSString *) addIPadSuffixWhenOnIPad:(NSString *)resourceName{
    if([eMobcViewController isIPad]){
		return [resourceName stringByAppendingString:@"-iPad"];
    }else {
		return resourceName;
    }   
}


+(NSString *) addIPadImageSuffixWhenOnIPad:(NSString *)resourceImage{
	if([eMobcViewController isIPad]){
		//Sirve para coger imagenes con terminacion -iPad.png
		NSString *imagePath;
		NSString *cadena;
		NSScanner *scanner = [NSScanner scannerWithString:resourceImage];
		[scanner scanUpToString:@".png" intoString:&cadena];
		
		imagePath = [cadena stringByAppendingString:@"-iPad.png"];
			
		resourceImage = imagePath;
		return resourceImage;
	}else {
		return resourceImage;
	}
}

+(NSString *) addLandscapeImageSuffix:(NSString *) resourcesImageLandscape{
		
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		NSString *imagePath;
		NSString *cadena;
		NSScanner *scanner = [NSScanner scannerWithString:resourcesImageLandscape];
		[scanner scanUpToString:@".png" intoString:&cadena];
		
		imagePath = [cadena stringByAppendingString:@"-Landscape.png"];
		
		resourcesImageLandscape = imagePath;
		return resourcesImageLandscape;
	}else{
		return resourcesImageLandscape;
	}					
}


+(NSString *) whatDevice:(NSString *) directoryImages{
 
	CGRect currentScreen = [[UIScreen mainScreen] bounds];
	int a = currentScreen.size.width;
	int b = currentScreen.size.height;
	int sw = 0;
 
	if(a == 320 && b == 480){
		directoryImages = @"iphone";
	}else if(a == 640 && b == 960){
			directoryImages = @"iphone4";
	}else if(a == 640 && b == 1136){
			directoryImages = @"iphone5";
			sw = 1;
	}else if(a == 768 && b == 1024){
			directoryImages = @"ipad";		
	}else if(a == 1536 && b == 2048){
			directoryImages = @"nipad";
			sw = 2;
	}

	if(sw == 0){
		return directoryImages;
	}else{
		if(sw == 1 && directoryImages == nil){
			directoryImages = @"iphone4";
		}else if(sw == 2 && directoryImages == nil){
			directoryImages = @"ipad";
		}
		return directoryImages;
	}
}

#pragma mark -
#pragma mark iPhone-iPad Rotation


/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 *
 * @param interfaceOrientation The orientation of the application’s user interface after the rotation. 
 * The possible values are described in UIInterfaceOrientation.
 *
 * @return YES if the view controller supports the specified orientation or NO if it does not
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

/**
 * Send to viewController before user interfaz start to rotate
 *
 * @param orientation Interface new orientation 
 * @param duration Second wasted to rotate
 */
-(void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
	
}

@end