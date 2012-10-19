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
#import "WebLevelData.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"
#import "NwController.h"

@interface NwWebController : NwController<UIWebViewDelegate> {	

//Objetos
	WebLevelData* data;
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
	
//Outlets
	IBOutlet UIWebView* webView;
	IBOutlet UIWebView* webViewLandscape;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
}

@property(nonatomic, retain) WebLevelData* data;
@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;
@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, retain) IBOutlet UIWebView* webViewLandscape;

//Metodos
	-(void)embedWeb:(NSString*)url frame:(CGRect)frame;
	-(void)embedHTML:(NSString*)url frame:(CGRect)frame;

	-(void) loadThemesComponents;
	-(void) loadThemes;

	-(void) orientationChangedMethod;
	-(void) orientationChanged:(NSNotification *)object;

@end
