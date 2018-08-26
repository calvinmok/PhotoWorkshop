



#import "DataType.h"



Bool Path_isAbsolute(String* path);

String* Path_combine(String* path, String* component);

String* Path_parent(String* path);




typedef enum
{
	PathType_NotExist,
	PathType_File, 
	PathType_Directory
}
PathType;

STRUCT_NUBLE_TEMPLATE(PathType);


PathType FileManager_getPathType(String* path);


StringList* FileManager_getAllItemShallow(String* path);
StringList* FileManager_getAllItemDeeply(String* path);


Bool FileManager_createDirectory(String* path);

Bool FileManager_writeFileByData(String* path, NSData* data);
Bool FileManager_writeFileByUTF8(String* path, String* data);

String* FileManager_readFileByUTF8(String* path);



Bool FileManager_removeDeeply(String* path);


void FileManager_selfTest(void);







@interface PrivateFileSys : ObjectBase
	{
		String* my_base;
	}


	+ (PrivateFileSys*) createFromDocuments:(String*)subBase;
	
    
    - (String*) getAbsolutePath :(String*)path;

	
	- (StringList*) getAllItemDeeply;
	- (StringList*) getAllItemShallow;
	
	- (PathType) getPathType :(String*)path;
	
	
	- (Bool) createDirectory:(String*)path;
	
	
	- (String*) readFile :(String*)path;
	- (void) writeFile :(String*)path :(String*)data;
	
	- (NSData*) readData :(String*)path;
    - (DataReadingFlow*) readDataFlow :(String*)path;
    
	- (void) writeData :(String*)path :(NSData*)data;
	
    
    
    
	
	
	- (void) removeDeeply :(String*)path;
    
    
    - (void) removeAll;

@end


