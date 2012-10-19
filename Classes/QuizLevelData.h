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

#import <Foundation/Foundation.h>
#import "DataItem.h"
#import "AppQuestion.h"

/**
 * CLASS SUMMARY
 * QuizLevelData saves all necesary dates to define pdf view
 * QuizLevelData has all dates which are going to be saves by PdfParser
 */

@interface QuizLevelData : DataItem {
	NSString *description;
	NSString *time;
	NSString *first;
	
	NSMutableArray *question;
	NSMutableDictionary *questionsMap;
}

@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *first;
@property (nonatomic, retain) NSMutableArray *question;
@property (nonatomic, retain) NSMutableDictionary *questionsMap;

-(void) addQuestion:(AppQuestion*) newQuestion;

@end