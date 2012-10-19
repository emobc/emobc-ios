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
#import "QuizLevelData.h"
#import "NwController.h"
#import "NextLevel.h"
#import "StylesLevelData.h"
#import "FormatsStylesLevelData.h" 

#import "NwSideMenuController.h"

/**
 * CLASS SUMMARY
 * NwButtonsController is button viewController so It is going to handle buttons
 * It's going to load menu when and where we have pointed
 *
 * @note buttonsController need data to work, this dates is taken from buttons.xml and then saves into data.
 */

@interface NwQuizController : NwController <UIWebViewDelegate> {
	
	//Objetos
	QuizLevelData* data;	
	
	AppQuestion* varQuestion;
	AppAnswer* varAnswer;
	
	UILabel *myHeaderText;
	UIImageView *imgView;
	UIImageView *imgViewQuestion;
	UIImageView *imgViewFinish;
	UIImageView *background;
	UILabel *myDescription;
	UILabel *myText;
	UILabel *myTextPoint;
	UIButton *button;
	
	UILabel *myAnswer;
	
	NSString *a;
	
	UIButton *but;
	
	NSMutableArray *score;
	NSMutableArray *questionRepeat;
	NSMutableArray *numQuestion;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
	
}

@property (nonatomic, retain) QuizLevelData* data;
@property (nonatomic, retain) AppQuestion* varQuestion;
@property (nonatomic, retain) AppAnswer* varAnswer;

@property (nonatomic, retain) UILabel *myHeaderText;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIImageView *imgViewQuestion;
@property (nonatomic, retain) UIImageView *imgViewFinish;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UILabel *myDescription;
@property (nonatomic, retain) UILabel *myText;
@property (nonatomic, retain) UILabel *myTextPoint;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) NSString *a;
@property (nonatomic, retain) UILabel *myAnswer;

@property (nonatomic, retain) UIButton *but;

@property (nonatomic, retain) NSMutableArray *score;
@property (nonatomic, retain) NSMutableArray *questionRepeat;
@property (nonatomic, retain) NSMutableArray *numQuestion;

-(void) startButton;
-(void) buttonPressed;
-(void) question:(NSString*) next;
-(void) upgradeQuestion;
-(void) nextButton;

-(void) checkboxButton:(UIButton*) button;
-(void) checkboxButtonRandom:(UIButton*) buttons;

-(void) quizFinish;

-(void) randomQuestion;

-(void) scorePoints;

-(void) nextButtonRandom;

-(void) backButtonPress:(id)sender;

@end