






#import "AppDelegate.h"





@implementation AppDelegate


    - (void)dealloc
    {
        [my_fileSys release];
        
        [my_window release];
        [my_viewController release];
        
        [my_navigationController release];
        [my_projectVC release];
        
        [super dealloc];
    }

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
    
        my_fileSys = [[PrivateFileSys createFromDocuments:STR(@"1")] retain];
        
        //[my_fileSys removeAll];
                    
    
        [application setStatusBarHidden:YES];
    

        
        CGRect appFrame = [UIScreen mainScreen].applicationFrame;
        
        
        my_currentRecordID = Int_nuble();
        my_allRecord = [[MutableRecordMutableList create:10] retain];
  
            
        my_viewController = [[MaskableCanvasViewController create :self :appFrame] retain];
        [my_viewController newCanvas];
        
        
        my_projectVC = [[ProjectViewController create:self] retain];
        my_navigationController = [[UINavigationController alloc] initWithRootViewController:my_projectVC];
        
        
        
        
            
        my_window = [[Window create] retain];
        
        
        [my_window setObserver:self];
        [my_window addSubview:my_viewController.view];
        
        [my_window layoutSubviews];
        
        
        
        
        [self loadAllRecord];
        if (my_allRecord.count == 0)
            [self newProject];
            
        [my_projectVC updateAllRecord :my_currentRecordID :RecordList_toStable(my_allRecord)];
        
        
        
        my_window.backgroundColor = [UIColor whiteColor];
        [my_window makeKeyAndVisible];
        return YES;
    }
    
    
    
    - (void) saveAllRecord
    {                
        DataWritingFlow* flow = [DataWritingFlow create:1000];
        
        [flow writeNubleInt :my_currentRecordID :Int_Max];
        [my_allRecord writeToFlow:flow];
        [my_fileSys writeData :STR(@"records.txt") :[flow end]];
    }
    
    - (void) loadAllRecord
    {
        NubleInt currentRecordID = Int_nuble();

        [my_allRecord removeAll];
        
        DataReadingFlow* flow = [my_fileSys readDataFlow:STR(@"records.txt")];   
        
        if (flow.remaining > (Int)sizeof(Int))   
        {
            currentRecordID = [flow readNubleInt:Int_Max];
            
            RecordList_readFromFlow(my_allRecord, flow);

            if (currentRecordID.hasVar)
            {
                NubleID r = [my_allRecord findRecordByIdentity:currentRecordID.vd];  
                if (r.hasVar == NO)              
                    currentRecordID = Int_nuble();
            }
        }
        
        if (currentRecordID.hasVar)
            [self loadCurrentProject :currentRecordID.vd];
        
        RecordList_sortByLastUpdateTime(my_allRecord);
    }
    
    
    
    
    
    - (void) saveCurrentProject
    {
        if (my_currentRecordID.hasVar == NO)
            return;
            
        String* projectFileName = String_concat(Int_print(my_currentRecordID.vd), STR(@".project"));
    
        //DataWritingFlow* projectDataFlow = [DataWritingFlow create:1000];
        FileHandleWritingFlow* projectDataFlow = [FileHandleWritingFlow create :[my_fileSys getAbsolutePath :projectFileName]];
        
        if ([my_viewController saveCanvasToFlow:projectDataFlow])
        {
            MutableRecord* currentRecord = CAST(MutableRecord, [my_allRecord findRecordByIdentity:my_currentRecordID.vd].vd);
            if (currentRecord == nil)
                return;
            
            [currentRecord setLastUpdateTime:DT2001_createNow()];
            RecordList_sortByLastUpdateTime(my_allRecord);
            
            [self saveAllRecord];
            
            String* thumbnailFileName = String_concat(Int_print(my_currentRecordID.vd), STR(@".thumbnail"));
            UIImage* thumbnailImage = [my_viewController createThumbnailWithBackground :CGSizeMake(160, 160)];            
            [my_fileSys writeData :thumbnailFileName :UIImagePNGRepresentation(thumbnailImage)];
        
            // [my_fileSys writeData :projectFileName :[projectDataFlow end]];
            [projectDataFlow close];
        }            
    }
    
    - (void) loadCurrentProject :(Int)recordID
    {
        MutableRecord* record = NubleID_AS(MutableRecord, [my_allRecord findRecordByIdentity:recordID]).vd;        
        if (record == nil)
            return;
        
        my_currentRecordID = Int_toNuble(record.identity);
        
        String* projectFileName = String_concat(Int_print(my_currentRecordID.vd), STR(@".project"));            
        [my_viewController loadCanvasFromFlow:[my_fileSys readDataFlow:projectFileName]];
    }
    
    - (void) newProject
    {
        [my_viewController newCanvas];        
        
        Int nextID = [my_allRecord nextIdentity];
        MutableRecord* record = [MutableRecord create:nextID];
        [record setLastUpdateTime:DT2001_createNow()];
        
        [my_allRecord insert:record]; 
        RecordList_sortByLastUpdateTime(my_allRecord);
               
        my_currentRecordID = Int_toNuble(record.identity);
                        
        [self saveCurrentProject];        
    }
        
    - (void) deleteProject :(Int)recordID
    {
        if (my_currentRecordID.hasVar && my_currentRecordID.vd == recordID)
            return;
            
        [my_allRecord removeMatch:^Bool(MutableRecord* r) { return r.identity == recordID; }];
        [self saveAllRecord];        
            
        String* thumbnailFileName = String_concat(Int_print(recordID), STR(@".thumbnail"));
        [my_fileSys removeDeeply:thumbnailFileName];
        
        String* projectFileName = String_concat(Int_print(recordID), STR(@".project"));
        [my_fileSys removeDeeply:projectFileName];        
    }
    
    
    
    
    
    
    
    - (void) MaskableCanvasViewController_openProjectMenu
    {
        [self saveCurrentProject];    
        [my_projectVC updateAllRecord :my_currentRecordID :RecordList_toStable(my_allRecord)];
        [my_viewController presentModalViewController:my_navigationController animated:YES];
    }
        
    
  
    
    
    - (void) ProjectViewController_removeAllData
    {
    }
    
    
	- (UIImage*) ProjectViewController_getThumbnail :(Int)recordID
    {    
        String* thumbnailFileName = String_concat(Int_print(recordID), STR(@".thumbnail"));
        NSData* data = [my_fileSys readData:thumbnailFileName];        
        return [UIImage imageWithData:data];
    }
    
    - (void) ProjectViewController_selected :(Int)recordID
    {
        [self loadCurrentProject:recordID];            
        [my_viewController dismissModalViewControllerAnimated:YES];
    }
    
    - (void) ProjectViewController_cancel
    {
        [my_viewController dismissModalViewControllerAnimated:YES];        
        [my_viewController reload];
    }
    
    - (void) ProjectViewController_creating
    {
        [self newProject];   
        [my_viewController dismissModalViewControllerAnimated:YES];
    }
    
    - (void) ProjectViewController_deleting :(Int)recordID
    {
        [self deleteProject:recordID];
        [my_projectVC updateAllRecord :my_currentRecordID :RecordList_toStable(my_allRecord)];        
    }
	    
    
    - (void) ProjectViewController_nameChanging :(Int)recordID :(String*)newName
    {
        NubleMutableRecord record = NubleID_AS(MutableRecord, [my_allRecord findRecordByIdentity:recordID]);
        if (record.hasVar)
        {
            [record.vd setName:newName];            
            [self saveAllRecord];
            
            [my_projectVC updateAllRecord :my_currentRecordID :RecordList_toStable(my_allRecord)];            
        }
    }
	 
    
    
    
    
    
    
    
	- (void) Window_shake
    {
        [my_viewController undo];
    }
    
            	    
    
    

    - (void)applicationWillResignActive:(UIApplication *)application
    {
        [self saveCurrentProject];        
        [my_projectVC updateAllRecord :my_currentRecordID :RecordList_toStable(my_allRecord)];
        
        /*
         Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
         Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
         */
    }

    - (void)applicationDidEnterBackground:(UIApplication *)application
    {
        [self saveCurrentProject];
        [my_projectVC updateAllRecord :my_currentRecordID :RecordList_toStable(my_allRecord)];
        /*
         Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
         If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         */
    }

    - (void)applicationWillEnterForeground:(UIApplication *)application
    {
        /*
         Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
         */
    }

    - (void)applicationDidBecomeActive:(UIApplication *)application
    {
        /*
         Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
         */
    }

    - (void)applicationWillTerminate:(UIApplication *)application
    {
        /*
         Called when the application is about to terminate.
         Save data if appropriate.
         See also applicationDidEnterBackground:.
         */
    }

@end





















