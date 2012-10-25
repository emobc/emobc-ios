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

#import "AppParser.h"
#import <Foundation/NSXMLParser.h>


@implementation AppParser

@synthesize currentApplicationDataObject;
@synthesize currentAppLevelObject;


static NSString * const kApplicationElementName = @"application";
static NSString * const kTitleElementName = @"title";
static NSString * const kCoverFileNameElementName = @"coverFileName";

static NSString * const kStylesFileNameElementName = @"stylesFileName";
static NSString * const kFormatsFileNameElementName = @"formatsFileName";

static NSString * const kProfileFileNameElementName = @"profileFileName";

static NSString * const kMenuElementName = @"menu";
static NSString * const kTopMenuElementName = @"topMenu";
static NSString * const kBottomMenuElementName = @"bottomMenu";
static NSString * const kBackgroundMenuElementName = @"backgroundMenu";


//Publicity
static NSString * const kBannerElementName = @"banner";
static NSString * const kTypeElementName = @"type";
static NSString * const kPositionElementName = @"position";
static NSString * const kIDElementName = @"id";
//--

static NSString * const kAdsElementName = @"ads";
static NSString * const kLevelsElementName = @"levels";
static NSString * const kLevelElementName = @"level";
static NSString * const kLevelIdElementName = @"levelId";
static NSString * const kLevelXibElementName = @"levelXib";
static NSString * const kLevelTitleElementName = @"levelTitle";
static NSString * const kLevelAdsElementName = @"levelAds";
static NSString * const kLevelFileElementName = @"levelFile";
static NSString * const kLevelTypeElementName = @"levelType";
static NSString * const kLevelTransitionElementName = @"levelTransition";

static NSString * const kLevelUseProfileElementName = @"levelUseProfile";

static NSString * const kStartPointElementName = @"entryPoint";
static NSString * const kPointNextLevelIdElementName = @"pointLevelId";
static NSString * const kPointNextDataIdElementName = @"pointDataId";

static NSString * const kActTypeCover = @"COVER_ACTIVITY";
static NSString * const kActTypeImageDescr = @"IMAGE_TEXT_DESCRIPTION_ACTIVITY";
static NSString * const kActTypeImageList = @"IMAGE_LIST_ACTIVITY";
static NSString * const kActTypeList = @"LIST_ACTIVITY";
static NSString * const kActTypeVideo = @"VIDEO_ACTIVITY";
static NSString * const kActTypeImageZoom = @"IMAGE_ZOOM_ACTIVITY";
static NSString * const kActTypeImageGalery = @"IMAGE_GALLERY_ACTIVITY";
static NSString * const kActTypeButtons = @"BUTTONS_ACTIVITY";
static NSString * const kActTypeForm = @"FORM_ACTIVITY";
static NSString * const kActTypeMap = @"MAP_ACTIVITY";
static NSString * const kActTypeWeb = @"WEB_ACTIVITY";
static NSString * const kActTypePdf = @"PDF_ACTIVITY";
static NSString * const kActTypeQR = @"QR_ACTIVITY";
static NSString * const kActTypeCalendar = @"CALENDAR_ACTIVITY";
static NSString * const kActTypeQuiz = @"QUIZ_ACTIVITY";
static NSString * const kActTypeCanvas = @"CANVAS_ACTIVITY";
static NSString * const kActTypeAudio = @"AUDIO_ACTIVITY";


-(id) init {
	if (self = [super init]) {    
	}	
	return self;
}

- (void)dealloc {
	
    [super dealloc];
}

/**
 * Sent by a parser object to its delegate when it encounters a start tag for a given element.
 *
 * @param parser A parser object
 * @param elementName  string that is the name of an element (in its start tag)
 * @param namespaceURI If namespace processing is turned on, contains the URI for the current namespace as a string object
 * @param qualifiedName If namespace processing is turned on, contains the qualified name for the current namespace as a string object
 * @param attributeDict A dictionary that contains any attributes associated with the element. 
 *  Keys are the names of attributes, and values are attribute values
 */
- (void)parser:(AQXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
	
    if ([elementName isEqualToString:kApplicationElementName]) {
        ApplicationData *appData = [[ApplicationData alloc] init];
        self.currentApplicationDataObject = appData;
        [appData release];
	} else if ([elementName isEqualToString:kLevelElementName]) {
		AppLevel* currAppLevel = [[AppLevel alloc]init];
		self.currentAppLevelObject = currAppLevel;
		[currAppLevel release];	
	} else if ([elementName isEqualToString:kTitleElementName] ||
               [elementName isEqualToString:kCoverFileNameElementName] ||
			   [elementName isEqualToString:kStylesFileNameElementName] ||
			   [elementName isEqualToString:kFormatsFileNameElementName] ||
			   [elementName isEqualToString:kProfileFileNameElementName] ||
			   [elementName isEqualToString:kPointNextLevelIdElementName] ||
			   [elementName isEqualToString:kPointNextDataIdElementName] ||
			   [elementName isEqualToString:kBannerElementName] ||
			   [elementName isEqualToString:kTypeElementName] ||
			   [elementName isEqualToString:kPositionElementName] ||
			   [elementName isEqualToString:kIDElementName] ||
			   [elementName isEqualToString:kTopMenuElementName] ||
			   [elementName isEqualToString:kBackgroundMenuElementName] ||
			   [elementName isEqualToString:kBottomMenuElementName] ||
			   [elementName isEqualToString:kAdsElementName] ||
               [elementName isEqualToString:kLevelIdElementName]||
			   [elementName isEqualToString:kLevelXibElementName]||
               [elementName isEqualToString:kLevelTitleElementName]||
               [elementName isEqualToString:kLevelFileElementName] ||
			   [elementName isEqualToString:kLevelTransitionElementName] ||
			   [elementName isEqualToString:kProfileFileNameElementName] ||
			   [elementName isEqualToString:kLevelTypeElementName]) {
        // For the 'title', 'updated', or 'georss:point' element begin accumulating parsed character data.
        // The contents are collected in parser:foundCharacters:.
        accumulatingParsedCharacterData = YES;
        // The mutable string needs to be reset to empty.
        [currentParsedCharacterData setString:@""];
    }
}


/**
 * Sent by a parser object to its delegate when it encounters an end tag for a specific element
 *
 * @param parser A parser object
 * @param elementName A string that is the name of an element (in its end tag)
 * @param namespaceURI If namespace processing is turned on, contains the URI for the current namespace as a string object
 * @param qualifiedName If namespace processing is turned on, contains the qualified name for the current namespace as a string object
 */
- (void)parser:(AQXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     

    if ([elementName isEqualToString:kApplicationElementName]) {
    } else if ([elementName isEqualToString:kTitleElementName]) {
		self.currentApplicationDataObject.title = self.currentParsedCharacterData;
    } else if ([elementName isEqualToString:kCoverFileNameElementName]) {
		self.currentApplicationDataObject.coverFileName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kStylesFileNameElementName]) {
		self.currentApplicationDataObject.stylesFileName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kFormatsFileNameElementName]) {
		self.currentApplicationDataObject.formatsFileName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kProfileFileNameElementName]) {
		self.currentApplicationDataObject.profileFileName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kTypeElementName]) {
		self.currentApplicationDataObject.banner = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kPositionElementName]) {
		self.currentApplicationDataObject.bannerPos = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kIDElementName]) {
		self.currentApplicationDataObject.bannerId = self.currentParsedCharacterData;
	} else if([elementName isEqualToString:kPointNextLevelIdElementName]){
		self.currentApplicationDataObject.pointLevelId = self.currentParsedCharacterData;
	} else if([elementName isEqualToString:kPointNextDataIdElementName]){
		self.currentApplicationDataObject.pointDataId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kTopMenuElementName]) {
		self.currentApplicationDataObject.topMenu = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kBottomMenuElementName]) {
		self.currentApplicationDataObject.bottomMenu = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kBackgroundMenuElementName]) {
		self.currentApplicationDataObject.backgroundMenu = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kLevelElementName]) {
		[self.currentApplicationDataObject addLevel: self.currentAppLevelObject];
		self.currentAppLevelObject = nil;		
    } else if ([elementName isEqualToString:kLevelIdElementName]) {
		self.currentAppLevelObject.levelId = self.currentParsedCharacterData;		
    } else if ([elementName isEqualToString:kLevelXibElementName]) {
		self.currentAppLevelObject.levelXib = self.currentParsedCharacterData; 
    } else if ([elementName isEqualToString:kLevelTransitionElementName]) {
		self.currentAppLevelObject.transitionName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kLevelUseProfileElementName]){
		self.currentAppLevelObject.useProfile = currentParsedCharacterData;
    } else if ([elementName isEqualToString:kLevelTitleElementName]) {
		self.currentAppLevelObject.title = self.currentParsedCharacterData;
    } else if ([elementName isEqualToString:kLevelAdsElementName]) {
		self.currentAppLevelObject.ads = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kLevelFileElementName]) {
		CachedContent* cachedContent = [[CachedContent alloc] initWithFileName:self.currentParsedCharacterData]; 
		self.currentAppLevelObject.file = cachedContent;
		[cachedContent release];
    } else if ([elementName isEqualToString:kLevelTypeElementName]) {
		if ([self.currentParsedCharacterData isEqualToString:kActTypeCover]) {
			self.currentAppLevelObject.type = COVER_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeImageDescr]) {
			self.currentAppLevelObject.type = IMAGE_TEXT_DESCRIPTION_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeImageList]) {
			self.currentAppLevelObject.type = IMAGE_LIST_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeList]) {
			self.currentAppLevelObject.type = LIST_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeVideo]) {
			self.currentAppLevelObject.type = VIDEO_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeImageZoom]) {
			self.currentAppLevelObject.type = IMAGE_ZOOM_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeImageGalery]) {
			self.currentAppLevelObject.type = IMAGE_GALLERY_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeButtons]) {
			self.currentAppLevelObject.type = BUTTONS_ACTIVITY;			
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeForm]) {
			self.currentAppLevelObject.type = FORM_ACTIVITY;			
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeMap]) {
			self.currentAppLevelObject.type = MAP_ACTIVITY;			
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeWeb]) {
			self.currentAppLevelObject.type = WEB_ACTIVITY;			
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypePdf]) {
			self.currentAppLevelObject.type = PDF_ACTIVITY;		
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeQR]) {
			self.currentAppLevelObject.type = QR_ACTIVITY;			
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeCalendar]) {
			self.currentAppLevelObject.type = CALENDAR_ACTIVITY;	
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeQuiz]) {
			self.currentAppLevelObject.type = QUIZ_ACTIVITY;	
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeCanvas]) {
			self.currentAppLevelObject.type = CANVAS_ACTIVITY;
		}else if ([self.currentParsedCharacterData isEqualToString:kActTypeAudio]) {
			self.currentAppLevelObject.type = AUDIO_ACTIVITY;
		}
	}				
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;	
}

@end

