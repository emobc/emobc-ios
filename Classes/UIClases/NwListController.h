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
#import "NwController.h"
#import "ListLevelData.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"

/**
 * CLASS SUMMARY
 * NwListController is list viewController so It is going to handle list
 *
 * @note NwListController need data to work, this dates is taken from list.xml and then saves into data.
 */

@interface NwListController : NwController<UITableViewDelegate, UITableViewDataSource> {
	
//Objetos
	ListLevelData* data;
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
	NSMutableArray* contentArray;
	
//Objects need for asynchronous image charge
	
	NSMutableArray *pathList;
	NSMutableDictionary* imageMap;	//diccionary -> key: item.text  value:image
	NSMutableArray *imageToShow;	// Contains all images ready to be showen. Its behavior is like a queue
	
//Outlets
	IBOutlet UITableView* listTableView;
	IBOutlet UIImageView *listImageView; 
	IBOutlet UIImageView *listNextImageView; 
	IBOutlet UILabel *listLabel;
	IBOutlet UILabel *descrLabel;	
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
}

@property (nonatomic, retain) ListLevelData* data;

@property (nonatomic, retain) IBOutlet UITableView* listTableView;
@property (nonatomic, retain) IBOutlet UIImageView *listNextImageView; 
@property (nonatomic, retain) IBOutlet UIImageView *listImageView; 
@property (nonatomic, retain) IBOutlet UILabel *listLabel;
@property (nonatomic, retain) IBOutlet UILabel *descrLabel;

@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;

//Asynchronous image charge
@property (nonatomic, retain) NSMutableDictionary *imageMap;
@property (nonatomic, retain) NSMutableArray *pathList;
@property (nonatomic, retain) NSMutableArray *imageToShow;


//Metodos
	-(void) saveScrollPosition;
	-(void) restoreScrollPosition;

//Medotos para la carga asíncrona de imagenes
	/*-(void) loadImage:(UITableViewCell *)cell;
	 -(UITableViewCell *) displayImage:(UITableViewCell *)cell;*/
	-(void) loadImage:(ListItem *)theItem;
	-(UITableViewCell *) displayImage:(UITableView *)tableView;

	-(void) loadThemesComponents;
	-(void) loadThemes;

	-(void) orientationChangedMethod;
	-(void) orientationChanged:(NSNotification *)object;

@end
