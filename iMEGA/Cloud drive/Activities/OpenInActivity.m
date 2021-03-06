#import "OpenInActivity.h"
#import "Helper.h"

@interface OpenInActivity () <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *shareBarButtonItem;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end

@implementation OpenInActivity

- (instancetype)initOnBarButtonItem:(UIBarButtonItem *)barButtonItem {
    _shareBarButtonItem = barButtonItem;
    
    return self;
}

- (NSString *)activityType {
    return @"OpenInActivity";
}

- (NSString *)activityTitle {
    return AMLocalizedString(@"openIn", @"Title shown under the action that allows you to open a file in another app");
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"activity_openIn"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {

    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)) {
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[activityItems objectAtIndex:0]];
        [self.documentInteractionController setDelegate:self];
    }
}

- (void)performActivity {
    
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)) {
        BOOL canOpenIn = [self.documentInteractionController presentOpenInMenuFromBarButtonItem:self.shareBarButtonItem animated:YES];
        if (canOpenIn) {
            [self.documentInteractionController presentPreviewAnimated:YES];
        }
    } else {
        [self activityDidFinish:YES];
    }
}

+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

@end
