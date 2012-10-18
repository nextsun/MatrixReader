//
//  DetailBookTxtViewController.h
//  BookReader
//
//  Created by Sun on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    BGTypeWhite=1,
    BGTypeGray,
    BGTypeYangPiZhi
}BGType;


@interface DetailBookTxtViewController : UIViewController
{
    
    NSString* fontSize;
    UIPopoverController* popController;
    
    //NSMutableArray* sizeArray;
    
    //NSData* fileData;
    NSString* fileString;
    NSInteger fileStringLength;
    
    
    NSString* currentPageString;    
    NSInteger currentPageIndex;
    
    UIView* bottomView;
    UILabel* lbPageIndex;
    UISwitch* animitionOn;
    
    BGType bgType;
    
}
@property(nonatomic, retain) UISwipeGestureRecognizer* swipeLeftRecognizer;
@property(nonatomic, retain) UISwipeGestureRecognizer* swipeRightRecognizer;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSMutableArray* sizeArray;
@property (nonatomic, retain) NSString* fontSize;
@property (nonatomic, retain) NSString* currentPageString;
@property (nonatomic, assign) NSInteger currentPageIndex;
- (id)initWithTxtName:(NSString *)fileName;
@end
