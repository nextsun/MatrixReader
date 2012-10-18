//
//  DetailBookTxtViewController.m
//  BookReader
//
//  Created by Sun on 12-10-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailBookTxtViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation DetailBookTxtViewController
@synthesize fileName=_fileName;
@synthesize webView=_webView;
@synthesize sizeArray=_sizeArray;
@synthesize swipeLeftRecognizer;
@synthesize swipeRightRecognizer;
@synthesize fontSize=_fontSize;
@synthesize currentPageIndex;
@synthesize currentPageString;
- (id)initWithTxtName:(NSString *)file
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.fileName = file;
        
        self.sizeArray=[NSMutableArray arrayWithObjects:@"10px",@"12px",@"15px",@"20px",@"25px",@"30px",nil];
        bgType=BGTypeYangPiZhi;
        
        
        
    }
    return self;
}


-(NSString*) returnHtmlPrefixHeaderWithFontSize:(NSString*)size{
    NSString * str=@"<!DOCTYPE html PUBLIC";
    str=[str stringByAppendingFormat:@"\"-//W3C//DTD XHTML 1.0 Transitional//EN\""];
    str=[str stringByAppendingFormat:@"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\""];
    str=[str stringByAppendingFormat:@"> <html xmlns="];
    str=[str stringByAppendingFormat:@" \"http://www.w3.org/1999/xhtml\""];
    str=[str stringByAppendingFormat:@" xml:lang="];
    str=[str stringByAppendingFormat:@" \"zh-CN\""];
    str=[str stringByAppendingFormat:@" dir="];
    str=[str stringByAppendingFormat:@" \"ltr\""];
    str=[str stringByAppendingFormat:@" <head> <meta http-equiv="];
    str=[str stringByAppendingFormat:@" \"Content-Type\" "];
    str=[str stringByAppendingFormat:@" content="];
    str=[str stringByAppendingFormat:@" \"text/html; charset=UTF-8\" />"];
    str=[str stringByAppendingFormat:@" <body>"];
    str=[str stringByAppendingFormat:@" <p style='font-size:%@'>",size];
    return str;
}

-(NSString*) returnHtmlEnder{
    NSString * str=@" </p>";
    str=[str stringByAppendingFormat:@" </body>"];
    str=[str stringByAppendingFormat:@" </html>"];
    return str;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"yangpizhi.png"]];
    // Do any additional setup after loading the view from its nib.
    
    CGRect rect=self.view.bounds;
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-44)];
    [self.view addSubview:self.webView];
    
    self.webView.delegate=(id<UIWebViewDelegate>)self;
    
    
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque=NO;
    self.webView.scalesPageToFit = NO;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    //self.webView.delegate = self;
    
    
    self.webView.multipleTouchEnabled=YES;
    //    self.webView.scalesPageToFit=YES;
    self.webView.autoresizingMask= UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;;
    self.webView.contentMode=UIViewContentModeScaleToFill;
    
    for (UIView *subView in [self.webView subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            //[(UIScrollView *)subView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
            for (UIView *shadowView in [subView subviews]) {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_nosd.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imgBack = [UIImage imageNamed:@"back_btt.png"];
    [btnBack setFrame:CGRectMake(0, 0, imgBack.size.width, imgBack.size.height)];
    [btnBack setImage:imgBack forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackWebDetailIsPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    UIButton *title = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [title setTitle:self.title forState:UIControlStateNormal];
    //    [btnBack setFrame:CGRectMake(200, 0, 400,44)];
    //    [btnBack setImage:imgBack forState:UIControlStateNormal];
    //[btnBack addTarget:self action:@selector(btnBackWebDetailIsPressed:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.title=self.title;
    
    
    UIBarButtonItem *btnItemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = btnItemBack;
    
    
    UILabel* lbForSwith=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [lbForSwith setText:[NSString stringWithFormat:@"动画"]];
    [lbForSwith setTextColor:[UIColor whiteColor]];
    [lbForSwith setBackgroundColor:[UIColor clearColor]];
    lbForSwith.textAlignment=UITextAlignmentCenter;
    
    
    animitionOn=[[UISwitch alloc] initWithFrame:CGRectMake(60, 7, 80, 25)];
    [animitionOn setOn:YES];
    
    
    
    UIButton *sizeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sizeBtn setFrame:CGRectMake(0+150, 0,80, 40)];
    [sizeBtn setTitle:@"字号" forState:UIControlStateNormal];
    //[sizeBtn setImage:imgsizeBtn forState:UIControlStateNormal];
    [sizeBtn addTarget:self action:@selector(btnChangeSize:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *bgimgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bgimgBtn setFrame:CGRectMake(90+150, 0,80, 40)];
    [bgimgBtn setTitle:@"切换背景" forState:UIControlStateNormal];
    //[bgimgBtn setImage:imgbgimg forState:UIControlStateNormal];
    [bgimgBtn addTarget:self action:@selector(btnChangeBg:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* cstView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,170+150, 40)];
    [cstView addSubview:bgimgBtn];
    [cstView addSubview:sizeBtn];
    [cstView addSubview:animitionOn];
    [cstView addSubview: lbForSwith];
    
    UIBarButtonItem *btnRightItem = [[UIBarButtonItem alloc] initWithCustomView:cstView];
    self.navigationItem.rightBarButtonItem = btnRightItem;
    
    
    
    bottomView=[[UIView alloc] init];
    bottomView.backgroundColor=[UIColor darkGrayColor];
    [self.view addSubview:bottomView];
    
    
    UIButton* btnPrev = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPrev setFrame:CGRectMake(0, 0,80, 40)];
    [btnPrev setTitle:@"<<" forState:UIControlStateNormal];
    //[sizeBtn setImage:imgsizeBtn forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(btnChangePrev:) forControlEvents:UIControlEventTouchUpInside];
    
    
    lbPageIndex=[[UILabel alloc] initWithFrame:CGRectMake(90, 0, 90, 40)];
    [lbPageIndex setText:[NSString stringWithFormat:@"%i/%i",currentPageIndex,fileStringLength/PAGE_WORD_COUNT]];
    [lbPageIndex setTextColor:[UIColor whiteColor]];
    [lbPageIndex setBackgroundColor:[UIColor clearColor]];
    lbPageIndex.textAlignment=UITextAlignmentCenter;
    
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnNext setFrame:CGRectMake(200, 0,80, 40)];
    [btnNext setTitle:@">>" forState:UIControlStateNormal];
    //[bgimgBtn setImage:imgbgimg forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(btnChangeNext:) forControlEvents:UIControlEventTouchUpInside];
    bottomView.frame=CGRectMake(0,self.view.bounds.size.height -44, self.view.frame.size.width, 44);  
    bottomView.contentMode=UIViewContentModeRight;
    [bottomView addSubview:btnNext];
    [bottomView addSubview:btnPrev];
    [bottomView addSubview:lbPageIndex];
    
    
    
    
    
    //    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    //    //longPressGesture.delegate=self;
    //    
    //    [self.webView addGestureRecognizer:longPressGesture];
    //    
    //    [longPressGesture release];
    
    
    
    UIGestureRecognizer *swipeRecognizer= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [self.webView addGestureRecognizer:swipeRecognizer];
    [swipeRecognizer release];
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)swipeRecognizer;
    self.swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.webView addGestureRecognizer:self.swipeLeftRecognizer];
    
    self.swipeLeftRecognizer = (UISwipeGestureRecognizer *)swipeRecognizer;
    [swipeRecognizer release];
    
    
    
    
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
    if (gestureRecognizer.view != self.webView)
        return NO;
    
    
    return YES;
}
-(void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    
    CGRect rect=self.view.bounds;
    self.webView.frame=CGRectMake(0, 0, rect.size.width, rect.size.height-44);
    bottomView.frame=CGRectMake(0,self.view.bounds.size.height -44, self.view.frame.size.width, 44);        
    
    
}


-(void)reloadContent
{   
    
    //float f=fileStringLength/PAGE_WORD_COUNT;
    
    [lbPageIndex setText:[NSString stringWithFormat:@"%i/%i",currentPageIndex,fileStringLength/PAGE_WORD_COUNT+1]];
    
    
    NSString* htmlString=[NSString stringWithFormat:@"%@%@%@",[self returnHtmlPrefixHeaderWithFontSize:self.fontSize],self.currentPageString,[self returnHtmlEnder]];
    
    
    htmlString=[htmlString stringByReplacingOccurrencesOfString:@"\n\r" withString:@"<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"];
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[self.view addSubview:self.webView];
}
-(void)loadWithPageIndex:(int)index
{
    //self.currentPageIndex=index;
    if (index<=0) {
        index=1;
    }
    int pos=PAGE_WORD_COUNT*(index-1);
    int len=MIN(PAGE_WORD_COUNT, fileStringLength-pos);
    
    self.currentPageString= [fileString substringWithRange:(NSRange){pos,len}];
    [self reloadContent];
}
-(void)viewDidAppear:(BOOL)animated
{
    
    
    fileString=[[NSString alloc] initWithContentsOfFile:self.fileName encoding:NSUTF8StringEncoding error:nil];
    
    
    fileStringLength=[fileString length];  
    NSLog(@"%d",fileStringLength);
    self.fontSize=@"15px";
    currentPageIndex=1;
    [self loadWithPageIndex:1];
    
}




#pragma mark - Back Button 
- (void)btnBackWebDetailIsPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
    [UIView beginAnimations:nil context:nil];
    CGRect rect=self.view.bounds;
    
    self.webView.frame=CGRectMake(0, 0, rect.size.width, rect.size.height-44);
    bottomView.frame=CGRectMake(0,self.view.bounds.size.height -44, self.view.frame.size.width, 44);       
    [UIView commitAnimations];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void)btnChangeSize:(id)sender
{
    UIButton* btn =(UIButton*)sender;
    //poptag=btn.tag;
    UIViewController* viewController=[[UIViewController alloc] init];
    
    UITableView* table=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    table.dataSource=(id<UITableViewDataSource>)self;
    table.delegate=(id<UITableViewDelegate>)self;
    viewController.view=table;
    popController=[[UIPopoverController alloc]initWithContentViewController:viewController];
    [popController setPopoverContentSize:CGSizeMake(200, 230) animated:YES];
    [popController presentPopoverFromRect:CGRectMake(0,0, 50, 40)  inView:btn permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [table release];
    [viewController release];  
}
-(void)btnChangeBg:(id)sender
{
    
    if (bgType==BGTypeWhite) {
        bgType=BGTypeGray;
        self.view.backgroundColor=[UIColor lightGrayColor];
    }else
        if (bgType==BGTypeGray) {
            bgType=BGTypeYangPiZhi;
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"yangpizhi.png"]];
        }else
            if (bgType==BGTypeYangPiZhi) {
                bgType=BGTypeWhite;
                self.view.backgroundColor=[UIColor whiteColor];
            }
    
}
-(void)btnChangePrev:(id)sender
{
    if (self.currentPageIndex<=1) {
        return;
    }
    self.currentPageIndex--;
    
    CATransition *t = [CATransition animation];
    if (animitionOn.isOn) {
        t.type = @"pageUnCurl";
    }
    
    t.duration = 0.5;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.view.layer addAnimation:t forKey:@"Transition"];
    
    [self loadWithPageIndex:self.currentPageIndex];
}
-(void)btnChangeNext:(id)sender
{
    if ((self.currentPageIndex)*PAGE_WORD_COUNT>=fileStringLength) {
        return;
    }
    self.currentPageIndex++;
    CATransition *t = [CATransition animation];
    
    if (animitionOn.isOn) {
        t.type = @"pageCurl";
    }
    
    t.duration = 0.5;
    t.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.view.layer addAnimation:t forKey:@"Transition"];
    
    
    
    [self loadWithPageIndex:self.currentPageIndex];
    
    self.webView.hidden=NO;
    
    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)reg
{
    
    
    switch (reg.direction) {
        case UISwipeGestureRecognizerDirectionRight:
        {
            [self btnChangePrev:nil];
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft:
        {
            [self btnChangeNext:nil];
            break;
        } 
            
        default:
            break;
    }
    
}
#pragma mark - Table view Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.sizeArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentify=@"indentify";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentify];
    
    if (cell==nil) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify]autorelease];
    }
    //    cell.imageView.frame=CGRectMake(0, 0, 30, 30);
    cell.textLabel.text=[self.sizeArray objectAtIndex:indexPath.row];
    
    return cell;
    
}
#pragma mark - Table view DataSource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSString* str=[fourthView.array objectAtIndex:indexPath.row];
    //    [self editImpartInfo:fourthView textSelValue:[NSString stringWithFormat:@"%d",indexPath.row+1]];
    //    [fourthView.dropbtn setTitle:str forState:UIControlStateNormal];
    [popController dismissPopoverAnimated:YES];
    // SlideView* slideView=nil;
    //    SlideView* sv=[SlideView ShareSlideView];
    self.fontSize=[self.sizeArray objectAtIndex:indexPath.row];
    
    [self reloadContent];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
