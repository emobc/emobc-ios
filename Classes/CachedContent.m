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

#import "CachedContent.h"
#import "NwCache.h"

@implementation CachedContent

@synthesize fileName;
@synthesize isLocal;
@synthesize isCached;
@synthesize neverCached;

- (id) initWithFileName:(NSString*) theFileName{
    if (self = [super init]) {
		fileName = [theFileName copy];
		
		if ([theFileName rangeOfString:@"http"].location == NSNotFound)	{
			isLocal = true;
		} else {
			isLocal = false;
		}		
		isCached = [[NwCache instance] isFileNamedCached:fileName];
		neverCached = false;
	}	
	return self;
}

- (id)init {
    if (self = [super init]) {
		fileName = nil;
		isLocal = false;
		isCached = false;
		neverCached = false;
	}	
	return self;	
}

-(void) dealloc{
	[fileName release];
	
	[super dealloc];
}

-(NSData*) content{
	NSData* cachedData = nil;
	if (isLocal)	{
		//NSLog(@"Ruta al Contenido Local: %@", fileName);
		cachedData = [NSData dataWithContentsOfFile:fileName];
		if (cachedData == nil) {
			NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
			//NSLog(@"Ruta al Contenido del Bundle: %@", bundlePath);
			cachedData = [NSData dataWithContentsOfFile:bundlePath];
			if (cachedData == nil) {
				//NSLog(@"Contenido NO ENCONTRADO: %@", fileName);
			}
		}
		
	} else {
		if (isCached) {
			NSString* cachedFileName = [[NwCache instance] cachedFileName:fileName];
			//NSLog(@"Reading cached content: %@", cachedFileName);
			cachedData = [[NwCache instance] cachedData:fileName];
		}else {
			if (!neverCached) {
				//NSLog(@"Caching data for file: %@", fileName);
				cachedData = [[NwCache instance] cachedData:fileName];
				if (cachedData != nil) {
					isCached = true;
				}				
			}else {
				//NSLog(@"Reading data for file: %@", fileName);
				cachedData = [[NwCache instance] readData:fileName];
			}

		}
	}
	return cachedData;
}

@end