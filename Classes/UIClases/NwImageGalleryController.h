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
#import "ImageGalleryLevel.h"
#import "NwButton.h"
#import "NwController.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"

/**
 * CLASS SUMMARY
 * NwImageGalleryController is gallery viewController so It is going to handle image gallery
 * It's going to administer all images and to show it in the view
 *
 * @note ImageGalleryController need data to work, this dates is taken from image_galley.xml and then saves into data.
 */

@interface NwImageGalleryController : NwController <UIScrollViewDelegate> {	

//Variables
	int view1Index;
	int view2Index;
	
//Objetos
	ImageGalleryLevelData* data;
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
	NSArray *imageSet;
	NwButton* view1;
	NwButton* view2;
	
//Outlets
	UIScrollView* scroll;
	IBOutlet UILabel* labelImageCount;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
}

@property(nonatomic, retain) ImageGalleryLevelData* data;
@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;
@property(nonatomic, retain) IBOutlet UIScrollView* scroll;
@property(nonatomic, retain) IBOutlet UILabel* labelImageCount;


//Metodos
	-(void) setImages:(NSArray *) images;
	-(void)	update;
	-(void) loadsView;
	-(void) propiedadesScroll;
	-(void) loadThemesComponents;
	-(void) loadThemes;

@end

