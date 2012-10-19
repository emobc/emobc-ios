//
//  AsynchronousImageView.h
//  WallApp
//
//  Created by sebastiao Gazolla Costa Junior on 10/06/11.
// Based on http://iphone-dev-tips.alterplay.com/2009/10/asynchronous-uiimage.html

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AsynchronousUIImage;

@protocol AsynchronousUIImageDelegate <NSObject>
@optional
-(void) imageDidLoad:(AsynchronousUIImage *)anImage;

@end



@interface AsynchronousUIImage : UIImage
{
    NSURLConnection *connection;
    NSMutableData *data;
	NSString *theUrl;
}
@property (nonatomic, assign) id <AsynchronousUIImageDelegate> delegate;
@property (nonatomic)  int tag;
- (void)loadImageFromURL:(NSString *)anUrl;

@end