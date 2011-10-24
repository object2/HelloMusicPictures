//
// SnapAndRunViewController.h
//
// Copyright (c) 2009 Lukhnos D. Liu (http://lukhnos.org)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

@interface SnapAndRunViewController : UIViewController <OFFlickrAPIRequestDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
    
    UIImagePickerController *imagePicker;
    
    UILabel *authorizeDescriptionLabel;
    UILabel *snapPictureDescriptionLabel;
    UIButton *authorizeButton;
    UIButton *snapPictureButton;
	
	UIButton *showPictureButton;
	UITextField *keywordTextField;
	UIWebView *webView;
	NSDictionary *responseDict;
}
- (IBAction)authorizeAction;
- (IBAction)snapPictureAction;
- (IBAction)showPictureAction;
- (void)showNextPicture;

@property (nonatomic, retain) IBOutlet UILabel *authorizeDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *snapPictureDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *snapPictureButton;
@property (nonatomic, retain) IBOutlet UIButton *authorizeButton;

@property (nonatomic, retain) IBOutlet UITextField *keywordTextField;
@property (nonatomic, retain) IBOutlet UIButton *showPictureButton;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSDictionary *responseDict;

@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@end
