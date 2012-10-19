//
//  AsynchronousImageView.m
//  WallApp
//
//  Created by sebastiao Gazolla Costa Junior on 10/06/11.
//  Based on http://iphone-dev-tips.alterplay.com/2009/10/asynchronous-uiimage.html 

#import "AsynchronousUIImage.h"
#import "NwCache.h"

@implementation AsynchronousUIImage
@synthesize delegate;
@synthesize tag;

- (void)loadImageFromURL:(NSString *)anUrl {
	NwCache* cache = [NwCache instance];
	
	bool cached = [cache isFileNamedCached:anUrl];
	
	if(cached == TRUE){
		NSData* cachedData = [cache readData:anUrl];
		[self initWithData:cachedData];
		[cachedData release];
		cachedData = nil;   
		[self.delegate imageDidLoad:self];
	}else {
		theUrl = anUrl;
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:anUrl] 
												 cachePolicy:NSURLRequestReturnCacheDataElseLoad 
											 timeoutInterval:30.0];
		
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];		
	}

}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (data == nil)
        data = [[NSMutableData alloc] initWithCapacity:2048];
    
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	NwCache* cache = [NwCache instance];
	
	[cache storeData:data forFileName:theUrl];
	
    [self initWithData:data];
    [data release], data = nil;
    [connection release], connection = nil;    
    [self.delegate imageDidLoad:self];
}

-(void)dealloc{
    [super dealloc];
    connection = nil;
    data = nil;
}

@end
