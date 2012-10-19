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
#import "ProfileParser.h"

@implementation ProfileParser

static NSString * const kProfileElementName = @"profile";

static NSString * const kFieldElementName = @"field";
static NSString * const kFieldTypeElementName = @"fieldType";
static NSString * const kFieldRequiredElementName = @"required";
static NSString * const kFieldLabelElementName = @"fieldLabel";
static NSString * const kFieldNameElementName = @"fieldName";
static NSString * const kFieldParamElementName = @"fieldParam";

static NSString * const kNextLevelElementName = @"nextLevel";
static NSString * const kNLLeveNumberElementName = @"nextLevelLevel";
static NSString * const kNLLeveIdElementName = @"nextLevelLevelId";
static NSString * const kNLDataNumberElementName = @"nextLevelDataNumber";
static NSString * const kNLDataIdElementName = @"nextLevelDataId";

static NSString * const kFieldTypeInputText = @"INPUT_TEXT";
static NSString * const kFieldTypeInputTextView = @"INPUT_TEXTVIEW";
static NSString * const kFieldTypeInputNumber = @"INPUT_NUMBER";
static NSString * const kFieldTypeInputEmail = @"INPUT_EMAIL";
static NSString * const kFieldTypeInputPhone = @"INPUT_PHONE";
static NSString * const kFieldTypeInputCheck = @"INPUT_CHECK";
static NSString * const kFieldTypeInputPicker = @"INPUT_PICKER";
static NSString * const kFieldTypeInputPassword = @"INPUT_PASSWORD";
static NSString * const kFieldTypeInputImage = @"INPUT_IMAGE";

@synthesize currField;
@synthesize currentNextLevel;
@synthesize profile;


-(id) init {
	if (self = [super init]) { 
	}	
	return self;
}

- (void)dealloc {
	[currField release];
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
	
	if ([elementName isEqualToString:kProfileElementName]) {
		ProfileLevelData *theProfile = [[ProfileLevelData alloc] init];
		self.profile = theProfile;
		[theProfile release];
	} else if ([elementName isEqualToString:kFieldElementName]) {
		NwAppField* theField = [[NwAppField alloc] init];
		self.currField = theField;
		[theField release];
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		NextLevel* theNextLevel = [[NextLevel alloc] init];
		self.currentNextLevel = theNextLevel;
		[theNextLevel release];
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
- (void)parser:(AQXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     

	if ([elementName isEqualToString:kFieldElementName]) {
		[self.profile addField:self.currField];
	}else if ([elementName isEqualToString:kFieldTypeElementName]) {
		if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputText]) {
			self.currField.type = INPUT_TEXT;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputTextView]) {
			self.currField.type = INPUT_TEXTVIEW;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputNumber]) {
			self.currField.type = INPUT_NUMBER;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputEmail]) {
			self.currField.type = INPUT_EMAIL;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputPhone]) {
			self.currField.type = INPUT_PHONE;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputCheck]) {
			self.currField.type = INPUT_CHECK;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputPicker]) {
			self.currField.type = INPUT_PICKER;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputPassword]) {
			self.currField.type = INPUT_PASSWORD;
		}else if ([self.currentParsedCharacterData isEqualToString:kFieldTypeInputImage]) {
			self.currField.type = INPUT_IMAGE;
		}
	} else if ([elementName isEqualToString:kFieldRequiredElementName]) {
		self.currField.required = TRUE;
	} else if ([elementName isEqualToString:kFieldParamElementName]) {
		[self.currField addParameter:self.currentParsedCharacterData];
	} else if ([elementName isEqualToString:kFieldLabelElementName]) {
		self.currField.labelText = self.currentParsedCharacterData; 
	}else if ([elementName isEqualToString:kFieldNameElementName]) {
		self.currField.fieldName = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNLLeveNumberElementName]) {
		self.currentNextLevel.levelNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLLeveIdElementName]) {
		self.currentNextLevel.levelId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNLDataNumberElementName]) {
		self.currentNextLevel.dataNumber = [self.currentParsedCharacterData intValue];
	} else if ([elementName isEqualToString:kNLDataIdElementName]) {
		self.currentNextLevel.dataId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kNextLevelElementName]) {
		self.profile.nextLevel = currentNextLevel;
	}
	// Stop accumulating parsed character data. We won't start again until specific elements begin.
	accumulatingParsedCharacterData = NO;
}

- (void)parser:(AQXMLParser *)parser foundCharacters:(NSString *)string{
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.currentParsedCharacterData appendString:string];
    }	
}

@end