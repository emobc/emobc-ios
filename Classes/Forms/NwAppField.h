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

typedef enum FieldType {
	INPUT_TEXT,
	INPUT_TEXTVIEW,
	INPUT_NUMBER,
	INPUT_EMAIL,
	INPUT_PHONE,
	INPUT_CHECK,
	INPUT_PICKER,
	INPUT_PASSWORD,
	INPUT_IMAGE
}FieldType;

@interface NwAppField : NSObject {
	NSString *labelText;
	NSString *fieldName;	
	FieldType type;
	bool required;
	
	NSMutableArray* parameters;
}

@property(nonatomic, copy) NSString *labelText;
@property(nonatomic, copy) NSString *fieldName;
@property(nonatomic, assign) FieldType type;
@property(nonatomic, assign) bool required;

@property(nonatomic, copy) NSMutableArray* parameters;

- (void) addParameter:(NSString*) parameter;
- (NSUInteger)countParameters;
- (NSString*) getParameterByNumber:(int) paramNumber;

@end
