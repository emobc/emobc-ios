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

#import "QuizParser.h"


@implementation QuizParser

static NSString * const kDataElementName = @"data";
static NSString * const kDataIdElementName = @"dataId";
static NSString * const kHeaderImageFileElementName = @"headerImageFile";
static NSString * const kHeaderTextElementName = @"headerText";
static NSString * const kDescriptionElementName = @"description";
static NSString * const kTimeElementName = @"time";
static NSString * const kFirstElementName = @"first";

static NSString * const kQuestionsElementName = @"questions";
static NSString * const kQuestionElementName = @"question";
static NSString * const kIdQElementName = @"idQ";
static NSString * const kImageFileElementName = @"imageFile";
static NSString * const kTextElementName = @"text";
static NSString * const kWeightElementName = @"weight";

static NSString * const kAnswersElementName = @"answers";
static NSString * const kAnswerElementName = @"answer";
static NSString * const kAnswerTextElementName = @"answerText";
static NSString * const kCorrectTextElementName = @"correct";
static NSString * const kNextElementName = @"next";


@synthesize currentQuestion;
@synthesize currentAnswer;
@synthesize currentNextLevel;

-(id) init {

	if (self = [super init]) {    
		parsedLevel = [[QuizLevel alloc] init];
	}	
	return self;
}


- (void)dealloc {
    [parsedLevel release];
	parsedLevel = nil;
	
	[currentAnswer release];
	[currentQuestion release];
	
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
	
	if([elementName isEqualToString:kDataElementName]){
		QuizLevelData *theItem = [[QuizLevelData alloc] init];
		self.parsedItem = theItem;
		[theItem release];
	} else if([elementName isEqualToString:kQuestionElementName]){
		AppQuestion* theQuestion = [[AppQuestion alloc] init];
		self.currentQuestion = theQuestion;
		[theQuestion release];
	} else if([elementName isEqualToString:kAnswerElementName]){
		AppAnswer* theAnswer = [[AppAnswer alloc] init];
		self.currentAnswer = theAnswer;
		[theAnswer release];
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
	
	if([elementName isEqualToString:kDataElementName]){
		[self.parsedLevel addItem:self.parsedItem];
	} else if ([elementName isEqualToString:kDataIdElementName]){
		self.parsedItem.dataId = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kHeaderImageFileElementName]){
		self.parsedItem.headerImageFile = self.currentParsedCharacterData;			
	} else if ([elementName isEqualToString:kHeaderTextElementName]){
		self.parsedItem.headerText = self.currentParsedCharacterData;	
	} else if ([elementName isEqualToString:kDescriptionElementName]){
		((QuizLevelData*)self.parsedItem).description = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kTimeElementName]){
		((QuizLevelData*)self.parsedItem).time = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kFirstElementName]){
		((QuizLevelData*)self.parsedItem).first = self.currentParsedCharacterData;
	} else if ([elementName isEqualToString:kQuestionElementName]){
		[((QuizLevelData*)self.parsedItem) addQuestion:self.currentQuestion];		
	} else if ([elementName isEqualToString:kIdQElementName]){
		self.currentQuestion.idQ = self.currentParsedCharacterData;	
	} else if ([elementName isEqualToString:kImageFileElementName]){
		self.currentQuestion.imageFile = self.currentParsedCharacterData;		
	} else if ([elementName isEqualToString:kTextElementName]){
		self.currentQuestion.text = self.currentParsedCharacterData;		
	} else if ([elementName isEqualToString:kWeightElementName]){
		self.currentQuestion.weight = self.currentParsedCharacterData;		
	} else if ([elementName isEqualToString:kAnswerElementName]){
		[((AppQuestion*)self.currentQuestion) addAnswer:self.currentAnswer];		
	} else if ([elementName isEqualToString:kAnswerTextElementName]){
		self.currentAnswer.answerText = self.currentParsedCharacterData;		
	} else if ([elementName isEqualToString:kCorrectTextElementName]){
		self.currentAnswer.correct = self.currentParsedCharacterData;		
	} else if([elementName isEqualToString:kNextElementName]){
		self.currentAnswer.next = self.currentParsedCharacterData;		
	}
	
    // Stop accumulating parsed character data. We won't start again until specific elements begin.
    accumulatingParsedCharacterData = NO;	
}

@end