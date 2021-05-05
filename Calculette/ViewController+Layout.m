//
//  ViewController+Layout.m
//  Calculette
//
//  Created by Nicolas Socheleau on 05/05/2021.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
    
@implementation ViewController (Layout)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    NSArray* grid = @[
        @[
            [self makeButton:@"0" color:[UIColor grayColor] target:@selector(tapZero) rect:CGRectMake(0, 0, 90, 40)], [self makeButton:@"." color:[UIColor grayColor] target:@selector(tapDot)], [self makeButton:@"=" color:[UIColor orangeColor] target:@selector(tapEqual)]
        ],
        @[
            [self makeButton:@"1" color:[UIColor grayColor] target:@selector(tapOne)], [self makeButton:@"2" color:[UIColor grayColor] target:@selector(tapTwo)], [self makeButton:@"3" color:[UIColor grayColor] target:@selector(tapThree)], [self makeButton:@"+" color:[UIColor orangeColor] target:@selector(tapPlus)]
        ],
        @[
            [self makeButton:@"4" color:[UIColor grayColor] target:@selector(tapFour)], [self makeButton:@"5" color:[UIColor grayColor] target:@selector(tapFive)], [self makeButton:@"6" color:[UIColor grayColor] target:@selector(tapSix)], [self makeButton:@"-" color:[UIColor orangeColor] target:@selector(tapMinus)]
        ],
        @[
            [self makeButton:@"7" color:[UIColor grayColor] target:@selector(tapSeven)], [self makeButton:@"8" color:[UIColor grayColor] target:@selector(tapEight)], [self makeButton:@"9" color:[UIColor grayColor] target:@selector(tapNine)], [self makeButton:@"*" color:[UIColor orangeColor] target:@selector(tapMultiply)]
        ],
        @[
            [self makeButton:@"AC" color:[UIColor lightGrayColor] target:@selector(tapReset) textColor:[UIColor blackColor]], [self makeButton:@"⁺∕₋" color:[UIColor lightGrayColor] target:@selector(tapChangeSign) textColor:[UIColor blackColor]], [self makeButton:@"%" color:[UIColor lightGrayColor] target:@selector(tapPercentage) textColor:[UIColor blackColor]], [self makeButton:@"÷" color:[UIColor orangeColor] target:@selector(tapDivide)]
        ]
    ];
    UIView* lastButton = [self install:grid];
    
    UILabel* res = [[UILabel alloc] initWithFrame:CGRectMake(0,0,190,0)];
    res.text = @"0";
    res.textAlignment = NSTextAlignmentRight;
    res.font = [UIFont systemFontOfSize:32];
    res.textColor = [UIColor whiteColor];
    res.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:res];
    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:res attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40],
        [NSLayoutConstraint constraintWithItem:res attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeRight multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:res attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastButton attribute:NSLayoutAttributeTop multiplier:1 constant:-10],
        
    ]];
    self.result = res;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat gap = (self.view.bounds.size.width - 160)/5;
    [[self.view.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return (evaluatedObject.firstAttribute != NSLayoutAttributeWidth && evaluatedObject.firstAttribute != NSLayoutAttributeHeight) || (evaluatedObject.firstAttribute == NSLayoutAttributeWidth && evaluatedObject.constant != 40);
        }]] enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( obj.firstAttribute == NSLayoutAttributeWidth ){
                if ( obj.firstItem == self.result ){
                    obj.constant = - (2*gap);
                }
                else{
                    obj.constant = 80+gap;
                }
            }
            else{
                if ( obj.constant < 0 ){
                    obj.constant = -gap;
                }
                else if (obj.constant > 0 ){
                    obj.constant = gap;
                }
            }
            ;
        }];
}

-(UIButton*)makeButton:(NSString*)label color:(UIColor*)color target:(SEL)action{
    return [self makeButton:label color:color target:action rect:CGRectMake(0, 0, 40, 40) textColor:[UIColor whiteColor]];
}
-(UIButton*)makeButton:(NSString*)label color:(UIColor*)color target:(SEL)action textColor:(UIColor*)textColor{
    return [self makeButton:label color:color target:action rect:CGRectMake(0, 0, 40, 40) textColor:textColor];
}
-(UIButton*)makeButton:(NSString*)label color:(UIColor*)color target:(SEL)action rect:(CGRect)rect{
    return [self makeButton:label color:color target:action rect:rect textColor:[UIColor whiteColor]];
}
-(UIButton*)makeButton:(NSString*)label color:(UIColor*)color target:(SEL)action rect:(CGRect)rect textColor:(UIColor*)textColor{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:label forState:UIControlStateNormal];
    btn.frame = rect;
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.backgroundColor = color;
    btn.layer.cornerRadius = 20;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    return btn;
}

-(UIView*)install:(NSArray*)grid{
    UIView* previousElement = nil;
    for(int i = 0 ; i < grid.count ; i++){
        NSArray* row = [grid objectAtIndex:i];
        for(int j =  0 ; j < row.count; j++){
            UIView* element = [row objectAtIndex:j];
            
            [self.view addSubview:element];
            NSLayoutConstraint* widthContraint = [NSLayoutConstraint constraintWithItem:element attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:element.frame.size.width];
            NSLayoutConstraint* heightContraint = [NSLayoutConstraint constraintWithItem:element attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:element.frame.size.height];
            NSLayoutConstraint* bottomContraint = [NSLayoutConstraint constraintWithItem:element attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:(previousElement != nil ? previousElement : self.view) attribute:(j == 0 && i > 0 ? NSLayoutAttributeTop : NSLayoutAttributeBottom) multiplier:1 constant:(j == 0 ? -10 : 0)];
            NSLayoutConstraint* leftContraint = [NSLayoutConstraint constraintWithItem:element attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:(j > 0 ? previousElement : self.view) attribute:(j == 0 ? NSLayoutAttributeLeft : NSLayoutAttributeRight) multiplier:1 constant:10];
            [self.view addConstraints:@[widthContraint, heightContraint, bottomContraint, leftContraint]];
            previousElement = element;
        }
    }
    return previousElement;
}


@end
