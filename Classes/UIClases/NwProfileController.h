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
#import "ProfileLevelData.h"
#import "NwController.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"
#import "ApplicationData.h"

@interface NwProfileController : NwController <
						UIScrollViewDelegate, 
						UITextFieldDelegate, 
						UITextViewDelegate, 
						UIPickerViewDelegate, 
						UIImagePickerControllerDelegate,
						UINavigationControllerDelegate> {

//Variables
	int nroDownload;
	bool keyboardIsShown;					

//Objetos
						
	ProfileLevelData* profile;
	NSMutableArray *formFields;
	NSMutableArray *pickersList;
	NSMutableDictionary* pickerTextFieldMap;
							
//Outlets
	UIScrollView* scrollView;
	UIImagePickerController* imagePickerController;
	UIImageView* imageView;
	UIActionSheet* currentActionSheet;		
							
	UIView* popView;
							
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
							
	ApplicationData* theAppData;
							
	UIDeviceOrientation currentOrientation;
							
	bool loadContent;
							
	bool firstProfile;
	
	//Field form
	UITextView* textViewRounded;
							
	UITextField* textFieldRounded;
							
	int sw;
							
}

@property(nonatomic, retain) ProfileLevelData* profile;
@property(nonatomic, retain) UIScrollView* scrollView;
@property(nonatomic, retain) UIImagePickerController* imagePickerController;

@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;

@property(nonatomic, retain) UITextView* textFieldRounded;

-(float) addField:(NwAppField*)field ypos:(float) ypos withValue:(NSString*) value;
-(float) addLabel:(NwAppField*)field ypos:(float) ypos;
-(float) addTextField:(NwAppField*)field ypos:(float) ypos withValue:(NSString*) value;
-(float) addTextViewField:(NwAppField*)field ypos:(float) ypos withValue:(NSString*) value;
-(float) addNumericField:(NwAppField*)field ypos:(float) ypos withValue:(NSString*) value;
-(float) addPhoneField:(NwAppField*)field ypos:(float) ypos withValue:(NSString*) value;
-(float) addEmailField:(NwAppField*)field ypos:(float) ypos withValue:(NSString*) value;
-(float) addCheckField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value;
-(float) addPickerField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value;
-(float) addPasswordField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value;
-(float) addImageField:(NwAppField*)field ypos:(float)ypos withValue:(NSString*) value;
-(float) addTextFieldOfType:(NwAppField*)field ypos:(float) ypos withValue:(NSString*) value keyboardType:(UIKeyboardType)keyboardType;
-(float) addButtonSubmit:(float) ypos;

//Acciones
	-(IBAction)submitPressed:(id)sender;
	-(IBAction)takePicturePressed:(id)sender;
	-(IBAction)selectPicturePressed:(id)sender;

//Metodos
	-(NSString*) saveFileFromGetUrl:(NSMutableDictionary*) urlParameters;
	-(NSString*) saveFileFromPostUrl:(NSMutableDictionary*) urlParameters;
	-(void) saveFormData:(NSMutableDictionary*) parameters;
	-(NSMutableDictionary*) readFormData;
	
	-(NSString*) saveFileFromUrl:(NSString*)urlString;

	-(bool) createParameterFromForm:(NSMutableDictionary*)parameters;
	-(bool) createDataIdFromForm:(NSMutableString*)formDataId;

	-(void) submitStatic;
	-(void) submitDynamic;
	-(void) missingFieldsAlert;
	-(void) sendImageViewToServer;

	-(void) loadForm;

	-(void) loadThemesComponents;
	-(void) loadThemes;

	-(void) enabledField;

@end