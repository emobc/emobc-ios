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

#import <UIKit/UIKit.h>
#import "NextLevel.h"
#import "ImageListLevelData.h"
#import "NwController.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"

@interface NwImageListController : NwController {
	
//Objetos
	ImageListLevelData* data;
	NSMutableArray* contentArray;
	
//Outlets
	UITableView* imgListTableView;
	UITableView* imgListTableViewLandscape;
	UIImageView* imgListImageView;

	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
}

@property(nonatomic, retain) ImageListLevelData* data;

@property (nonatomic, retain) IBOutlet UITableView* imgListTableView;
@property (nonatomic, retain) IBOutlet UITableView* imgListTableViewLandscape;
@property (nonatomic, retain) UIImageView* imgListImageView;


@property (nonatomic, retain) AppStyles* varStyles;
@property (nonatomic, retain) AppFormatsStyles* varFormats;
@property (nonatomic, retain) UIImageView *background;

//Methods
	-(void) loadImageList;
	-(void) loadThemesComponents;
	-(void) loadThemes;

@end
