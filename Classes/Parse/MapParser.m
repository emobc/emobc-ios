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

#import "MapParser.h"


@implementation MapParser

@synthesize currPositionItem;
@synthesize currNextLevel;

-(id) init {
	if (self = [super init]) {    
		parsedLevel = [[MapLevel alloc] init];
	}	
	return self;
}

- (void)dealloc {
	[parsedLevel release];
	parsedLevel = nil;
	
    [super dealloc];
}

static NSString * const kDataElementName = @"data";
static NSString * const kDataIdElementName = @"dataId";
static NSString * const kHeaderImageFileElementName = @"headerImageFile";
static NSString * const kHeaderTextElementName = @"headerText";

static NSString * const kPositionElementName = @"position";

static NSString * const kPositionTitleElementName = @"positionTitle";
static NSString * const kPositionAddressElementName = @"positionAddress";
static NSString * const kPositionLatElementName = @"positionLat";
static NSString * const kPositionLonElementName = @"positionLon";
static NSString * const kImageFileElementName = @"imageFile";
static NSString * const kIconFileElementName = @"iconFile";
static NSString * const kCurrPositionIconFileElementName = @"currentPositionIconFile";

static NSString * const kLocalizeMeElementName = @"localizeMe";
static NSString * const kShowAllElementName = @"showAll";

static NSString * const kNextLevelElementName = @"nextLevel";
static NSString * const kNLLeveNumberElementName = @"nextLevelLevel";
static NSString * const kNLLeveIdElementName = @"nextLevelLevelId";
static NSString * const kNLDataNumberElementName = @"nextLevelDataNumber";
static NSString * const kNLDataIdElementName = @"nextLevelDataId";


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
		MapLevelData *theItem = [[MapLevelData alloc] init];
		self.parsedItem = theItem;
		[theItem release];
	}else if ([elementName isEqualToString:kPositionElementName]) {
		MapItem* thePositionItem = [[MapItem alloc] init];
		self.currPositionItem = thePositionItem;
		[thePositionItem release];
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		NextLevel* theNextLevel = [[NextLevel alloc] init];
		self.currNextLevel = theNextLevel;
		[theNextLevel release];
	}else{
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
	
	if ([elementName isEqualToString:kDataElementName]) {
		[self.parsedLevel addItem:self.parsedItem];
	}else if ([elementName isEqualToString:kDataIdElementName]) {
		self.parsedItem.dataId = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kHeaderImageFileElementName]) {
		self.parsedItem.headerImageFile = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kHeaderTextElementName]) {
		self.parsedItem.headerText = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kLocalizeMeElementName]) {
		((MapLevelData*)self.parsedItem).localizeMe = [self.currentParsedCharacterData isEqualToString:@"true"];
	}else if ([elementName isEqualToString:kShowAllElementName]) {
		((MapLevelData*)self.parsedItem).showAllPositions = [self.currentParsedCharacterData isEqualToString:@"true"];
	}else if ([elementName isEqualToString:kHeaderImageFileElementName]) {
		self.parsedItem.headerImageFile = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kCurrPositionIconFileElementName]) {
		((MapLevelData*)self.parsedItem).currentPositionIconFileName = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kPositionElementName]) {
		[((MapLevelData*)self.parsedItem) addPosition:self.currPositionItem];
	}else if ([elementName isEqualToString:kPositionTitleElementName]) {
		self.currPositionItem.title = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kPositionAddressElementName]) {
		self.currPositionItem.address = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kPositionLatElementName]) {
		self.currPositionItem.lat = [self.currentParsedCharacterData doubleValue];
	}else if ([elementName isEqualToString:kPositionLonElementName]) {
		self.currPositionItem.lon = [self.currentParsedCharacterData doubleValue];
	}else if ([elementName isEqualToString:kImageFileElementName]) {
		CachedImage* cachedImage = [[CachedImage alloc] initWithFileName:self.currentParsedCharacterData]; 
		self.currPositionItem.image = cachedImage;
		[cachedImage release];
	}else if ([elementName isEqualToString:kIconFileElementName]) {
		CachedImage* cachedImage = [[CachedImage alloc] initWithFileName:self.currentParsedCharacterData]; 
		self.currPositionItem.icon = cachedImage;
		[cachedImage release];
	} else if ([elementName isEqualToString:kNLLeveNumberElementName]) {
		self.currNextLevel.levelNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLLeveIdElementName]) {
		self.currNextLevel.levelId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNLDataNumberElementName]) {
		self.currNextLevel.dataNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLDataIdElementName]) {
		self.currNextLevel.dataId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		self.currPositionItem.nextLevel = self.currNextLevel;
	}
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;	
}

@end