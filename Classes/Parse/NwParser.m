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

#import "NwParser.h"


@implementation NwParser

@synthesize currentParsedCharacterData;
@synthesize accumulatingParsedCharacterData;


-(id) init {
	if (self = [super init]) {    
		currentParsedCharacterData = [NSMutableString string];
	}	
	return self;
}

- (void)dealloc {
	//[currentParsedCharacterData release];
	
    [super dealloc];
}

/**
 * Parse an xml with given URL file
 */
- (void)parseXMLFileAtURL:(NSString *)URL {	

	//you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL fileURLWithPath:URL];
	
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    //NSXMLParser *parser = [[ NSClassFromString(@"NSXMLParser") alloc] initWithContentsOfURL:xmlURL];
	AQXMLParser *parser = [[ NSClassFromString(@"AQXMLParser") alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
    [parser parse];
	
    [parser release];
}

/**
 * Parse an xml with given Data
 */
- (void)parseXMLFileFromData:(NSData *)data {	
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    //NSXMLParser *parser = [[ NSClassFromString(@"NSXMLParser") alloc] initWithData:data];
	AQXMLParser *parser = [[ NSClassFromString(@"AQXMLParser") alloc] initWithData:data];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	
    [parser parse];
	
    [parser release];
}


#pragma mark -
#pragma mark NSXMLParserDelegate

- (void)parserDidStartDocument:(AQXMLParser *)parser{	
}

/*- (void)parserDidStartDocument:(NSXMLParser *)parser{	
}*/

- (void)parser:(AQXMLParser *)parser foundCharacters:(NSString *)string{
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.currentParsedCharacterData appendString:string];
    }	
}
/*
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if (accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.currentParsedCharacterData appendString:string];
    }	
}*/

@end