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

#import "ImageDescriptionParser.h"


@implementation ImageDescriptionParser

@synthesize currNextLevel;

static NSString * const kDataElementName = @"data";
static NSString * const kDataIdElementName = @"dataId";
static NSString * const kHeaderImageFileElementName = @"headerImageFile";
static NSString * const kHeaderTextElementName = @"headerText";
static NSString * const kImageFileElementName = @"imageFile";
static NSString * const kGeoRefElementName = @"geoRef";
static NSString * const kTextElementName = @"text";
static NSString * const kBarTextElementName = @"barText";

static NSString * const kNextLevelElementName = @"nextLevel";
static NSString * const kPrevLevelElementName = @"prevLevel";
static NSString * const kNLLeveNumberElementName = @"nextLevelLevel";
static NSString * const kNLLeveIdElementName = @"nextLevelLevelId";
static NSString * const kNLDataNumberElementName = @"nextLevelDataNumber";
static NSString * const kNLDataIdElementName = @"nextLevelDataId";

- (void)dealloc {
	[parsedLevel release];
	parsedLevel = nil;
	
    [super dealloc];
}

-(id) init {
	if (self = [super init]) {    
		parsedLevel = [[ImageTextDescriptionLevel alloc] init];
	}	
	return self;
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
	
    if ([elementName isEqualToString:kDataElementName]) {
		ImageTextDescriptionLevelData *theItem = [[ImageTextDescriptionLevelData alloc] init];
		self.parsedItem = theItem;
		[theItem release];
	} else if ([elementName isEqualToString:kNextLevelElementName] ||
			   [elementName isEqualToString:kPrevLevelElementName]) {
		NextLevel* theNextLevel = [[NextLevel alloc] init];
		self.currNextLevel = theNextLevel;
		[theNextLevel release];
	} else {
        // For the 'title', 'updated', or 'georss:point' element begin accumulating parsed character data.
        // The contents are collected in parser:foundCharacters:
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
	
	if ([elementName isEqualToString:kDataElementName]) {
		[self.parsedLevel addItem:self.parsedItem];
	}else if ([elementName isEqualToString:kDataIdElementName]) {
		self.parsedItem.dataId = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kHeaderImageFileElementName]) {
		self.parsedItem.headerImageFile = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kHeaderTextElementName]) {
		self.parsedItem.headerText = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kImageFileElementName]) {
		CachedImage* cachedImage = [[CachedImage alloc] initWithFileName:self.currentParsedCharacterData]; 
		((ImageTextDescriptionLevelData*)self.parsedItem).image = cachedImage;
		[cachedImage release];
	}else if ([elementName isEqualToString:kGeoRefElementName]) {
		((ImageTextDescriptionLevelData*)self.parsedItem).geoReferencia = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kTextElementName]) {
		((ImageTextDescriptionLevelData*)self.parsedItem).text = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kBarTextElementName]) {
		((ImageTextDescriptionLevelData*)self.parsedItem).barText = self.currentParsedCharacterData;		
	} else if ([elementName isEqualToString:kNLLeveNumberElementName]) {
		self.currNextLevel.levelNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLLeveIdElementName]) {
		self.currNextLevel.levelId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNLDataNumberElementName]) {
		self.currNextLevel.dataNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLDataIdElementName]) {
		self.currNextLevel.dataId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		((ImageTextDescriptionLevelData*)self.parsedItem).nextLevel = self.currNextLevel;
	} else if ([elementName isEqualToString:kPrevLevelElementName]) {
		((ImageTextDescriptionLevelData*)self.parsedItem).prevLevel = self.currNextLevel;
	}
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;	
}


@end