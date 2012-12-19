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

#import "NwImageTextController.h"
#import "SHKItem.h"
#import "SHKActionSheet.h"
#import "eMobcViewController.h"
#import "NwUtil.h"
#import <UIKit/UiKit.h>

#define MAX_CHARACTER  120

@implementation NwImageTextController

@synthesize imageDescription;
@synthesize contentImageDescription;
@synthesize textDesccription;
@synthesize nextButton;
@synthesize prevButton;
@synthesize data;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;

@synthesize sizeTop;
@synthesize sizeBottom;
@synthesize sizeHeaderText;
@synthesize swSize;


/**
 * When button is pressed load a multimedia menu
 *
 * @see mostrarMenuMultimedia
 */
-(IBAction) editButtonPress:(id)sender {
	[self mostrarMenuMultimedia];
}
 
/**
 * Share text in twitter when button is pressed
 */
-(IBAction) shareButtonPress:(id)sender {
	[super shareButtonPress:sender];
	
    NSString *shareText = [textDesccription.text stringByAppendingString:@" http://tiny.cc/zt4lt"];
	//NSString *shareText = [textDesccriptionLandscape.text stringByAppendingString:@" http://tiny.cc/zt4lt"];
	
    NSRange range = NSMakeRange (0, 80);
    NSString *twitterText =  [textDesccription.text substringWithRange:range];
	//NSString *twitterText =  [textDesccriptionLandscape.text substringWithRange:range];
    twitterText = [twitterText stringByAppendingString:@"... http://tiny.cc/zt4lt"];
	SHKItem *item = [SHKItem text:shareText];
    item.title = data.headerText;
    item.image = imageDescription.image;
	//comprobar Si es landscape
	//item.image = imageDescriptionLandscape.image;
	
    [item setAlternateText:twitterText toShareOn:@"Twitter"];
	
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showInView:self.view];	
}


/**
 * Button to get a back
 * see that if we get back payer stop top lay
 */
-(void) backButtonPress:(id)sender {
	[data release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if (playing == TRUE) {
		playing = FALSE;
		if (player != nil) {
			[player stop];
			[player release];
		}
	}
    
	[super backButtonPress:sender];
}

/**
 * Button to see the text with next photo
 *
 * @see loadNextLevel
 */
-(void) buttonNextPress:(id)sender {
	if (playing == TRUE) {
		playing = FALSE;
		if (player != nil) {
			[player stop];
			[player release];
		}
	}
	if (data != nil && data.nextLevel != nil && mainController != nil) {
		[self startSpinner];
		[mainController loadNextLevel:data.nextLevel];
	}
}

/**
 * Button to see the text and previous photo
 *
 * @see loadNextLevel
 */
-(void) buttonPrevPress:(id)sender {
	if (playing == TRUE) {
		playing = FALSE;
		if (player != nil) {
			[player stop];
			[player release];
		}
	}
	if (data != nil && data.prevLevel != nil && mainController != nil) {
		[self startSpinner];
		[mainController loadNextLevel:data.prevLevel];
	}
}

/**
 * Indicate receptor when one or more finger touch the view
 *
 * @param touches set of cases which answer those events
 * @param event Represent the event where thouch belong
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if ([touch tapCount] == 2) {
		[self becomeFirstResponder];
		UIMenuItem* item1 = [[UIMenuItem alloc] initWithTitle:@"Compartir" action:@selector(compartirAction)];
		UIMenuItem* item2 = [[UIMenuItem alloc] initWithTitle:@"Editar" action:@selector(editarAction)];
		
		UIMenuController* menuController = [UIMenuController sharedMenuController];
		[menuController setTargetRect:CGRectMake(0, 0, 320, 200) inView:self.view]; 
		menuController.menuItems = [NSArray arrayWithObjects:item1, item2, nil];
		[menuController setMenuVisible:YES animated:YES];	
	}
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
		
	if (action == @selector(compartirAction))
		return YES;
	if (action == @selector(editarAction))
		return YES;

	return NO;
}

-(BOOL) canBecomeFirstResponder {
	return YES;
}

/**
 * Action share
 */
-(void) compartirAction {
	NSString *text;
	
	if (textDesccription.selectedRange.length > 0)
		text = [textDesccription.text substringWithRange:textDesccription.selectedRange];
	else
		text = textDesccription.text;
	
	/*if (textDesccriptionLandscape.selectedRange.length > 0)
		text = [textDesccriptionLandscape.text substringWithRange:textDesccriptionLandscape.selectedRange];
	else
		text = textDesccriptionLandscape.text;
	*/
	
	SHKItem *item = [SHKItem text:text];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	 
	 // Display the action sheet
	 [actionSheet showInView:self.view];	
}

/**
 * Edit accion
 */
-(void) editarAction {
	textDesccription.editable = YES;
}



/**
 * Called after the controller’s view is loaded into memory.
 */
-(void)viewDidLoad {
    [super viewDidLoad];
	loadContent = FALSE;
	

	[self loadImageText];
}

/**
 * Load image text field
 */
-(void) loadImageText{
	int sw = 0;
	playing = FALSE;

	if(data != nil){
		sizeTop = 0;
		sizeBottom = 0;
		sizeHeaderText = 0;
		
		sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
		sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
		
		varStyles = [mainController.theStyle.stylesMap objectForKey:data.levelId];
		
		if (varStyles == nil) {
			varStyles = [mainController.theStyle.stylesMap objectForKey:@"IMAGE_TEXT_DESCRIPTION_ACTIVITY"];
		}else if(varStyles == nil){
			varStyles = [mainController.theStyle.stylesMap objectForKey:@"DEFAULT"];
		}
		
		if(varStyles != nil) {
			[self loadThemes];
			sizeTop += 25;
		}
		
		[self createImageView];
				
		if(data.prevLevel != nil && ![data.prevLevel.levelId isEqualToString:@""] && ![data.prevLevel.dataId isEqualToString:@""]){
			[self prevButtonCreate];
			sw = 1;
		}
		
		if(data.nextLevel != nil && ![data.nextLevel.levelId isEqualToString:@""] && ![data.nextLevel.dataId isEqualToString:@""]){
			[self nextButtonCreate];
			sw = 1;
		}
		
		if(sw == 1)
			sizeBottom += 25;
		
		[self createTextView];

	}else {
		self.titleLabel.text = @"eMobc Madrid";
		self.textDesccription.text = @"Sin Texto";
		
		[nextButton setTitle:@"Sin Texto" forState:UIControlStateNormal];
		[prevButton setTitle:@"Sin Texto" forState:UIControlStateNormal];
				
		self.geoRefString=@"";
	}
}


-(void) createImageView{
	swSize = 0;
	
	imageDescription = [[UIImageView alloc] init];
	imageDescription.image = [data.image imageContent];
	
	int width, height;
	
	width = imageDescription.image.size.width;
	height = imageDescription.image.size.height;
	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width < 512 && height < (768 - sizeTop - sizeBottom - sizeHeaderText)){
				swSize = 1;
				int posY = ((512 - sizeTop - sizeBottom - sizeHeaderText) - height)/2;
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(1024 - width, sizeTop + sizeHeaderText + posY , width, height)];
			}else{
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(512, sizeTop + sizeHeaderText, 512, 768 - sizeTop - sizeBottom - sizeHeaderText)];
			}
			
			if(swSize == 1){
				imageDescription.frame = CGRectMake(0, 0, width, height);
			}else{
				imageDescription.frame = CGRectMake(0, 0, 512, 768 - sizeTop - sizeBottom - sizeHeaderText);
			}
		}else{
			if(width < 768 && height < 400){
				swSize = 1;
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText + 5, width, height)];
				sizeTop += imageDescription.image.size.height + sizeHeaderText + 10;
			}else{
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 768, 400)];
				sizeTop += 405 + sizeHeaderText;
			}
			
			if(swSize == 1){
				imageDescription.frame = CGRectMake((768 - width)/2, 0, width, height);
			}else{
				imageDescription.frame = CGRectMake(0, 0, 768, 400);
			}
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width < 240 && height < (320 - sizeTop - sizeBottom - sizeHeaderText)){
				swSize = 1;
				int posY = ((320 - sizeTop - sizeBottom - sizeHeaderText) - height)/2;
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(480 - width, sizeTop + sizeHeaderText + posY , width, height)];
			}else{
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(240, sizeTop + sizeHeaderText, 240, 320 - sizeTop - sizeBottom - sizeHeaderText)];
			}
			
			if(swSize == 1){
				imageDescription.frame = CGRectMake(0, 0, width, height);
			}else{
				imageDescription.frame = CGRectMake(0, 0, 240, 320 - sizeTop - sizeBottom - sizeHeaderText);
			}
		}else{
			if(width < 320 && height < 160){
				swSize = 1;
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText + 5, width, height)];
				sizeTop += imageDescription.image.size.height + sizeHeaderText + 10;
			}else{
				contentImageDescription = [[UIImageView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 320, 160)];
				sizeTop += 165 + sizeHeaderText;
			}
			
			if(swSize == 1){
				imageDescription.frame = CGRectMake((320 - width)/2, 0, width, height);
			}else{
				imageDescription.frame = CGRectMake(0, 0, 320, 160);
			}
		}				
	}
	
	imageDescription.contentMode = UIViewContentModeScaleAspectFit;
		
	[self.view addSubview:contentImageDescription];
	[contentImageDescription addSubview:imageDescription];
}

-(void) nextButtonCreate {
	
	//create the button
	nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			nextButton.frame = CGRectMake(917, 768 - sizeBottom - 25, 87, 25);
		}else{
			nextButton.frame = CGRectMake(671, 1024 - sizeBottom - 25, 87, 25);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			nextButton.frame = CGRectMake(388, 320 - sizeBottom - 25, 90, 25);
		}else{
			nextButton.frame = CGRectMake(226, 480 - sizeBottom - 25, 90, 25);
		}				
	}
	
	//NSString *k = [eMobcViewController whatDevice:k];
	
	//NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"" ofType:nil inDirectory:k];
	
	//set the button's title
	[nextButton setTitle:@"Siguiente" forState:UIControlStateNormal];
	[nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[button setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	
	//listen for clicks
	[nextButton addTarget:self action:@selector(buttonNextPress:) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:nextButton];
}

-(void) prevButtonCreate {
	
	//create the button
	prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			prevButton.frame = CGRectMake(538, 768 - sizeBottom - 25, 87, 25);
		}else{
			prevButton.frame = CGRectMake(9, 1024 - sizeBottom - 25, 90, 25);
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			prevButton.frame = CGRectMake(257, 320 - sizeBottom - 25, 90, 25);
		}else{
			prevButton.frame = CGRectMake(4, 480 - sizeBottom - 25, 90, 25);
		}				
	}
	
	//NSString *k = [eMobcViewController whatDevice:k];
	
	//NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"" ofType:nil inDirectory:k];
	
	//set the button's title
	[prevButton setTitle:@"Anterior" forState:UIControlStateNormal];
	[prevButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[button setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	
	//listen for clicks
	[prevButton addTarget:self action:@selector(buttonPrevPress:) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:prevButton];
}

-(void) createTextView{
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(swSize == 1){
				textDesccription = [[[UITextView alloc]initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 1024 - imageDescription.image.size.width, 768 - sizeTop - sizeBottom - sizeHeaderText)]autorelease];
			}else{
				textDesccription = [[[UITextView alloc]initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 512, 768 - sizeTop - sizeBottom - sizeHeaderText)] autorelease];
			}
		}else{
			textDesccription = [[[UITextView alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 1024 - sizeTop - sizeBottom - 5)] autorelease];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(swSize == 1){
				textDesccription = [[[UITextView alloc]initWithFrame:CGRectMake(0, sizeTop, 480 - imageDescription.image.size.width, 320 - sizeTop - sizeBottom - sizeHeaderText)]autorelease];
			}else{
				textDesccription = [[[UITextView alloc]initWithFrame:CGRectMake(0, sizeTop, 240, 320 - sizeTop - sizeBottom - sizeHeaderText)] autorelease];
			}
		}else{
			textDesccription = [[[UITextView alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 480 - sizeTop - sizeBottom - 5 )] autorelease];
		}				
	}

	[textDesccription setEditable:NO];
	
	textDesccription.text = data.text;
	
	[self.view addSubview:textDesccription];
}


-(void)loadThemesComponents {
	
	for(int x = 0; x < varStyles.listComponents.count; x++){
		NSString *var = [varStyles.listComponents objectAtIndex:x];
		
		NSString *type = [varStyles.mapFormatComponents objectForKey:var];
		
		varFormats = [mainController.theFormat.formatsMap objectForKey:type];
		UILabel *myLabel;
		
		if([var isEqualToString:@"header"]){
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeTop, 320, 20)];
				}				
			}
			
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			

			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
			myLabel.textColor = [UIColor blackColor];
			myLabel.textAlignment = UITextAlignmentCenter;
			
			[self.view addSubview:myLabel];
			[myLabel release];
		}else if([var isEqualToString:@"basic_text"]){
			
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 108, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 88, 320, 20)];
				}				
			}
			
			self.textDesccription.text = data.text;
			int varSize = [varFormats.textSize intValue];
			self.textDesccription.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			
		}else if([var isEqualToString:@"footer"]){
			
			if([eMobcViewController isIPad]){
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 680, 1024, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 936, 768, 20)];
				}				
			}else {
				if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 252, 480, 20)];	
				}else{
					myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 412, 320, 20)];
				}				
			}
				
			int varSize = [varFormats.textSize intValue];

			nextButton.titleLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			prevButton.titleLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			
		}
	}
}


/**
 Carga los temas
 */
-(void) loadThemes {
	if(![varStyles.backgroundFileName isEqualToString:@""]) {
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
			}				
		}
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:varStyles.backgroundFileName ofType:nil inDirectory:k];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:background];
		[self.view sendSubviewToBack:background];
		[background release];
	}else{
		self.view.backgroundColor = [UIColor whiteColor];
	}
	
	if(![varStyles.components isEqualToString:@""]) {
		NSArray *separarComponents = [varStyles.components componentsSeparatedByString:@";"];
		NSArray *assignment;
		NSString *component;
		
		for(int i = 0; i < separarComponents.count - 1; i++){
			assignment = [[separarComponents objectAtIndex:i] componentsSeparatedByString:@"="];
			
			component = [assignment objectAtIndex:0];
			NSString *format = [assignment objectAtIndex:1];

			[varStyles.mapFormatComponents setObject:format forKey:component];
			
			if(![component isEqual:@"selection_list"]){
				[varStyles.listComponents addObject:component];
			}else{
				varStyles.selectionList = format;
			}
		}
		[self loadThemesComponents];
	}
}


-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * Sent to the view controller when the application receives a memory warning
 */
-(void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	//self.pinchGestureRecognizer = nil;
}

-(void)dealloc {
	[imageDescription release];
	[textDesccription release];
	[varStyles release];
	[varFormats release];
	[data release];
	
    [super dealloc];
}


/**
 * Compartir
 */
-(void) nwMMshareButtonPress {
    NSString *shareText = [textDesccription.text stringByAppendingString:@" http://tiny.cc/zt4lt"];
    NSRange range = NSMakeRange (0, 80);
    NSString *headerText = [data.headerText stringByAppendingFormat:@". "];
    NSString *twitterText = [headerText stringByAppendingFormat:[textDesccription.text substringWithRange:range]];
    //NSString *twitterText =  [textDesccription.text substringWithRange:range];
    twitterText = [twitterText stringByAppendingString:@"... http://tiny.cc/zt4lt"];
    
	SHKItem *item = [SHKItem text:shareText];
    item.title = data.headerText;
    item.image = imageDescription.image;
    [item setCustomValue:@"http://madeinmobile.net/images/3minmotor.jpg" forKey:@"caption"];
    [item setCustomValue:@"http://madeinmobile.net/images/3minmotor.jpg" forKey:@"picture"];
    [item setAlternateText:twitterText toShareOn:@"Twitter"];
    [item setAlternateText:twitterText toShareOn:@"Facebook"];
	
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	
	// Display the action sheet
	[actionSheet showInView:self.view];	
}


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
		
		if(![theMenu.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
		if(![theMenu.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
	
		//publicity
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
		
		[self loadImageText];
	}
}

@end