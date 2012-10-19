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

#import "NwQuizController.h"
#import "AppButton.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"
#import "NwButton.h"
#import "eMobcViewController.h"
#import "NwUtil.h"

@implementation NwQuizController

@synthesize data;
@synthesize varQuestion;
@synthesize varAnswer;
@synthesize myHeaderText;
@synthesize imgView;
@synthesize myDescription;
@synthesize myText;
@synthesize myTextPoint;
@synthesize button;
@synthesize imgViewQuestion;
@synthesize imgViewFinish;
@synthesize background;
@synthesize a;
@synthesize myAnswer;
@synthesize but;
@synthesize score;
@synthesize questionRepeat;
@synthesize numQuestion;

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
   	[super viewDidLoad];
	loadContent = FALSE;
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 1024, 642)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 768, 898)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 480, 194)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 320, 354)];
			
		}				
	}
	
	background.image = [UIImage imageNamed:@"images/quiz/backgroundQuiz.png"];
	[self.view addSubview:background];
	
	
	score = [[NSMutableArray alloc] init];
	questionRepeat = [[NSMutableArray alloc] init];
	numQuestion = [[NSMutableArray alloc] init];
	
	//Iphone
	int posY = 108;
	
	if(![data.headerText isEqualToString:@""]){
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myHeaderText = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 1014, 60)];
				posY = posY + 80;
			}else{
				myHeaderText = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 758, 80)];
				posY = posY+100;
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myHeaderText = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 480, 20)];
				posY = posY+20;
			}else{
				myHeaderText = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 320, 50)];
				posY= posY + 50;
			}				
		}
		
		myHeaderText.text = data.headerText;
		
		/*Estilos
		 
		 int varSize = [varFormats.textSize intValue];
		 
		 myHeaderText.font = [UIFont fontWithName:varFormats.typeFace size:varSize];*/
		myHeaderText.backgroundColor = [UIColor clearColor];
		
		//Hay que convertirlo a hexadecimal.
		//	varFormats.textColor*/
		myHeaderText.textColor = [UIColor whiteColor];
		myHeaderText.textAlignment = UITextAlignmentCenter;
		
		[self.view addSubview:myHeaderText];
		[myHeaderText release];
	}
	
	
	if(![data.headerImageFile isEqualToString:@""]){
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, posY, 1024, 300)];
				posY = posY + 320;
			}else{
				imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, posY, 768, 400)];
				posY = posY + 420;
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				imgView = [[UIImageView alloc] initWithFrame:CGRectMake(80, posY, 320, 90)];
				posY = posY + 90;
			}else{
				imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, posY, 320, 120)];
				posY = posY + 120;
			}				
		}
		
		NSString *imagePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:data.headerImageFile];
		
		imagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePath];
		
		imgView.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:imgView];
		[imgView release];
		
	}
	
	
	if(![data.description isEqualToString:@""]){
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 1024, 100)];	
			}else{
				myDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 768, 200)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 480, 55)];	
			}else{
				myDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, 320, 65)];
			}				
		}
		myDescription.text = data.description;
		myDescription.lineBreakMode = UILineBreakModeWordWrap;
		myDescription.numberOfLines = 0;
		
		/*Estilos
		 
		 int varSize = [varFormats.textSize intValue];
		 
		 myDescription.font = [UIFont fontWithName:varFormats.typeFace size:varSize];*/
		myDescription.backgroundColor = [UIColor clearColor];
		
		//Hay que convertirlo a hexadecimal.
		//	varFormats.textColor*/
		myDescription.textColor = [UIColor whiteColor];
		myDescription.textAlignment = UITextAlignmentCenter;
		
		[self.view addSubview:myDescription];
		[myDescription release];
	}
	
	[self startButton];
	
}

-(void) startButton{
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(392, 600, 240, 50);	
		}else{
			button.frame = CGRectMake(264, 800, 240, 60);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(320, 250, 120, 30);	
		}else{
			button.frame = CGRectMake(180, 410, 120, 30);
		}				
	}
	
	//set the button's title
	//[button setTitle:@"Comenzar" forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"images/quiz/start.png"] forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) buttonPressed{
	[myHeaderText removeFromSuperview];
	[imgView removeFromSuperview];
	[myDescription removeFromSuperview];
	[button removeFromSuperview];
	
	if(![data.first isEqualToString:@""]){
		[self question: data.first];
	}else{
		[self randomQuestion];
	}
	
	
}

-(void) randomQuestion {
	
	if([varAnswer.correct isEqualToString:@"true"]){
		[self scorePoints];
	}
	
	[background release];
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 1024, 642)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 768, 898)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 480, 194)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 320, 354)];
			
		}				
	}
	
	background.image = [UIImage imageNamed:@"images/quiz/backgroundQuiz.png"];
	[self.view addSubview:background];
	
	int count = [data.question count];
	
	if(count == [numQuestion count]){
		[self quizFinish];
	}else{
		int fromNumber = 0;
		int toNumber = count;
		int randomNumber = (arc4random()%(toNumber - fromNumber)) + fromNumber;
		
		int p = [questionRepeat count];
		int r;
		int sw = 0;
		
		NSString *bString = [NSString stringWithFormat:@"%d", randomNumber];
		
		[questionRepeat addObject:bString];
		
		for(int j = 0; j < p; j++){
			r =[[questionRepeat objectAtIndex:j] intValue];
			
			if(randomNumber == r){
				sw = 1;
			}
		}
		
		int positionY = 108;
		
		if(sw == 0){
			//El numero de preguntas para que no se repitan y se acabe el quiz.
			[numQuestion addObject:bString];
			
			varQuestion = [data.question objectAtIndex:randomNumber];
			
			if(![varQuestion.imageFile isEqualToString:@""]){
				
				if([eMobcViewController isIPad]){
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 1024, 300)];
						positionY = positionY + 300;
					}else{
						imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 768, 300)];
						positionY = positionY + 300;
					}				
				}else {
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 480, 50)];
						positionY = positionY + 50;
					}else{
						imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 320, 120)];
						positionY = positionY + 120;
					}				
				}
				
				NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:varQuestion.imageFile];
				imgViewQuestion.image = [UIImage imageWithContentsOfFile:imagePath];
				
				[self.view addSubview:imgViewQuestion];
				
			}
			
			if(![varQuestion.text isEqualToString:@""]){
				
				if([eMobcViewController isIPad]){
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 1024, 50)];
						positionY = positionY + 50;
					}else{
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 768, 50)];
						positionY = positionY + 50;
					}				
				}else {
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 480, 65)];	
						positionY = positionY + 65;
					}else{
						myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 320, 65)];
						positionY = positionY + 65;
					}				
				}
				myText.text = varQuestion.text;
				myText.lineBreakMode = UILineBreakModeWordWrap;
				myText.numberOfLines = 0;
				
				/*Estilos
				 
				 int varSize = [varFormats.textSize intValue];
				 
				 myText.font = [UIFont fontWithName:varFormats.typeFace size:varSize];*/
				myText.backgroundColor = [UIColor clearColor];
				
				//Hay que convertirlo a hexadecimal.
				//	varFormats.textColor*/
				myText.textColor = [UIColor whiteColor];
				myText.textAlignment = UITextAlignmentCenter;
				
				[self.view addSubview:myText];
			}
			
			
			//cuantas preguntas
			int count1 = [varQuestion.answers count];
			int y = 200;
			
			for(int i = 0; i < count1; i++){
				varAnswer = [varQuestion.answers objectAtIndex:i];
				
				but = [UIButton buttonWithType:UIButtonTypeCustom];
				if([eMobcViewController isIPad]){
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						[but setFrame:CGRectMake(0, positionY, 1024, 50)];
						positionY = positionY + 55;
					}else{
						[but setFrame:CGRectMake(0, positionY, 768, 50)];
						positionY = positionY + 55;
					}				
				}else {
					if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
						[but setFrame:CGRectMake(0, positionY, 320, 30)];
						positionY = positionY + 35;
					}else{
						[but setFrame:CGRectMake(0, positionY, 320, 40)];
						positionY = positionY + 45;
					}				
				}
				
				[but setImage:[UIImage imageNamed:@"images/quiz/answerButtonOff.png"] forState:UIControlStateNormal];
				[but setImage:[UIImage imageNamed:@"images/quiz/answerButtonOn.png"] forState:UIControlStateSelected];
				
				[but setTitle:varAnswer.answerText forState:UIControlStateNormal];
				
				[but setTag:i];
				[but addTarget:self action:@selector(checkboxButtonRandom:) forControlEvents:UIControlEventTouchUpInside];
				
				[self.view addSubview:but];
				y = y + 40;
				
			}	
			
		}else{
			[self randomQuestion];
		}
	}
	
	
}

-(void) question:(NSString*) next{
	[imgViewQuestion removeFromSuperview];
	[myText removeFromSuperview];
	[myAnswer removeFromSuperview];
	
	[but removeFromSuperview];
	
	
	varQuestion = [data.questionsMap objectForKey:next];
	int positionY = 108;
	
	if(![varQuestion.imageFile isEqualToString:@""]){
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 1024, 300)];
				positionY = positionY + 300;
			}else{
				imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 768, 300)];
				positionY = positionY + 300;
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 480, 50)];
				positionY = positionY + 50;
			}else{
				imgViewQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, 320, 120)];
				positionY = positionY + 120;
			}				
		}
		
		NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:varQuestion.imageFile];
		imgViewQuestion.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:imgViewQuestion];
		
	}
	
	if(![varQuestion.text isEqualToString:@""]){
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 1024, 30)];
				positionY = positionY + 50;
			}else{
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 768, 50)];
				positionY = positionY + 70;
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 480, 45)];	
				positionY = positionY + 45;
			}else{
				myText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionY, 320, 60)];
				positionY = positionY + 60;
			}				
		}
		myText.text = varQuestion.text;
		myText.lineBreakMode = UILineBreakModeWordWrap;
		myText.numberOfLines = 0;
		
		/*Estilos
		 
		 int varSize = [varFormats.textSize intValue];
		 
		 myText.font = [UIFont fontWithName:varFormats.typeFace size:varSize];*/
		myText.backgroundColor = [UIColor clearColor];
		
		//Hay que convertirlo a hexadecimal.
		//	varFormats.textColor*/
		myText.textColor = [UIColor whiteColor];
		myText.textAlignment = UITextAlignmentCenter;
		
		[self.view addSubview:myText];
		[myText release];
	}
	
	
	//cuantas preguntas
	int count = [varQuestion.answers count];
	
	for(int i = 0; i < count; i++){
		varAnswer = [varQuestion.answers objectAtIndex:i];
		
		but = [UIButton buttonWithType:UIButtonTypeCustom];
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				[but setFrame:CGRectMake(0, positionY, 320, 40)];
				positionY = positionY + 45;
			}else{
				[but setFrame:CGRectMake(0, positionY, 320, 40)];
				positionY = positionY + 45;
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				[but setFrame:CGRectMake(0, positionY, 320, 30)];
				positionY = positionY + 35;
			}else{
				[but setFrame:CGRectMake(0, positionY, 320, 40)];
				positionY = positionY + 45;
			}				
		}
		
		[but setImage:[UIImage imageNamed:@"images/quiz/answerButtonOff.png"] forState:UIControlStateNormal];
		[but setImage:[UIImage imageNamed:@"images/quiz/answerButtonOn.png"] forState:UIControlStateSelected];
		
		[but setTitle:varAnswer.answerText forState:UIControlStateNormal];
		
		[but setTag:i];
		[but addTarget:self action:@selector(checkboxButton:) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:but];
		
	}	
	
}

-(void) checkboxButtonRandom:(UIButton*) buttons{
	
	int idAnswer = [buttons tag];
	for(but in [self.view subviews]){
		if([but isKindOfClass:[UIButton class]] && ![but isEqual:buttons]){
			[but setSelected:NO];
		}
	}
	if(!buttons.selected){
		buttons.selected = !buttons.selected;
		
	}
	
	varAnswer = [varQuestion.answers objectAtIndex:idAnswer];
	
	
	//[self randomQuestion];
	
	//Para utilizar el quiz con los button radios
	[self nextButtonRandom];
}

-(void) nextButtonRandom{
	
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(800, 610, 240, 50);
		}else{
			button.frame = CGRectMake(560, 900, 240, 50);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(340, 240, 120, 30);
		}else{
			button.frame = CGRectMake(180, 410, 120, 30);
			
		}				
	}
	
	//set the button's title
	[button setImage:[UIImage imageNamed:@"images/quiz/next.png"] forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(randomQuestion) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) scorePoints {
	NSLog(@"score: %@", varQuestion.weight);
	[score addObject:varQuestion.weight];
}

-(void) checkboxButton:(UIButton*) buttons{
	
	int idAnswer = [buttons tag];
	for(but in [self.view subviews]){
		if([but isKindOfClass:[UIButton class]] && ![but isEqual:buttons]){
			[but setSelected:NO];
		}
	}
	if(!buttons.selected){
		buttons.selected = !buttons.selected;
	}
	
	
	varAnswer = [varQuestion.answers objectAtIndex:idAnswer];
	a = varAnswer.next;
	
	/*if(![a isEqualToString:@""]){
	 //Sin los button radio
	 [self question:a];
	 
	 }else{
	 [self quizFinish];
	 }*/
	
	
	//Para utilizar el quiz con los button radios
	if(![a isEqualToString:@""]){
		//Sin los button radio
		[self nextButton];
		
	}else{
		[self quizFinish];
	}
	
}

-(void) nextButton {
	
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(800, 610, 240, 50);
		}else{
			button.frame = CGRectMake(560, 900, 240, 50);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(340, 240, 120, 30);
		}else{
			button.frame = CGRectMake(180, 410, 120, 30);
			
		}				
	}
	
	//set the button's title
	//[button setTitle:@"Responder" forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"images/quiz/next.png"] forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(upgradeQuestion) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
}

-(void) upgradeQuestion{
	
	[background release];
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 1024, 642)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 768, 898)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 480, 194)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 320, 354)];
			
		}				
	}
	
	background.image = [UIImage imageNamed:@"images/quiz/backgroundQuiz.png"];
	[self.view addSubview:background];
	
	//El parametro selecionado sera guadado en una varible local y se le mandara el next a la funcion question por parametro.
	[self question:a];
}

-(void) quizFinish{
	[background release];
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 1024, 582)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 768, 838)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 480, 194)];
		}else{
			background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 320, 354)];
			
		}				
	}
	
	background.image = [UIImage imageNamed:@"images/quiz/backgroundQuiz.png"];
	[self.view addSubview:background];
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			imgViewFinish = [[UIImageView alloc] initWithFrame:CGRectMake(150, 108, 768, 400)];
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 520, 1024, 30)];
		}else{
			imgViewFinish = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 768, 550)];
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 800, 768, 70)];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			imgViewFinish = [[UIImageView alloc] initWithFrame:CGRectMake(70, 88, 320, 120)];
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, 300, 40)];
		}else{
			imgViewFinish = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, 320, 200)];
			myTextPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 285, 320, 110)];
		}				
	}
	
	imgViewFinish.image = [UIImage imageNamed:@"images/quiz/imagenFinalizado.png"];
	
	int valor = [score count];
	int point = 0;
	int n;
	
	
	for(int k = 0; k < valor; k++){
		n = [[score objectAtIndex:k] intValue];
		point = point + n;
	}
	
	NSString *aString = [NSString stringWithFormat:@"Score point : %d", point];
	myTextPoint.text = aString;
	
	myTextPoint.backgroundColor = [UIColor clearColor];
	myTextPoint.textAlignment = UITextAlignmentCenter;
	myTextPoint.textColor = [UIColor whiteColor];
	
	
	//create the button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(400, 500, 240, 50);
		}else{
			button.frame = CGRectMake(270, 900, 240, 50);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			button.frame = CGRectMake(340, 240, 120, 30);
		}else{
			button.frame = CGRectMake(180, 410, 120, 30);
			
		}				
	}
	
	//set the button's title
	//[button setTitle:@"Responder" forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"images/quiz/close.png"] forState:UIControlStateNormal];
	
	//listen for clicks
	[button addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:button];
	
	[self.view addSubview:myTextPoint];	
	[self.view addSubview:imgViewFinish];
	[myTextPoint release];
	[imgViewFinish release];
}

/**
 * Show a level back when backButton is pressed
 */
-(void)backButtonPress:(id)sender {
	[mainController goBack];	
}


/**
 * Show differents views depending on orientation
 *
 * @param object
 */
-(void) orientationChanged:(NSNotification *)object{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation ){
		return;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object: nil];
	
	currentOrientation = orientation;
	
	[self performSelector:@selector(orientationChangedMethod) withObject: nil afterDelay: 0];
}

-(void) orientationChangedMethod{
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else{
		self.view = self.portraitView;
	}
	
	if(loadContent == FALSE){
		loadContent = TRUE;
		
		if(![mainController.appData.backgroundMenu isEqualToString:@""]){
			[self loadBackgroundMenu];
		}
		
		if(![mainController.appData.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
		if(![mainController.appData.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
		
		//publicity
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
		
		[self viewDidLoad];	
	}
}



/**
 * Sent to the view controller when the application receives a memory warning
 */
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
    [super viewDidUnload];
	
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end