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

/**
 * CLASS SUMMARY
 * DataItem has main data from any xml
 * All parsers have a DataItem object and save these datas into this object
 */

@interface DataItem : NSObject {
@protected
	//Datos principales de un xml
	NSString *dataId;
	NSString *headerImageFile;
	NSString *headerText;
	NSString *geoReferencia;	
}

@property(nonatomic, copy) NSString *dataId;
@property(nonatomic, copy) NSString *headerImageFile;
@property(nonatomic, copy) NSString *headerText;
@property(nonatomic, copy) NSString *geoReferencia;

//Methods
	-(NSMutableArray*) findAllImages;

@end
