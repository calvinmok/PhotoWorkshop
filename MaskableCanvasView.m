


#import "MaskableCanvasView.h"




@implementation MaskableCanvasView



    + (MaskableCanvasView*) create :(MaskableCanvasViewOwner*)owner :(CGSize)size
    {
        MaskableCanvasView* result = [[[MaskableCanvasView alloc] init] autorelease];
        [result _create :owner :size];                
        return result;
    }

    - (void) _create :(MaskableCanvasViewOwner*)owner :(CGSize)size
    {
        my_owner = owner;
        
        self.frame = CGRectMake(0.f, 0.f, size.width, size.height);
        //self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        

        
        my_imageView = [[UIImageView alloc] init];
        my_imageView.frame = CGRectMake(0.f, 0.f, size.width, size.height);        
        my_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        my_imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:my_imageView];
        
        
        
        

        UIRotationGestureRecognizer* rotationGesture = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_rotate:)] autorelease];
        [self addGestureRecognizer:rotationGesture];
        
        
        UIPinchGestureRecognizer* pinchGesture = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_scale:)] autorelease];
        [pinchGesture setDelegate:self];
        [self addGestureRecognizer:pinchGesture];


        UIPanGestureRecognizer* panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)] autorelease];
        [panGesture setDelegate:self];
        [panGesture setMinimumNumberOfTouches:1];
        [panGesture setMaximumNumberOfTouches:2];
        [self addGestureRecognizer:panGesture];
        
        
        UITapGestureRecognizer* tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)] autorelease];
        [tapGesture setDelegate:self];        
        [self addGestureRecognizer:tapGesture];

        
    }

    - (void) dealloc
    {
        MutableMaskableCanvas_release(my_maskableCanvas);

        [my_imageView release];
        [super dealloc];
    }
    
    
    

    - (void) MutableMaskableCanvas_selectedImageChanged:(NubleInt)index
    {
        [my_owner MaskableCanvasView_selectedImageChanged:index];
    }
    
    
    
    - (NubleInt) _findMaskableImageIndex:(UIGestureRecognizer*)gestureRecognizer
    {
        if (my_maskableCanvas.hasVar == NO)
            return Int_nuble();
        
        CGSize size = self.frame.size;
        
        NubleInt lastIndex = Int_nuble();        
        NSUInteger numberOfTouches = [gestureRecognizer numberOfTouches];
        for (NSUInteger i = 0; i < numberOfTouches; i++)
        {
            CGPoint location = [gestureRecognizer locationOfTouch:i inView:self];
            location = CGPointMake(location.x - (size.width / 2.f), size.height - location.y - (size.height / 2.f));
            
            NubleInt imageIndex = [my_maskableCanvas.vd findMaskableImageIndex:location];
            if (imageIndex.hasVar == NO)
                return Int_nuble();
            
            if (lastIndex.hasVar && imageIndex.vd != lastIndex.vd)
                return Int_nuble();
                
            lastIndex = imageIndex;
        }
        
        return lastIndex;
    }
    


    - (NubleMutableMaskableCanvas) maskableCanvas
    {
        return my_maskableCanvas;
    }
    
    - (void) setMaskableCanvas:(NubleMutableMaskableCanvas)maskableCanvas
    {
        MutableMaskableCanvas_autorelease(my_maskableCanvas);
        my_maskableCanvas = MutableMaskableCanvas_retain(maskableCanvas);
        
        [self reload:ImageQuality_High];
    }
    
    
    - (void) reload :(ImageQuality)imageQuality
    {    
        if (my_maskableCanvas.hasVar == NO)
            return;        
    
        MaskableCanvas* canvas = my_maskableCanvas.vd;
        my_imageView.image = [canvas generateImage :self.frame.size :imageQuality :IsThumbnail_No];
            
        
    }
    
    
    - (void) setCanvasEnabled:(Bool)enabled
    {
        for (UIGestureRecognizer* gestureRecognizer in self.gestureRecognizers)
        {
            gestureRecognizer.enabled = enabled;
        }
    }



    - (void) _rotate:(UIRotationGestureRecognizer*)gestureRecognizer
    {
        if (my_maskableCanvas.hasVar == NO)
            return;        
    
        MutableMaskableCanvas* canvas = my_maskableCanvas.vd;
        
        UIGestureRecognizerState state = [gestureRecognizer state];
        
        if (state == UIGestureRecognizerStateBegan)
        {
            my_gestureImageIndex = [self _findMaskableImageIndex:gestureRecognizer];
        }
        
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateEnded) 
        {                  
            CGRect imageViewFrame = my_imageView.frame;
                    
            CGPoint locationInView = [gestureRecognizer locationInView:my_imageView];
            locationInView.y = imageViewFrame.size.height - locationInView.y;
            locationInView.x -= imageViewFrame.size.width / 2.0;
            locationInView.y -= imageViewFrame.size.height / 2.0;

            if (my_gestureImageIndex.hasVar)
            { 
                CGPoint location = CGPointApplyAffineTransform(locationInView, CGAffineTransformInvert(canvas.transform));

                CGAffineTransform t = [canvas imageSetAt:my_gestureImageIndex.vd].transform;
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(-location.x, -location.y));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(-[gestureRecognizer rotation]));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(location.x, location.y));
                [[canvas imageSetAt_:my_gestureImageIndex.vd] setTransform:t];
            }
            else
            {   
                CGAffineTransform t = canvas.transform;
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(-locationInView.x, -locationInView.y));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(-[gestureRecognizer rotation]));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(locationInView.x, locationInView.y));
                [canvas setTransform:t];
            }
            
            [gestureRecognizer setRotation:0.f];


            if (state == UIGestureRecognizerStateEnded)
                [self reload:ImageQuality_Mid];
            else
                [self reload:ImageQuality_Low];
        }
    }
    
    - (void) _scale:(UIPinchGestureRecognizer*)gestureRecognizer
    {    
        if (my_maskableCanvas.hasVar == NO)
            return;        
                    
        MutableMaskableCanvas* canvas = my_maskableCanvas.vd;

        UIGestureRecognizerState state = [gestureRecognizer state];
                
        if (state == UIGestureRecognizerStateBegan)
        {
            my_gestureImageIndex = [self _findMaskableImageIndex:gestureRecognizer];
        }
        
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateEnded) 
        {        
            CGRect imageViewFrame = my_imageView.frame;
                    
            CGPoint locationInView = [gestureRecognizer locationInView:my_imageView];
            locationInView.y = imageViewFrame.size.height - locationInView.y;
            locationInView.x -= imageViewFrame.size.width / 2.0;
            locationInView.y -= imageViewFrame.size.height / 2.0;        
        
            CGFloat scale = [gestureRecognizer scale];
            
            if (my_gestureImageIndex.hasVar)
            {
                CGPoint location = CGPointApplyAffineTransform(locationInView, CGAffineTransformInvert(canvas.transform));

                CGAffineTransform t = [canvas imageSetAt:my_gestureImageIndex.vd].transform;
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(-location.x, -location.y));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeScale(scale, scale));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(location.x, location.y));
                [[canvas imageSetAt_:my_gestureImageIndex.vd] setTransform:t];
            }
            else
            {
                CGAffineTransform t = canvas.transform;
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(-locationInView.x, -locationInView.y));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeScale(scale, scale));
                t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(locationInView.x, locationInView.y));
                [canvas setTransform:t];
            }
            
            [gestureRecognizer setScale:1.f];
            
            if (state == UIGestureRecognizerStateEnded)
                [self reload:ImageQuality_Mid];
            else
                [self reload:ImageQuality_Low];
        }
    }
    
    
    - (void) _pan:(UIPanGestureRecognizer*)gestureRecognizer
    {
        if (my_maskableCanvas.hasVar == NO)
            return;        
            
        MutableMaskableCanvas* canvas = my_maskableCanvas.vd;
    
        UIGestureRecognizerState state = [gestureRecognizer state];
                        
        if (state == UIGestureRecognizerStateBegan)
        {
            my_gestureImageIndex = [self _findMaskableImageIndex:gestureRecognizer];
        }
                
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateEnded) 
        {
            CGPoint translation = [gestureRecognizer translationInView:self];
            translation.y = -translation.y;

            CGAffineTransform it = CGAffineTransformInvert(canvas.transform);
            it = CGAffineTransformMake(it.a, it.b, it.c, it.d, 0.f, 0.f);
        
            translation = CGPointApplyAffineTransform(translation, it);
                        
            if (my_gestureImageIndex.hasVar)
            {
                CGAffineTransform imageSetTransform = [canvas imageSetAt:my_gestureImageIndex.vd].transform;            
            
                CGAffineTransform t = CGAffineTransformInvert(imageSetTransform);
                t = CGAffineTransformMake(t.a, t.b, t.c, t.d, 0.f, 0.f);
                translation = CGPointApplyAffineTransform(translation, t);  
                
                [[canvas imageSetAt_:my_gestureImageIndex.vd] setTransform:CGAffineTransformTranslate(imageSetTransform, translation.x, translation.y)];
            }
            else
            {                    
                [canvas setTransform:CGAffineTransformTranslate(canvas.transform, translation.x, translation.y)];
            }      
                        
            [gestureRecognizer setTranslation:CGPointZero inView:self];      

            if (state == UIGestureRecognizerStateEnded)
                [self reload:ImageQuality_Mid];
            else
                [self reload:ImageQuality_Low];
        }
                        
    }
    
    
    - (void) _tap:(UITapGestureRecognizer*)gestureRecognizer
    {
        if (my_maskableCanvas.hasVar == NO)
            return;        
            
        MutableMaskableCanvas* canvas = my_maskableCanvas.vd;
        
        UIGestureRecognizerState state = [gestureRecognizer state];
        if (state == UIGestureRecognizerStateRecognized)
        {
            CGSize size = self.frame.size;
            CGPoint location = [gestureRecognizer locationInView:self];            
            location = CGPointMake(location.x - (size.width / 2.f), size.height - location.y - (size.height / 2.f));
            
            NubleInt tappedIndex = [canvas findMaskableImageIndex:location];
            
            NubleInt selectedIndex = canvas.selectedImageSetIndex;
            if (selectedIndex.hasVar)
            {
                if (tappedIndex.hasVar == NO || selectedIndex.vd != tappedIndex.vd)
                    [canvas setSelectedImageSetIndex:Int_nuble()];
            }
            else
            {            
                [canvas setSelectedImageSetIndex:tappedIndex];
            }            
            
            [self reload:ImageQuality_Low];
        }
                
        if (state == UIGestureRecognizerStateEnded)
        {
            [self reload:ImageQuality_Mid];
        }   
    }
    
    
    - (BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
    {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
            return NO;
        
        return YES;
    }        
    
    
    
    
    
    - (StableMaskableCanvas*) createStableCanvas
    {
        ASSERT(my_maskableCanvas.hasVar);
        
        CGFloat scale = 2;//2;
        
        CGSize size = self.frame.size;
        size = CGSizeMake(size.width * scale, size.height * scale);
        
        return [StableMaskableCanvas create :size :scale :my_maskableCanvas.vd];
    }
            
    
    - (void) up
    {
        if (my_maskableCanvas.hasVar)
        {
            [my_maskableCanvas.vd up];
            [self reload:ImageQuality_Mid];
        }
    }
    
    - (void) down
    {
        if (my_maskableCanvas.hasVar)
        {
            [my_maskableCanvas.vd down];
            [self reload:ImageQuality_Mid];
        }
    }
    
    - (void) deleteImage
    {
        if (my_maskableCanvas.hasVar)
        {
            [my_maskableCanvas.vd deleteImage];
            [self reload:ImageQuality_Mid];
        }
    }
    
                  
    
@end



@implementation MaskableCanvasViewController 


    + (MaskableCanvasViewController*) create :(MaskableCanvasViewControllerOwner*)owner :(CGRect)rootFrame
    {
        MaskableCanvasViewController* result = [[[MaskableCanvasViewController alloc] init] autorelease];
        [result _create :owner :rootFrame];
        return result;
    }
    
    - (void) _create :(MaskableCanvasViewControllerOwner*)owner :(CGRect)rootFrame
    {        
        my_owner = owner;


        CGRect frame = CGRectMake(0.0, 0.0, rootFrame.size.width, rootFrame.size.height);
        
        Layout* layout = [Layout create :self :frame.size];
        
                    
        my_imagePicker = [[UIImagePickerController alloc] init];
        my_imagePicker.delegate = self;
        
        @try 
        {
            my_popoverOrNil = [[UIPopoverController alloc] initWithContentViewController:my_imagePicker];
        }
        @catch (NSException *exception) 
        {
            my_popoverOrNil = nil;
        }
            
    
		my_cameraActionSheet = [[UIActionSheet alloc] 
			initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" 
            destructiveButtonTitle:nil 
            otherButtonTitles:@"Take a Picture", @"Select a Picture", nil];
            
            
        my_deleteAlertView = [[OkCancelAlertView create:self] retain];
        [my_deleteAlertView setMessage:STR(@"The image will be deleted. Are you sure?")];

        my_exportAlertView = [[OkCancelAlertView create:self] retain];
        [my_exportAlertView setMessage:STR(@"The project will be expoted. Are you sure?")];
            
        my_backgroundImageView = [[UIImageView alloc] init];
        my_backgroundImageView.frame = frame;
        my_backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        my_backgroundImageView.image = createBackgroundImage(frame.size);
        
        my_maskableImageVC = [[MaskableImageViewController create :self :frame.size] retain];

                
        my_maskableCanvasView = [[MaskableCanvasView create :self :frame.size] retain];
        


        UIImage* menuImage = [UIImage imageNamed:@"Menu.png"];
        UIImage* crossImage = [UIImage imageNamed:@"Cross.png"];
        UIImage* importImage = [UIImage imageNamed:@"Import.png"];
        UIImage* exportImage = [UIImage imageNamed:@"Export.png"];
        UIImage* upImage = [UIImage imageNamed:@"Up.png"];
        UIImage* downImage = [UIImage imageNamed:@"Down.png"];
        UIImage* editImage = [UIImage imageNamed:@"Edit.png"];
                
        
        my_openProjectMenuButton = [[layout createButton :+1 :+1 :menuImage :@selector(_openProjectMenu)] retain];
        my_importButton = [[layout createButton :+2 :+1 :importImage :@selector(_import)] retain];
        my_exportButton = [[layout createButton :+1 :+2 :exportImage :@selector(_export)] retain];        
        
        my_deleteButton = [[layout createButton :-1 :1 :crossImage :@selector(_delete)] retain];        

        my_upButton = [[layout createButton :-2 :-1 :upImage :@selector(_up)] retain];
        my_downButton = [[layout createButton :-1 :-1 :downImage :@selector(_down)] retain];        

        my_editButton = [[layout createButton :1 :-1 :editImage :@selector(_edit)] retain];        
        
        [self MaskableCanvasView_selectedImageChanged :Int_nuble()];
                        
        my_activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];        
        my_activityIndicator.frame = my_exportButton.frame; // CGRect_changeMax(CGRect_shrinkRatio(frame, 1.0), 150.0);
        my_activityIndicator.autoresizingMask = my_exportButton.autoresizingMask;
        
        
        my_rootView = [[UIView alloc] initWithFrame:rootFrame];
        my_rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        my_rootView.autoresizesSubviews = YES;
        
        [my_rootView addSubview:my_backgroundImageView];   
        [my_rootView addSubview:my_maskableCanvasView];   

        [my_rootView addSubview:my_openProjectMenuButton];   
        [my_rootView addSubview:my_importButton];   
        [my_rootView addSubview:my_exportButton];   
        [my_rootView addSubview:my_deleteButton];   
        [my_rootView addSubview:my_upButton];   
        [my_rootView addSubview:my_downButton];   
        [my_rootView addSubview:my_editButton];   
        
        [my_rootView addSubview:my_activityIndicator];   
        
        
    }
    
    
    - (void) dealloc
    {        
        [my_imagePicker release];
        [my_popoverOrNil release];

        [my_cameraActionSheet release];
        [my_deleteAlertView release];
        [my_exportAlertView release];

        [my_rootView release];
        [my_backgroundImageView release];
        [my_maskableCanvasView release];
        [my_maskableImageVC release];
                
        [super dealloc];
    }
    
    
	- (void) loadView
	{
        self.view = my_rootView;    
        [self reload];
    }
    


	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
	{
		return YES;
	}
    
    - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
    {
        [self reload];    
    }




    - (void) reload
    {
        CGRect frame = my_backgroundImageView.frame;
        my_backgroundImageView.image = createBackgroundImage(frame.size);
        
        [my_maskableCanvasView reload:ImageQuality_Mid];    
    }
	    
        
    - (void) undo
    {
        if ([self presentedViewController] == my_maskableImageVC)
        {
            [my_maskableImageVC undo];
        }
        else
        {
        }
    }
    
    
    - (void) setEnabled:(Bool)enabled
    {
        
    }
        
    
    
    
    - (void) newCanvas
    {
        MutableMaskableCanvas* canvas = [MutableMaskableCanvas create:my_maskableCanvasView];
        
/*
UIImage* img = [UIImage imageNamed:@"Icocopy.png"];
OriginalImage* oi = [OriginalImage createWithImage:img];
MutableMaskableImageSet* maskableImageSet = [MutableMaskableImageSet create:oi];
[canvas appendMaskableImageSet:maskableImageSet];
*/
                              
        [my_maskableCanvasView setMaskableCanvas:MutableMaskableCanvas_toNuble(canvas)];
        
        
        [self MaskableCanvasView_selectedImageChanged :canvas.selectedImageSetIndex];
    }
    
    - (Bool) saveCanvasToFlow :(WritingFlow*)flow
    {
        if (my_maskableCanvasView.maskableCanvas.hasVar)        
        {
            [my_maskableCanvasView.maskableCanvas.vd writeToFlow:flow];
            return YES;
        }
            
        return NO;    
    }
    
    - (void) loadCanvasFromFlow:(ReadingFlow*)flow
    {
        NubleMutableMaskableCanvas canvas = [MutableMaskableCanvas createFromFlow :my_maskableCanvasView :flow];
        if (canvas.hasVar == NO)
            return;
        
        [my_maskableCanvasView setMaskableCanvas:canvas];
    }
    
    - (UIImage*) createThumbnailWithBackground :(CGSize)outputSize
    {
        MaskableCanvas* canvas = my_maskableCanvasView.maskableCanvas.vd;
        ASSERT(canvas != nil);
            
        return [canvas createThumbnailWithBackground :my_maskableCanvasView.frame.size :outputSize];        
    }
        
        

    
    - (void) MaskableCanvasView_selectedImageChanged:(NubleInt)index
    {
        [my_upButton setHidden:(index.hasVar == NO)];
        [my_downButton setHidden:(index.hasVar == NO)];        
        [my_deleteButton setHidden:(index.hasVar == NO)];     
        [my_editButton setHidden:(index.hasVar == NO)];     
    }
    
    

	- (void) MaskableImageViewController_close
    {
        [self dismissModalViewControllerAnimated:YES];        
        [my_maskableCanvasView reload:ImageQuality_Mid];
    }

	    
        
        
        
        

    - (void) _openProjectMenu
    {
    
        [my_owner MaskableCanvasViewController_openProjectMenu];
    }
    
    
    
    
    - (void) _import
    {
        [self _showSelectPicture];
        
        //if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        //    [my_cameraActionSheet showInView:self.view];
        //else
        //    [self _showSelectPicture];
    }
    
    - (void) _export
    {
        ASSERT([NSThread isMainThread]);
        
        if ([my_activityIndicator isAnimating])
            return;
            
        [my_exportAlertView show];
    }
    
    - (void) _exporting:(StableMaskableCanvas*)canvas
    {
        @autoreleasepool 
        {    
            ASSERT([NSThread isMainThread] == NO);
        
            UIImage* image = [canvas generateImage];
        
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
    
    - (void) image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo;
    { 
        if ([NSThread isMainThread])
            [self _exportCompleted];
        else
            [self performSelectorOnMainThread:@selector(_exportCompleted) withObject:nil waitUntilDone:NO];
    }
    
    - (void) _exportCompleted
    {
        ASSERT([NSThread isMainThread]);

NSString* message = @"Export Completed!\nThe picture is saved in your photo album.";
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
[alert show];
[alert release];        

        [my_activityIndicator stopAnimating];
            
        my_openProjectMenuButton.enabled = YES;
        my_importButton.enabled = YES;
        my_exportButton.enabled = YES;
        my_deleteButton.enabled = YES;
        my_upButton.enabled = YES;
        my_downButton.enabled = YES;
        my_editButton.enabled = YES;
                
        [my_exportButton setImage:[UIImage imageNamed:@"Export.png"] forState:UIControlStateNormal];        
        
        [my_maskableCanvasView setCanvasEnabled:YES];

    }
    
    
    
    - (void) _up
    {
        [my_maskableCanvasView up];
    }
    
    - (void) _down
    {
        [my_maskableCanvasView down];
    }
    
    - (void) _delete
    {
        [my_deleteAlertView show];
    }
    
    - (void) OkCancelAlertView_ok :(OkCancelAlertView*)ownee
    {
        if (ownee == my_deleteAlertView)
        {
            [my_maskableCanvasView deleteImage];
        }
        else if (ownee == my_exportAlertView)
        {
            [my_activityIndicator startAnimating];
            
            my_openProjectMenuButton.enabled = NO;
            my_importButton.enabled = NO;
            my_exportButton.enabled = NO;
            my_deleteButton.enabled = NO;
            my_upButton.enabled = NO;
            my_downButton.enabled = NO;
            my_editButton.enabled = NO;
            
            [my_exportButton setImage:[UIImage imageNamed:@"Blank.png"] forState:UIControlStateNormal];
            
            [my_maskableCanvasView setCanvasEnabled:NO];
                    
            StableMaskableCanvas* stableCanvas = [my_maskableCanvasView createStableCanvas];
            [self performSelectorInBackground:@selector(_exporting:) withObject:stableCanvas];
        }
    }
    
    - (void) OkCancelAlertView_cancel :(OkCancelAlertView*)ownee
    {
    }
    	    
    
    - (void) _edit
    {
        NubleMutableMaskableCanvas canvas = my_maskableCanvasView.maskableCanvas;
        if (canvas.hasVar == NO)
            return;
            
        NubleInt imageSetIndex = canvas.vd.selectedImageSetIndex;
        if (imageSetIndex.hasVar == NO)
            return;
                    
        MutableMaskableImageSet* imageSet = [canvas.vd imageSetAt_:imageSetIndex.vd];
        
        [my_maskableImageVC setMaskableImageSet :MutableMaskableImageSet_toNuble(imageSet)];
        
        my_maskableImageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:my_maskableImageVC animated:YES];                              
    }
    
    
    
    
   

    - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        if (actionSheet == my_cameraActionSheet)
        {
            String* title = STR([my_cameraActionSheet buttonTitleAtIndex:buttonIndex]);

            IF ([title eqNS:@"Take a Picture"])
            {
                [self _showTakePicture];
            }
            EF ([title eqNS:@"Select a Picture"])
            {
                [self _showSelectPicture];
            }
            EL
            {
            }
        }
    }
    
    
    
    
    - (void) _showTakePicture
    {
        my_imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:my_imagePicker animated:YES];
    }
    
    - (void) _showSelectPicture
    {
        my_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if (my_popoverOrNil == nil)
        {
            [self presentModalViewController:my_imagePicker animated:YES];
        }
        else
        {
            [my_popoverOrNil presentPopoverFromRect:my_importButton.frame 
                             inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionUp | UIPopoverArrowDirectionLeft 
                             animated:YES];           
        }
    }
    
    
    
    - (void) imagePickerControllerDidCancel :(UIImagePickerController*)picker
    {
        if (my_popoverOrNil == nil)
        {
            [picker dismissModalViewControllerAnimated:YES];
        }
        else
        {
            [my_popoverOrNil dismissPopoverAnimated:YES];
        }

        [self reload];
    }

	- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info  
	{
        NubleMutableMaskableCanvas canvas = my_maskableCanvasView.maskableCanvas;
        if (canvas.hasVar == NO)
            return;
            
		[self dismissModalViewControllerAnimated:YES]; 


        NSString* mediaType = [info objectForKey: UIImagePickerControllerMediaType];    
        
        if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
        {
            UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            if (image == nil)
                image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
            if (image != nil)
            {
                CGSize originalSize = image.size;
                UIImageOrientation originalImageOrientation = image.imageOrientation;
                
                if (originalImageOrientation != UIImageOrientationUp)
                {
                    image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
                }
                
                OriginalImage* oi = [OriginalImage createWithImage:image];                
                MutableMaskableImageSet* maskableImageSet = [MutableMaskableImageSet create:oi];
                
                
                CGAffineTransform transform = CGAffineTransformInvert(canvas.vd.transform);
                
                if (originalImageOrientation == UIImageOrientationLeft)
                    transform = CGAffineTransformRotate(transform, (-3.14159265/2.0) * 3.0);
                if (originalImageOrientation == UIImageOrientationDown)
                    transform = CGAffineTransformRotate(transform, (-3.14159265/2.0) * 2.0);
                if (originalImageOrientation == UIImageOrientationRight)
                    transform = CGAffineTransformRotate(transform, (-3.14159265/2.0) * 1.0);
                
                CGSize frameSize = my_maskableCanvasView.frame.size;
                // CGSize imageSize = maskableImageSet.originalImage.size;
                CGFloat scale = CGFloat_min2(frameSize.width / originalSize.width, frameSize.height / originalSize.height);
                transform = CGAffineTransformScale(transform, scale * 0.9, scale * 0.9);
                
                
                [maskableImageSet setTransform:transform];
                
                [canvas.vd appendMaskableImageSet:maskableImageSet];

                [my_maskableCanvasView reload:ImageQuality_Mid];
            }
        }
    
        [self reload];
        
        if (my_popoverOrNil != nil)
            [my_popoverOrNil dismissPopoverAnimated:YES];
	}    
    

@end




