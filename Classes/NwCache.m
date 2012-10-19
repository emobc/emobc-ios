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

#import "NwCache.h"


@implementation NwCache

+ (id) instance{
	static NwCache* sharedSingleton;
	
	@synchronized(self){
		if (!sharedSingleton)
			sharedSingleton = [[NwCache alloc] init];
		return sharedSingleton;
	}
}

- (id)init {
    if (self = [super init]) {    
		// Init loca data
		cacheMap = [[[NSMutableDictionary dictionary] init] retain];
		nroDownload = 0;
	}	
	return self;
}

- (bool) isFileNamedCached:(NSString*)fileName{
	return ([self cachedFileName:fileName] != nil);
}

- (void) storeData:(NSData*)theData forFileName:(NSString*)theUrl{
	nroDownload++;
	NSString *cachedFileName = [NSString stringWithFormat:@"File%d.cached", nroDownload];
	// Guardamos el archivo en local
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:cachedFileName];
	//NSLog(@"Saving %@ to %@.", theUrl, path);
	[theData writeToFile:path atomically:YES];
	
	// Guardamos en el cache
	[cacheMap setObject:path forKey:theUrl];
	
}

-(NSData*)   cachedData:(NSString*)fileName{
	// Nos fijamos en el cache
	NSData* retData = nil; 
	if (![self isFileNamedCached:fileName]) {
		// Si no está, lo descargamos y lo agregamos al cache.
		retData = [self readData:fileName];

		[self storeData:retData forFileName:fileName];
	} else {
		// Si está leemos el archivo y lo devolvemos
		NSString* cachedFileName = [self cachedFileName:fileName];
		//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		//NSString *documentsDirectory = [paths objectAtIndex:0];
		//NSString *pathToCacheFile = [documentsDirectory stringByAppendingPathComponent:cachedFileName];
		retData = [NSData dataWithContentsOfFile:cachedFileName];
	}

	return retData;
}

- (NSData*) readData:(NSString*)fileName{
	NSData* retData = nil; 
		
	NSString *url = [fileName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	retData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	
	return retData;
}

-(NSString*) cachedFileName:(NSString*)fileName{
	return [cacheMap valueForKey:fileName];;
}

-(void) clear{
	//TODO Falta borrar los archivos del Sis de Archivos
	nroDownload = 0;
	[cacheMap removeAllObjects];
}

@end
