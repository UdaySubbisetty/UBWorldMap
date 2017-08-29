//
//  ViewController.m
//  UBWorldMapSample
//
//  Created by MNC on 28/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import "ViewController.h"
#import "UBMapView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //AD,AE,AF,AG,AI,AL,AM,AN,AO,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BN,BO,BR,BS,BT,BW,BY,BZ,CA,CD,CF,CG,CH,CI,CL,CM,CN,CO,CR,CU,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FR,FK,GA,GB,GD,GE,GF,GH,GI,GL,GM,GN,GP,GQ,GR,GT,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IN,IQ,IR,IS,IT,JM,JO,JP,KE,KG,KH,KP,KR,KW,KY,KZ,LA,LB,LC,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MG,MK,ML,MM,MN,MQ,MR,MS,MT,MW,MX,MY,MZ,NA,NC,NE,NG,NI,NL,NO,NP,NZ,OM,PA,PE,PG,PH,PK,PL,PR,YB,PY,QA,RO,RS,RU,RW,SA,SB,SD,SE,SG,SI,ZW,ZM,ZA,YE,WF,WA,VU,VN,VE,VC,UZ,UY,US,UG,UA,TZ,TW,TT,TR,TO,TN,TM,TL,TJ,TH,TG,TF,TD,SZ,SY,SV,SR,SO,SN,SL,SK,
    
    //country names
    
    NSArray * data = [[NSArray alloc]initWithObjects:@"IN",@"CH",@"US", nil];
    
    
    //country colors array
    
    //NSArray * colorsArray = [[NSArray alloc]initWithObjects:[UIColor greenColor],[UIColor redColor], nil];
    
    //map frame
    UBMapView* map = [[UBMapView alloc] initWithFrame:CGRectMake(16, 96, self.view.frame.size.width - 32, self.view.frame.size.height)];
    
    //map with diffrent colors
    
    //[map loadMap:@"world_map" withData:data withColorsArray:colorsArray withDefaultColor:[UIColor blueColor]];
    
    
    [map loadMap:@"world_map" withData:data withColorsArray:nil withDefaultColor:[UIColor blueColor]];
    
    
    //map will only one defalut blueColor
    
    //[map loadMap:@"world_map" withData:data withColorsArray:nil withDefaultColor:[UIColor blueColor]];
    
    
    [self.view addSubview:map];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
