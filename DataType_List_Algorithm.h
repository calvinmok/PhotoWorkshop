









@interface ObjectList (Algorithm)

	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller;	
	- (BinarySearchResult) binarySearch :(ID_IsSmallerTarget)isSmaller :(Int)start :(Int)end;
	
    - (NubleID) max:(ID_IsSmallerXY)isSmaller;
    - (NubleID) min:(ID_IsSmallerXY)isSmaller;
    
@end



@interface StructList (Algorithm)

	- (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller;	
	- (BinarySearchResult) binarySearch :(ConstPntr_IsSmallerTarget)isSmaller :(Int)start :(Int)end;
			
@end





@interface ObjectMutableList (Algorithm)

	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY;
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end;
	- (void) mergeSort :(ID_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(ObjectMutableList*)helper;

@end



@interface StructMutableList (Algorithm)

	- (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY;
	- (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end;
	- (void) mergeSort :(ConstPntr_IsSmallerXY)isSmallerXY :(Int)start :(Int)end :(StructMutableList*)helper;

@end





