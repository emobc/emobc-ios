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
#import "ImageZoomLevelData.h"
#import "NwController.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"

/**
 * CLASS SUMMARY
 * NwImageZoomController is image+Zoom viewController so It is going to handle the HD image View
 * this view allows user to show a HD photo and also allows move photo to see the whole view
 *
 * @note NwImageZoomController need data to work, this dates is taken from zomm_iamge.xml and then saves into data.
 */

@interface NwImageZoomController : NwController <UIScrollViewDelegate> {
	
//Objetos
	ImageZoomLevelData* data;
	
//Outlets
	UIImageView* imageView;
	UIImageView* imageViewLandscape;
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIScrollView* scrollViewLandscape;
	
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
	
}
 
@property(nonatomic, retain) ImageZoomLevelData* data;

@property(nonatomic,retain) UIImageView* imageView;
@property(nonatomic,retain) UIImageView* imageViewLandscape;
@property(nonatomic,retain) UIScrollView* scrollView;
@property(nonatomic,retain) UIScrollView* scrollViewLandscape;

@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;

//Metodos

	-(void) loadPhoto;
	-(void)	loadThemesComponents;
	-(void) loadThemes;

@end
