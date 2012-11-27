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
#import "eMobcViewController.h"
#import "NwController.h"
#import "OverlayViewController.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"

/**
 * CLASS SUMMARY
 * NwSearchController is search viewController so It is going to handle search view
 *
 * @note searchController is a little special because unlike nearly all our controllers doesn't have a data
 * so where are necesary dates to work? goals searchController is look for all images, georeferences and text contained in framework
 *
 * @see OverlayViewController  
 */

@interface NwSearchController : NwController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
	
//Objetos
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	OverlayViewController *ovController;

//Outlets
	UISearchBar *searchBar;
	UITableView *tableView;
	
	BOOL searching;
	BOOL letUserSelectRow;
	bool loadContent;
	
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;	
	
	UIDeviceOrientation currentOrientation;
	
	NSInteger sizeTop;
	NSInteger sizeBottom;
	NSInteger sizeHeaderText;
}

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) UISearchBar *searchBar;

@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;

@property (nonatomic) NSInteger sizeTop;
@property (nonatomic) NSInteger sizeBottom;
@property (nonatomic) NSInteger sizeHeaderText;

//Metodos
	-(void) searchTableView;
	-(void) doneSearching_Clicked:(id)sender;

	-(void) orientationChangedMethod;
	-(void) orientationChanged:(NSNotification *)object;

	-(void) loadThemesComponents;
	-(void) loadThemes;

	-(void) createSearchBar;
	-(void) createTableView;
	-(void) loadSize;

@end