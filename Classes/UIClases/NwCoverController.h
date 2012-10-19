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
#import "Cover.h"

/**
 * CLASS SUMMARY
 * NwCoverController is cover viewController so It is going to handle the cover
 *
 * @note NwCoverController need data to work, this dates is taken eMobcViewController instance 
 */

@class eMobcViewController;

@interface NwCoverController : UIViewController {
	
//Objetos
	NSString *facebookUrl;
	NSString *twitterUrl;
	NSString *wwwUrl;
	eMobcViewController* mainController;

//Outlets	
	UIImageView *coverBgImage;
	UIImageView *coverTitleImage;	
	UIImageView *background;
	UIButton *buttonFacebook;
	UIButton *buttonTwitter;
	UIView* indicator;
    UIView* animation;
	
	//Outlets
	IBOutlet UIView* landscapeView;
	IBOutlet UIView* portraitView;
	
	Cover* theCover;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
	
	
	//UIActivityIndicatorView *indicator;	
}

@property(nonatomic, retain) eMobcViewController* mainController;
@property(nonatomic, retain) UIImageView *coverBgImage;
@property(nonatomic, retain) UIImageView *coverTitleImage;
@property(nonatomic, retain) UIImageView *background;
@property(nonatomic, retain) UIButton *buttonFacebook;
@property(nonatomic, retain) UIButton *buttonTwitter;

@property(nonatomic, retain) IBOutlet UIView* landscapeView;
@property(nonatomic, retain) IBOutlet UIView* portraitView;

@property(nonatomic, retain) Cover* theCover;


//Acciones
	-(void) buttonsTwitterFacebook;
	-(void) buttonTwitterPress:(id)sender;
	-(void) buttonFacebookPress:(id)sender;

//Metodos
	-(void) buttonPressed: (id)sender;

	-(void) startSpinner;
	-(void) removeSpinner;

	-(void) startAnimation;
	-(void) stopAnimation;

	-(void) createAnimationCover;
	-(void) createIndicator;

	-(void) crearBotones;

@end