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
#import "Cover.h"
#import "TopMenuData.h"
#import "BottomMenuData.h" 
#import "ApplicationData.h"
#import "AppLevel.h"
#import "DataItem.h"
#import "ImageTextDescriptionLevelData.h"
#import "ImageListLevelData.h"
#import "ListLevelData.h"
#import "ImageGalleryLevelData.h"
#import "ImageZoomLevelData.h"
#import "ButtonsLevelData.h"
#import "FormLevelData.h"
#import "MapLevelData.h"
#import "VideoLevelData.h"
#import "WebLevelData.h"
#import "PdfLevelData.h"
#import "QRLevelData.h"
#import "CalendarLevelData.h"
#import "QuizLevelData.h"
#import "CanvasLevelData.h"
#import "AudioLevelData.h"
#import "LoadUtil.h"
#import "FormatsStylesLevelData.h"
#import "StylesLevelData.h"

#import "ProfileLevelData.h"

/**
 * CLASS SUMMARY
 * NwUtil is a special class which its goal is take Parser with their asociate xml
 * Take parser and return its data into LevelData
 */

@interface NwUtil : NSObject {

//Objetos	
	ApplicationData *theAppData;
	Cover* theCover;
	TopMenuData* theTopMenu;
	BottomMenuData* theBottomMenu;
	
	FormatsStylesLevelData* theFormatsStyles;
	StylesLevelData* theStyles;
	
	ProfileLevelData *theProfile;
	
	NSMutableDictionary *formData;
	
}

@property (nonatomic, retain) ApplicationData *theAppData;
@property (nonatomic, retain) Cover *theCover;
@property (nonatomic, retain) TopMenuData* theTopMenu;
@property (nonatomic, retain) BottomMenuData* theBottomMenu;
@property (nonatomic, retain) FormatsStylesLevelData* theFormatsStyles;
@property (nonatomic, retain) StylesLevelData* theStyles;
@property (nonatomic, retain) ProfileLevelData *theProfile;
@property (nonatomic, retain) NSMutableDictionary *formData;

//Metodos
	+(NwUtil*) instance;

//For Special Parsers
	-(ApplicationData *) readApplicationData;
	-(Cover*) readCover;
	-(FormatsStylesLevelData*) readFormats;
	-(StylesLevelData*) readStyles;
	-(ProfileLevelData*) readProfile;
	-(TopMenuData*) readTopMenu;
	-(BottomMenuData*) readBottomMenu;
	-(AppLevel*) readAppLevel:(NextLevel*)nextLevel;
	-(DataItem*) readAppLevelData:(NextLevel*)nextLevel;

//For rest of Parsers
	-(ImageTextDescriptionLevelData*) readImageTextDescriptionData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(ImageListLevelData*) readImageListData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(ListLevelData*) readListData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(ImageZoomLevelData*) readImageZoomData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(ImageGalleryLevelData*) readImageGalleryData:(LoadUtil*) util;
	-(ButtonsLevelData*) readButtonsData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(FormLevelData*) readFormData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(MapLevelData*) readMapData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(VideoLevelData*) readVideoData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(WebLevelData*) readWebData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(PdfLevelData*) readPdfData:(AppLevel *)appLevel nextLevel:(NextLevel *)nextLevel;
	-(QRLevelData*) readQRData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;
	-(CalendarLevelData*) readCalendarData:(AppLevel *)appLevel nextLevel:(NextLevel *)nextLevel;
	-(QuizLevelData*) readQuizData:(AppLevel *)appLevel nextLevel:(NextLevel *)nextLevel;
	-(CanvasLevelData*) readCanvasData:(AppLevel *)appLevel nextLevel:(NextLevel *)nextLevel;
	-(AudioLevelData*) readAudioData:(AppLevel *)appLevel nextLevel:(NextLevel *)nextLevel;

//Methods for search View
	-(NSMutableArray*) searchText:(NSString*)text;
	-(NSMutableArray*) findAllGeoReferences;
	-(NSMutableArray*) findAllImages;

	-(NSMutableDictionary*) readFormData;
	-(NSData*) readProfileAndPostData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel;

@end