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

#import "FormatsParser.h"

@implementation FormatsParser

static NSString * const kApplicationElementName = @"application";
static NSString * const kFormatsElementName = @"formats";
static NSString * const kFormatElementName = @"format";

static NSString * const kNameElementName = @"name";
static NSString * const kTextColorElementName = @"textColor";
static NSString * const kTextSizeElementName = @"textSize";
static NSString * const kTextStyleElementName = @"textStyle";
static NSString * const kTypeFaceElementName = @"typeFace";
static NSString * const kCacheColorHintElementName = @"cacheColorHint";
static NSString * const kBackgroundSelectionFileNameElementName = @"backgroundSelectionFileName";

static NSString * const kNextLevelElementName = @"nextLevel";
static NSString * const kNLLeveNumberElementName = @"nextLevelLevel";
static NSString * const kNLLeveIdElementName = @"nextLevelLevelId";
static NSString * const kNLDataNumberElementName = @"nextLevelDataNumber";
static NSString * const kNLDataIdElementName = @"nextLevelDataId";


@synthesize format;
@synthesize currentFormat;

@synthesize currentButton;
@synthesize currentNextLevel;


-(id) init {
	if (self = [super init]) {    
	}	
	return self;
}

- (void)dealloc {
	[currentFormat release];
	[currentButton release];
	[currentNextLevel release];
	
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
        FormatsStylesLevelData *theFormat = [[FormatsStylesLevelData alloc] init];
		self.format = theFormat;
		[theFormat release];
	} else if ([elementName isEqualToString:kFormatElementName]) {
		AppFormatsStyles* theFormat = [[AppFormatsStyles alloc] init];
		self.currentFormat = theFormat;
		[theFormat release];
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		NextLevel* theNextLevel = [[NextLevel alloc] init];
		self.currentNextLevel = theNextLevel;
		[theNextLevel release];
	} else if ([elementName isEqualToString:kNameElementName]||
               [elementName isEqualToString:kTextColorElementName] ||
			   [elementName isEqualToString:kTextSizeElementName] ||
               [elementName isEqualToString:kTextStyleElementName]||
               [elementName isEqualToString:kTypeFaceElementName] ||
               [elementName isEqualToString:kCacheColorHintElementName] ||
               [elementName isEqualToString:kBackgroundSelectionFileNameElementName] ||
			   [elementName isEqualToString:kNLLeveNumberElementName] ||
			   [elementName isEqualToString:kNLLeveIdElementName] ||
			   [elementName isEqualToString:kNLDataNumberElementName] ||
			   [elementName isEqualToString:kNLDataIdElementName]){
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

    if([elementName isEqualToString:kFormatElementName]){
		[self.format addFormatsStyles:self.currentFormat];
	}else if([elementName isEqualToString:kNameElementName]){
		self.currentFormat.name = self.currentParsedCharacterData;
	}else if([elementName isEqualToString:kTextColorElementName]){
		self.currentFormat.textColor = self.currentParsedCharacterData;
	}else if([elementName isEqualToString:kTextSizeElementName]){
		self.currentFormat.textSize = self.currentParsedCharacterData;
	}else if([elementName isEqualToString:kTextStyleElementName]){
		self.currentFormat.textStyle = self.currentParsedCharacterData;
	}else if([elementName isEqualToString:kTypeFaceElementName]){
		self.currentFormat.typeFace = self.currentParsedCharacterData;
	}else if([elementName isEqualToString:kCacheColorHintElementName]){
		self.currentFormat.cacheColorHint = self.currentParsedCharacterData;
	}else if([elementName isEqualToString:kBackgroundSelectionFileNameElementName]){
		self.currentFormat.backgroundSelectionFileName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNLLeveNumberElementName]) {
		self.currentNextLevel.levelNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLLeveIdElementName]) {
		self.currentNextLevel.levelId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNLDataNumberElementName]) {
		self.currentNextLevel.dataNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLDataIdElementName]) {
		self.currentNextLevel.dataId = self.currentParsedCharacterData;
	}else if ([elementName isEqualToString:kNextLevelElementName]) {
		self.currentFormat.nextLevel = currentNextLevel;
	}
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;	
}

@end
