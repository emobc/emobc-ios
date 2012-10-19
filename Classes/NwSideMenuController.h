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
#import "NextLevel.h"

/**
 * CLASS SUMMARY
 * NwSideMenuController is menu viewController so It is going to handle menus
 * It's going to add menu when it's needed
 *
 * @note SideMenuController need data to work but It doesn't have a data declared, insted of this it has a eMobcViewController instace
 * thanks to that it's going to take the data which it needs to work
 */

@class eMobcViewController;

@interface NwSideMenuController : UIViewController {

//Objetos
	eMobcViewController* mainController;
	
//Outlets
	IBOutlet UIView* landscapeView;
	IBOutlet UIView* portraitView;
	
}

@property(nonatomic, retain) IBOutlet UIView* landscapeView;
@property(nonatomic, retain) IBOutlet UIView* portraitView;
@property(nonatomic, retain) eMobcViewController* mainController;


//Acciones
	-(void) backButtonPress:(id)sender;
	-(void) callTopMenu;

@end
