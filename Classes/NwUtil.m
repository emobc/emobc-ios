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

#import "NwUtil.h"
#import "AppParser.h"
#import "CoverParser.h"
#import "TopMenuParser.h"
#import "BottomMenuparser.h"
#import "ImageDescriptionParser.h"
#import "ImageListParser.h"
#import "ListParser.h"
#import "ImageGalleryParser.h"
#import "ImageZoomParser.h"
#import "ButtonsParser.h"
#import "FormParser.h"
#import "MapParser.h"
#import "VideoParser.h"
#import "WebParser.h"
#import "PdfParser.h"
#import "QRParser.h"
#import "CalendarParser.h"
#import "QuizParser.h"
#import "CanvasParser.h"
#import "AudioParser.h"
#import "FormatsParser.h"
#import "StylesParser.h"

#import "ProfileParser.h"

@implementation NwUtil

@synthesize theAppData;
@synthesize theCover;
@synthesize theTopMenu;
@synthesize theBottomMenu;
@synthesize theFormatsStyles;
@synthesize theStyles;
@synthesize theProfile;
@synthesize formData;

+(id) instance {
	static NwUtil* sharedSingleton;
	
	@synchronized(self) {
		if (!sharedSingleton)
			sharedSingleton = [[NwUtil alloc] init];
		
		return sharedSingleton;
	}
}

-(id)init {
    if (self = [super init]) {    
		theAppData = nil;
		theCover = nil;
		theTopMenu = nil;
		theBottomMenu = nil;
		theFormatsStyles = nil;
		theStyles = nil;
		theProfile = nil;
	}	

	return self;
}

/**
 * Read app.xml data
 *
 * @return read data
 */
-(ApplicationData *) readApplicationData {	
	
	if (theAppData == nil) {
		NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"app.xml"];
		
		AppParser* appParser = [[AppParser alloc] init];
		[appParser parseXMLFileAtURL:path];
		
		theAppData = appParser.currentApplicationDataObject;
		[appParser release];
	}
	
	return theAppData;
}

/**
 * Read cover.xml data
 *
 * @return read data
 */
-(Cover*) readCover {
	if (theCover == nil) {
		ApplicationData *appData = [self readApplicationData];
		
		NSString *coverPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:appData.coverFileName];
		CoverParser* coverParser = [[CoverParser alloc] init];
		[coverParser parseXMLFileAtURL:coverPath];
		
		theCover = coverParser.cover;
		[coverParser release];
	}
	return theCover;
}

/**
 * Read formats.xml data
 *
 * @return read data
 */
-(FormatsStylesLevelData*) readFormats{
	if(theFormatsStyles == nil){
		ApplicationData *appData = [self readApplicationData];

		NSString *formatsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:appData.formatsFileName];
		FormatsParser* formatsParser = [[FormatsParser alloc] init];
		[formatsParser parseXMLFileAtURL:formatsPath];
		
		theFormatsStyles = formatsParser.format;
		[formatsParser release];
	}
	return theFormatsStyles;
}

/**
 * Read styles.xml data
 *
 * @return read data
 */
-(StylesLevelData*) readStyles {
	if(theStyles == nil){
		ApplicationData *appData = [self readApplicationData];
		
		NSString *stylesPath =[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:appData.stylesFileName];
		StylesParser* stylesParser = [[StylesParser alloc] init];
		[stylesParser parseXMLFileAtURL:stylesPath];
		
		theStyles = stylesParser.style;
		[stylesParser release];
	}
	return theStyles; 
}	

/**
 * Read profile.xml data
 *
 * @return read data
 */
-(ProfileLevelData*) readProfile {
	if (theProfile == nil) {
		ApplicationData *appData = [self readApplicationData];
		
		NSString *profilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:appData.profileFileName];
		ProfileParser* profileParser = [[ProfileParser alloc] init];
		[profileParser parseXMLFileAtURL:profilePath];
		
		theProfile = profileParser.profile;
		[profileParser release];
	}
	return theProfile;
}

/**
 * Read top_menu.xml data
 *
 * @return read data
 */
-(TopMenuData*) readTopMenu {
	
	if (theTopMenu == nil) {
		ApplicationData *appData = [self readApplicationData];
		
		NSString *topMenuPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:appData.topMenu];
		TopMenuParser* topMenuParser = [[TopMenuParser alloc] init];
		[topMenuParser parseXMLFileAtURL:topMenuPath];
		
		theTopMenu = topMenuParser.topMenu;
		[topMenuParser release];
	}
	return theTopMenu;
}

/**
 * Read bottom_menu.xml data
 *
 * @return read data
 */
-(BottomMenuData*) readBottomMenu {
	
	if (theBottomMenu == nil) {
		ApplicationData *appData = [self readApplicationData];
		
		NSString *bottomMenuPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:appData.bottomMenu];
		BottomMenuParser* bottomMenuParser = [[BottomMenuParser alloc] init];
		[bottomMenuParser parseXMLFileAtURL:bottomMenuPath];
		
		theBottomMenu = bottomMenuParser.bottomMenu;
		[bottomMenuParser release];
	}
	return theBottomMenu;
}

/**
 * Read app.xml data
 *
 * @return read data
 *
 * @see readAplicationData
 */
-(AppLevel*) readAppLevel:(NextLevel*)nextLevel {
	
	ApplicationData *appData = [self readApplicationData];
	AppLevel* theLevel = nil;

	if (nextLevel.levelId != nil) {
		theLevel = [appData getLevelById:nextLevel.levelId];
	}else {
		theLevel = [appData getLevelByNumber:nextLevel.levelNumber];
	}
	
	return theLevel;
}

/**
 * Depending on type view, we are going to call differents methods
 *
 * @param nextLevel
 *
 * @return Return LevelData differents for each view
 *
 * @see readImageTextDescriptionData
 * @see readImageListData
 * @see readImageGalleryData
 * @see readImageZoomData
 * @see readMapData
 * @see readVideoData
 * @see readWebData
 * @see readPdfData
 * @see readQRData
 */
-(DataItem*) readAppLevelData:(NextLevel*)nextLevel {
	
	AppLevel* theLevel = [self readAppLevel:nextLevel];
	DataItem* theData = nil;
	LoadUtil* util = nil;
	util = [[LoadUtil alloc] initWithValues:theLevel nextLevel:nextLevel];
	
	switch (theLevel.type) {
		case IMAGE_TEXT_DESCRIPTION_ACTIVITY:
			theData = [self readImageTextDescriptionData:theLevel nextLevel:nextLevel];	
			break;
		case IMAGE_LIST_ACTIVITY:
			theData = [self readImageListData:theLevel nextLevel:nextLevel];	
			break;
		case IMAGE_GALLERY_ACTIVITY:
			theData = [self readImageGalleryData:util];
			break;
		case IMAGE_ZOOM_ACTIVITY:
			theData = [self readImageZoomData:theLevel nextLevel:nextLevel];	
			break;
		case MAP_ACTIVITY:
			theData = [self readMapData:theLevel nextLevel:nextLevel];
			break;
		case VIDEO_ACTIVITY:
			theData = [self readVideoData:theLevel nextLevel:nextLevel];
			break;
		case WEB_ACTIVITY:
			theData = [self readWebData:theLevel nextLevel:nextLevel];
			break;
		case PDF_ACTIVITY:
			theData = [self readPdfData:theLevel nextLevel:nextLevel];
			break;
		case QR_ACTIVITY:
			theData = [self readQRData:theLevel nextLevel:nextLevel];
			break;
		case BUTTONS_ACTIVITY:
			theData = [self readButtonsData:theLevel nextLevel:nextLevel];
			break;
		case FORM_ACTIVITY:
			theData = [self readFormData:theLevel nextLevel:nextLevel];
			break;
		case LIST_ACTIVITY:
			theData = [self readListData:theLevel nextLevel:nextLevel];
			break;
		case CALENDAR_ACTIVITY:
			theData = [self readCalendarData:theLevel nextLevel:nextLevel];
			break;
		case QUIZ_ACTIVITY:
			theData = [self readQuizData:theLevel nextLevel:nextLevel];
			break;
		case CANVAS_ACTIVITY:
			theData = [self readCanvasData:theLevel nextLevel:nextLevel];
			break;
		case AUDIO_ACTIVITY:
			theData = [self readAudioData:theLevel nextLevel:nextLevel];
			break;
		default:
			break;
	}
	[util release];
	[theLevel release];	
	
	return theData;
}

/**
 * Read image_text_description.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return ImageTextDescription data
 */
-(ImageTextDescriptionLevelData*) readImageTextDescriptionData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	formData = [self readFormData];
	
	ImageDescriptionParser *parser = [[ImageDescriptionParser alloc] init];
	
	NSData* parseData;
	if (appLevel.useProfile == TRUE){
		parseData = [self readProfileAndPostData:appLevel nextLevel:nextLevel];
	} else{
		parseData = [appLevel.file content]; 
	}
	
	[parser parseXMLFileFromData:parseData];
		
	ImageTextDescriptionLevel* theLevel = (ImageTextDescriptionLevel*)parser.parsedLevel;
		
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
		
	return (ImageTextDescriptionLevelData*)theItem;
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
 *
 * Read and send a post
 *
 * @return Return a xml.
 *
 */
-(NSData*) readProfileAndPostData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel  {
	
	NSMutableString* strParams = [NSMutableString new];
	bool first = true;
	
	for (id key in formData) {
		NSString* value = [formData objectForKey:key];
		
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
	
	[request setURL:[NSURL URLWithString:appLevel.file.fileName]];
	[request setHTTPMethod:@"POST"];
	
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	[request setHTTPBody:postData];
	
	NSError *error;
	NSURLResponse *response;
	
	NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	return urlData;
}

/**
 * Read image_list.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return ImageList data
 */

-(ImageListLevelData*) readImageListData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	ImageListParser *parser = [[ImageListParser alloc] init];

	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	ImageListLevel* theLevel = (ImageListLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}

	[parser release];
	return (ImageListLevelData*)theItem;
}


/**
 * Read list.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return List data
 */
-(ListLevelData*) readListData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	ListParser *parser = [[ListParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	ListLevel* theLevel = (ListLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (ListLevelData*)theItem;
}

/**
 * Read image_zoom.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return ImageZoom data
 */
-(ImageZoomLevelData*) readImageZoomData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	ImageZoomParser *parser = [[ImageZoomParser alloc] init];

	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	ImageZoomLevel* theLevel = (ImageZoomLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}

	[parser release];
	return (ImageZoomLevelData*)theItem;
}


/**
 * Read image_gallery.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return ImageGallery data
 */
-(ImageGalleryLevelData*) readImageGalleryData:(LoadUtil*) util {
	ImageGalleryParser *parser = [[ImageGalleryParser alloc] init];
	
	NSData* parseData = [util.appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	ImageGalleryLevel* theLevel = (ImageGalleryLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (util.nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:util.nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:util.nextLevel.dataNumber];
	}
	
	[parser release];
	return (ImageGalleryLevelData*)theItem;
}


/**
 * Read buttons.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Buttons data
 */
-(ButtonsLevelData*) readButtonsData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	ButtonsParser *parser = [[ButtonsParser alloc] init];

	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];

	ButtonsLevel* theLevel = (ButtonsLevel*)parser.parsedLevel;	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}

	[parser release];
	return (ButtonsLevelData*)theItem;
	
}

/**
 * Read form.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Form data
 */-(FormLevelData*) readFormData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	FormParser *parser = [[FormParser alloc] init];

	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	FormLevel* theLevel = (FormLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (FormLevelData*)theItem;
}


/**
 * Read map.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Map data
 */
-(MapLevelData*) readMapData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	MapParser *parser = [[MapParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	MapLevel* theLevel = (MapLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}

	[parser release];
	return (MapLevelData*)theItem;
}


/**
 * Read video.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Video data
 */-(VideoLevelData*) readVideoData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	VideoParser *parser = [[VideoParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	VideoLevel* theLevel = (VideoLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (VideoLevelData*)theItem;
}


/**
 * Read web.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Web data
 */
-(WebLevelData*) readWebData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	WebParser *parser = [[WebParser alloc] init];

	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	WebLevel* theLevel = (WebLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (WebLevelData*)theItem;
}


/**
 * Read pdf.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Pdf data
 */
-(PdfLevelData*) readPdfData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	PdfParser *parser = [[PdfParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	PdfLevel* theLevel = (PdfLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (PdfLevelData*)theItem;
}


/**
 * Read lector_QR.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return QR data
 */
-(QRLevelData*) readQRData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	QRParser *parser = [[QRParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	QRLevel* theLevel = (QRLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (QRLevelData*)theItem;
}

/**
 * Read calendar.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Calendar data
 */
-(CalendarLevelData*) readCalendarData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	CalendarParser *parser = [[CalendarParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	CalendarLevel* theLevel = (CalendarLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (CalendarLevelData*)theItem;
}


/**
 * Read buttons.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Buttons data
 */
-(QuizLevelData*) readQuizData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	QuizParser *parser = [[QuizParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	QuizLevel* theLevel = (QuizLevel*)parser.parsedLevel;	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}
	
	[parser release];
	return (QuizLevelData*)theItem;
}

/**
 * Read canvas.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return Canvas data
 */
-(CanvasLevelData*) readCanvasData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	CanvasParser *parser = [[CanvasParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	CanvasLevel* theLevel = (CanvasLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (CanvasLevelData*)theItem;
}


/**
 * Read audio.xml
 *
 * @param appLevel Level View
 * @param nextLevel Next Level which this view can show
 *
 * @return audio data
 */
-(AudioLevelData*) readAudioData:(AppLevel*) appLevel nextLevel:(NextLevel*)nextLevel {
	AudioParser *parser = [[AudioParser alloc] init];
	
	NSData* parseData = [appLevel.file content]; 	
	[parser parseXMLFileFromData:parseData];
	
	AudioLevel* theLevel = (AudioLevel*)parser.parsedLevel;
	
	DataItem* theItem = nil;
	if (nextLevel.dataId != nil) {
		theItem = [theLevel dataItemById:nextLevel.dataId];
	}else {
		theItem = [theLevel dataItemByNumber:nextLevel.dataNumber];
	}
	
	[parser release];
	return (AudioLevelData*)theItem;
}



/**
 * Search all posibles matches from a text given into text framework
 *
 * @return Matched found
 */
-(NSMutableArray*) searchText:(NSString*)text {
	NSMutableArray* retArray = [[NSMutableArray alloc]init];
	
	ApplicationData * appData = [self readApplicationData];
	int levelCount = [appData getLevelsCount];
	
	for(int i=0;i < levelCount;i++){
		AppLevel* appLevel = [appData getLevelByNumber:i];
		
		NSArray *array = [appLevel searchText:text];
		[retArray addObjectsFromArray:array];
	}
	
	return retArray;
}

/**
 * Search all georeferences contained into framework
 *
 * @return georeferences list
 */
-(NSMutableArray*) findAllGeoReferences {
	NSMutableArray* retArray = [[NSMutableArray alloc]init];
	
	ApplicationData * appData = [self readApplicationData];
	int levelCount = [appData getLevelsCount];
	
	for(int i=0;i < levelCount;i++){
		AppLevel* appLevel = [appData getLevelByNumber:i];
		
		NSArray *array = [appLevel findAllGeoReferences];
		[retArray addObjectsFromArray:array];
	}
	
	return retArray;
}

/**
 * Search all images contained into framework
 *
 * @return images list
 */
-(NSMutableArray*) findAllImages {
	NSMutableArray* retArray = [[NSMutableArray alloc]init];
	
	ApplicationData * appData = [self readApplicationData];
	int levelCount = [appData getLevelsCount];
	
	for(int i=0;i < levelCount;i++){
		AppLevel* appLevel = [appData getLevelByNumber:i];
		
		NSArray *array = [appLevel findAllImages];
		[retArray addObjectsFromArray:array];
	}
	
	return retArray;
}

@end