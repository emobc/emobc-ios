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

#import "VideoParser.h"


@implementation VideoParser

- (void)dealloc {
	[parsedLevel release];
	parsedLevel = nil;
	
    [super dealloc];
}

-(id) init {
	if (self = [super init]) {    
		parsedLevel = [[VideoLevel alloc] init];
	}	
	return self;
}

static NSString * const kDataElementName = @"data";
static NSString * const kDataIdElementName = @"dataId";
static NSString * const kHeaderImageFileElementName = @"headerImageFile";
static NSString * const kHeaderTextElementName = @"headerText";
static NSString * const kVideoURLElementName = @"videoUrl";
static NSString * const kLocalElementName = @"local";


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
		VideoLevelData *theItem = [[VideoLevelData alloc] init];
		self.parsedItem = theItem;
		[theItem release];
	} else {
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
-(void)parser:(AQXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	
	if ([elementName isEqualToString:kDataElementName]) {
		[self.parsedLevel addItem:self.parsedItem];
	}else if ([elementName isEqualToString:kDataIdElementName]) {
		self.parsedItem.dataId = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kHeaderImageFileElementName]) {
		self.parsedItem.headerImageFile = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kHeaderTextElementName]) {
		self.parsedItem.headerText = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kVideoURLElementName]) {
		((VideoLevelData*)self.parsedItem).videoUrl = self.currentParsedCharacterData;		
	}else if ([elementName isEqualToString:kLocalElementName]) {
		((VideoLevelData*)self.parsedItem).local = [self.currentParsedCharacterData isEqualToString:@"true"];
	}
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;	
}

@end