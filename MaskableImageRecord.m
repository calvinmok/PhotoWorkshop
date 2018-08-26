



#import "MaskableImageRecord.h"



OBJECT_LIST_IMPLEMENTATION_TEMPLATE(Record, NSObject)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(StableRecord, Record)
OBJECT_LIST_IMPLEMENTATION_TEMPLATE(MutableRecord, Record)






@implementation Record
    
    - (void) dealloc
    {
        [my_name release];
        [super dealloc];
    }
    

    - (Int) identity { return my_identity; }    
    - (DT2001) lastUpdateTime { return my_lastUpdate; }
    - (String*) name { return my_name; }

@end


@implementation StableRecord

    + (StableRecord*) create :(Record*)record
    {
        StableRecord* result = [[[StableRecord alloc] init] autorelease];
        result->my_identity = record.identity;
        result->my_lastUpdate = record.lastUpdateTime;
        result->my_name = [[record.name toStable] retain];
        return result;    
    }
        
@end


@implementation MutableRecord

    + (MutableRecord*) create :(Int)identity
    {
        MutableRecord* result = [[[MutableRecord alloc] init] autorelease];        
        result->my_identity = identity;
        result->my_lastUpdate = DT2001_createNow();
        result->my_name = [STR(@"") retain];
        return result;
    }
    
    - (void) setIdentity:(Int)identity 
    { 
        my_identity = identity; 
    }  
    
    - (void) setLastUpdateTime:(DT2001)lastUpdateTime 
    { 
        my_lastUpdate = lastUpdateTime; 
    }    
    
    - (void) setName:(String*)name 
    {
        [my_name autorelease];
        my_name = [name retain];
    }

@end



@implementation Record_ListBase(_)
    
    - (Int) nextIdentity
    {
        NubleID max = [self.subject max:^(id x, id y)
        {            
            return Int_isSmallerXY(CAST(Record, x).identity, CAST(Record, y).identity);
        }];
        
        return (max.hasVar) ? ((Record*)max.vd).identity + 1 : 0;    
    }
    
    - (NubleID) findRecordByIdentity:(Int)identity
    {    
        return [self.subject firstOf_:^(id r) 
        { 
            Record* record = CAST(Record, r);
            return Bool_(record.identity == identity);
        }];  
    }
    
    - (void) writeToFlow :(WritingFlow*)flow
    {
        FOR_EACH_INDEX(i, self)
        {
            Record* record = [self Record_at:i];
            if (record == nil) 
                continue;
                
            [flow writeLengthAndString:STR(@"id")];            
            [flow writeLengthAndString:Int_print(record.identity)];
            
            [flow writeLengthAndString:STR(@"lastUpdateTime")];            
            [flow writeLengthAndString:DT2001_printYMDHMS(record.lastUpdateTime)];

            [flow writeLengthAndString:STR(@"name")];            
            [flow writeLengthAndString:record.name];

            if (i != self.lastIndex)
                [flow writeLengthAndString:STR(@"-/-")];           
            else
                [flow writeLengthAndString:STR(@"eof")];                       
        }    
    }
    
    
    
@end





void RecordList_readFromFlow(ObjectMutableListTemplate* me, ReadingFlow* flow)
{
    ASSERT(Class_isKindOf(me.type, [Record class]));

    [me.mutableSubject removeAll];
    
    for (Bool hasData = YES; hasData; )
    {
        NubleInt identity = Int_nuble();
        NubleDT2001 lastUpdateTime = DT2001_nuble();
        String* name = String_empty();
        
        while (YES)
        {            
            String* key = [flow readLengthAndString];
            
            IF ([key eq: STR(@"id")])
                identity = Int_parse([flow readLengthAndString]);
            
            EF ([key eq: STR(@"lastUpdateTime")])
                lastUpdateTime = DT2001_parse([flow readLengthAndString]);
                
            EF ([key eq: STR(@"name")])
                name = [flow readLengthAndString];

            EF ([key eq: STR(@"-/-")])
                break;
            
            EF ([key eq: STR(@"eof")])
            {
                hasData = NO;
                break;
            }
        }
        
        if (identity.hasVar && lastUpdateTime.hasVar)
        {
            MutableRecord* record = [MutableRecord create:identity.vd];
            [record setLastUpdateTime:lastUpdateTime.vd];
            [record setName:name];
            
            [me.mutableSubject append:record];
        }
    }
}


void RecordList_sortByLastUpdateTime(ObjectMutableListTemplate* me)
{
    ASSERT(Class_isKindOf(me.type, [Record class]));

    [me.mutableSubject mergeSort:^Bool3(id x, id y) 
    {
        Record* a = CAST(Record, x);
        Record* b = CAST(Record, y);
        return not(DT2001_isSmallerXY(a.lastUpdateTime, b.lastUpdateTime));
    }];
}


StableRecordStableList* RecordList_toStable(ObjectListTemplate* me)
{
    ASSERT(Class_isKindOf(me.type, [Record class]));
    
    StableRecordMutableList* result = [StableRecordMutableList create:me.subject.count];
    FOR_EACH_INDEX(i, me.subject)
    {
        Record* record = [me.subject at:i];
        if (record == nil) 
            continue;
            
        [result append:[StableRecord create:record]];
    }
    
    return [result toStable];
}











#define NameTextFieldTag 100
#define DateTimeLabelTag 200
#define ImageViewTag     300



@interface UITableViewCell(ProjectViewController)


    @property(readonly) Int recordIdentity;
    - (void) setRecordIdentity:(Int)recordIdentity;
    
    
    - (void) initTableViewCell;
    

    @property(readonly) UITextField* nameTextField;
    @property(readonly) UILabel*  dateTimeLabel;
    @property(readonly) UIImageView* imageView;

@end


#define ViewController_CellPadding  10
#define ViewController_CellHeight  (160 + ViewController_CellPadding + ViewController_CellPadding)


@interface UITableView(ProjectViewController)

    - (NubleUITableViewCell) findCellWithFirstResponderNameTextField;
    
@end



@implementation UITableViewCell(ProjectViewController)

    - (Int) recordIdentity
    {
        return self.tag;
    }
    
    - (void) setRecordIdentity:(Int)recordIdentity
    {
        self.tag = recordIdentity;
    }
    

    
    - (void) initTableViewCell
    {
        CGFloat selfWidth = self.contentView.frame.size.width;
        CGFloat selfHeight = ViewController_CellHeight;        
        CGFloat imageWidth = selfHeight - ViewController_CellPadding - ViewController_CellPadding;
        CGFloat imageHeight = selfHeight - ViewController_CellPadding - ViewController_CellPadding ;

        CGFloat m = [@"gXL ^_!@#$%^&*()_+-={}|[];':<>?,./" sizeWithFont:UIFont_systemLabel()].height + 8;

        UITextField* nameTextField = [[[UITextField alloc] init] autorelease];
        nameTextField.tag = NameTextFieldTag;
        nameTextField.placeholder = @"<Name>";
        nameTextField.returnKeyType = UIReturnKeyDone;
        nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        nameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        //nameTextField.frame = CGRect_moveTopTo(CGRectMake(m/2, m, selfWidth - imageWidth - m, m), m + ViewController_CellPadding);
        nameTextField.frame = CGRect_moveTopTo(CGRectMake(m/2, m, selfWidth - imageWidth - m, m), (ViewController_CellHeight - m) / 2.0);        

        UILabel* dateTimeLabel = [[[UILabel alloc] init] autorelease];
        dateTimeLabel.backgroundColor = [UIColor clearColor];
        dateTimeLabel.tag = DateTimeLabelTag;
        dateTimeLabel.adjustsFontSizeToFitWidth = YES;
        dateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dateTimeLabel.frame = CGRect_moveBottomTo(CGRectMake(m/2, m, selfWidth - imageWidth - m, m), selfHeight - m - ViewController_CellPadding);
    
        UIImageView* imageView = [[[UIImageView alloc] init] autorelease];
        imageView.tag = ImageViewTag;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        imageView.frame = CGRect_moveRightTo(CGRectMake(0, ViewController_CellPadding, imageWidth, imageHeight), selfWidth);
     
        UIView* rootView = [[[UIView alloc] init] autorelease];
        rootView.autoresizingMask = UIViewAutoresizingFlexibleWidthAndHeight;
        rootView.frame = CGRectMake(0, 0, selfWidth, selfHeight);
        [rootView addSubview:nameTextField];
        //[rootView addSubview:dateTimeLabel];
        [rootView addSubview:imageView];
        
        [self.contentView addSubview:rootView];    
    }
    
    
    - (UITextField*) nameTextField 
    {
        return (UITextField*)[self.contentView viewWithTag:NameTextFieldTag];
    }
    
    - (UILabel*) dateTimeLabel
    {
        return (UILabel*)[self.contentView viewWithTag:DateTimeLabelTag];
    }
    
    - (UIImageView*) imageView
    {
        return (UIImageView*)[self.contentView viewWithTag:ImageViewTag];
    }
    
@end


@implementation UITableView(ProjectViewController)

    - (NubleUITableViewCell) findCellWithFirstResponderNameTextField
    {
        NubleUITableViewCell result = UITableViewCell_nuble();
        
        for (NSInteger row = 0; row < [self numberOfRowsInSection:0]; row++)
        {
            UITableViewCell* cell = [self cellForRow:row inSection:0];
            if ([cell.nameTextField isFirstResponder])
                result = UITableViewCell_toNuble(cell);
        }
        
        return result;
    }
    
@end






@implementation ProjectViewController

	+ (ProjectViewController*) create :(ProjectViewController_Owner*)owner
    {
        ProjectViewController* result = [[[ProjectViewController alloc] init] autorelease];
        [result _creating:owner];
        return result;
    }
    
	- (void) _creating :(ProjectViewController_Owner*)owner
    {
        self.tableView.separatorColor = [UIColor blackColor];
        self.title = @"Projects";
        
        my_owner = owner;
        

        my_allRecord = [[StableRecordStableList empty] retain]; 
        
        
		my_cancelBarButtonItem = [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel)];
		my_editBarButtonItem = [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(_edit)];
		my_doneBarButtonItem = [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_done)];
            

        self.navigationItem.leftBarButtonItem = my_cancelBarButtonItem;
        self.navigationItem.rightBarButtonItem = my_editBarButtonItem;        
        
    }
	
    - (void) dealloc
    {
        [my_allRecord release];
        
        [my_cancelBarButtonItem release];
        [my_editBarButtonItem release];
        [my_doneBarButtonItem release];
        
        [super dealloc];
    }
    
    


	

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
	{
		return YES;
	}
	    

    
    

	- (void) updateAllRecord  :(NubleInt)currentRecordID :(StableRecordStableList*)allRecord;
    {
        my_currentRecordID = currentRecordID;
    
        [my_allRecord autorelease];
        my_allRecord = [allRecord retain];
            
        [self.tableView reloadData];
    }
    


	- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
	{
		return 1;
	}

	- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
	{
        return my_allRecord.count + 1;
	}
	
	- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
	{		
        UITableViewCell* cell;
        
        if (indexPath.row == 0)
        {
            static NSString* Identifier = @"orhjg9e893h49gh0ow4hg9h4j9p23jf09hf0q32h";
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:Identifier];	    
            if (cell == nil) 
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier] autorelease];
                                                
            cell.textLabel.text = @"+ New";
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:1.0 blue:0.8 alpha:1.0];
        }
        else
        {
            static NSString* Identifier = @"gtrh54ye5i6iow34ti74wtyy5478o6eyh45k74f4eg";
            
            cell = [self.tableView dequeueReusableCellWithIdentifier:Identifier];	    
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier] autorelease];
                // cell.frame = CGRectMake(0, 0, cell.frame.size.width, 160);
                
                [cell initTableViewCell];
                cell.nameTextField.delegate = self;
            }
            
            Record* record = [my_allRecord at:indexPath.row - 1];
            cell.recordIdentity = record.identity;
            cell.nameTextField.text = record.name.ns;
            cell.dateTimeLabel.text = DT2001_printYMDHMS(record.lastUpdateTime).ns;
            cell.imageView.image = [my_owner ProjectViewController_getThumbnail:record.identity];     
                                  
                                  
            if (my_currentRecordID.hasVar && record.identity == my_currentRecordID.vd)
                cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:1.0 alpha:1.0];
            else
                cell.contentView.backgroundColor = nil;
        }
        
        return cell;
    }    
    
    
    - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if (indexPath.row == 0)
            return ViewController_CellHeight / 2;
        else
            return ViewController_CellHeight;
    }
    
    

	- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
	{
        if (self.navigationItem.rightBarButtonItem == nil)
            return UITableViewCellEditingStyleNone;
    
        if (indexPath.row == 0)
        {
            return UITableViewCellEditingStyleNone;
        }
        else
        {
            if (my_currentRecordID.hasVar)
            {
                FOR_EACH_INDEX(i, my_allRecord)
                {
                    if ([my_allRecord at:i].identity == my_currentRecordID.vd)
                    {
                        if (indexPath.row - 1 == i)
                            return UITableViewCellEditingStyleNone;
                    }
                }
            }
            
            return UITableViewCellEditingStyleDelete;            
        }
	}
	
    - (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if (self.navigationItem.rightBarButtonItem == nil)
            return nil;

        if (self.navigationItem.rightBarButtonItem == my_doneBarButtonItem)
            return nil;
        else
            return indexPath;
    }

	- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
	{
        if (self.navigationItem.rightBarButtonItem == nil)
            return;

        if (self.navigationItem.rightBarButtonItem == my_doneBarButtonItem)
            return;
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (indexPath.row == 0)
        {
            [my_owner ProjectViewController_creating];
        }
        else
        {
            NubleRecord record = NubleID_AS(Record, [my_allRecord findRecordByIdentity:cell.tag]);        
            if (record.hasVar)
                [my_owner ProjectViewController_selected:record.vd.identity];
        }        
    }    
    

	- (void) 
		tableView          :(UITableView *)tableView 
		commitEditingStyle :(UITableViewCellEditingStyle)editingStyle 
		forRowAtIndexPath  :(NSIndexPath *)indexPath
	{
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (indexPath.row != 0)
        {
            NubleRecord record = NubleID_AS(Record, [my_allRecord findRecordByIdentity:cell.tag]);
            if (record.hasVar)
            {                
                if (self.tableView.isEditing == NO)
                {
                }
                
                
                //if ([record.vd.name eq:STR(@"...rad")])
                //    [my_owner ProjectViewController_removeAllData];
                //else                            
                    [my_owner ProjectViewController_deleting:record.vd.identity];                
            }
        }
	}    
    

    - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
    {                
        if (self.tableView.isEditing)
            return NO;
            
        for (NSInteger row = 0; row < [self.tableView numberOfRowsInSection:0]; row++)
        {
            UITableViewCell* cell = [self.tableView cellForRow:row inSection:0];
            if (cell.nameTextField.isFirstResponder)
                return NO;
        }
        
        return YES;
    }

	- (void)textFieldDidBeginEditing:(UITextField *)textField
    {		
        self.tableView.allowsSelection = NO;
        self.tableView.scrollEnabled = NO;
    
        self.navigationItem.leftBarButtonItem = my_cancelBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;    
    }
    
    - (void)textFieldDidEndEditing:(UITextField *)textField
    {
        for (NSInteger row = 0; row < [self.tableView numberOfRowsInSection:0]; row++)
        {
            UITableViewCell* cell = [self.tableView cellForRow:row inSection:0];
            if (cell.nameTextField == textField)
            {
                Int identity = cell.recordIdentity;
                Record* record = CAST(Record, [my_allRecord findRecordByIdentity:identity].vd);
                cell.nameTextField.text = record.name.ns;
            }
        }
        
        self.tableView.allowsSelection = YES;
        self.tableView.scrollEnabled = YES;

        self.navigationItem.leftBarButtonItem = my_cancelBarButtonItem;
        self.navigationItem.rightBarButtonItem = my_editBarButtonItem;    
    }

    
	- (BOOL)textFieldShouldReturn:(UITextField*)textField
	{
        for (NSInteger row = 0; row < [self.tableView numberOfRowsInSection:0]; row++)
        {
            UITableViewCell* cell = [self.tableView cellForRow:row inSection:0];
            if (cell.nameTextField == textField)
            {
                [my_owner ProjectViewController_nameChanging :cell.recordIdentity :STR(textField.text)];
                break;
            }
        }

		[textField resignFirstResponder];
		return YES;
	}	
	




	- (void) _cancel
    {
        self.tableView.allowsSelection = YES;
        self.tableView.scrollEnabled = YES;
    

        UIBarButtonItem* oldRightItem = self.navigationItem.rightBarButtonItem;


        NubleUITableViewCell tableViewCell = [self.tableView findCellWithFirstResponderNameTextField];
        if (tableViewCell.hasVar)
            [tableViewCell.vd.nameTextField resignFirstResponder];
            
        
        if (oldRightItem == nil)
        {
            if (tableViewCell.hasVar)
            {
                Int identity = tableViewCell.vd.recordIdentity;
                Record* record = CAST(Record, [my_allRecord findRecordByIdentity:identity].vd);
                tableViewCell.vd.nameTextField.text = record.name.ns;
            }
            
            self.navigationItem.leftBarButtonItem = my_cancelBarButtonItem;
            self.navigationItem.rightBarButtonItem = my_editBarButtonItem;
        }
        else if (oldRightItem == my_editBarButtonItem)
        {
            [my_owner ProjectViewController_cancel];
        }
    }
    
	- (void) _edit
    {
		if (self.tableView.isEditing == NO)	
		{		
			[self.tableView setEditing:YES animated:YES];			
            
			self.navigationItem.leftBarButtonItem = nil;
			self.navigationItem.rightBarButtonItem = my_doneBarButtonItem;
		}
    }
    
    - (void) _done
    {
        self.tableView.allowsSelection = YES;
        self.tableView.scrollEnabled = YES;
		
        if (self.tableView.isEditing)	
		{		
			[self.tableView setEditing:NO animated:YES];			
		}   
        else
        {
            NubleUITableViewCell tableViewCell = [self.tableView findCellWithFirstResponderNameTextField];
            if (tableViewCell.hasVar)
                [tableViewCell.vd.nameTextField resignFirstResponder];
            
            if (tableViewCell.hasVar)
            {
                Int identity = tableViewCell.vd.recordIdentity;
                String* name = STR(tableViewCell.vd.nameTextField.text);
                [my_owner ProjectViewController_nameChanging :identity :name];
            }
        }
        
        self.navigationItem.leftBarButtonItem = my_cancelBarButtonItem;
        self.navigationItem.rightBarButtonItem = my_editBarButtonItem;
    }
	    
    

@end


















