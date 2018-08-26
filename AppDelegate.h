


#import "MathData.h"
#import "FileSys.h"



#import "Window.h"

#import "MaskableCanvasView.h"

#import "MaskableImageRecord.h"



#define AppDelegate_PROTOCOLS \
    \
    UIApplicationDelegate, \
    \
    WindowObserver_, \
    MaskableCanvasViewControllerOwner_, \
    ProjectViewController_Owner_ 



@interface AppDelegate : UIResponder <AppDelegate_PROTOCOLS>
    {
    
        PrivateFileSys* my_fileSys;
    
    
        Window* my_window;
        
        MaskableCanvasViewController* my_viewController;
        
        
        NubleInt my_currentRecordID;
        MutableRecordMutableList* my_allRecord;
        
        
        UINavigationController* my_navigationController;
        ProjectViewController* my_projectVC;
        
        
        
        
    }


    - (void) saveAllRecord;
    - (void) loadAllRecord;   
    
    - (void) saveCurrentProject;
    - (void) loadCurrentProject :(Int)recordID;     
    - (void) newProject;
    - (void) deleteProject :(Int)recordID;
    
    
@end
