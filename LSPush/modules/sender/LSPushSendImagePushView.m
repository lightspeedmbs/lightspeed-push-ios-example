//
//  LSPushSendImagePushView.m
//  LSPush
//
//  Created by Bobie on 1/13/14.
//  Copyright (c) 2014 Herxun. All rights reserved.
//

#import "LSPushSendImagePushView.h"
#import "UICommonUtility.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface LSPushSendImagePushView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

/* UI elements */
@property (strong) UIButton* btnPickImage;
@property (strong) UILabel* labelPickImageHint;
@property (strong) UIButton* btnPush;
@property (strong) UIView* croppedImageView;
@property (strong) UIImageView* imageCropped;
@property (strong) UIButton* btnDeletePickedImage;

/* controls */
@property (strong) UIImage* pickedImage;
@property (strong) UIImage* croppedImage;

@end

@implementation LSPushSendImagePushView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self prepareSendImagePushView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)prepareSendImagePushView
{
    CGSize screenSize = [UICommonUtility getScreenSize];
    CGFloat fBtnPickImageLeftMargin = 13.0f;
    CGFloat fBtnPickImageWidth = screenSize.width - 2*fBtnPickImageLeftMargin, fBtnPickImageHeight = 150.0f;
    CGFloat fBtnPushWidth = screenSize.width - 2*fBtnPickImageLeftMargin, fBtnPushHeight = 44.0f;
    CGFloat fBtnPushTop = fBtnPickImageHeight + 10.0f;

    if (!self.btnPickImage)
    {
        self.btnPickImage = [[UIButton alloc] initWithFrame:CGRectMake(fBtnPickImageLeftMargin, 0.0f, fBtnPickImageWidth, fBtnPickImageHeight)];
        [self addSubview:self.btnPickImage];
        [self.btnPickImage addTarget:self action:@selector(btnPickImageClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnPickImage.layer setBorderWidth:1.0f];
        [self.btnPickImage.layer setBorderColor:[UICommonUtility hexToColor:0x7CA941 withAlpha:[NSNumber numberWithFloat:1.0f]].CGColor];
    }
    
    if (!self.labelPickImageHint)
    {
        self.labelPickImageHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.btnPickImage addSubview:self.labelPickImageHint];
        [self.labelPickImageHint setBackgroundColor:[UIColor clearColor]];
        [self.labelPickImageHint setFont:[UIFont fontWithName:@"STHeitiTC-Light" size:16.0f]];
        [self.labelPickImageHint setTextColor:[UICommonUtility hexToColor:0x949494 withAlpha:[NSNumber numberWithFloat:1.0f]]];
        [self.labelPickImageHint setNumberOfLines:0];
        [self.labelPickImageHint setTextAlignment:NSTextAlignmentCenter];
        [self.labelPickImageHint setText:@"upload image"];
        [self.labelPickImageHint sizeToFit];
        
        CGRect frame = self.labelPickImageHint.frame;
        frame.origin.x = (fBtnPickImageWidth - frame.size.width)/2;
        frame.origin.y = (fBtnPickImageHeight - frame.size.height)/2;
        self.labelPickImageHint.frame = frame;
    }
    
    if (!self.btnPush)
    {
        self.btnPush = [[UIButton alloc] initWithFrame:CGRectMake(fBtnPickImageLeftMargin, fBtnPushTop, fBtnPushWidth, fBtnPushHeight)];
        [self addSubview:self.btnPush];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu03_up.png"] forState:UIControlStateNormal];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu03_down.png"] forState:UIControlStateHighlighted];
        [self.btnPush setImage:[UIImage imageNamed:@"push_bu03_disable.png"] forState:UIControlStateDisabled];
        [self.btnPush addTarget:self action:@selector(btnPushClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.btnPush setEnabled:NO];
    }
}

#pragma mark - button functions
- (void)btnPickImageClicked
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"選取圖片"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"從圖庫選擇", nil];
    [sheet showInView:self.superview];
}

- (void)btnPushClicked
{
    NSLog(@"sending text push");
}

- (void)deletePickedImage
{
    [UIView animateWithDuration:0.25f animations:^{
        self.croppedImageView.alpha = 0.0f;
        self.btnDeletePickedImage.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.croppedImageView setHidden:YES];
        [self.btnDeletePickedImage setHidden:YES];
        self.croppedImageView.alpha = 1.0f;
        self.btnDeletePickedImage.alpha = 1.0f;
        self.croppedImage = nil;
        self.pickedImage = nil;
        
        [self.btnPush setEnabled:NO];
        [self.labelPickImageHint setHidden:NO];
        [self.btnPickImage setEnabled:YES];
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        /* take picture */
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
            imagePicker.allowsEditing = NO;
            imagePicker.showsCameraControls = YES;
            imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            
            [((UIViewController*)self.parentSenderVC) presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1)
    {
        /* camera roll */
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController* cameraRollPicker = [[UIImagePickerController alloc] init];
            cameraRollPicker.delegate = self;
            cameraRollPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            cameraRollPicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
            cameraRollPicker.allowsEditing = NO;
            
            [((UIViewController*)self.parentSenderVC) presentViewController:cameraRollPicker animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.pickedImage = image;
        
        self.croppedImage = [self _cropImageToSquare:self.pickedImage];
        [self updatePickedImage];
    }];
}

- (UIImage*)_cropImageToSquare:(UIImage*)image
{
    /* check width/height ratio & orientation */
    UIImageOrientation orientation = UIImageOrientationRight;
    CGRect rect = CGRectZero;
    CGFloat fCroppedImageSize = 0.0f, fOriginX = 0.0f, fOriginY = 0.0f;
    if (image.imageOrientation == UIImageOrientationRight || image.imageOrientation == UIImageOrientationLeft)
    {
        fCroppedImageSize = image.size.width;
        if (image.size.height >= image.size.width)
        {
            fOriginX = (image.size.height - image.size.width)/2;
            fOriginY = 0.0f;
        }
        else
        {
            fCroppedImageSize = image.size.height;
            fOriginX = 0.0f;
            fOriginY = (image.size.width - image.size.height)/2;
        }
    }
    else if (image.imageOrientation == UIImageOrientationUp || image.imageOrientation == UIImageOrientationDown)
    {
        orientation = UIImageOrientationUp;
        fCroppedImageSize = image.size.height;
        if (image.size.width >= image.size.height)
        {
            fOriginX = (image.size.width - image.size.height)/2;
            fOriginY = 0.0f;
        }
        else
        {
            fCroppedImageSize = image.size.width;
            fOriginX = 0.0f;
            fOriginY = (image.size.height - image.size.width)/2;
        }
    }
    rect = CGRectMake(fOriginX, fOriginY, fCroppedImageSize, fCroppedImageSize);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage* resultImage = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:orientation];
    CGImageRelease(imageRef);
    
    return resultImage;
}

- (void)updatePickedImage
{
    if (!self.croppedImageView)
    {
        CGFloat fCroppedViewSize = 90.0f, fCroppedImageSize = 85.0f;
        CGSize screenSize = [UICommonUtility getScreenSize];
        
        /* add from the origin of the dummy gray view */
        CGFloat fCroppedViewTop = (150.0f - fCroppedViewSize)/2;
        
        self.croppedImageView = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - fCroppedViewSize)/2, fCroppedViewTop, fCroppedViewSize, fCroppedViewSize)];
        [self addSubview:self.croppedImageView];
        [self.croppedImageView setBackgroundColor:[UICommonUtility hexToColor:0x7CA941 withAlpha:[NSNumber numberWithFloat:1.0f]]];
        
        self.imageCropped = [[UIImageView alloc] initWithFrame:CGRectMake((fCroppedViewSize - fCroppedImageSize)/2, (fCroppedViewSize - fCroppedImageSize)/2,
                                                                          fCroppedImageSize, fCroppedImageSize)];
        [self.croppedImageView addSubview:self.imageCropped];
        
        CGFloat fDeleteButtonSize = 40.0f;
        CGFloat fX = self.croppedImageView.frame.origin.x + self.croppedImageView.frame.size.width - fDeleteButtonSize/2;
        CGFloat fY = self.croppedImageView.frame.origin.y - fDeleteButtonSize/2;
        self.btnDeletePickedImage = [[UIButton alloc] initWithFrame:CGRectMake(fX, fY, fDeleteButtonSize, fDeleteButtonSize)];
        [self addSubview:self.btnDeletePickedImage];
        [self.btnDeletePickedImage setImage:[UIImage imageNamed:@"delete_up.png"] forState:UIControlStateNormal];
        [self.btnDeletePickedImage setImage:[UIImage imageNamed:@"delete_down.png"] forState:UIControlStateHighlighted];
        [self.btnDeletePickedImage addTarget:self action:@selector(deletePickedImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.croppedImageView setHidden:NO];
    [self.btnDeletePickedImage setHidden:NO];
    self.imageCropped.image = self.croppedImage;
    
    [self.btnPickImage setEnabled:NO];
    [self.btnPush setEnabled:YES];
    [self.labelPickImageHint setHidden:YES];
}

@end
