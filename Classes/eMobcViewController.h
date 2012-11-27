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
#import "NwImageTextController.h"
#import "NwImageListController.h"
#import "NwListController.h"
#import "NwImageZoomController.h"
#import "NwImageGalleryController.h"
#import "NwCoverController.h"
#import "NwSplashController.h"
#import "NwButtonsController.h"
#import "NwFormController.h"
#import "NwMapController.h"
#import "NwVideoController.h"
#import "NwWebController.h"
#import "NwPdfController.h"
#import "NwQRController.h"
#import "NwCalendarController.h"
#import "NwQuizController.h"
#import "NwCanvasController.h"
#import "NwAudioController.h"
#import "LoadUtil.h"
#import "LoadControlerUtil.h"
#import "AppLevel.h"
#import "NwSideMenuController.h"
#import "ApplicationData.h"
#import "NwProfileController.h"

@interface eMobcViewController : UIViewController {
	
//Objetos
	NwCoverController *coverController;
	NwController *currentController;
	
	NwSideMenuController *currentMenuController;
	
	NSMutableArray* levelsStack;
	NextLevel* currentNextLevel;
		
//We use it to play the start audio while the cover is charging
	AVAudioPlayer  *player;

//Outlets
	IBOutlet UIView* modelView;
	
//save all data from app.xml
	ApplicationData* appData;

//Format and styles
	StylesLevelData* theStyle;
	FormatsStylesLevelData* theFormat;
	
}

@property(nonatomic, retain) NwCoverController *coverController;
@property(nonatomic, retain) NwController *currentController;

@property(nonatomic, retain) NwSideMenuController *currentMenuController;

@property(nonatomic, retain) NextLevel* currentNextLevel;

@property(nonatomic, retain) ApplicationData* appData; 
@property(nonatomic, retain) StylesLevelData* theStyle; 
@property(nonatomic, retain) FormatsStylesLevelData* theFormat;


//Metodos
	-(void) goBack;
	-(void) showAllGeoReferences;
	-(void) loadCover;
	//- (void) loadSplash;
	- (void) loadNextLevel:(NextLevel*) nextLevel;
	/*
	 Muestra el NextLevel pero no lo almacena en la pila de llamada
	 */
	-(bool) showNextLevel:(NextLevel*) nextLevel;

//call nextLevel of each view
	-(void) loadImageTextNextLevel:(LoadUtil*) util;
	-(void) loadImageListNextLevel:(LoadUtil*) util;
	-(void) loadListNextLevel:(LoadUtil*) util;
	-(void) loadImageZoomNextLevel:(LoadUtil*) util;
	-(void) loadImageGalleryNextLevel:(LoadUtil*) util;
	-(void) loadButtonsNextLevel:(LoadUtil*) util;
	-(void) loadFormNextLevel:(LoadUtil*) util;
	-(void) loadMapNextLevel:(LoadUtil*) util;
	-(void) loadVideoNextLevel:(LoadUtil*) util;
	-(void) loadWebNextLevel:(LoadUtil*) util;
	-(void) loadPdfNextLevel:(LoadUtil*) util;
	-(void) loadQRNextLevel:(LoadUtil*) util;
	-(void) loadCalendarNextLevel:(LoadUtil*) util;
	-(void) loadQuizNextLevel:(LoadUtil*) util;
	-(void) loadCanvasNextLevel:(LoadUtil*) util;
	-(void) loadAudioNextLevel:(LoadUtil*) util;

	-(void) loadSearchNextLevel;

//call controller of each view
	-(void) loadImageTextController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadImageListController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadListController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadImageZoomController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadImageGalleryController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadButtonsController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadFormController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadMapController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadVideoController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadWebController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadPdfController:(LoadControlerUtil*)  theControlerUtil;
	-(void) loadQRController:(LoadControlerUtil*) theControlerUtil;
	-(void) loadCalendarController:(LoadControlerUtil*)  theControlerUtil;
	-(void) loadQuizController:(LoadControlerUtil*)  theControlerUtil;
	-(void) loadCanvasController:(LoadControlerUtil*)  theControlerUtil;
	-(void) loadAudioController:(LoadControlerUtil*)  theControlerUtil;

	-(void) loadController:(UIViewController*)controller withAnimation:(BOOL)withAnimation;
	-(void) loadController:(UIViewController*)controller withAppLevel:(AppLevel*)appLevel;
	-(void) loadCurrentController;

	-(void) mostrarUrl:(NSString*)urlString;
	-(void) mostrarWevActivityUrl:(NSString*)urlString;
	-(void) removeAllActivitiesViews;

	-(void) loadProfileFirstTime;
	-(void) loadProfile;

// iPhone - iPad Support
	+ (BOOL)isIPad;
	+ (NSString *) addIPadSuffixWhenOnIPad:(NSString *)resourceName;
	+ (NSString *) addIPadImageSuffixWhenOnIPad:(NSString *)resourceImage;
	+ (NSString *) addLandscapeImageSuffix:(NSString *) resourcesImageLandscape;
	+ (NSString *) whatDevice:(NSString *) directoryImages;

	-(NSInteger) ifMenuAndAdsTop: (NSInteger) sizeTop;
	-(NSInteger) ifMenuAndAdsBottom: (NSInteger) sizeBottom;

@end