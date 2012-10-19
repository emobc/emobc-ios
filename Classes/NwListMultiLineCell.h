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
#import "AppStyles.h"
#import "AppFormatsStyles.h"
#import "StylesLevelData.h"
#import "FormatsStylesLevelData.h"


@interface NwListMultiLineCell : UITableViewCell {
	
//Outlets	
	IBOutlet UIImageView *listImageView; 
	IBOutlet UIImageView *listNextImageView; 
	IBOutlet UILabel *listLabel;
	IBOutlet UILabel *descrLabel;
	
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	
	StylesLevelData* theStyle;
	FormatsStylesLevelData* theFormat;
}

@property (nonatomic, retain) IBOutlet UIImageView *listNextImageView; 
@property (nonatomic, retain) IBOutlet UIImageView *listImageView; 
@property (nonatomic, retain) IBOutlet UILabel *listLabel;
@property (nonatomic, retain) IBOutlet UILabel *descrLabel;

@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;

@property(nonatomic, retain) StylesLevelData* theStyle; 
@property(nonatomic, retain) FormatsStylesLevelData* theFormat;

-(void) loadThemesComponents;
-(void) loadThemes;

@end
