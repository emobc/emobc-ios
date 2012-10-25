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

#import "AppLevel.h"
#import "ImageDescriptionParser.h"
#import "ImageListParser.h"
#import "ImageZoomParser.h"
#import "ButtonsParser.h"
#import "FormParser.h"
#import "MapParser.h"
#import "SearchItem.h"

@implementation AppLevel

@synthesize number;
@synthesize levelId;
@synthesize title;
@synthesize file;
@synthesize ads;
@synthesize type;
@synthesize levelXib;
@synthesize transitionName; 
@synthesize useProfile;

-(id)init {
	if (self = [super init]) {
		number = 0;
		levelId = nil;
		title = nil;
		file = nil;
		transitionName = nil;
		useProfile = FALSE;		
	}	
	
	return self;
	
}

-(void) dealloc {
	[levelId release];
	[title release];
	[file release];
	
	[super dealloc];
}

/**
 * Depending on type view, we are going to call differents methods
 *
 * @param nextLevel
 *
 * @return Return LevelData differents for each view
 *
 */
-(AppLevelData*) readLevelData {
	AppLevelData* retLevelData = nil;
	
	switch (type) {
		case IMAGE_TEXT_DESCRIPTION_ACTIVITY:
			retLevelData = [self readImageTextDescriptionLevel];
			break;
		case IMAGE_LIST_ACTIVITY:
			retLevelData = [self readImageListLevel];
			break;
		case IMAGE_ZOOM_ACTIVITY:
			retLevelData = [self readImageZoomLevel];	
			break;
		case BUTTONS_ACTIVITY:
			retLevelData = [self readButtonsLevel];
			break;
		case FORM_ACTIVITY:
			retLevelData = [self readFormLevel];
			break;
		case MAP_ACTIVITY:
			retLevelData = [self readMapLevel];
			break;
		default:
			break;
	}
	
	return retLevelData;
}

/**
 * Parse dates from image_text_description.xml and asing level from parser to ImageTextDescriptionLevel
 *
 * @return View Level
 */
-(ImageTextDescriptionLevel*) readImageTextDescriptionLevel {
	ImageDescriptionParser *parser = [[ImageDescriptionParser alloc] init];
	
	NSData* parseData = [file content]; 
	
	[parser parseXMLFileFromData:parseData];
	
	ImageTextDescriptionLevel* theLevel = (ImageTextDescriptionLevel*)parser.parsedLevel;
	
	return theLevel;
}

/**
 * Parse dates from image_list.xml and asing level from parser to ImageListLevel
 *
 * @return View Level
 */
-(ImageListLevel*) readImageListLevel {
	ImageListParser *parser = [[ImageListParser alloc] init];
	
	NSData* parseData = [file content];
	
	[parser parseXMLFileFromData:parseData];
	
	ImageListLevel* theLevel = (ImageListLevel*)parser.parsedLevel;

	return theLevel;
}


-(ImageZoomLevel*) readImageZoomLevel {
	ImageZoomParser *parser = [[ImageZoomParser alloc] init];
	
	NSData* parseData = [file content]; 
	
	[parser parseXMLFileFromData:parseData];
	
	ImageZoomLevel* theLevel = (ImageZoomLevel*)parser.parsedLevel;
	
	return theLevel;	
}

-(ButtonsLevel*) readButtonsLevel {
	ButtonsParser *parser = [[ButtonsParser alloc] init];
	
	NSData* parseData = [file content]; 
	
	[parser parseXMLFileFromData:parseData];
	
	ButtonsLevel* theLevel = (ButtonsLevel*)parser.parsedLevel;

	return theLevel;
}

/**
 * Parse dates from form.xml and asing level from parser to FormLevel
 *
 * @return View Level
 */
-(FormLevel*) readFormLevel {
	FormParser *parser = [[FormParser alloc] init];
	
	NSData* parseData = [file content]; 
	
	[parser parseXMLFileFromData:parseData];
	
	FormLevel* theLevel = (FormLevel*)parser.parsedLevel;

	return theLevel;
	
}

/**
 * Parse dates from map.xml and asing level from parser to MapLevel
 *
 * @return View Level
 */
-(MapLevel*) readMapLevel {
	MapParser *parser = [[MapParser alloc] init];
	
	NSData* parseData = [file content]; 
	[parser parseXMLFileFromData:parseData];
	
	MapLevel* theLevel = (MapLevel*)parser.parsedLevel;

	return theLevel;
}


/**
 * Search all posibles matches from a text given into text framework
 *
 * @return Matched found
 */
-(NSMutableArray*) searchText:(NSString*)text {
	NSMutableArray* retArray = [[NSMutableArray alloc]init];
	
	AppLevelData* appLevelData = [self readLevelData];
	
	for(DataItem* dataItem in appLevelData.items) {	
	
		NSRange titleResultsRange = [dataItem.headerText rangeOfString:text 
															   options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0) {
			SearchItem* searchItem = [[SearchItem alloc]init];
			searchItem.text = dataItem.headerText;
			NextLevel* nextLevel = [[NextLevel alloc]init];
			
			nextLevel.levelId = levelId;
			nextLevel.dataId = dataItem.dataId;
			
			searchItem.nextLevel = nextLevel;
			
			[retArray addObject:searchItem];
			[searchItem release];
			[nextLevel release];
		}
		
	}
	
	return retArray;
}


/**
 * Search all georeferences contained into framework
 *
 * @return georeferences list
 */
-(NSMutableArray*) findAllGeoReferences {
	NSMutableArray* retArray = [[NSMutableArray alloc]init];
	
	AppLevelData* appLevelData = [self readLevelData];
	
	for(DataItem* dataItem in appLevelData.items){
		if (dataItem.geoReferencia > 0){
			SearchItem* searchItem = [[SearchItem alloc]init];
			searchItem.text = dataItem.geoReferencia;
			NextLevel* nextLevel = [[NextLevel alloc]init];
			
			nextLevel.levelId = levelId;
			nextLevel.dataId = dataItem.dataId;
			
			searchItem.nextLevel = nextLevel;
			
			[retArray addObject:searchItem];
		}
	}
	
	return retArray;
}


/**
 * Search all images contained into framework
 *
 * @return images list
 */
-(NSMutableArray*) findAllImages {
	NSMutableArray* retArray = [[NSMutableArray alloc]init];
	
	AppLevelData* appLevelData = [self readLevelData];
	
	for(DataItem* dataItem in appLevelData.items) {
		
		NSArray *array = [dataItem findAllImages];
		
		if (array != nil) {			
			for(NSString* imageFileName in array){
				SearchItem* searchItem = [[SearchItem alloc]init];
				searchItem.text = imageFileName;
				NextLevel* nextLevel = [[NextLevel alloc]init];
			
				nextLevel.levelId = levelId;
				nextLevel.dataId = dataItem.dataId;
			
				searchItem.nextLevel = nextLevel;
			
				[retArray addObject:searchItem];
			}
		}
	}
	
	return retArray;
}


@end