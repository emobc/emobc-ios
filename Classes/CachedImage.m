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

#import "CachedImage.h"
#import "NwCache.h"

@implementation CachedImage

- (id)init {
    if (self = [super init]) {
		image = nil;
	}	
	return self;
	
}

-(void) dealloc{
	[image release];
	image = nil;
	
	[super dealloc];
}

-(UIImage*) imageContent{
	if (image == nil) {
		if (isLocal)	{
			//NSLog(@"Ruta a Imagen Local: %@", fileName);
			image = [UIImage imageNamed:fileName];
			if (image == nil) {
				NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
				//NSLog(@"Ruta a Imagen Bundle: %@", imagePath);
				image = [UIImage imageWithContentsOfFile:imagePath];
				if (image == nil) {
					//NSLog(@"Imagen NO ENCONTRADA: %@", fileName);
				}
			}
		} else {
			NSData* cachedData = nil;
			if (isCached) {
				//NSString* cachedFileName = [[NwCache instance] cachedFileName:fileName];
				//NSLog(@"Reading cached content: %@", cachedFileName);
				cachedData = [[NwCache instance] cachedData:fileName];
			}else {
				//NSLog(@"Caching data for file: %@", fileName);
				cachedData = [[NwCache instance] cachedData:fileName];
				if (cachedData != nil) {
					isCached = true;
				}
			}
			if (cachedData != nil) {
				image = [[UIImage imageWithData:cachedData] retain];
			}
		}
	}
	return image;
}

@end
