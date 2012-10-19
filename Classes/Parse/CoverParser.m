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

#import "CoverParser.h"


@implementation CoverParser

static NSString * const kLevelElementName = @"level";
static NSString * const kTitleElementName = @"title";
static NSString * const kBackgoundImageElementName = @"backgroundFileName";
static NSString * const kTitleFileNameElementName = @"titleFileName";
static NSString * const kFacebookElementName = @"facebook";
static NSString * const kTwitterElementName = @"twitter";
static NSString * const kWwwElementName = @"www";

static NSString * const kButtonsElementName = @"buttons";
static NSString * const kButtonElementName = @"button";
static NSString * const kButtonTitleElementName = @"buttonTitle";
static NSString * const kButtonFileElementName = @"buttonFileName";

static NSString * const kNextLevelElementName = @"nextLevel";
static NSString * const kNLLeveNumberElementName = @"nextLevelLevel";
static NSString * const kNLLeveIdElementName = @"nextLevelLevelId";
static NSString * const kNLDataNumberElementName = @"nextLevelDataNumber";
static NSString * const kNLDataIdElementName = @"nextLevelDataId";

@synthesize cover;
@synthesize currentButton;
@synthesize currentNextLevel;


-(id) init {
	if (self = [super init]) {    
	}	
	return self;
}

- (void)dealloc {
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
	
    if ([elementName isEqualToString:kLevelElementName]) {
        Cover *theCover = [[Cover alloc] init];
        self.cover = theCover;
		[theCover release];
	} else if ([elementName isEqualToString:kButtonElementName]) {
		AppButton* theButton = [[AppButton alloc] init];
		self.currentButton = theButton;
		[theButton release];		
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		NextLevel* theNextLevel = [[NextLevel alloc] init];
		self.currentNextLevel = theNextLevel;
		[theNextLevel release];
	} else if ([elementName isEqualToString:kTitleElementName] ||
               [elementName isEqualToString:kBackgoundImageElementName] ||
               [elementName isEqualToString:kTitleFileNameElementName]||
               [elementName isEqualToString:kFacebookElementName] ||
               [elementName isEqualToString:kTwitterElementName]||
               [elementName isEqualToString:kWwwElementName] ||
               [elementName isEqualToString:kButtonTitleElementName] ||
               [elementName isEqualToString:kButtonFileElementName] ||
               [elementName isEqualToString:kNLLeveNumberElementName] ||
               [elementName isEqualToString:kNLLeveIdElementName] ||
               [elementName isEqualToString:kNLDataNumberElementName] ||
               [elementName isEqualToString:kNLDataIdElementName]) {
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
	
    if ([elementName isEqualToString:kTitleElementName]) {
		self.cover.title = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kBackgoundImageElementName]) {
		self.cover.backgroundFileName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kTitleFileNameElementName]) {
		self.cover.titleFileName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kFacebookElementName]) {
		self.cover.facebook = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kTwitterElementName]) {
		self.cover.twitter = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kWwwElementName]) {
		self.cover.www = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kButtonElementName]) {
		[self.cover addButton:self.currentButton];
	} else if ([elementName isEqualToString:kButtonTitleElementName]) {
		self.currentButton.title = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kButtonFileElementName]) {
		self.currentButton.fileName = self.currentParsedCharacterData;	
	} else if ([elementName isEqualToString:kNLLeveNumberElementName]) {
		self.currentNextLevel.levelNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLLeveIdElementName]) {
		self.currentNextLevel.levelId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNLDataNumberElementName]) {
		self.currentNextLevel.dataNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLDataIdElementName]) {
		self.currentNextLevel.dataId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		self.currentButton.nextLevel = currentNextLevel;
	}
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;	
}

@end