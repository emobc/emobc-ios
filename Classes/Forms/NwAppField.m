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

#import "NwAppField.h"


@implementation NwAppField

@synthesize type;
@synthesize labelText;
@synthesize fieldName;
@synthesize required;
@synthesize parameters;

-(id) init {
	if (self = [super init]) {
		labelText = nil;
		fieldName = nil;
		required = FALSE;
		parameters = [[[NSMutableArray array] init] retain];
		
	}	
	return self;
}

-(void) dealloc{
	[parameters release];
	[super dealloc];
}

- (void) addParameter:(NSString*) parameter{
	[parameters addObject:[parameter copy]];	
}

-(NSString*) getParameterByNumber:(int) paramNumber{
	return [parameters objectAtIndex:paramNumber];
}

- (NSUInteger)countParameters{
	return [parameters count]; 
}

@end
