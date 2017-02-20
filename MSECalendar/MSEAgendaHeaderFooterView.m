//
//  MSEAgendaHeaderFooterView.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEAgendaHeaderFooterView.h"
#import "UIColor+MSEColor.h"
#import "MSEWeather.h"

@interface MSEAgendaHeaderFooterView()

@property (nonatomic, weak) IBOutlet UILabel *lowLabel;
@property (nonatomic, weak) IBOutlet UILabel *highLabel;
@property (nonatomic, weak) IBOutlet UIImageView *weatherImageView;
@property (nonatomic, strong) MSEWeather *weather;

@end

@implementation MSEAgendaHeaderFooterView

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-1, rect.size.width, 1)];
    [borderView setBackgroundColor:[UIColor mseSeperatorColor]];
    [self addSubview:borderView];
}

- (void)prepareForReuse {
    [self.weatherImageView setImage:nil];
    [self.highLabel setText:@""];
    [self.lowLabel setText:@""];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.dateLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.highLabel setText:@""];
        [self.lowLabel setText:@""];
    }
    return self;
}

- (void)initWithDate:(NSString *)date weather:(MSEWeather *)weather {
    __weak typeof(self) weakSelf = self;
    if (weather) {
        self.weather = weather;
        [self.highLabel setText:[NSString stringWithFormat:@"Hi: %ld",self.weather.high]];
        [self.lowLabel setText:[NSString stringWithFormat:@"Low: %ld",self.weather.low]];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSString *weatherImage = weather.imageURL;
            NSError *error;
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weather.imageURL] options:NSDataReadingUncached error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weatherImage isEqualToString:weakSelf.weather.imageURL]) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    [weakSelf.weatherImageView setImage:image];
                }
            });
        });
    }
    [self.dateLabel setText:date];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
