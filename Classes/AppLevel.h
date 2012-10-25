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
#import "AppLevelData.h"
#import "ImageTextDescriptionLevel.h"
#import "ImageListLevel.h"
#import "ImageZoomLevel.h"
#import "ButtonsLevel.h"
#import "FormLevel.h"
#import "MapLevel.h"
#import "CachedContent.h"

/**
 * CLASS SUMMARY
 * AppLevel is a special level because It doesn't add levels into system stack
 * AppLevel has a enum atribute to define all types of view we have 
 * 
 */
/*
 PDF_ACTIVITY
 WEB_ACTIVITY
 BUTTONS_ACTIVITY	
 IMAGE_TEXT_DESCRIPTION_ACTIVITY
 IMAGE_LIST_ACTIVITY
 IMAGE_ZOOM_ACTIVITY
 QR_ACTIVITY
 FORM_ACTIVITY		
 IMAGE_GALLERY_ACTIVITY
 MAP_ACTIVITY
 VIDEO_ACTIVITY
 LIST_ACTIVITY		
 SPLASH_ACTIVITY	//Falta
 SEARCH_ACTIVITY	//Falta
 COVER_ACTIVITY	
 */
typedef enum ActivityType {
	COVER_ACTIVITY,
	IMAGE_TEXT_DESCRIPTION_ACTIVITY,
	IMAGE_LIST_ACTIVITY,
	LIST_ACTIVITY,
	VIDEO_ACTIVITY,
	IMAGE_ZOOM_ACTIVITY,
	IMAGE_GALLERY_ACTIVITY,
	BUTTONS_ACTIVITY,
	FORM_ACTIVITY,
	MAP_ACTIVITY,
	WEB_ACTIVITY,
	PDF_ACTIVITY,
	QR_ACTIVITY,
	SPLASH_ACTIVITY,
	SEARCH_ACTIVITY,
	CALENDAR_ACTIVITY,
	QUIZ_ACTIVITY,
	CANVAS_ACTIVITY,
	AUDIO_ACTIVITY
}ActivityType;

@interface AppLevel : NSObject {
	
//Variables
	int number;

//Objetos
	NSString *levelId;
	NSString *title;
//Publicity
	NSString *ads;
	CachedContent *file;
	ActivityType type;
	NSString *levelXib;
	NSString *transitionName;
	bool useProfile;
}

@property(nonatomic, assign) int number;
@property(nonatomic, copy) NSString *levelId;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *ads;
@property(nonatomic, retain) CachedContent *file;
@property(nonatomic, assign) ActivityType type;
@property(nonatomic, copy) NSString *levelXib;
@property(nonatomic, copy) NSString *transitionName;
@property(nonatomic, assign) bool useProfile;


//Metodos
	-(AppLevelData*) readLevelData;
	-(ImageTextDescriptionLevel*) readImageTextDescriptionLevel;
	-(ImageListLevel*) readImageListLevel;
	-(ImageZoomLevel*) readImageZoomLevel;
	-(ButtonsLevel*) readButtonsLevel;
	-(FormLevel*) readFormLevel;
	-(MapLevel*) readMapLevel;

//Methods necesary to SearchView
	-(NSMutableArray*) searchText:(NSString*)text;
	-(NSMutableArray*) findAllGeoReferences;
	-(NSMutableArray*) findAllImages;

@end
