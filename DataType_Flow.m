








#import "DataType.h"



#import "FileSys.h"











void ReadingFlow_selftest(void);
void ReadingFlow_selftest(void)
{
    SELFTEST_START
    
    

    
    DataWritingFlow* writingFlow = [DataWritingFlow create:100];    
    [writingFlow writeInt:0];
    [writingFlow writeInt:1];
    [writingFlow writeInt:Int_Max];
    
    [writingFlow writeDouble:99999.99999];
    
    [writingFlow writeLengthAndString:STR(@"")];
    [writingFlow writeLengthAndString:STR(@"abc")];
    
    
    
    DataReadingFlow* readingFlow = [DataReadingFlow create:[writingFlow end]];
    ASSERT([readingFlow readInt] == 0);
    ASSERT([readingFlow readInt] == 1);
    ASSERT([readingFlow readInt] == Int_Max);
    
    ASSERT([readingFlow readDouble] == 99999.99999);
    
    [[readingFlow readLengthAndString] assert:@""];
    [[readingFlow readLengthAndString] assert:@"abc"];
    
    
    
    SELFTEST_END
    
    
}










@implementation ReadingFlow
    
    - (NSData*) readData:(Int)length { ABSTRACT_METHOD_NIL }
    
    - (BOOL) hasMoreData { ABSTRACT_METHOD(BOOL) }
        
@end

@implementation WritingFlow
    
    - (void) writeByte:(Byte)byte { ABSTRACT_METHOD_VOID }
    - (void) writeData:(NSData*)data { ABSTRACT_METHOD_VOID }
    
@end






@implementation ReadingFlow (_)

    - (Int) readInt
    {
        ReadingFlow_selftest();
        
        NSData* data = [self readData:4];
        return Byte4_toInt(Byte4_fromData(data, 0));
    }
    
    - (NubleInt) readNubleInt :(Int)def
    {
        Int i = [self readInt];        
        return (i == def) ? Int_nuble() : Int_toNuble(i);
    }
    
    
    - (Double) readDouble
    {
        NSData* data = [self readData:8];
        return Byte8_toDouble(Byte8_fromData(data, 0));
    }
    
    - (DT2001) readDT2001
    {
        NSData* data = [self readData:19 * 2];
        MutableString* str = [MutableString create:19];
        
        for (Int i = 0; i < 19 * 2; i += 2)
        {
            Char c = Byte2_toChar(Byte2_fromData(data, i));            
            [str appendChar:c];
        }    
        
        NubleDT2001 result = DT2001_parse(str);
        
        if (result.hasVar == NO)
            Exception_raise();
            
        return result.vd;
    }
    
    
    
    
    - (CGAffineTransform) readCGAffineTransform
    {
        CGAffineTransform result;        
        result.a = [self readDouble];
        result.b = [self readDouble];
        result.c = [self readDouble];
        result.d = [self readDouble];
        result.tx = [self readDouble];
        result.ty = [self readDouble];
        return result;        
    }
    
    

    - (String*) readLengthAndString
    {
        Int length = [self readInt];
        if (length == 0)
            return String_empty();
        
        NSData* data = [self readData:length];
        
        MutableString* result = [MutableString create:length / 2];
        
        for (Int i = 0; i <= length - 2; i += 2)
        {
            Char c = Byte2_toChar(Byte2_fromData(data, i));            
            [result appendChar:c];
        }
        
        return [result seal];
    }
    
    - (NSData*) readLengthAndData
    {
        Int length = [self readInt];
        if (length == 0)
            return [NSData data];
        
        return [self readData:length];
    }
    

@end



@implementation WritingFlow (_)

    - (void) writeInt:(Int)i
    {
        ReadingFlow_selftest();
        
        Byte4 b = Byte4_fromInt(i);        
        [self writeByte:b.a];
        [self writeByte:b.b];
        [self writeByte:b.c];
        [self writeByte:b.d];
    }
    
    - (void) writeNubleInt :(NubleInt)i :(Int)def
    {
        if (i.hasVar) 
            [self writeInt:i.vd];
        else
            [self writeInt:def];
    }
    
    - (void) writeDouble:(Double)d
    {
        Byte8 b = Byte8_fromDouble(d);        
        [self writeByte:b.a];
        [self writeByte:b.b];
        [self writeByte:b.c];
        [self writeByte:b.d];
        [self writeByte:b.e];
        [self writeByte:b.f];
        [self writeByte:b.g];
        [self writeByte:b.h];
    }
    
    - (void) writeDT2001:(DT2001)d
    {
        String* string = DT2001_printYMDHMS(d);
        
        FOR_EACH_INDEX(i, string) 
        {
            Byte2 b = Byte2_fromChar([string charAt:i]);            
            [self writeByte:b.a];
            [self writeByte:b.b];
        }        
    }

    
    
    
    - (void) writeCGAffineTransform:(CGAffineTransform)transform
    {
        [self writeDouble:transform.a];
        [self writeDouble:transform.b];
        [self writeDouble:transform.c];
        [self writeDouble:transform.d];
        [self writeDouble:transform.tx];
        [self writeDouble:transform.ty];        
    }
    
    

    - (void) writeLengthAndString:(String*)string
    {
        [self writeInt:string.length * 2];
        
        FOR_EACH_INDEX(i, string) 
        {
            Byte2 b = Byte2_fromChar([string charAt:i]);            
            [self writeByte:b.a];
            [self writeByte:b.b];
        }           
    }
    
    - (void) writeLengthAndData:(NSData*)data
    {
        [self writeInt:toInt(data.length)];
        [self writeData:data];            
    }
    
    

@end










@implementation DataReadingFlow : ReadingFlow

    + (DataReadingFlow*) create:(NSData*)data
    {
        DataReadingFlow* result = [[[DataReadingFlow alloc] init] autorelease];
        result->my_offset = 0;
        result->my_data = [data retain];
        return result;        
    }
    
    - (void) dealloc
    {
        [my_data release];
        [super dealloc];
    }
    
    
    - (NSData*) readData:(Int)length
    {
        ASSERT(length > 0);
        
        Int dataLength = toInt(my_data.length);
        if (my_offset + length > dataLength)
            Exception_raise();        
        
        NSRange range = NSMakeRange(toUInt(my_offset), toUInt(length));
        NSData* result = [my_data subdataWithRange:range];
        
        my_offset += toUInt(length);

        return result;
    }
    
    - (BOOL) hasMoreData 
    {  
        return my_offset < my_data.length;
    }
    
    
    - (Int) length
    {
        return toInt(my_data.length);
    }
    
    - (Int) remaining
    {
        return toInt(my_data.length) - my_offset;
    }
    
        
@end


@implementation DataWritingFlow : WritingFlow
    
    + (DataWritingFlow*) create:(Int)capacity
    {
        DataWritingFlow* result = [[[DataWritingFlow alloc] init] autorelease];
        result->my_ended = NO;
        result->my_data = [[NSMutableData alloc] initWithCapacity:toUInt(capacity)];
        return result;
    }
    
    - (void) dealloc
    {
        [my_data release];
        [super dealloc];
    }
    
    - (void) writeByte:(Byte)byte    
    {
        ASSERT(my_ended == NO);
        [my_data appendBytes:&byte length:1];
    }
    
    - (void) writeData:(NSData*)data 
    {
        ASSERT(my_ended == NO);
        [my_data appendData:data];
    }
        
    
    - (NSData*) end
    {
        my_ended = YES;
        return my_data;
    }
        
    
@end















@implementation FileHandleWritingFlow 


    + (FileHandleWritingFlow*) create:(String*)path
    {
        //if (FileManager_getPathType(path) != PathType_File)
        //{
            FileManager_writeFileByData(path, [NSData data]);
        //}
        
        FileHandleWritingFlow* result = [[[FileHandleWritingFlow alloc] init] autorelease];
        result->my_fileHandle = [[NSFileHandle fileHandleForWritingAtPath:path.ns] retain];
        
        return result;
    }
    
    - (void) dealloc 
    {
        if (my_fileHandle != nil)
        {
            [my_fileHandle closeFile];
            [my_fileHandle release];
            my_fileHandle = nil;
        }
        
        [super dealloc];
    }
    
    
    
    - (void) writeByte:(Byte)byte    
    {
        NSData* data = [NSData dataWithBytes:&byte length:1];
        [my_fileHandle writeData:data];
    }
    
    - (void) writeData:(NSData*)data 
    {
        [my_fileHandle writeData:data];
    }    
    
    
    - (void) close
    {
        if (my_fileHandle != nil)
        {
            [my_fileHandle closeFile];
            [my_fileHandle release];
            my_fileHandle = nil;
        }
    }
    

@end




