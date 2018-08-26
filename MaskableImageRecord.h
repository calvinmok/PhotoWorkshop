


#import "MaskableCanvasView.h"



@class Record;
@class MutableRecord;


@interface Record : ObjectBase
    {
        Int my_identity;
        DT2001 my_lastUpdate;     
        String* my_name;   
    }
    
    @property(readonly) Int identity;    
    @property(readonly) DT2001 lastUpdateTime;    
    @property(readonly) String* name;

@end

OBJECT_NUBLE_TEMPLATE(Record)
OBJECT_LIST_INTERFACE_TEMPLATE(Record, NSObject)


@interface StableRecord : Record

    + (StableRecord*) create :(Record*)record;
        
@end

OBJECT_NUBLE_TEMPLATE(StableRecord)
OBJECT_LIST_INTERFACE_TEMPLATE(StableRecord, Record)


@interface MutableRecord : Record

    + (MutableRecord*) create :(Int)identity;
        
    - (void) setIdentity:(Int)identity;
    - (void) setLastUpdateTime:(DT2001)lastUpdateTime;
    - (void) setName:(String*)name;

@end

OBJECT_NUBLE_TEMPLATE(MutableRecord)
OBJECT_LIST_INTERFACE_TEMPLATE(MutableRecord, Record)


@interface Record_ListBase(_)
    
    - (Int) nextIdentity;

    - (NubleID) findRecordByIdentity:(Int)identity;

    - (void) writeToFlow :(WritingFlow*)flow;
    
@end



void RecordList_readFromFlow(ObjectMutableListTemplate* me, ReadingFlow* flow);
void RecordList_sortByLastUpdateTime(ObjectMutableListTemplate* me);

StableRecordStableList* RecordList_toStable(ObjectListTemplate* me);










@class ProjectViewController;


@protocol ProjectViewController_Owner_



    - (void) ProjectViewController_removeAllData;


	- (UIImage*) ProjectViewController_getThumbnail :(Int)recordID;

			
    - (void) ProjectViewController_selected :(Int)recordID;
    - (void) ProjectViewController_cancel;
    
    - (void) ProjectViewController_creating;
    - (void) ProjectViewController_deleting :(Int)recordID;
    

    - (void) ProjectViewController_nameChanging :(Int)recordID :(String*)newName;
	
@end

typedef NSObject<ProjectViewController_Owner_> ProjectViewController_Owner;



@interface ProjectViewController : UITableViewController<UITextFieldDelegate>
    {
        ProjectViewController_Owner* my_owner;
        
        NubleInt my_currentRecordID;
        StableRecordStableList* my_allRecord;
        
		UIBarButtonItem* my_cancelBarButtonItem;		
		UIBarButtonItem* my_editBarButtonItem;
		UIBarButtonItem* my_doneBarButtonItem;
		        
    }

	
	+ (ProjectViewController*) create :(ProjectViewController_Owner*)owner;
	- (void) _creating :(ProjectViewController_Owner*)owner;
	
    

	- (void) updateAllRecord :(NubleInt)currentRecordID :(StableRecordStableList*)allRecord;
    


	- (void) _cancel;
	- (void) _edit;
	

@end







