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

#import "NwProfileController.h"
#import "AppParser.h"
#import "NwUtil.h"
#import "eMobcViewController.h"

@implementation NwProfileController

@synthesize profile;
@synthesize scrollView;
@synthesize varStyles;
@synthesize varFormats;
@synthesize background;
@synthesize imagePickerController;

static CGFloat const kScreenWidth = 320.0;
static CGFloat const kScreenHeight = 480.0;

static CGFloat const kScreenWidthLandscape = 480.0;

static CGFloat const kFormLeftMargin = 10.0;
static CGFloat const kFormRightMargin = 10.0;
static CGFloat const kFormTopMargin = 10.0;
static CGFloat const kFormBottomMargin = 10.0;

static CGFloat const kFormLeftMarginLandscape = 90.0;

#define kFormWidth	300.0
#define kFromHeight 336.0

static CGFloat const kFormSeparatorHeight = 5.0;

static CGFloat const kFormLabelWidth = kFormWidth;
static CGFloat const kFormLabelHeight = 20.0;

static CGFloat const kFormTextFieldWidth = kFormWidth;
static CGFloat const kFormTextFieldHeight = 30.0;

static CGFloat const kFormTextViewWidth = kFormWidth;
static CGFloat const kFormTextViewHeight = 80.0;

static CGFloat const kFormCheckWidth = 60.0;
static CGFloat const kFormCheckHeight = 30.0;

static CGFloat const kFormSubmitButtonWidth = 125;
static CGFloat const kFormSubmitButtonHeight = 35;

static float   const kKeyboardAnimationDuration = 0.3;
static CGFloat const kTabBarHeight = 29.0;
static CGFloat const kTabBarWidth = 29.0;

// iPAD

static CGFloat const kScreenWidthiPad = 740.0;
static CGFloat const kScreenHeightiPad = 1024.0;

static CGFloat const kScreenWidthiPadLandscape = 1000.0;

static CGFloat const kFormLeftMarginiPad = 40.0;
static CGFloat const kFormRightMarginiPad = 40.0;
static CGFloat const kFormTopMarginiPad = 40.0;
static CGFloat const kFormBottomMarginiPad = 40.0;

static CGFloat const kFormLeftMarginiPadLandscape = 150.0;

#define kFormWidthiPad	693.0
#define kFromHeightiPad 636.0

static CGFloat const kFormSeparatorHeightiPad = 5.0;

static CGFloat const kFormLabelWidthiPad = kFormWidthiPad;
static CGFloat const kFormLabelHeightiPad = 40.0;

static CGFloat const kFormTextFieldWidthiPad = kFormWidthiPad;
static CGFloat const kFormTextFieldHeightiPad = 60.0;

static CGFloat const kFormTextViewWidthiPad = kFormWidthiPad;
static CGFloat const kFormTextViewHeightiPad = 160.0;

static CGFloat const kFormCheckWidthiPad = 120.0;
static CGFloat const kFormCheckHeightiPad = 60.0;

static CGFloat const kFormSubmitButtonWidthiPad = 160;
static CGFloat const kFormSubmitButtonHeightiPad = 50;

static float   const kKeyboardAnimationDurationiPad = 0.3;
static CGFloat const kTabBarHeightiPad = 58.0;


/**
 * Called after the controller’s view is loaded into memory.
 *
 * @see keyboardWillShow
 * @see keyboardWillHide
 */
-(void)viewDidLoad {
    [super viewDidLoad];
	
	profile = [[NwUtil instance] readProfile];
	
	loadContent = FALSE;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSFileManager *gestorArchivos = [NSFileManager defaultManager];
	NSString *rutaArchivo = [documentsDirectory stringByAppendingPathComponent:@"Form_Profile.data"];
	
	if(![gestorArchivos fileExistsAtPath:rutaArchivo]){
		firstProfile = TRUE;
	}
	
	[self loadForm];

}

/*-(void)loadThemesComponents {
	
	for(int x = 0; x < varStyles.listComponents.count; x++){
		NSString *var = [varStyles.listComponents objectAtIndex:x];
		
		NSString *type = [varStyles.mapFormatComponents objectForKey:var];
		
		varFormats = [mainController.theFormat.formatsMap objectForKey:type];
		UILabel *myLabel;
		
		if([var isEqualToString:@"header"]){
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
			
			myLabel.text = data.headerText;
			
			int varSize = [varFormats.textSize intValue];
			
			myLabel.font = [UIFont fontWithName:varFormats.typeFace size:varSize];
			myLabel.backgroundColor = [UIColor clearColor];
			
			//Hay que convertirlo a hexadecimal.
			//	varFormats.textColor
			myLabel.textColor = [UIColor whiteColor];
			myLabel.textAlignment = UITextAlignmentCenter;
			
			[self.view addSubview:myLabel];
			[myLabel release];
		}
	}
}*/


/**
 Carga los temas
 */
/*-(void) loadThemes {
	if(![varStyles.backgroundFileName isEqualToString:@""]) {
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 1024, 582)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 786, 838)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 480, 174)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 320, 334)];
			}				
		}
		
		NSString *imagePath = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:varStyles.backgroundFileName];
		
		imagePath = [eMobcViewController addIPadImageSuffixWhenOnIPad:imagePath];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		[self.view addSubview:background];
		//[self.view sendSubviewToBack:background];
	}else{
		self.view.backgroundColor = [UIColor blackColor];
	}
	
	if(![varStyles.components isEqualToString:@""]) {
		NSArray *separarComponents = [varStyles.components componentsSeparatedByString:@";"];
		NSArray *assignment;
		NSString *component;
		
		for(int i = 0; i < separarComponents.count - 1; i++){
			assignment = [[separarComponents objectAtIndex:i] componentsSeparatedByString:@"="];
			
			component = [assignment objectAtIndex:0];
			NSString *format = [assignment objectAtIndex:1];
			
			//[varStyles.mapFormatComponents setObject:component forKey:format];
			[varStyles.mapFormatComponents setObject:format forKey:component];
			
			if(![component isEqual:@"selection_list"]){
				[varStyles.listComponents addObject:component];
			}else{
				varStyles.selectionList = format;
			}
		}
		[self loadThemesComponents];
	}
}*/

/**
 * Load and prepare the form
 */
-(void) loadForm{
		
	if(profile != nil){
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
		
		background.image = [UIImage imageNamed:@"images/cover/backgroundCover.png"];
		[self.view addSubview:background];
	
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 128, 1024, 582)];	
			}else{
				scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 128, 786, 838)];
			}
		}else{
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, 480, 174)];	
			}else{
				scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, 320, 334)];
			}
		}
		
		scrollView.maximumZoomScale = 4.0;
		scrollView.minimumZoomScale = 0.75;
		scrollView.clipsToBounds = YES;
		scrollView.delegate = self;
		
		[self.view addSubview:scrollView];
						
		
		nroDownload = 0;
		NSMutableDictionary *formData = [self readFormData]; 
		
		float ypos = 0;
        
        if ([eMobcViewController isIPad]) {
            ypos = kFormTopMarginiPad;
        } else {
            ypos = kFormTopMargin;
        }
		
		formFields = [[[NSMutableArray array] init] retain];
		pickersList = [[[NSMutableArray array] init] retain];
		pickerTextFieldMap = [[[NSMutableDictionary dictionary] init] retain];
		
		int count;
		loadContent = FALSE;
		count = [profile.fieldsProfile count];
		
		
		for(int i=0; i < count;i++){
			NwAppField* theField;
			
			theField = [profile.fieldsProfile objectAtIndex:i];
			
						
			NSString* value = [formData objectForKey:theField.fieldName];
			
			ypos += [self addField:theField ypos:ypos withValue:value];
            if ([eMobcViewController isIPad]) {
                ypos += kFormSeparatorHeightiPad;
            } else {
                ypos += kFormSeparatorHeight;
            }
			
		}

		ypos += [self addButtonSubmit:ypos];
			
		if ([eMobcViewController isIPad]) {
            ypos += kFormBottomMarginiPad;
        } else {
            ypos += kFormBottomMargin;
        }
		
		CGFloat formHeight = 0.0;
		
		if ([eMobcViewController isIPad]) {
            if (ypos < kFromHeightiPad) {
                formHeight = kFromHeightiPad;
            }else {
                formHeight = ypos;
            }
        } else {
            if (ypos < kFromHeight) {
                formHeight = kFromHeight;
            }else {
                formHeight = ypos;
            }
        }
		
		// register for keyboard notifications
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:self.view.window];
		// register for keyboard notifications
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification 
												   object:self.view.window];
		keyboardIsShown = NO;
        //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)		
		
	
		if ([eMobcViewController isIPad]) {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				scrollView.contentSize = CGSizeMake(kScreenWidthiPadLandscape, formHeight);
			}else{
				scrollView.contentSize = CGSizeMake(kScreenWidthiPad, formHeight);
			}
        } else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				scrollView.contentSize = CGSizeMake(kScreenWidthLandscape, formHeight);
			}else{
				scrollView.contentSize = CGSizeMake(kScreenWidth, formHeight);
			}
        }
		
	}else {
		self.titleLabel.text = @"eMobc.com";
		self.geoRefString=@"";
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Conectividad a internet"
                                                          message:@"Para realizar esta operación necesita conectividad a Internet."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        [message release];	
	}	
	
	popView.hidden = TRUE;
}

/**
 * Sent to the view controller when the application receives a memory warning
 */
-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/**
 * Called when the controller’s view is released from memory.
 */
-(void)viewDidUnload {
    [super viewDidUnload];

    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillShowNotification 
                                                  object:nil]; 
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIKeyboardWillHideNotification 
                                                  object:nil];  
	
    

	self.scrollView = nil;
	
	self.titleLabel = nil;
}


-(void)dealloc {
	[varStyles release];
	[varFormats release];
	[scrollView release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Mostrar UITextField cuando aparece el teclado

/**
 * Call when keyboard hides
 *
 * @param n Notificacion
 */
-(void)keyboardWillHide:(NSNotification *)n {
	NSDictionary* userInfo = [n userInfo];
	
    // get the size of the keyboard
    //NSValue* boundsValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
    //CGSize keyboardSize = [boundsValue CGRectValue].size;
	CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	// resize the scrollview
	CGRect viewFrame = self.scrollView.frame;
    
	// I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight - 300);
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
	
	[self.scrollView setFrame:viewFrame];
	
    [UIView commitAnimations];
	
    keyboardIsShown = NO;
}

/**
 * Call when keyboard show 
 *
 * @param n Notificacion
 */
-(void)keyboardWillShow:(NSNotification *)n {
	// This is an ivar I'm using to ensure that we do not do the frame size adjustment on the UIScrollView if the keyboard is already shown.  This can happen if the user, after fixing editing a UITextField, scrolls the resized UIScrollView to another UITextField and attempts to edit the next UITextField.  If we were to resize the UIScrollView again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
	
    NSDictionary* userInfo = [n userInfo];
	
    // get the size of the keyboard
    //NSValue* boundsValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
    //CGSize keyboardSize = [boundsValue CGRectValue].size;
	CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	// resize the noteView
	 CGRect viewFrame = self.scrollView.frame;
		

    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight - 300);
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // The kKeyboardAnimationDuration I am using is 0.3
    [UIView setAnimationDuration:kKeyboardAnimationDuration];
   	
	[self.scrollView setFrame:viewFrame];

    [UIView commitAnimations];
	
    keyboardIsShown = YES;
}

#pragma mark -
#pragma mark Agregar Campos al Form

/**
 * Add field to form
 * 
 * @param field 
 * @param ypos coordinate y
 * @param value field value 
 *
 * @return call a especific method depending on the type of field
 *
 * @see addTextField
 * @see addTextViewField
 * @see addNumericField
 * @see addPhoneField
 * @see addEmailField
 * @see addCheckField
 * @see addPickerField
 * @see addPasswordField
 * @see addImageField
 */
-(float) addField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	float ret = 0;
	switch (field.type) {
		case INPUT_TEXT:
			ret = [self addTextField:field ypos:ypos withValue:value];
			break;
		case INPUT_TEXTVIEW:
			ret = [self addTextViewField:field ypos:ypos withValue:value];
			break;
		case INPUT_NUMBER:
			ret = [self addNumericField:field ypos:ypos withValue:value];
			break;
		case INPUT_PHONE:
			ret = [self addPhoneField:field ypos:ypos withValue:value];
			break;
		case INPUT_EMAIL:
			ret = [self addEmailField:field ypos:ypos withValue:value];
			break;
		case INPUT_CHECK:
			ret = [self addCheckField:field ypos:ypos withValue:value];
			break;
		case INPUT_PICKER:
			ret = [self addPickerField:field ypos:ypos withValue:value];
			break;			
		case INPUT_PASSWORD:
			ret = [self addPasswordField:field ypos:ypos withValue:value];
			break;			
		case INPUT_IMAGE:
			ret = [self addImageField:field ypos:ypos withValue:value];
			break;			
		default:
			break;
	}
	return ret;
}

/**
 * Add label
 *
 * @param field 
 * @param ypos Coordinate y
 *
 * @return Height label
 */
-(float) addLabel:(NwAppField*)field ypos:(float) ypos {
	UILabel *label;
    
    if ([eMobcViewController isIPad]) {
        if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			label = [[UILabel alloc] initWithFrame:CGRectMake(kFormLeftMarginiPadLandscape, ypos, kFormLabelWidthiPad, kFormLabelHeightiPad)];	
		}else{
			label = [[UILabel alloc] initWithFrame:CGRectMake(kFormLeftMarginiPad, ypos, kFormLabelWidthiPad, kFormLabelHeightiPad)];
		}
		
        label.font = [UIFont systemFontOfSize:24.0];
    } else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			label = [[UILabel alloc] initWithFrame:CGRectMake(kFormLeftMarginLandscape, ypos, kFormLabelWidth, kFormLabelHeight)];
		}else{
			label = [[UILabel alloc] initWithFrame:CGRectMake(kFormLeftMargin, ypos, kFormLabelWidth, kFormLabelHeight)];
		}
        label.font = [UIFont systemFontOfSize:17.0];
    }
	
  
	label.text = field.labelText;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
	label.highlightedTextColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentLeft;
	
	[scrollView addSubview:label];

	[label release];
	
    if ([eMobcViewController isIPad]) {
        return kFormLabelHeightiPad;
    } else {
        return kFormLabelHeight;
	}
}

/**
 * Add text field
 *
 * @param field 
 * @param ypos Coodinate y
 * @param value 
 *
 * @return Space between two fields
 */-(float) addTextField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	return [self addTextFieldOfType:field ypos:ypos withValue:value keyboardType:UIKeyboardTypeDefault];
}

/**
 * Add scroll text field
 *
 * @param field 
 * @param ypos Coordinate y
 * @param value
 *
 * @return Heigh field
 */
-(float) addTextViewField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	float labelHeigth = [self addLabel:field ypos:ypos];
	float textFieldYPos = 0;
	
	if ([eMobcViewController isIPad]) {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeightiPad;
    } else {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeight;
    }
	
	//UITextView* textFieldRounded;
    if ([eMobcViewController isIPad]) {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textViewRounded = [[UITextView alloc] initWithFrame:CGRectMake(kFormLeftMarginiPadLandscape, textFieldYPos, kFormTextViewWidthiPad, kFormTextViewHeightiPad)];	
		}else{
			textViewRounded = [[UITextView alloc] initWithFrame:CGRectMake(kFormLeftMarginiPad, textFieldYPos, kFormTextViewWidthiPad, kFormTextViewHeightiPad)];
		}
		
        textViewRounded.font = [UIFont systemFontOfSize:24.0];  //font size
    } else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textViewRounded = [[UITextView alloc] initWithFrame:CGRectMake(kFormLeftMarginLandscape, textFieldYPos, kFormTextViewWidth, kFormTextViewHeight)];	
		}else{
			textViewRounded = [[UITextView alloc] initWithFrame:CGRectMake(kFormLeftMargin, textFieldYPos, kFormTextViewWidth, kFormTextViewHeight)];
		}
        
        textViewRounded.font = [UIFont systemFontOfSize:17.0];  //font size
	}	
	
	
	[textViewRounded.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
	[textViewRounded.layer setBorderColor:[[UIColor grayColor] CGColor]];
	[textViewRounded.layer setBorderWidth:1.0];
	[textViewRounded.layer setCornerRadius:7];
	[textViewRounded.layer setMasksToBounds:NO];
	textViewRounded.layer.shouldRasterize = YES;
	
	[textViewRounded.layer setShadowRadius: 3.0f];
	[textViewRounded.layer setShadowOffset:CGSizeMake(3, 3)];
	[textViewRounded.layer setShadowOpacity: 1.0f];
	textViewRounded.layer.shadowColor = [[UIColor blackColor] CGColor];
	textViewRounded.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
	textViewRounded.layer.shadowOpacity = 0.5f;
	textViewRounded.layer.shadowRadius = 0.5f;

	textViewRounded.textColor = [UIColor blackColor]; //text color	
	//textViewRounded.placeholder = @"<enter text>";  //place holder
	textViewRounded.editable = TRUE;
	
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    if ([iosVersion intValue] >= 5)
        textViewRounded.backgroundColor = [UIColor whiteColor];
    
	textViewRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	textViewRounded.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
	textViewRounded.returnKeyType = UIReturnKeyDone;  // type of the return key
	textViewRounded.delegate = self;
	textViewRounded.text = value;	
	
	
	[scrollView addSubview:textViewRounded];
	
	[formFields addObject:textViewRounded];
	
	if(firstProfile == FALSE){
		textViewRounded.userInteractionEnabled = NO;
	}	
		
	[textViewRounded release];
		
	if([eMobcViewController isIPad]){
		return 210;
	}else{
		return 110;
	}
	
}
	

/**
 * Add image field
 *
 * @param field 
 * @param ypos 
 * @param value
 *
 * @return Heigh field
 *
 * @see takePicturePressed
 * @see selectPicturePressed
 */
-(float) addImageField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	float labelHeigth = [self addLabel:field ypos:ypos];
	float textFieldYPos = 0;
    
    if ([eMobcViewController isIPad]) {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeightiPad;
    } else {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeight;
    }
	
	UIButton *buttonCamara = [[UIButton buttonWithType:UIButtonTypeCustom] retain];	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonCamara.frame = CGRectMake(kFormLeftMarginiPadLandscape + 203, textFieldYPos + 30, 150, 40);
		}else{
			buttonCamara.frame = CGRectMake(kFormLeftMarginiPad + 203, textFieldYPos + 30, 150, 40);
		}	
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonCamara.frame = CGRectMake(kFormLeftMarginLandscape, textFieldYPos, 150, 40);
		}else{
			buttonCamara.frame = CGRectMake(kFormLeftMargin, textFieldYPos, 150, 40);
		}
	}
	
	[buttonCamara setImage:[UIImage imageNamed:@"images/form/takePicture.png"] forState:UIControlStateNormal];
		
	
	UIButton *buttonGalery = [[UIButton buttonWithType:UIButtonTypeCustom] retain];	
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonGalery.frame = CGRectMake(kFormLeftMarginiPadLandscape + 353, textFieldYPos + 30, 150, 40);
		}else{
			buttonGalery.frame = CGRectMake(kFormLeftMarginiPad + 353, textFieldYPos + 30, 150, 40);
		}		
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			buttonGalery.frame = CGRectMake(kFormLeftMarginLandscape + 150, textFieldYPos, 150, 40);
		}else{
			buttonGalery.frame = CGRectMake(kFormLeftMargin + 150, textFieldYPos, 150, 40);
		}		
	}
	
	[buttonGalery setImage:[UIImage imageNamed:@"images/form/galleryPicture.png"] forState:UIControlStateNormal];

	
	[buttonCamara addTarget:self action:@selector(takePicturePressed:) forControlEvents:UIControlEventTouchUpInside];
	[buttonGalery addTarget:self action:@selector(selectPicturePressed:) forControlEvents:UIControlEventTouchUpInside];

	
	imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
		
		
	if([eMobcViewController isIPad]){
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kFormLeftMarginiPad + 113, textFieldYPos + 70, 480, 200)];
	}else{
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kFormLeftMargin, textFieldYPos + 70, 240, 100)];
	}
    imageView.hidden = YES;
	
	
	if(firstProfile == FALSE){
		buttonCamara.userInteractionEnabled = NO;
		buttonGalery.userInteractionEnabled = NO;
	}	

	[scrollView addSubview:buttonCamara];
	[scrollView addSubview:buttonGalery];
	[scrollView addSubview:imageView];
	
	[formFields addObject:imageView];
	
	return 200;
}


/**
 * Add numeric field
 *
 * @param field 
 * @param ypos Coordinate y
 * @param value
 *
 * @return Call another method to return heigh field
 *
 * @see addTextFieldOfType
 */
-(float) addNumericField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	return [self addTextFieldOfType:field ypos:ypos withValue:value keyboardType:UIKeyboardTypeNumberPad];
}

/**
 * Add phone field 
 *
 * @param field 
 * @param ypos Coordinate y
 * @param value
 *
 * @return Call another method to return heigh field
 *
 * @see addTextFieldOfType
 */
-(float) addPhoneField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	return [self addTextFieldOfType:field ypos:ypos withValue:value keyboardType:UIKeyboardTypePhonePad];
}

/**
 * Add e-mail field
 *
 * @param field 
 * @param ypos Coordinate y
 * @param value
 *
 * @return Call another method to return heigh field
 *
 * @see addTextFieldOfType
 */
-(float) addEmailField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	return [self addTextFieldOfType:field ypos:ypos withValue:value keyboardType:UIKeyboardTypeEmailAddress];
}


/**
 * Agregar un campo de check.
 *
 * @param field Campo
 * @param ypos La posicion en las coordenadas y
 * @param value
 *
 * @return Devuelve la altura del campo
 */
-(float) addCheckField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	float labelHeigth = [self addLabel:field ypos:ypos];
    float textFieldYPos = 0;
    UISwitch *onoff;
    
    if ([eMobcViewController isIPad]) {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeightiPad;
       
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			onoff = [[UISwitch alloc] initWithFrame:CGRectMake(kFormLeftMarginiPadLandscape, textFieldYPos, kFormCheckWidthiPad, kFormCheckHeightiPad)];	
		}else{
			onoff = [[UISwitch alloc] initWithFrame:CGRectMake(kFormLeftMarginiPad, textFieldYPos, kFormCheckWidthiPad, kFormCheckHeightiPad)];
		}
		
    } else {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeight;
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			onoff = [[UISwitch alloc] initWithFrame:CGRectMake(kFormLeftMarginLandscape, textFieldYPos, kFormCheckWidth, kFormCheckHeight)];	
		}else{
			onoff = [[UISwitch alloc] initWithFrame:CGRectMake(kFormLeftMargin, textFieldYPos, kFormCheckWidth, kFormCheckHeight)];
		}
    }
	
	bool on = [value isEqualToString:@"true"];
	[onoff setOn:on];
	
	[scrollView addSubview:onoff];
	
	[formFields addObject:onoff];
	
	if(firstProfile == FALSE){
		onoff.userInteractionEnabled = NO;
	}
	[onoff release];
    
    if ([eMobcViewController isIPad]) {
        return labelHeigth + kFormSeparatorHeightiPad + kFormCheckHeightiPad + kFormSeparatorHeightiPad;
    } else {
        return labelHeigth + kFormSeparatorHeight + kFormCheckHeight + kFormSeparatorHeight;
    }
}


/**
 * Add picker field
 *
 * @param field 
 * @param ypos Coordinate y
 * @param value
 *
 * @return Heigh field
 *
 * @see dismissActionSheet
 */
-(float) addPickerField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	float labelHeigth = [self addLabel:field ypos:ypos];
	
	
	if ([eMobcViewController isIPad]) {
		
		float textFieldYPos = ypos + labelHeigth + kFormSeparatorHeightiPad;
				
		/*UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
		 delegate:nil
		 cancelButtonTitle:nil
		 destructiveButtonTitle:nil
		 otherButtonTitles:nil];
         
         [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];*/
        // actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			popView = [[UIView alloc] initWithFrame:CGRectMake(355.5, 400, 200, 200)];
		}else{
			popView = [[UIView alloc] initWithFrame:CGRectMake(227.5, 600, 200, 200)];
		}	

		[self.view addSubview:popView];
		CGRect pickerFrame = CGRectMake(0, 0, 313, 180);
		UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
		//UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ypos+25, 0, 0)];
		pickerView.delegate = self;
		pickerView.showsSelectionIndicator = YES;
		pickerView.tag = [formFields count];
		//pickerView.hidden = TRUE;
		//[actionSheet addSubview:pickerView];
		[popView addSubview:pickerView];
		[pickerView release];
		
		
		//UIPopoverController *tempPopover = [[UIPopoverController alloc] initWithContentViewController:pickerView];
		
		/*UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cerrar"]];
		 closeButton.momentary = YES; 
		 closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
		 //closeButton.frame = CGRectMake(10, 14, 50, 100);
		 closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
		 closeButton.tintColor = [UIColor blackColor];
		 [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
		 [actionSheet addSubview:closeButton];
		 [closeButton release]; */
		
		//[actionSheet showInView:scrollView];
		//[actionSheet setBounds:CGRectMake(0, 0, 768, 1024)];
		
		//UITextField *textFieldRounded; 
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginiPadLandscape, textFieldYPos, kFormTextFieldWidthiPad, kFormTextFieldHeightiPad)];
		}else{
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginiPad, textFieldYPos, kFormTextFieldWidthiPad, kFormTextFieldHeightiPad)];
		}	
		
		textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
		textFieldRounded.textColor = [UIColor blackColor]; //text color
		textFieldRounded.font = [UIFont systemFontOfSize:22.0];  //font size
		textFieldRounded.backgroundColor = [UIColor clearColor]; //background color
		textFieldRounded.returnKeyType = UIReturnKeyDone;  // type of the return key	
		textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		textFieldRounded.delegate = self;
		textFieldRounded.tag = [pickersList count] + 1;

		
		[scrollView addSubview:textFieldRounded];
		
		[formFields addObject:pickerView];
		//[pickersList addObject:pickerView];
		[pickersList addObject:pickerView];
		
		
		NSNumber *txtKey = [NSNumber numberWithInt:pickerView.tag];
		[pickerTextFieldMap setObject:textFieldRounded forKey:txtKey];
		
		int count = [field countParameters];
		bool found = false;
		
		for(int i =0; i < count; i++){
			NSString* pickParameter = [[field getParameterByNumber:i] retain];
			if ([pickParameter isEqualToString: value]) {
				textFieldRounded.placeholder = value;  //place holder
				[pickerView selectRow:i inComponent:0 animated:YES];
				found = true;
				break;
			}
		}
		if (!found) {
			textFieldRounded.placeholder = @"Seleccione";  //place holder
		}
		
		if(firstProfile == FALSE){
			pickerView.userInteractionEnabled = NO;
		}
		
		[textFieldRounded release];
		[pickerView release];
		
		return labelHeigth + kFormSeparatorHeightiPad + kFormTextFieldHeightiPad + kFormSeparatorHeightiPad; }
	else {
		float textFieldYPos = ypos + labelHeigth + kFormSeparatorHeight;
		
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
																 delegate:nil
														cancelButtonTitle:nil
												   destructiveButtonTitle:nil
														otherButtonTitles:nil];
		
		[actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		CGRect pickerFrame = CGRectMake(0, 40, 0, 0);	
		UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
		//UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ypos+25, 0, 0)];
		pickerView.delegate = self;
		pickerView.showsSelectionIndicator = YES;
		pickerView.tag = [formFields count];
		//pickerView.hidden = TRUE;
		
	
		[actionSheet addSubview:pickerView];
		//[pickerView release];
		
		UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cerrar"]];
		closeButton.momentary = YES; 
		closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
		closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
		closeButton.tintColor = [UIColor blackColor];
		[closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
		[actionSheet addSubview:closeButton];
		[closeButton release];
		
		
		//[actionSheet showInView:scrollView];
		//[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
		
		//UITextField *textFieldRounded;
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginLandscape, textFieldYPos, kFormTextFieldWidth, kFormTextFieldHeight)];
		}else{
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMargin, textFieldYPos, kFormTextFieldWidth, kFormTextFieldHeight)];
		}	
		textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
		textFieldRounded.textColor = [UIColor blackColor]; //text color
		textFieldRounded.font = [UIFont systemFontOfSize:17.0];  //font size
		textFieldRounded.backgroundColor = [UIColor clearColor]; //background color
		
		NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
		
		if ([iosVersion intValue] >= 5)
			textFieldRounded.backgroundColor = [UIColor whiteColor];
		
		textFieldRounded.returnKeyType = UIReturnKeyDone;  // type of the return key	
		textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		textFieldRounded.delegate = self;
		textFieldRounded.tag = [pickersList count] + 1;
		

		[scrollView addSubview:textFieldRounded];
		
		[formFields addObject:pickerView];
		//[pickersList addObject:pickerView];
		[pickersList addObject:actionSheet];
		
	
		NSNumber *txtKey = [NSNumber numberWithInt:pickerView.tag];
		[pickerTextFieldMap setObject:textFieldRounded forKey:txtKey];
		
		int count = [field countParameters];
		bool found = false;
		
		for(int i =0; i < count; i++){
			NSString* pickParameter = [[field getParameterByNumber:i] retain];
			if ([pickParameter isEqualToString: value]) {
				textFieldRounded.placeholder = value;  //place holder
				[pickerView selectRow:i inComponent:0 animated:YES];
				found = true;
				break;
			}
		}
		if (!found) {
			textFieldRounded.placeholder = @"Seleccione";  //place holder
		}
		
		if(firstProfile == FALSE){
			pickerView.userInteractionEnabled = NO;
		}
		
		[textFieldRounded release];
		[pickerView release];
		
		return labelHeigth + kFormSeparatorHeight + kFormTextFieldHeight + kFormSeparatorHeight; 
	}
}


/**
 * Hides the popView when user touch background
 */
-(IBAction) backgroundTouched:(id)sender {
	popView.hidden = TRUE;
}

/**
 * Add password field
 *
 * @param field 
 * @param ypos Coordinate y
 * @param value
 *
 * @return Heigh field 
 */
-(float) addPasswordField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value {
	float labelHeigth = [self addLabel:field ypos:ypos];
	float textFieldYPos = 0;
	
	if ([eMobcViewController isIPad]) {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeightiPad;
    } else {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeight;
    }

	//UITextField *textFieldRounded;
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginiPadLandscape, textFieldYPos, kFormTextFieldWidthiPad, kFormTextFieldHeightiPad)];
		}else{
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginiPad, textFieldYPos, kFormTextFieldWidthiPad, kFormTextFieldHeightiPad)];
		}
		
		textFieldRounded.font = [UIFont systemFontOfSize:24.0];  //font size
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginLandscape, textFieldYPos, kFormTextFieldWidth, kFormTextFieldHeight)];
		}else{
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMargin, textFieldYPos, kFormTextFieldWidth, kFormTextFieldHeight)];
		}
		
		textFieldRounded.font = [UIFont systemFontOfSize:17.0];  //font size
	}
	
	textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
	textFieldRounded.textColor = [UIColor blackColor]; //text color
	//textFieldRounded.placeholder = @"<enter text>";  //place holder
	textFieldRounded.backgroundColor = [UIColor clearColor]; //background color
	textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	textFieldRounded.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
	textFieldRounded.returnKeyType = UIReturnKeyDone;  // type of the return key
	
	textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	textFieldRounded.delegate = self;
	textFieldRounded.secureTextEntry = YES; 
	
	
	if(firstProfile == FALSE){
		textFieldRounded.userInteractionEnabled = NO;
	}
	
	
	[scrollView addSubview:textFieldRounded];
	
	[formFields addObject:textFieldRounded];
	
	//[label release];
	[textFieldRounded release];
	return 60;
}

/**
 * Add a special text field.
 * It's going to add different type of textField depend on a given type
 *
 * @param field 
 * @param ypos Coordinate y
 * @param value
 * @param keyboardType type text field
 *
 * @return Heigh field
 */
-(float) addTextFieldOfType:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value keyboardType:(UIKeyboardType)keyboardType {	
	float labelHeigth = [self addLabel:field ypos:ypos];
	float textFieldYPos = 0;
  //  UITextField * textFieldRounded;
    
    if ([eMobcViewController isIPad]) {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeightiPad;
        
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginiPadLandscape, textFieldYPos, kFormTextFieldWidthiPad, kFormTextFieldHeightiPad)];
		}else{
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginiPad, textFieldYPos, kFormTextFieldWidthiPad, kFormTextFieldHeightiPad)];
		}

        textFieldRounded.font = [UIFont systemFontOfSize:24.0];  //font size
    } else {
        textFieldYPos = ypos + labelHeigth + kFormSeparatorHeight;
		
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMarginLandscape, textFieldYPos, kFormTextFieldWidth, kFormTextFieldHeight)];
		}else{
			textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(kFormLeftMargin, textFieldYPos, kFormTextFieldWidth, kFormTextFieldHeight)];
		}
		
        textFieldRounded.font = [UIFont systemFontOfSize:17.0];  //font size
    }
	
	textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
	textFieldRounded.textColor = [UIColor blackColor]; //text color

	//textFieldRounded.placeholder = @"<enter text>";  //place holder
	NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
	textFieldRounded.backgroundColor = [UIColor clearColor]; //background color    
	    if ([iosVersion intValue] >= 5)
	        textFieldRounded.backgroundColor = [UIColor whiteColor];
	textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	textFieldRounded.keyboardType = keyboardType;  // type of the keyboard
	textFieldRounded.returnKeyType = UIReturnKeyDone;  // type of the return key
	
	textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	textFieldRounded.delegate = self;
	textFieldRounded.text = value;
	
	[scrollView addSubview:textFieldRounded];
	
	[formFields addObject:textFieldRounded];
	
	[textFieldRounded release];
	
	if(firstProfile == FALSE){
		textFieldRounded.userInteractionEnabled = NO;
	}
	
	if ([eMobcViewController isIPad]) {
        return labelHeigth + kFormSeparatorHeightiPad + kFormTextFieldHeightiPad + kFormSeparatorHeightiPad;
    } else {
        return labelHeigth + kFormSeparatorHeight + kFormTextFieldHeight + kFormSeparatorHeight;
    }
}

/**
 * Add submit button
 *
 * @param ypos Coordinate y
 *
 * @return Heigh button
 *
 * @see submitPressed
 */
-(float) addButtonSubmit:(float) ypos{
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];	
	
	UIImage *img;
	
	if(firstProfile == FALSE){
		//Editar
		if ([eMobcViewController isIPad]) {
			
			button.frame = CGRectMake(kFormLeftMarginiPad, ypos, kFormSubmitButtonWidthiPad, kFormSubmitButtonHeightiPad);
			//img = [UIImage imageNamed:[NSString stringWithFormat:@"images/form/enviar-iPad.png"]];
			[button setTitle:@"Editar" forState:UIControlStateNormal];
		} else { 
			button.frame = CGRectMake(kFormLeftMargin, ypos, kFormSubmitButtonWidth, kFormSubmitButtonHeight);
			//img = [UIImage imageNamed:[NSString stringWithFormat:@"images/form/enviar.png"]];
			[button setTitle:@"Editar" forState:UIControlStateNormal];
		}
	}else{
		//Guardar
		if ([eMobcViewController isIPad]) {
			button.frame = CGRectMake(kFormLeftMarginiPad, ypos, kFormSubmitButtonWidthiPad, kFormSubmitButtonHeightiPad);
			//img = [UIImage imageNamed:[NSString stringWithFormat:@"images/form/enviar-iPad.png"]];
			[button setTitle:@"Guardar" forState:UIControlStateNormal];
		} else { 
			button.frame = CGRectMake(kFormLeftMargin, ypos, kFormSubmitButtonWidth, kFormSubmitButtonHeight);
			//img = [UIImage imageNamed:[NSString stringWithFormat:@"images/form/enviar.png"]];
			[button setTitle:@"Guardar" forState:UIControlStateNormal];
		}
		//[button setImage:img forState:UIControlStateNormal];
	}
		
	if(firstProfile == FALSE){
		[button addTarget:self action:@selector(enabledField) forControlEvents:UIControlEventTouchUpInside];
	}else{
		[button addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
		
	[scrollView addSubview:button];
	
	return kFormSubmitButtonHeight;	
}


#pragma mark Deferred image loading (UIScrollViewDelegate)

/**
 * Tells the delegate when dragging ended in the scroll view
 *
 * @param scrollView he scroll-view object that finished scrolling the content view
 * @param decelerate YES if the scrolling movement will continue, but decelerate, after a touch-up gesture during a dragging operation. 
 *  If the value is NO, scrolling stops immediately upon touch-up.
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
}


/**
 * Tells the delegate that the scroll view has ended decelerating the scrolling movement.
 *
 * @param scrollView The scroll-view object that is decelerating the scrolling of the content view. 
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
}

/**
 * 
 *
 * @param parameters
 *
 * @return
 */
-(bool) createParameterFromForm:(NSMutableDictionary*)parameters {
	int count = [formFields count];
	
	/*if (data.parentNextLevel != nil) {
		[parameters setObject:data.parentNextLevel.levelId forKey:@"levelId"];
		[parameters setObject:data.parentNextLevel.dataId forKey:@"dataId"];
	}*/
	
	for(int i=0; i < count;i++){
		UIControl *field = [formFields objectAtIndex:i];
		if (field != nil) {			
			NwAppField* theField = [profile.fieldsProfile objectAtIndex:i];
			if (theField != nil) {				
				if ([field isKindOfClass:[UITextField class]]){
					UITextField *textField = (UITextField*)field;					
					if(textField.text == nil || [textField.text length] == 0) {
						if (theField.required == TRUE) {
							[textField becomeFirstResponder];
							return FALSE;			
						}
					}else {												
						[parameters setObject:textField.text forKey:theField.fieldName];
					}					
				}else if ([field isKindOfClass:[UITextView class]]) {
					UITextView *textView = (UITextView*)field;					
					if(textView.text == nil || [textView.text length] == 0) {
						if (theField.required == TRUE) {
							[textView becomeFirstResponder];
							return FALSE;			
						}
					}else {						
						[parameters setObject:textView.text forKey:theField.fieldName];
					}					
				}else if ([field isKindOfClass:[UISwitch class]]) {
					UISwitch* onoff = (UISwitch*)field;
					
					if (onoff.on) {
						[parameters setObject:@"true" forKey:theField.fieldName];
					}else {
						[parameters setObject:@"false" forKey:theField.fieldName];
					}
				}else if ([field isKindOfClass:[UIPickerView class]]) {
					UIPickerView* picker = (UIPickerView*)field;
					NSInteger row = [picker selectedRowInComponent:0];
					
					NSString* value = [theField.parameters objectAtIndex:row];
					
					[parameters setObject:value forKey:theField.fieldName];
				}else if ([field isKindOfClass:[UIImageView class]]) {
					//NSData *imageData = UIImageJPEGRepresentation(imageView.image, 90);
					//[parameters appendString:theField.fieldName];
					//[parameters appendString:@"="];
					//[parameters appendData:[NSString stringWithFormat:@"%@",imageData] dataUsingEncoding:NSUTF8StringEncoding]]
				}	
			}
		}
	}
	return TRUE;
}


/**
 * Save file if get method is used
 * 
 * @param parameters
 *
 * @return file name saved
 */
/*-(NSString*) saveFileFromGetUrl:(NSMutableDictionary*) parameters {
	NSMutableString* strParams = [NSMutableString new];
	bool first = true;
	
	for (id key in parameters) {
		NSString* value = [parameters objectForKey:key];
		
		if (!first) {
			[strParams appendString:@"&"];
		}
		[strParams appendString:key];
		[strParams appendString:@"="];
		[strParams appendString:value];
		first = false;
	}
	
	
	NSMutableString* actionUrl = [NSMutableString new];	
	[actionUrl appendString:data.actionUrl];
	[actionUrl appendString:@"?"];
	[actionUrl appendString:strParams];
	
	NSError *err = [[[NSError alloc] init] autorelease];
	NSString *url = [[NSString stringWithFormat:actionUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
	if(err.code != 0) {
		//HANDLE ERROR HERE
	}
	
	nroDownload++;
	NSString *fileName = [NSString stringWithFormat:@"File%d.xml", nroDownload];
	
	[[NSUserDefaults standardUserDefaults] setObject:myTxtFile forKey:fileName];
	
	return fileName;
}*/


/**
 * Save file if post method is used 
 * 
 * @param parameters
 *
 * @return file name saved
 */

-(NSString*) saveFileFromPostUrl:(NSMutableDictionary*) parameters {
	NSMutableString* strParams = [NSMutableString new];
	bool first = true;
	
	for (id key in parameters) {
		NSString* value = [parameters objectForKey:key];
		
		if (!first) {
			[strParams appendString:@"&"];
		}
		[strParams appendString:key];
		[strParams appendString:@"="];
		[strParams appendString:value];
		first = false;
	}
	
	NSData *postData = [strParams dataUsingEncoding:NSUTF8StringEncoding 
							   allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	//[request setURL:[NSURL URLWithString:data.actionUrl]];
	[request setHTTPMethod:@"POST"];
	
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	NSError *error;
	NSURLResponse *response;
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	NSString *postReturnData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
	
	nroDownload++;
	NSString *fileName = [NSString stringWithFormat:@"File%d.xml", nroDownload];
	
	[[NSUserDefaults standardUserDefaults] setObject:postReturnData forKey:fileName];
	
	return fileName;
}


/**
 * Save file from URL
 * 
 * @param urlString
 *
 * @return file name
 */
-(NSString*) saveFileFromUrl:(NSString*)urlString {
	NSError *err = [[[NSError alloc] init] autorelease];
	NSString *url = [[NSString stringWithFormat:urlString] 
					 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&err];
	if(err.code != 0) {
		//HANDLE ERROR HERE
	}
	
	nroDownload++;
	NSString *fileName = [NSString stringWithFormat:@"File%d.xml", nroDownload];
	
	[[NSUserDefaults standardUserDefaults] setObject:myTxtFile forKey:fileName];
	
	return fileName;
}


/**
 * Save file into a local directory
 * 
 * @param parameters
 */
-(void) saveFormData:(NSMutableDictionary*) parameters {	
	NSString *cachedFileName;
	cachedFileName = [NSString stringWithFormat:@"Form_Profile.data"];
	
	// Guardamos el archivo en local
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:cachedFileName];
	NSLog(@"Saving %@ to %@.", cachedFileName, path);
	
	[parameters writeToFile:path atomically: YES];
	
	UIAlertView *alertDialog;
	alertDialog = [[UIAlertView alloc]
				   initWithTitle:@"eMobc"
				   message:@"Tus datos se han guardado correctamente."
				   delegate:nil 
				   cancelButtonTitle:@"Ok"
				   otherButtonTitles:nil];
	
	[alertDialog show];
	[alertDialog release];
	
	if(firstProfile == TRUE && sw == 0){
		[mainController loadCover];
	}
}


/**
 * Read data from a local file
 * 
 * @return Devuelve un array con el directorio y nombre del fichero.
 */
-(NSMutableDictionary*) readFormData {
	NSString *cachedFileName;

	cachedFileName = [NSString stringWithFormat:@"Form_Profile.data"];
	
	// Guardamos el archivo en local
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *path = [documentsDirectory stringByAppendingPathComponent:cachedFileName];
	
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	return plistDict;
}

/**
 * Take a image
 */
-(IBAction)takePicturePressed:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
	
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		[imagePickerController setAllowsEditing:YES];
		imagePickerController.showsCameraControls = YES;
		
		if([eMobcViewController isIPad]){
			UIPopoverController *tempPopOver = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
			[tempPopOver presentPopoverFromRect:CGRectMake(0, 0, 768, 1024) 
										 inView:[self view]
					   permittedArrowDirections: UIPopoverArrowDirectionAny
									   animated:YES];
		}else{
			[self presentModalViewController:imagePickerController animated:YES];
		}
		
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accesing camera" message:@"Device does not support a camera" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

/**
 * Select images
 * 
 * @return Array with the directory and file name
 */
-(IBAction)selectPicturePressed:(id)sender {
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
		
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		//imagePickerController.navigationBar.opaque = true;
		[imagePickerController setAllowsEditing:YES];
		
		
		if([eMobcViewController isIPad]){
			UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
			
			[popover presentPopoverFromRect:CGRectMake(0, 0, 320, 480)
									 inView:self.view
				   permittedArrowDirections:UIPopoverArrowDirectionRight
								   animated:NO];
			
		}else{ 
			[self presentModalViewController:imagePickerController animated:YES];
		}
		
	}else{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accesing photo library" message:@"Device does not support a photo library" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}


/**
 * Called when submit button is pressed
 */
-(IBAction)submitPressed:(id)sender {
	int count = [formFields count];
	
	for(int i=0; i < count;i++){
		UIControl *field = [formFields objectAtIndex:i];
		if (field != nil) {
			[field resignFirstResponder];
		}
	}
	
	[self submitDynamic];
	[self resignFirstResponder];
}

-(void) enabledField {
	sw = 1;
	NSLog(@"sw 3: %d",sw);
	firstProfile = TRUE;
	[self loadForm];
}


/**
 * Submit static button 
 */
-(void) submitStatic {
	NSMutableString* formDataId = [NSMutableString new];
	
	NSMutableDictionary* parameters = [[NSMutableDictionary dictionary] init];	
	
	if ([self createParameterFromForm:parameters]) {				
		if ([self createDataIdFromForm:formDataId]) {
			[self saveFormData:parameters];
			[self startSpinner];
			
			//data.nextLevel.dataId = [formDataId lowercaseString];
			//[mainController loadNextLevel:data.nextLevel];	
		}else {
			[self missingFieldsAlert];
		}		
	}else {
		[self missingFieldsAlert];
	}	
}


/**
 * Submit static button 
 *
 * @see submitParameters
 */
-(void) submitDynamic {	
	if (imageView != nil) {
		[self sendImageViewToServer];
	}
	
	NSMutableDictionary* parameters = [[NSMutableDictionary dictionary] init];	
	
	if ([self createParameterFromForm:parameters]) {		
		[self startSpinner];
		
		[self performSelectorOnMainThread:@selector(submitParameters:)
							   withObject:parameters 
							waitUntilDone:FALSE];
		
	}else {
		[self missingFieldsAlert];
	}
}

/**
 * Send images to server
 */

-(void) sendImageViewToServer {
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 90
	 */
	
	NSData *imageData = UIImageJPEGRepresentation(imageView.image, 90);
	// setting up the URL to post to
	//NSString *urlString = data.actionUrl;
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	
	//[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */

	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */

	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"rn--%@rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"image.jpg\"rn"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-streamrnrn"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"rn--%@--rn",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}



/**
 * Alerts to show into form fields
 */
-(void) missingFieldsAlert {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campos del Formulario" 
													message:@"Alguno de los campos obligatorios no han sido rellenados" 
												   delegate:self 
										  cancelButtonTitle:@"Aceptar" 
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];			
}

-(bool) createDataIdFromForm:(NSMutableString*)formDataId {
	int count = [formFields count];
	bool firstParam = TRUE;
	
	for(int i=0; i < count;i++){
		UIControl *field = [formFields objectAtIndex:i];
		if (field != nil) {			
			NwAppField* theField = [profile.fieldsProfile objectAtIndex:i];
			if (theField != nil) {				
				if ([field isKindOfClass:[UITextField class]]){
					UITextField *textField = (UITextField*)field;					
					if(textField.text == nil || [textField.text length] == 0) {
						if (theField.required == TRUE) {
							[textField becomeFirstResponder];
							return FALSE;			
						}
					}else {						
						if (firstParam) {
							firstParam = FALSE;
						}else {
							[formDataId appendString:@"_"];
						}
						
						[formDataId appendString:textField.text];
					}					
				}else if ([field isKindOfClass:[UITextView class]]) {
					UITextView *textView = (UITextView*)field;					
					if(textView.text == nil || [textView.text length] == 0) {
						if (theField.required == TRUE) {
							[textView becomeFirstResponder];
							return FALSE;			
						}
					}else {						
						if (firstParam) {
							firstParam = FALSE;
						}else {
							[formDataId appendString:@"_"];
						}
						
						[formDataId appendString:textView.text];
					}										
				}else if ([field isKindOfClass:[UISwitch class]]) {
					UISwitch* onoff = (UISwitch*)field;
					if (firstParam) {
						firstParam = FALSE;
					}else {
						[formDataId appendString:@"_"];
					}
					
					if (onoff.on) {
						[formDataId appendString:@"true"];
					}else {
						[formDataId appendString:@"false"];
					}
				}else if ([field isKindOfClass:[UIPickerView class]]) {
					UIPickerView* picker = (UIPickerView*)field;
					NSInteger row = [picker selectedRowInComponent:0];
					
					NSString* value = [theField.parameters objectAtIndex:row];
					if (firstParam) {
						firstParam = FALSE;
					}else {
						[formDataId appendString:@"_"];
					}
					[formDataId appendString:value];
				}	
			}
		}
	}
	return TRUE;
	
}

/**
 * Save file into device from URL. 
 * If everything is ok we'll add with levels App
 *
 * @param parameters
 *
 * @see loadNextLevel
 * @see removeSpinner
 */
-(void)submitParameters:(NSMutableDictionary*)parameters {
	// Save file into device from URL
	//NSString* fileName = [self saveFileFromGetUrl:parameters];
	NSString* fileName = [self saveFileFromPostUrl:parameters];
	
	// Si está todo OK leemos el archivo y lo agregamos a los levels de la App
	if (fileName != nil) {
		NSString *myTxtFile2 = [[NSUserDefaults standardUserDefaults] stringForKey:fileName];
		NSLog(@"File: %@", myTxtFile2);
		
		NSData* theData = [myTxtFile2 dataUsingEncoding:NSUTF8StringEncoding];
		AppParser* appParser = [[AppParser alloc] init];
		[appParser parseXMLFileFromData:theData];
		
		ApplicationData *appData = appParser.currentApplicationDataObject;
		[appParser release];
		
		theAppData = [[NwUtil instance] readApplicationData];
		
		int count = [appData getLevelsCount];
		for(int i=0; i < count;i++){
			AppLevel* theLevel = [appData getLevelByNumber:i];
			theLevel.file.neverCached = true;
			/*
			 Esto estaba porque no había cache, entonces se bajaba
			 el archivo y se creaba un AppLevel con el archivo en local.
			 Ahora se usa el cache y ya no es necesario bajarlo.
			 NSString* levelFileName = [self saveFileFromUrl:theLevel.fileName];
			 
			 AppLevel* newLevel = [[AppLevel alloc] init];
			 
			 newLevel.levelId = theLevel.levelId;
			 newLevel.title = theLevel.title;
			 newLevel.fileName = levelFileName;
			 newLevel.type = theLevel.type;
			 newLevel.isLocal = true;
			 
			 [theAppData addLevel:newLevel];
			 */
			[theAppData addLevel:theLevel];
		}
		
		[self saveFormData:parameters];
		
		// Finalmente nos movemos al próximo nivel 
		[self startSpinner];
		//[mainController loadNextLevel:data.nextLevel];	
	}else {
		NSLog(@"Error al guardar el archivo con parámetros: %@", parameters);
	}
	
	[self removeSpinner];
}


-(void)dismissActionSheet:(id)sender {
    [currentActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate

/**
 * Tells the delegate that editing of the specified text view has ended
 *
 * @param textView The text view in which editing ended
 */
-(void)textViewDidEndEditing:(UITextView *)textView {
	[textView resignFirstResponder];
	popView.hidden = TRUE;
}


/**
 * Asks the delegate whether the specified text should be replaced in the text view.
 *
 * @param textView The text view containing the changes.
 * @param range The current selection range. If the length of the range is 0, range reflects the current insertion point. 
 *  If the user presses the Delete key, the length of the range is 1 and an empty string object replaces that single character.
 * @param text The text to insert
 *
 * @return YES if the old text should be replaced by the new text; NO if the replacement operation should be aborted.
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}


#pragma mark -
#pragma mark UITextFieldDelegate

/**
 * Asks the delegate if editing should begin in the specified text field.
 *
 * @param The text field for which editing is about to begin.
 *
 * @return YES if an editing session should be initiated; otherwise, NO to disallow editing.
 */
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField.tag != 0) {
		int index = textField.tag - 1;
		
		popView.hidden = FALSE;
		//UIPickerView* picker = [pickersList objectAtIndex:index];
		//
		//textField.hidden = TRUE;
		//picker.hidden = FALSE;
		//
		//[scrollView bringSubviewToFront:picker];
		
		if(![eMobcViewController isIPad]){
			UIActionSheet *actionSheet = [pickersList objectAtIndex:index];
			
			currentActionSheet = actionSheet;
			
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				[actionSheet showInView:scrollView];
				[actionSheet setBounds:CGRectMake(80, 0, 320, 300)];
			}else{
				[actionSheet showInView:scrollView];
				[actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
			}
		}
		return FALSE;
	}
	return TRUE;
}

/**
 * Tells the delegate that editing began for the specified text field.
 *
 * @param textField The text field for which an editing session began.
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField {
	CGPoint point = CGPointMake(0, textField.frame.origin.y);
	
	[scrollView setContentOffset:point animated:YES];
	
	popView.hidden = TRUE;
}

/**
 * Tells the delegate that editing stopped for the specified text field
 *
 * @param textField The text field for which editing ended
 */
-(void)textFieldDidEndEditing:(UITextField *)textField {
	[textField resignFirstResponder];
}


/**
 * Asks the delegate if the text field should process the pressing of the return button
 *
 * @param textField The text field whose return button was pressed.
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark UIPickerView Data Source
/**
 * Called by the picker view when it needs the number of components
 *
 * @param pickerView The picker view requesting the data
 *
 * @return The number of components (or “columns”) that the picker view should display
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

/**
 * Called by the picker view when it needs the number of rows for a specified component
 *
 * @param pickerView The picker view requesting the data
 * @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right
 *
 * @return The number of rows for the component
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {	
	NwAppField* theField = [profile.fieldsProfile objectAtIndex:pickerView.tag];
	
	if (theField != nil) {
		return [theField countParameters];
	}
	
    return 0;
}

#pragma mark -
#pragma mark UIPickerView Delegate

/**
 * Called by the picker view when it needs the row width to use for drawing row content
 *
 * @param pickerView The picker view requesting this information
 * @param component A zero-indexed number identifying a component of the picker view. Components are numbered left-to-right.
 * 
 * @return A float value indicating the width of the row in points.
 */
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	int sectionWidth = 300;
	
	return sectionWidth;
}


/**
 * Called by the picker view when it needs the title to use for a given row in a given component.
 *
 * @param pickerView An object representing the picker view requesting the data
 * @param row A zero-indexed number identifying a row of component. Rows are numbered top-to-bottom 
 * @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right
 *
 * @return The string to use as the title of the indicated component row
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NwAppField* theField = [profile.fieldsProfile objectAtIndex:pickerView.tag];
	
	if (theField != nil) {
		NSString* pickParameter = [[theField getParameterByNumber:row] retain];
		NSLog(@"Pick Parameter: %@", pickParameter);
		return pickParameter;
	}
	
    return @"Err";
}

/**
 * Called by the picker view when the user selects a row in a component.
 *
 * @param pickerView An object representing the picker view requesting the data
 * @param row A zero-indexed number identifying a row of component. Rows are numbered top-to-bottom.
 * @param component A zero-indexed number identifying a component of pickerView. Components are numbered left-to-right.
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
	NwAppField* theField = [profile.fieldsProfile objectAtIndex:pickerView.tag];
	
	NSNumber* txtKey = [NSNumber numberWithInt:pickerView.tag];
	UITextField* textField = [pickerTextFieldMap objectForKey:txtKey];
	textField.placeholder = [theField.parameters objectAtIndex:row];
	
	//	textField.hidden = FALSE;
	//	pickerView.hidden = TRUE;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

/**
 * Tells the delegate that the user picked a still image or movie
 *
 * @param picker The controller object managing the image picker interface.
 * @param info  dictionary containing the original image and the edited image, if an image was picked; 
 * or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	if([eMobcViewController isIPad]){
		[imagePickerController release];
	}else{
		[imagePickerController dismissModalViewControllerAnimated:YES];
	}
	
	[picker dismissModalViewControllerAnimated:YES];
	
	imagePickerController.view.hidden = NO;
    imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageView.hidden = NO;
	
    [self.view bringSubviewToFront:imageView];	
}

/**
 * Tells the delegate that the user cancelled the pick operation.
 *
 * @param picker The controller object managing the image picker interface
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker dismissModalViewControllerAnimated:YES];
}


/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 *
 * @param interfaceOrientation The orientation of the application’s user interface after the rotation. 
 * The possible values are described in UIInterfaceOrientation.
 *
 * @return YES if the view controller supports the specified orientation or NO if it does not
 */
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
    return YES;
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
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSFileManager *gestorArchivos = [NSFileManager defaultManager];
		NSString *rutaArchivo = [documentsDirectory stringByAppendingPathComponent:@"Form_Profile.data"];
		
		if([gestorArchivos fileExistsAtPath:rutaArchivo]){
			
			if(![mainController.appData.backgroundMenu isEqualToString:@""]){
				[self loadBackgroundMenu];
			}
			
			if(varStyles != nil) {
				[self loadThemes];
			}
			
			if(![mainController.appData.topMenu isEqualToString:@""]) {
				[self callTopMenu];
			}
			
			if(![mainController.appData.bottomMenu isEqualToString:@""]) {
				[self callBottomMenu];
			}
			
			//publicity
			if([mainController.appData.banner isEqualToString:@"admob"]){
				[self createAdmobBanner];
			}else if([mainController.appData.banner isEqualToString:@"yoc"]){
				[self createYocBanner];
			}
		}
	
		[self loadForm];
	}	
}


-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	if(imagePickerController != nil && 768 > 0)
		[imagePickerController.view setFrame:imagePickerController.view.superview.frame];
}

@end