//
//  UIExtendedTableView.m
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "UIExtendedTableView.h"
#import "NoteTableViewCell.h"



@implementation UIExtendedTableViewPrivateDataSource
@synthesize dataSource;

#pragma mark - UITableViewDataSource

- (void)tableView:(UIExtendedTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        

        
        NSDictionary* sectionDictionary=[dataSource objectAtIndex:[indexPath section]];
        
        Note *note = [[sectionDictionary objectForKey:@"cells"] objectAtIndex:indexPath.row];
        NSMutableArray *arrayNotes = [NSMutableArray arrayWithArray:[sectionDictionary objectForKey:@"cells"]];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithArray:arrayNotes];
        [tempArray removeObject:note];
        
        [[sectionDictionary objectForKey:@"cells"] setArray:tempArray];
        
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
        
        
        [tableView.managedObjectContext deleteObject:note];
        
        [tableView.managedObjectContext save:nil];
        
    }
}

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if(!dataSource){return 0;}
        NSUInteger r= [[[dataSource objectAtIndex:section] objectForKey:@"cells"] count];
        return r;
    }

    -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        if(!dataSource){return 0;}
        return [dataSource count];
    }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
   
    return [[dataSource objectAtIndex:section] objectForKey:@"header_title"];
  
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [[dataSource objectAtIndex:section] objectForKey:@"footer_title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
        /*
         Array @{
            @"header_title":
            @"footer_title"
            Array cells @{  style,title,type,subviews,description  }
         }
         */
        
        long rid=[indexPath row];
        if(!dataSource){
            NSLog(@"RETURN NIL FROM %s %d",__FUNCTION__,__LINE__);
            return nil;}
        UITableViewCellStyle style=UITableViewCellStyleDefault;
        NSDictionary* sectionDictionary=[dataSource objectAtIndex:[indexPath section]];
    
    Note *note = [[sectionDictionary objectForKey:@"cells"] objectAtIndex:rid];
    
    if ([note isKindOfClass:[Note class]]) {
        
        UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if(!c){
            NSString *title = [NSString stringWithFormat:@"Place #%li",rid];
            
            c=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
             [[c textLabel]setText:title];
            
            [[c detailTextLabel]setNumberOfLines: 4];
            NSLineBreakMode lb=NSLineBreakByWordWrapping;
            [[c detailTextLabel] setLineBreakMode:(lb)];
            [[c detailTextLabel]setText:note.textNote];
           
        }
         return c;
    }
    
     NSDictionary *rowDictionary = [[sectionDictionary objectForKey:@"cells"] objectAtIndex:rid];
    
    
        NSString *tcstyle=[rowDictionary objectForKey:@"style"];
        if(tcstyle){
            if([tcstyle isEqualToString:@"UITableViewCellStyleDefault"]){
                style=UITableViewCellStyleDefault;
            }else if([tcstyle isEqualToString:@"UITableViewCellStyleSubtitle"]){
                style=UITableViewCellStyleSubtitle;
            }else if([tcstyle isEqualToString:@"UITableViewCellStyleValue1"]){
                style=UITableViewCellStyleValue1;
            }else if([tcstyle isEqualToString:@"UITableViewCellStyleValue2"]){
                style=UITableViewCellStyleValue2;
            }
        }
                
        
        //noteTableViewCell
        
        NSString *title=[rowDictionary objectForKey:@"title"];
        
    if (([title isEqualToString:@"Note"])||([title isEqualToString:@"Заметка"])) {
        
            static NSString *identifNoteCell = @"noteCell";
            
            NoteTableViewCell *c = [tableView dequeueReusableCellWithIdentifier:identifNoteCell];
            
            if (!c) {
                
                c = [[NoteTableViewCell alloc]initWithStyle:style reuseIdentifier:identifNoteCell];
                
                
            }
             return c;
            
        } else {
        
        UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if(!c){
            c=[[UITableViewCell alloc]initWithStyle:style reuseIdentifier:nil];
           // NSLog(@"RETURN NIL FROM %s %d",__FUNCTION__,__LINE__);
           // return nil;
       // }
        
        NSArray *subviews=[rowDictionary objectForKey:@"subviews"];
        if(subviews){
            for(UIView* v in subviews){
                [c addSubview:v];
            }
        }
        
        //NSString *title=[rowDictionary objectForKey:@"title"];
        if(title){
            [[c textLabel]setText:title];
        }
        NSString *description_lines=[rowDictionary objectForKey:@"description_lines"];
        if(description_lines){
            [[c detailTextLabel]setNumberOfLines: [description_lines intValue] ];
        }
        
        NSString *description_linebreak=[rowDictionary objectForKey:@"description_linebreak"];
        if(description_linebreak){
            NSLineBreakMode lb=NSLineBreakByWordWrapping;
            if([description_linebreak isEqualToString:@"NSLineBreakByWordWrapping"]){
                lb=NSLineBreakByWordWrapping;
            }else if([description_linebreak isEqualToString:@"NSLineBreakByCharWrapping"]){
                lb=NSLineBreakByCharWrapping;
            }else if([description_linebreak isEqualToString:@"NSLineBreakByClipping"]){
                lb=NSLineBreakByClipping;
            }else if([description_linebreak isEqualToString:@"NSLineBreakByTruncatingHead"]){
                lb=NSLineBreakByTruncatingHead;
            }else if([description_linebreak isEqualToString:@"NSLineBreakByTruncatingTail"]){
                lb=NSLineBreakByTruncatingTail;
            }else if([description_linebreak isEqualToString:@"NSLineBreakByTruncatingMiddle"]){
                lb=NSLineBreakByTruncatingMiddle;
            }
            [[c detailTextLabel] setLineBreakMode:(lb)];
            
        }


        NSString *description=[rowDictionary objectForKey:@"description"];
        if(description){
            [[c detailTextLabel]setText:description];
        }
        
        NSString *selection_style=[rowDictionary objectForKey:@"selection_style"];
        if(selection_style){
            UITableViewCellSelectionStyle ss=UITableViewCellSelectionStyleDefault;
            if([selection_style isEqualToString:@"UITableViewCellSelectionStyleNone"]){
                ss=UITableViewCellSelectionStyleNone;
            }else if([selection_style isEqualToString:@"UITableViewCellSelectionStyleDefault"]){
                ss=UITableViewCellSelectionStyleDefault;
            }
            [c setSelectionStyle:ss];
        }
        
        

        NSString *type=[rowDictionary objectForKey:@"type"];
        if(type){
            if([type isEqualToString:@"switch"]){
                UISwitch * uisw=[[UISwitch alloc]initWithFrame:CGRectZero];
                NSString *ss=[rowDictionary objectForKey:@"switch-state"];
                if(ss){
                    [uisw setOn:[ss isEqualToString:@"on"] animated:YES];
                }
               
                [c setAccessoryView: uisw ];
                NSString *title = [rowDictionary objectForKey:@"title"];
                if ([title isEqual:[GLang getString:@"EditCreate.place_alert"]]) {
                    self.swithNotifPlace = uisw;
                } else if ([title isEqual:[GLang getString:@"EditCreate.time_alert"]]) {
                    self.swithNotifTime = uisw;
                } else if ([title isEqual:[GLang getString:@"EditCreate.pause"]]) {
                    self.swithStatusPause = uisw;
                } else if ([title isEqual:[GLang getString:@"EditCreate.complete"]]) {
                    self.swithStatusComplete = uisw;
                }
                
            }else if([type isEqualToString:@"arrow"]){
                [c setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }else if([type isEqualToString:@"checkbox"]){
                [c setAccessoryType:UITableViewCellAccessoryCheckmark];
            }else if([type isEqualToString:@"default"]){
                [c setAccessoryType:UITableViewCellAccessoryNone];
            }else {
                [c setAccessoryType:UITableViewCellAccessoryNone];
            }            
        }
//        if(!c){
//            NSLog(@"RETURN NIL FROM %s %d",__FUNCTION__,__LINE__);
//        }
       
        }
            return c;
        }
    }
    
@end



@implementation UIExtendedTableView

@synthesize privateDataSource;


-(NSDictionary*)extendedDictionaryForIndexPath:(NSIndexPath*)indx{
    UIExtendedDataSource ds=[privateDataSource dataSource];
    NSDictionary* sect=[ds objectAtIndex: [indx section] ];
    NSArray* sects=[sect objectForKey:@"cells"];
    NSDictionary* r=[sects objectAtIndex:[indx row]];
    return r;
}


-(void)UIExtendedTableViewAfterInit{
    [self setPrivateDataSource: [[UIExtendedTableViewPrivateDataSource alloc]init]];
    [self setDataSource:privateDataSource];
    
    //set managedObjectContext
    AppDelegate *appDelegate =  [[UIApplication sharedApplication]delegate];
    self.managedObjectContext=[appDelegate managedObjectContext];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(!self){return nil;}
    [self UIExtendedTableViewAfterInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if(!self){return nil;}
    [self UIExtendedTableViewAfterInit];
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(!self){return nil;}
    [self UIExtendedTableViewAfterInit];
    return self;
    
}


-(void)setExtendedDataSource:(UIExtendedDataSource)arrayWithDictionarys{
    [privateDataSource setDataSource:arrayWithDictionarys];
    [self reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
      
}


@end
