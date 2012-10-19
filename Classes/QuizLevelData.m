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

#import "QuizLevelData.h"


@implementation QuizLevelData

@synthesize questionsMap;
@synthesize description;
@synthesize time;
@synthesize first;
@synthesize question;

-(void) dealloc{
	[description release];
	[time release];
	[first release];
	[question release];
	[questionsMap release];
	
	[super dealloc];
}

-(id) init {
	if (self = [super init]) {   
		question = [[[NSMutableArray array] init] retain];
		questionsMap = [[[NSMutableDictionary dictionary] init] retain];
	}
	return self;
}

/**
 * Add a new style intro styles list
 * Even more add it into a styles map
 */
-(void) addQuestion:(AppQuestion*) newQuestion{

	[question addObject:newQuestion];
	if(newQuestion.idQ != nil){
		[questionsMap setObject:newQuestion forKey:newQuestion.idQ];
	}
}

@end



