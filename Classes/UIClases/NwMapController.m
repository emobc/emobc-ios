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

#import "NwMapController.h"
#import "CustomPlacemark.h"
#import "NwUtil.h"
#import "SearchItem.h"
#import "NwPlacemark.h"
#import "NwCustomPin.h"
//#import "SM3DAR.h"
#import "NwListNearPositionController.h"
#import "eMobcViewController.h"
#import "AppFormatsStyles.h"
#import "AppStyles.h"


@implementation NwMapController

@synthesize mapView;
@synthesize data;
@synthesize annotations;
@synthesize itemToGo;

@synthesize varStyles;
@synthesize varFormats;
@synthesize background;

@synthesize sizeTop;
@synthesize sizeBottom;
@synthesize sizeHeaderText;

@synthesize nearPosButton;
@synthesize imageSize;
 
/**
 * Returns a newly initialized view controller with the nib file in the specified bundle.
 *
 * @param nibNameOrNil he name of the nib file to associate with the view controller. 
 *  The nib file name should not contain any leading path information. If you specify nil, the nibName property is set to nil.
 *
 * @param nibBundleOrNil The bundle in which to search for the nib file. 
 *  This method looks for the nib file in the bundle's language-specific project directories first, followed by the Resources directory. 
 *  If nil, this method looks for the nib file in the main bundle.
 *
 * @return A newly initialized UIViewController object
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
		annotations = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	loadContent = FALSE;
	
	//Load de view into landScape orientation, when there was no movement in the device
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else{
		self.view = self.portraitView;
	}
	
	[self loadMapa];
	
}

/**
 * Load map in MKMapView 
 */
-(void) loadMapa{
	
	sizeTop = 0;
	sizeBottom = 0;
	sizeHeaderText = 25;
	
	sizeTop = [mainController ifMenuAndAdsTop:sizeTop];
	sizeBottom = [mainController ifMenuAndAdsBottom:sizeBottom];
	
	[self createMapView];
	
	[mapView setMapType:MKMapTypeHybrid];

    MKCoordinateRegion region;
	
	if (itemToGo == nil){
		region.center.latitude=40.3;
		region.center.longitude=-3.7;	
		region.span.latitudeDelta = 10.0;
		region.span.longitudeDelta = 10.0;		
	}else {
		region.center.latitude=itemToGo.lat;
		region.center.longitude=itemToGo.lon;	
		region.span.latitudeDelta = 2.0;
		region.span.longitudeDelta = 2.0;		
	}
		
	[mapView setRegion:region animated:YES];
	
	
	if(data != nil){
		
		varStyles = [mainController.theStyle.stylesMap objectForKey:@"MAP_ACTIVITY"];
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
		[self createButtonNear];
		
		
		if (data.showAllPositions == TRUE){
			NSMutableArray *searchArray = [[NwUtil instance] findAllGeoReferences];
			
			for (SearchItem* searchItem in searchArray){
				NextLevel *nextLevel = searchItem.nextLevel;
				[data.items addObject:searchItem.text];
				if (searchItem.text != nil)
					[forwardGeocoder findLocation:searchItem.text withNextLevel:nextLevel];
				
			}
			
			[searchArray release];
			searchArray = nil;
		}else{
			copyListOfItems = [[NSMutableArray alloc] init];
			[copyListOfItems addObjectsFromArray:data.items];
			
			[self loadMapItems];
		}	
		
	}
	
	mapView.showsUserLocation = YES;
	mapView.delegate=self;
	
	
    CLLocationCoordinate2D coordinate;
    
    if ([CLLocationManager locationServicesEnabled]){
		coordinate.latitude = self.mapView.userLocation.location.coordinate.latitude;
		coordinate.longitude = self.mapView.userLocation.location.coordinate.longitude;
    }
    
    //NSLog(@"Longitud: %f",  self.mapView.userLocation.location.coordinate.longitude);
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]; 
    
	NSMutableArray* tempItems = [[NSMutableArray alloc] init];
	
	for (MapItem* item in data.items){
		CLLocationDegrees itemLat = item.lat;
		CLLocationDegrees itemLon = item.lon;
		
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:itemLat 
													 longitude:itemLon];
		
		CLLocationDistance dist = [location distanceFromLocation:loc];
        
		NearUtil* util = [[NearUtil alloc] initWithDistance:item 
												   distance:dist];
		
		[tempItems addObject:util];
		[loc release];
	}
	
	[tempItems sortUsingFunction:compareDistance context:NULL];
    
	NwListNearPositionController *controller = [[NwListNearPositionController alloc] initWithNibName:@"NwListNearPositionController" 
																							  bundle:nil];
	
	controller.items = tempItems;
	controller.mapController = self;
	controller.mainController = mainController;
}


-(void) createMapView {
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 1024, 768 - sizeTop - sizeBottom - sizeHeaderText)] autorelease];
		}else{
			mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 768, 1024 - sizeTop - sizeBottom - sizeHeaderText)] autorelease];
		}				
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 480, 320 - sizeTop - sizeBottom - sizeHeaderText)] autorelease];
		}else{
			mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, sizeTop + sizeHeaderText, 320, 480 - sizeTop - sizeBottom - sizeHeaderText)] autorelease];
		}				
	}

	mapView.delegate = self;
	
	[self.view addSubview:mapView];
}

-(void) createButtonNear{
	imageSize = [[UIImageView alloc] init];
	//create the button
	nearPosButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
	NSString *k = [eMobcViewController whatDevice:k];
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:data.nearPosImage ofType:nil inDirectory:k];
	
	[nearPosButton setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
	
	imageSize.image = [UIImage imageWithContentsOfFile:imagePath];
	
	int width,height;
	
	if(![data.nearPosImage isEqualToString:@""] && data.nearPosImage != nil){
		width = imageSize.image.size.width;
		height = imageSize.image.size.height;
	}else{
		width = 40;
		height = 40;
	}
	
	//set the position of the button
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 40 || height > 40){
				nearPosButton.frame = CGRectMake(966, sizeTop + 30, 40, 40);
			}else{
				nearPosButton.frame = CGRectMake(966 + ((40 - width)/2), sizeTop + 30 + ((40 - height)/2), width, height);
			}
		}else{
			if(width > 40 || height > 40){
				nearPosButton.frame = CGRectMake(710, sizeTop + 30, 40, 40);
			}else{
				nearPosButton.frame = CGRectMake(710 + ((40 - width)/2), sizeTop + 30 + ((40 - height)/2), width, height);
			}
		}
	}else {
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			if(width > 40 || height > 40){
				nearPosButton.frame = CGRectMake(435, sizeTop + 30, 40, 40);
			}else{
				nearPosButton.frame = CGRectMake(435 + (40 - width)/2, sizeTop + 30 + ((40 - height)/2), width, height);
			}
		}else{
			if(width > 40 || height > 40){
				nearPosButton.frame = CGRectMake(275, sizeTop + 30, 40, 40);
			}else{
				nearPosButton.frame = CGRectMake(275 + ((40 - width)/2), sizeTop + 30 + ((40 - height)/2), width, height);
			}
		}				
	}
	
	if([data.nearPosImage isEqualToString:@""] || data.nearPosImage == nil){
		//set the button's title
		[nearPosButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[nearPosButton setTitle:@"Near" forState:UIControlStateNormal];
	}
	
	nearPosButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	nearPosButton.adjustsImageWhenHighlighted = NO;
	
	//listen for clicks
	[nearPosButton addTarget:self action:@selector(nearPositions:) forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[self.view addSubview:nearPosButton];
}


/**
 * Tells the delegate that the location of the user was updated
 *
 * @param mapView The map view that is tracking the user’s location
 * @param userLocation The location object representing the user’s latest location
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKCoordinateRegion mapRegion;   
    	
	mapRegion.center = mapView.userLocation.coordinate;
	
    mapRegion.span = MKCoordinateSpanMake(0.1, 0.1);
    	
	[mapView setRegion:mapRegion animated: YES];
}

/**
 * Asing the coordenate to map
 */
- (void) goToItem{
	MKCoordinateRegion region;
	
	if (itemToGo == nil){
		region.center.latitude=40.3;
		region.center.longitude=-3.7;	
		region.span.latitudeDelta = 10.0;
		region.span.longitudeDelta = 10.0;		
	}else{
		region.center.latitude=itemToGo.lat;
		region.center.longitude=itemToGo.lon;	
		region.span.latitudeDelta = 2.0;
		region.span.longitudeDelta = 2.0;		
	}
	
	[mapView setRegion:region animated:YES];
}

/**
 * Assing places to Map
 *
 * @param dataMap map's data read from map.xml
 */
- (void)forwardGeocoderFoundLocation:(id)dataMap{
	
	if(forwardGeocoder.status == G_GEO_SUCCESS){
		int searchResults = [forwardGeocoder.results count];
		
		// Add placemarks for each result
		for(int i = 0; i < searchResults; i++){
			BSKmlResult *place = [forwardGeocoder.results objectAtIndex:i];
			
			// Add a placemark on the map
			NwPlacemark *placemark = [[NwPlacemark alloc] initWithRegion:place.coordinateRegion];
			placemark.title = place.address;
			if(dataMap != nil){
				placemark.nextLevel = (NextLevel*)dataMap;
			}
			
				
			//[self.annotations addObject:placemark];
			[mapView addAnnotation:placemark];
		}
	}
}


/**
 * Call if there is something wrong while loading placemarks
 *
 * @param geocoder 
 * @param errorMessage error id
 */
- (void)forwardGeocoderError:(BSForwardGeocoder*)geocoder errorMessage:(NSString *)errorMessage {
	
}

/**
 * Call if everything was right while loading placemarks
 * Si se han colocado bien las marcas en el mapa.
 *
 * @param dataMap map's data
 */
-(void)forwardGeocoderOk:forwardGeocoderOk:(NSDictionary*)dataMap {
	
}

/**
 * Sent to the view controller when the application receives a memory warning
 */
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
-(void)viewDidUnload {
    [super viewDidUnload];
    
	self.mapView.showsUserLocation = NO;
	self.mapView = nil;
		
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc{
	[self.mapView removeFromSuperview]; // release crashes app
	self.mapView = nil;

	[data release];

    [super dealloc];
}


/**
 * Load a level back when button is pressed
 *
 * @see goBack
 */
-(IBAction) back:(id)sender{
	self.mapView.showsUserLocation = NO;	
	[mainController goBack];	
}

//No se si se utiliza
-(IBAction) findUserPos:(id)sender{
	/*mapView.showsUserLocation = YES;
		
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude] autorelease]; //Get your location and create a CLLocation
    MKCoordinateRegion region; //create a region.  No this is not a pointer
    region.center = location.coordinate;  // set the region center to your current location
    MKCoordinateSpan span; // create a range of your view
    span.latitudeDelta = 0.0144927 / 3;  // span dimensions.  I have BASE_RADIUS defined as 0.0144927536 which is equivalent to 1 mile
    span.longitudeDelta = 0.0144927 / 3;  // span dimensions
    region.span = span; // Set the region's span to the new span.
    [mapView setRegion:region animated:YES]; // to set the map to the newly created region	
    
    mapView.userLocation.title = @"Posición actual";*/
}

/**
 *Tells the delegate that the specified reverse geocoder failed to obtain information about its coordinate. (required) 
 * Deprecated in iOS 5.0. Replace it with CLGeocoder 
 *
 * @param geocoder The reverse geocoder object that was unable to complete its request
 * @param error An error object indicating the reason the request did not succeed
 */
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	
}

/**
 * Tells the delegate that a reverse geocoder successfully obtained placemark information for its coordinate
 *
 * @param geocoder The reverse geocoder object that completed its request successfully
 * @param placemark The object containing the placemark data
 */
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
//	mPlacemark=placemark;
//	[mapView addAnnotation:placemark];
}

/**
 * Returns the view associated with the specified annotation object
 *
 * @param mapView The map view that requested the annotation view
 * @param annotation The object representing the annotation that is about to be displayed. 
 * In addition to your custom annotations, this object could be an MKUserLocation object representing the user’s current location
 *
 * @return The annotation view to display for the specified annotation or nil if you want to display a standard annotation view
 *
 * @see showDetailView
 */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	NwPlacemark *placemark = (NwPlacemark*)annotation;
	
	NwCustomPin *pin = (NwCustomPin *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomId"];
	    	
	if (pin == nil) {
        pin = [[[NwCustomPin alloc] initWithAnnotation:placemark] autorelease];
    } else {
        pin.annotation = annotation;
    }
	
	if(annotation == mapView.userLocation){
		if (data.currentPositionIconFileName != nil){
			pin.image = [UIImage imageNamed:data.currentPositionIconFileName]; 
		}		
	}else{
		//pin.pinColor = MKPinAnnotationColorRed;
		pin.canShowCallout = YES;
		//pin.animatesDrop = NO;	
		
		// now we'll add the right callout button
		UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		
		if (placemark.icon != nil) {
			pin.image = [placemark.icon imageContent]; 
		}
		
		// customize this line to fit the structure of your code.  basically
		// you just need to find an integer value that matches your object in some way:
		// its index in your array of MKAnnotation items, or an id of some sort, etc
		// 
		// here I'll assume you have an annotation array that is a property of the current
		// class and we just want to store the index of this annotation.
		NSInteger annotationValue = [self.annotations indexOfObject:annotation];
		
		if (annotationValue != NSNotFound){
			// set the tag property of the button to the index
			detailButton.tag = annotationValue;
			
			// tell the button what to do when it gets touched
			[detailButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
			
			pin.rightCalloutAccessoryView = detailButton;		
		}		
	}
    
    return pin;
	
}

/**
 * Show details about a especific placemark
 *
 * @see loadNextLevel
 */
-(IBAction)showDetailView:(UIView*)sender{
    // get the tag value from the sender
    NSInteger selectedIndex = sender.tag;
    
	NwPlacemark *selectedObject = [self.annotations objectAtIndex:selectedIndex];
	
	if (selectedObject != nil){
		if(selectedObject.nextLevel != nil){
			[self startSpinner];
			[mainController loadNextLevel:selectedObject.nextLevel];
		}
	}
	
	/*
    // now you know which detail view you want to show; the code that follows
    // depends on the structure of your app, but probably looks like:
    MyDetailViewController *detailView = [[MyDetailViewController alloc] initWithNibName...];
    detailView.detailObject = selectedObject;
	
    [[self navigationController] pushViewController:detailView animated:YES];
    [detailView release];
	 */
}


/**
 * Find near positions to a specific place 
 *
 * @see loadController
 */
- (IBAction) nearPositions:(id)sender {

    CLLocationCoordinate2D coordinate;
    
    if ([CLLocationManager locationServicesEnabled]){
		coordinate.latitude = self.mapView.userLocation.location.coordinate.latitude;
		coordinate.longitude = self.mapView.userLocation.location.coordinate.longitude;
    }
    
     CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]; 
    
	NSMutableArray* tempItems = [[NSMutableArray alloc] init];
	
	
	for (MapItem* item in data.items){
		CLLocationDegrees itemLat = item.lat;
		CLLocationDegrees itemLon = item.lon;
		
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:itemLat 
													 longitude:itemLon];
		
		CLLocationDistance dist = [location distanceFromLocation:loc];
        
		NearUtil* util = [[NearUtil alloc] initWithDistance:item 
												   distance:dist];
		
		[tempItems addObject:util];

		[loc release];
	}

	[tempItems sortUsingFunction:compareDistance context:NULL];
    
	if ([eMobcViewController isIPad]) {
		NwListNearPositionController *controller = [[NwListNearPositionController alloc] initWithNibName:@"NwListNearPositionController-iPad" 
																								  bundle:nil];
		
		controller.items = tempItems;
		controller.mapController = self;
		controller.mainController = mainController;
		[mainController removeAllActivitiesViews];
		
		[mainController loadController:controller withAnimation:YES];
		
	} else { 
		NwListNearPositionController *controller = [[NwListNearPositionController alloc] initWithNibName:@"NwListNearPositionController" 
																								  bundle:nil];
		
		controller.items = tempItems;
		controller.mapController = self;
		controller.mainController = mainController;
		[mainController removeAllActivitiesViews];
		
		[mainController loadController:controller withAnimation:YES];
		
	}

}

/**
 * Compare two distances
 */
NSComparisonResult compareDistance(NearUtil* first, NearUtil *second, void *context) {
	if (first.distance < second.distance)
		return NSOrderedAscending;
	else if (first.distance > second.distance)
		return NSOrderedDescending;
	else 
		return NSOrderedSame;
}

#pragma mark UISearchBarDelegate delegate methods
/**
 * Tells the delegate that the search button was tapped
 *
 * @param theSearchBar The search bar that was tapped
 */
- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchAddress];
	[searchBar setHidden:YES];
	[searchBar resignFirstResponder];
}

/**
 * Tells the delegate that the cancel button was pessed
 *
 * @param theSearchBar The search bar that was pressed
 */
-(void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar { 
	[searchBar setHidden:YES];
    [searchBar resignFirstResponder];
}


#pragma mark -
#pragma mark Search Bar 

/**
 * Tells the delegate that the user changed the search text
 *
 * @param theSearchBar The search bar that is being edited
 * @param searchText The current text in the search text field
 *
 * @see loadMapItems
 */

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText{
	
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		[self searchAddress];
	}else{
	}
	
	//Reload the map  
	[self loadMapItems];
}

/**
 * Search a specific address
 */- (void) searchAddress{
	NSString *searchText = searchBar.text;
	copyListOfItems = [[NSMutableArray alloc] init];
	
	//Start searching
	
	for (MapItem* searchItem in data.items)	{
		NSRange addressRange = [searchItem.address rangeOfString:searchText 
														 options:NSCaseInsensitiveSearch];
		NSRange titleRange = [searchItem.title rangeOfString:searchText 
													 options:NSCaseInsensitiveSearch];
		
		if (addressRange.length > 0 || titleRange.length > 0){
			[copyListOfItems addObject:searchItem];
		}
	}
}

/**
 * Add properties to placemarks
 */
- (void) loadMapItems{
	[mapView removeAnnotations:annotations];
	
	[annotations removeAllObjects];
	
	for (MapItem* geoRef in copyListOfItems){
		
		MKCoordinateRegion coordinateRegion;
		coordinateRegion.center.latitude = geoRef.lat;
		coordinateRegion.center.longitude = geoRef.lon;
		coordinateRegion.span.latitudeDelta = 10.0;
		coordinateRegion.span.longitudeDelta = 10.0;
		
		NwPlacemark *placemark = [[NwPlacemark alloc] initWithRegion:coordinateRegion];
		placemark.title = geoRef.title;
		placemark.subtitle = geoRef.address; 
		if(geoRef.nextLevel != nil){
			placemark.nextLevel = geoRef.nextLevel;
		}
		if (geoRef.icon != nil){
			placemark.icon = geoRef.icon;
		}
		
		[annotations addObject:placemark];
				
		[mapView addAnnotation:placemark];
	}	
}



/**
 * Load themes from xml to components
 */
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
		}
	}
}


/**
 * Load themes
 */
-(void) loadThemes {
	if(![varStyles.backgroundFileName isEqualToString:@""]) {
		
		if([eMobcViewController isIPad]){
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 1024, 630)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, 768, 886)];
			}				
		}else {
			if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 480, 320)];
			}else{
				background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 108, 320, 480)];
			}				
		}
		
		NSString *k = [eMobcViewController whatDevice:k];
		
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:varStyles.backgroundFileName ofType:nil inDirectory:k];
		
		background.image = [UIImage imageWithContentsOfFile:imagePath];
		
		//[self.view addSubview:background];
		//[self.view sendSubviewToBack:background];
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
	
		
		if(varStyles != nil) {
			[self loadThemes];
		}
		
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
	
		[self loadMapa];
	}	
}

@end