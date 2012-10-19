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

#import "BottomMenuParser.h"


@implementation BottomMenuParser

static NSString * const kLevelElementName = @"level";

static NSString * const kMenuActionsElementName = @"menuActions";
static NSString * const kActionElementName = @"action";
static NSString * const kActionTitleElementName = @"actionTitle";
static NSString * const kActionImageNameElementName = @"actionImageName";
static NSString * const kSystemActionElementName = @"systemAction";

static NSString * const kLeftMarginElementName = @"leftMargin";
static NSString * const kWidthButtonElementName = @"widthButton";
static NSString * const kHeightButtonElementName = @"heightButton";

static NSString * const kNextLevelElementName = @"nextLevel";
static NSString * const kNLLeveNumberElementName = @"nextLevelLevel";
static NSString * const kNLLeveIdElementName = @"nextLevelLevelId";
static NSString * const kNLDataNumberElementName = @"nextLevelDataNumber";
static NSString * const kNLDataIdElementName = @"nextLevelDataId";


@synthesize bottomMenu;
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
        BottomMenuData *theBottomMenu = [[BottomMenuData alloc] init];
        self.bottomMenu = theBottomMenu;
		[theBottomMenu release];
	} else if ([elementName isEqualToString:kActionElementName]) {
		AppButton* theButton = [[AppButton alloc] init];
		self.currentButton = theButton;
		[theButton release];		
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		NextLevel* theNextLevel = [[NextLevel alloc] init];
		self.currentNextLevel = theNextLevel;
		[theNextLevel release];
	} else if ([elementName isEqualToString:kActionTitleElementName] ||
               [elementName isEqualToString:kActionImageNameElementName] ||
               [elementName isEqualToString:kSystemActionElementName]||
			   [elementName isEqualToString:kLeftMarginElementName]||
			   [elementName isEqualToString:kWidthButtonElementName]||
			   [elementName isEqualToString:kHeightButtonElementName]||
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
	
	if ([elementName isEqualToString:kActionElementName]) {
		[self.bottomMenu addButton:self.currentButton];
	} else if ([elementName isEqualToString:kActionTitleElementName]) {
		self.currentButton.title = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kActionImageNameElementName]) {
		self.currentButton.imageName = self.currentParsedCharacterData;	
	} else if ([elementName isEqualToString:kSystemActionElementName]) {
		self.currentButton.systemAction = self.currentParsedCharacterData;			
	} else if ([elementName isEqualToString:kLeftMarginElementName]) {
		self.currentButton.leftMargin = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kWidthButtonElementName]) {
		self.currentButton.widthButton = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kHeightButtonElementName]) {
		self.currentButton.heightButton = [self.currentParsedCharacterData intValue];
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