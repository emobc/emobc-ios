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
#import "SmartAdServerView.h"
#import "NwControllerDelegate.h"
#import "NwMultiMediaView.h"
#import "NextLevel.h"
#import "GADBannerView.h"
#import "AppStyles.h"
#import "ApplicationData.h"

@class eMobcViewController;
@class NwMultiMediaView;

@interface NwController : UIViewController<SmartAdServerViewDelegate,NwControllerDelegate>{

	
//Objetos
	NwMultiMediaView* mmView;
	NSString *geoRefString;
	eMobcViewController* mainController;

//Publicity
	GADBannerView * admobBanner_; //admob
	SmartAdServerView *yocBanner_; //yoc	

//Outlets
	IBOutlet UILabel* titleLabel;
	IBOutlet UILabel* titleLabelLandscape;
	IBOutlet UIView* landscapeView;
	IBOutlet UIView* portraitView;
	
	UIImageView *backgroundMenu;
	
	/*
	 NavBar Buttons
	 */
	IBOutlet UIButton* backButton;
	IBOutlet UIButton* homeButton;

	
	//UIActivityIndicatorView *indicator;
	UIView* indicator;
	UIView* menuView;
	
	ApplicationData* theMenu;
	
	
}

@property(nonatomic, retain) IBOutlet UIView* landscapeView;
@property(nonatomic, retain) IBOutlet UIView* portraitView;

@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* titleLabelLandscape;

@property(nonatomic, retain) IBOutlet UIButton* backButton;
@property(nonatomic, retain) IBOutlet UIButton* homeButton;

@property(nonatomic, retain) eMobcViewController* mainController;
@property(nonatomic, retain) NSString* geoRefString;

//Publicity
@property(nonatomic, retain) SmartAdServerView *yocBanner_;
@property(nonatomic, retain) GADBannerView *admobBanner_;

@property(nonatomic, retain) UIImageView *backgroundMenu;

//Acctions
	-(void) backButtonPress:(id)sender;
	-(void) homeButtonPress:(id)sender;

//Methods
	-(void) startSpinner;
	-(void) removeSpinner;

// Two methods to create the ad objects and display them
	-(void) createIndicator;


//Publicity
	-(void) createAdmobBanner;
	-(void) createYocBanner;
//---

	-(void) mostrarMenuMultimedia;
	-(void) callTopMenu;
	-(void) callBottomMenu;
	-(void) loadBackgroundMenu;

@end
