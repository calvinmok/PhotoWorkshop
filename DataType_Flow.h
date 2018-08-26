









@interface ReadingFlow : ObjectBase
    
    - (NSData*) readData:(Int)length;
    
    @property(readonly) BOOL hasMoreData;
    
@end

@interface WritingFlow : ObjectBase
    
    - (void) writeByte:(Byte)byte;
    - (void) writeData:(NSData*)data;
    
@end


@interface ReadingFlow (_)

    - (Int) readInt;
    - (NubleInt) readNubleInt :(Int)def;    

    - (Double) readDouble;    
    - (DT2001) readDT2001;
    
    - (CGAffineTransform) readCGAffineTransform;
    
    - (String*) readLengthAndString;
    - (NSData*) readLengthAndData;
    

@end



@interface WritingFlow (_)

    - (void) writeInt:(Int)i;
    - (void) writeNubleInt :(NubleInt)i :(Int)def;
        
    - (void) writeDouble:(Double)d;
    - (void) writeDT2001:(DT2001)d;
    
    - (void) writeCGAffineTransform:(CGAffineTransform)transform;

    - (void) writeLengthAndString:(String*)string;
    - (void) writeLengthAndData:(NSData*)data;

@end







@interface DataReadingFlow : ReadingFlow
    {
        NSData* my_data;
        
        Int my_offset;
    }
    
    + (DataReadingFlow*) create:(NSData*)data;
    
    @property(readonly) Int length;
    @property(readonly) Int remaining;
    
@end


@interface DataWritingFlow : WritingFlow
    {
        Bool my_ended;        
        NSMutableData* my_data;
    }
    
    + (DataWritingFlow*) create:(Int)capacity;
    
    - (NSData*) end;
    
@end





@interface FileHandleWritingFlow : WritingFlow
    {
        NSFileHandle* my_fileHandle;
    }

    + (FileHandleWritingFlow*) create:(String*)path;
    
    
    - (void) close;

@end





