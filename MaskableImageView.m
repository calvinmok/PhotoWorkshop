




#import "MaskableImageView.h"







@implementation MaskableImageView 
    
    + (MaskableImageView*) create :(CGSize)size
    {
        MaskableImageView* result = [[[MaskableImageView alloc] init] autorelease];
        
        [result _create :size];
        
        return result;
    }
    
    - (void) _create :(CGSize)size
    {
        self.frame = CGRectMake(0.f, 0.f, size.width, size.height);            
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
        my_isEditing = NO;
        my_imageMaskTool = ImageMaskTool_Eraser;
        my_lastToPoint = CGPoint_nuble();
                
        
        my_imageView = [[UIImageView alloc] init];
        my_imageView.frame = CGRectZero;            
    
        
        UIRotationGestureRecognizer* rotationGesture = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_rotate:)] autorelease];
        [self addGestureRecognizer:rotationGesture];
        
        
        UIPinchGestureRecognizer* pinchGesture = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_scale:)] autorelease];
        [pinchGesture setDelegate:self];
        [self addGestureRecognizer:pinchGesture];


        UIPanGestureRecognizer* panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)] autorelease];
        [panGesture setDelegate:self];
        [panGesture setMinimumNumberOfTouches:1];
        [panGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:panGesture];
        
        UIPanGestureRecognizer* doublePanGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_doublePan:)] autorelease];
        [doublePanGesture setDelegate:self];
        [doublePanGesture setMinimumNumberOfTouches:2];
        [doublePanGesture setMaximumNumberOfTouches:2];
        [self addGestureRecognizer:doublePanGesture];
        
        UITapGestureRecognizer* tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)] autorelease];
        [tapGesture setDelegate:self];        
        [self addGestureRecognizer:tapGesture];
        
        [self addSubview:my_imageView];
    }
    
    - (void) dealloc
    {
        [my_imageView release];
        
        [super dealloc];
    }
    
                
                
                
    
    - (void) _adjustAnchorPoint :(UIView*)view :(UIGestureRecognizer*)gestureRecognizer
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            CGPoint location = [gestureRecognizer locationInView:view];        
            view.layer.anchorPoint = CGPointMake(location.x / view.bounds.size.width, location.y / view.bounds.size.height);
            
            view.center = [gestureRecognizer locationInView:view.superview];
        }
    }
    
    
    - (void) _rotate:(UIRotationGestureRecognizer*)gestureRecognizer
    {
        UIGestureRecognizerState state = [gestureRecognizer state];
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) 
        {
            [self _adjustAnchorPoint :my_imageView :gestureRecognizer];
                        
            my_imageView.transform = CGAffineTransformRotate(my_imageView.transform, [gestureRecognizer rotation]);
            
            [gestureRecognizer setRotation:0.f];
        }
    }
    
    - (void) _scale:(UIPinchGestureRecognizer*)gestureRecognizer
    {
        UIGestureRecognizerState state = [gestureRecognizer state];
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) 
        {
            [self _adjustAnchorPoint :my_imageView :gestureRecognizer];
            
            my_imageView.transform = CGAffineTransformScale(my_imageView.transform, gestureRecognizer.scale, gestureRecognizer.scale);
            
            [gestureRecognizer setScale:1.f];
        }
    }
    
    

    - (void) _doublePan:(UIPanGestureRecognizer*)gestureRecognizer
    {
        if (my_maskableImageSet.hasVar == NO)
            return;
            
        [self _adjustAnchorPoint :my_imageView :gestureRecognizer];
        
        CGPoint translation = [gestureRecognizer translationInView:my_imageView.superview];
        my_imageView.center = CGPoint_add(my_imageView.center, translation);
    
        [gestureRecognizer setTranslation:CGPointZero inView:my_imageView.superview];            
        
    }
    
        
    
    - (void) _pan:(UIPanGestureRecognizer*)gestureRecognizer
    {
        if (my_maskableImageSet.hasVar == NO)
            return;
            
   
            
        UIGestureRecognizerState state = [gestureRecognizer state];
        
        CGSize boundSize = my_imageView.bounds.size;
        CGSize imageSize = my_maskableImageSet.vd.originalImage.image.size;
        CGFloat sx = imageSize.width / boundSize.width;
        CGFloat sy = imageSize.height / boundSize.height;
        
        CGAffineTransform invert = CGAffineTransformInvert(my_imageView.transform);
        CGSize penSS = CGSize_abs(CGSizeApplyAffineTransform(CGSizeMake(64.f, 64.f), invert));
        CGFloat penSize = ((penSS.width + penSS.height) / 2.f) * ((sx + sy) / 2.f);
                    
        if (state == UIGestureRecognizerStateBegan)
        {
            CGPoint location = [gestureRecognizer locationInView:my_imageView];   
            location.y = boundSize.height - location.y;
            location = CGPoint_scale2(location, sx, sy);
            
            AggPixelResult aggPixelResult = [my_maskableImageSet.vd getAggMaskPixel :location :penSize];
                
            my_isEditing = Int_abs((Int)aggPixelResult.max - (Int)aggPixelResult.min) > 128;
        }
        
        if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateEnded) 
        {
            if (my_isEditing)
            {
                CGPoint translation = [gestureRecognizer translationInView:my_imageView];
                translation.y = -translation.y;

                CGPoint fromPoint = [gestureRecognizer locationInView:my_imageView];                  
                fromPoint.y = boundSize.height - fromPoint.y;
                
                CGPoint toPoint = CGPoint_add(fromPoint, translation);                
                                
                fromPoint = CGPoint_scale2(fromPoint, sx, sy);
                toPoint = CGPoint_scale2(toPoint, sx, sy);
            
                if (my_lastToPoint.hasVar)
                {
                    [my_maskableImageSet.vd edit :my_lastToPoint.vd :fromPoint :penSize];
                }
                
                my_lastToPoint = CGPoint_toNuble(toPoint);
                
                [my_maskableImageSet.vd edit :fromPoint :toPoint :penSize];
                
                [self reloadImageView];
                
                [gestureRecognizer setTranslation:CGPointZero inView:my_imageView];
            }        
            else
            {
                [self _doublePan:gestureRecognizer];
                return;
            }
        }
        
        if (state == UIGestureRecognizerStateEnded)
        {
            my_lastToPoint = CGPoint_nuble();
            
            [self reloadImageView];
            
            [my_maskableImageSet.vd endSession];
        }
    }
            
    - (void) _tap:(UITapGestureRecognizer*)gestureRecognizer
    {
        return;
    }
    
        
    - (BOOL) gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
    {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
            return NO;
        
        return YES;
    }        
    

    - (ImageMaskTool) imageMaskTool 
    { 
        return my_imageMaskTool; 
    }
    - (void) setImageMaskTool :(ImageMaskTool)tool
    { 
        my_imageMaskTool = tool; 
        [my_maskableImageSet.vd setImageMaskTool:my_imageMaskTool];
        
        [self reloadImageView];
    }
    
    
    - (void) setMaskableImageSet :(NubleMutableMaskableImageSet)maskableImageSet
    {        
        my_imageView.transform = CGAffineTransformIdentity;
                
        if (maskableImageSet.hasVar == NO)
        {
            MutableMaskableImageSet_autorelease(maskableImageSet);
            my_maskableImageSet = MutableMaskableImageSet_nuble();
            
            my_imageView.image = nil;
            
            my_imageView.frame = CGRectMake(CGPointZero.x, CGPointZero.y, CGSizeZero.width, CGSizeZero.height);
            
            return;
        }
        
        
        MutableMaskableImageSet_autorelease(my_maskableImageSet);
        my_maskableImageSet = MutableMaskableImageSet_retain(maskableImageSet);
        
        [my_maskableImageSet.vd setImageMaskTool:my_imageMaskTool];
        
        [self initImageView];
        
    }
    
    - (NubleMutableMaskableImageSet) maskableImageSet
    {
        return my_maskableImageSet;
    }
        
    
    
    - (void) initImageView
    {
        if (my_maskableImageSet.hasVar == NO)
            return;
            
        CGSize frameSize = self.frame.size;
        CGRect rect = CGRectMake(0.f, 0.f, frameSize.width, frameSize.height);  
        CGFloat ratio = CGSize_ratio_(my_maskableImageSet.vd.originalImage.image.size).vd;                                 

        my_imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        my_imageView.transform = CGAffineTransformIdentity; // it seems this setting transform statement have to come before setting frame statement, so that the second setting transform statement will work.

        my_imageView.frame = CGRect_shrinkRatio(rect, ratio);    
            
        [self reloadImageView];

        my_imageView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    }
    
    - (void) reloadImageView
    {
        if (my_maskableImageSet.hasVar == NO)
            return;
        
        my_imageView.image = [my_maskableImageSet.vd generateImage :ImageQuality_Mid :NO];
    }

    - (void) undo
    {
        if (my_maskableImageSet.hasVar)
        {
            [my_maskableImageSet.vd undo];
            [self reloadImageView];
        }
    }        

    - (void) redo
    {
        if (my_maskableImageSet.hasVar)
        {
            [my_maskableImageSet.vd redo];
            [self reloadImageView];
        }
    }        
    
    
    
@end








@implementation MaskableImageViewController 


    + (MaskableImageViewController*) create :(MaskableImageViewControllerOwner*)owner :(CGSize)size
    {
        MaskableImageViewController* result = [[[MaskableImageViewController alloc] init] autorelease];
        [result _create :owner :size];
        return result;
    }
    
    - (void) _create :(MaskableImageViewControllerOwner*)owner :(CGSize)size
    {
        my_owner = owner;    
        
        
        Layout* layout = [Layout create :self :size];
        
      
        UIImage* leftImage = [UIImage imageNamed:@"Left.png"];
        UIImage* undoImage = [UIImage imageNamed:@"Undo.png"];
        UIImage* redoImage = [UIImage imageNamed:@"Redo.png"];
        UIImage* eraserImage = [UIImage imageNamed:@"Eraser.png"];
        UIImage* pencilImage = [UIImage imageNamed:@"Pencil.png"];
        
        
        my_closeButton = [[layout createButton :+1 :+1 :leftImage :@selector(_close)] retain];

        my_undoButton = [[layout createButton :+1 :-2 :undoImage :@selector(undo)] retain];
        my_redoButton = [[layout createButton :+1 :-1 :redoImage :@selector(redo)] retain];
    
        my_eraserButton = [[layout createButton :-2 :+1 :eraserImage :@selector(_eraser)] retain];
        my_pencilButton = [[layout createButton :-1 :+1 :pencilImage :@selector(_pencil)] retain];
            
            
        my_maskableImageView = [[MaskableImageView create :size] retain];
        
        
        my_rootView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
        my_rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
                    
        my_backgroundImageView = [[UIImageView alloc] init];
        my_backgroundImageView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        my_backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
        
        [my_rootView addSubview:my_backgroundImageView];         
        [my_rootView addSubview:my_maskableImageView];         
        [my_rootView addSubview:my_closeButton];         
        [my_rootView addSubview:my_undoButton];         
        [my_rootView addSubview:my_redoButton];         
        [my_rootView addSubview:my_eraserButton];         
        [my_rootView addSubview:my_pencilButton];    
        
                  
        [my_eraserButton setTransform: self._eraserButtonTransform];
        [my_pencilButton setTransform: self._pencilButtonTransform];
    }
    
    
        
    - (void) dealloc
    {
        [my_closeButton release];        
        [my_undoButton release];
        [my_redoButton release];
        
        [my_maskableImageView release];
        [my_backgroundImageView release];
        [my_rootView release];
        
        [super dealloc];
    }
    
    
    
	- (void) loadView
	{
        my_backgroundImageView.image = createBackgroundImage(my_backgroundImageView.frame.size);
    
        self.view = my_rootView;        
    }
    

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
	{
		return YES;
	}

    - (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
    {
        my_backgroundImageView.image = createBackgroundImage(my_backgroundImageView.frame.size);    
        [my_maskableImageView initImageView];
    }



	        
    
    
    
    
    - (void) setMaskableImageSet :(NubleMutableMaskableImageSet)maskableImageSet
    {
        [my_maskableImageView setMaskableImageSet:maskableImageSet];
        [self _eraser];
    }
    
    - (NubleMutableMaskableImageSet) maskableImageSet
    {
        return [my_maskableImageView maskableImageSet];
    }
    
    
    
    - (void) _close
    {
        [self _eraser];
        [my_owner MaskableImageViewController_close];
    }
    
            
    - (void) undo
    {
        [my_maskableImageView undo];
    }
    
    - (void) redo
    {
        [my_maskableImageView redo];
    }
    
    
    - (void) _eraser
    {
        [my_maskableImageView setImageMaskTool:ImageMaskTool_Eraser];
        
        [my_eraserButton setTransform: self._eraserButtonTransform];
        [my_pencilButton setTransform: self._pencilButtonTransform];
    }
    
    - (void) _pencil
    {
        [my_maskableImageView setImageMaskTool:ImageMaskTool_Pencil];

        [my_eraserButton setTransform: self._eraserButtonTransform];
        [my_pencilButton setTransform: self._pencilButtonTransform];
    }
    
    - (CGAffineTransform) _eraserButtonTransform 
    { 
        CGFloat s = (my_maskableImageView.imageMaskTool == ImageMaskTool_Eraser) ? 1.0 : 0.8;
        return CGAffineTransformMakeScale(s, s);
    }    
    - (CGAffineTransform) _pencilButtonTransform
    { 
        CGFloat s = (my_maskableImageView.imageMaskTool == ImageMaskTool_Pencil) ? 1.0 : 0.8;
        return CGAffineTransformMakeScale(s, s);
    }    


@end











