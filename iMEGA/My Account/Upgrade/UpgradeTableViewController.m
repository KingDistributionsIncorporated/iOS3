#import "UpgradeTableViewController.h"
#import "ProductTableViewCell.h"
#import "MEGASdkManager.h"
#import "Helper.h"
#import "ProductDetailViewController.h"
#import "MEGAPurchase.h"


#define TOBYTES 1024*1024*1024

@interface UpgradeTableViewController ()


@property (nonatomic, strong) NSString *monthlyPrice;
@property (nonatomic, strong) NSString *yearlyPrice;

@property (weak, nonatomic) IBOutlet UILabel *choosePlanLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoMonthsFreeLabel;

@end

@implementation UpgradeTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = AMLocalizedString(@"upgradeAccount", @"Upgrade account");
    [_choosePlanLabel setText:AMLocalizedString(@"choosePlan", nil)];
    [_twoMonthsFreeLabel setText:AMLocalizedString(@"twoMonthsFree", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MEGAPurchase sharedInstance].pricing.products / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0.0, 100.0, 0.0, 0.0)];
    
    [cell.productNameLabel.layer setCornerRadius:5];
    
    switch ([[MEGAPurchase sharedInstance].pricing proLevelAtProductIndex:indexPath.row * 2]) {
        case MEGAAccountTypeLite:
            [cell.productImageView setImage:[UIImage imageNamed:@"list_crest_LITE"]];
            [cell.productNameLabel setText:@"LITE"];
            [cell.productNameLabel setBackgroundColor:[UIColor mnz_orangeFFA500]];
            
            [cell.productPriceLabel setTextColor:[UIColor mnz_orangeFFA500]];
            break;

        case MEGAAccountTypeProI:
            [cell.productImageView setImage:[UIImage imageNamed:@"list_crest_PROI"]];
            [cell.productNameLabel setText:@"PRO I"];
            [cell.productNameLabel setBackgroundColor:[UIColor mnz_redE13339]];
            
            [cell.productPriceLabel setTextColor:[UIColor mnz_redE13339]];
            break;
            
        case MEGAAccountTypeProII:
            [cell.productImageView setImage:[UIImage imageNamed:@"list_crest_PROII"]];
            [cell.productNameLabel setText:@"PRO II"];
            [cell.productNameLabel setBackgroundColor:[UIColor mnz_redDC191F]];
            
            [cell.productPriceLabel setTextColor:[UIColor mnz_redDC191F]];
            break;
            
        case MEGAAccountTypeProIII:
            [cell.productImageView setImage:[UIImage imageNamed:@"list_crest_PROIII"]];
            [cell.productNameLabel setText:@"PRO III"];
            [cell.productNameLabel setBackgroundColor:[UIColor mnz_redD90007]];
            
            [cell.productPriceLabel setTextColor:[UIColor mnz_redD90007]];
            break;
            
        default:
            
            break;
    }
    
    NSMutableAttributedString *storageSizeString = [[NSMutableAttributedString alloc] initWithString:[NSByteCountFormatter stringFromByteCount:((long long)[[MEGAPurchase sharedInstance].pricing storageGBAtProductIndex:indexPath.row * 2] * TOBYTES) countStyle:NSByteCountFormatterCountStyleMemory] attributes:@{NSFontAttributeName:[UIFont fontWithName:kFont size:12.0], NSForegroundColorAttributeName:[UIColor mnz_black333333]}];
    
    NSMutableAttributedString *storageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", AMLocalizedString(@"productSpace", @"Space")] attributes:@{NSFontAttributeName:[UIFont fontWithName:kFont size:12.0], NSForegroundColorAttributeName:[UIColor mnz_gray666666]}];
    
    [storageSizeString appendAttributedString:storageString];
    
    [cell.productStorageLabel setAttributedText:storageSizeString];
    
    NSMutableAttributedString *bandwidthSizeString = [[NSMutableAttributedString alloc] initWithString:[NSByteCountFormatter stringFromByteCount:((long long)[[MEGAPurchase sharedInstance].pricing transferGBAtProductIndex:indexPath.row * 2] * TOBYTES) countStyle:NSByteCountFormatterCountStyleMemory] attributes:@{NSFontAttributeName:[UIFont fontWithName:kFont size:12.0], NSForegroundColorAttributeName:[UIColor mnz_black333333]}];
    
    NSMutableAttributedString *bandwidthString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", AMLocalizedString(@"productBandwidth", @"Bandwidth")] attributes:@{NSFontAttributeName:[UIFont fontWithName:kFont size:12.0], NSForegroundColorAttributeName:[UIColor mnz_gray666666]}];
    
    [bandwidthSizeString appendAttributedString:bandwidthString];
    
    [cell.productBandwidthLabel setAttributedText:bandwidthSizeString];
    
    [cell.productPriceLabel setText:[NSString stringWithFormat:AMLocalizedString(@"productPricePerMonth", @"from %.2f %@ / month"), (float)[[MEGAPurchase sharedInstance].pricing amountAtProductIndex:indexPath.row * 2] / 100, [[MEGAPurchase sharedInstance].pricing currencyAtProductIndex:indexPath.row]]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductDetailViewController *productDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"productDetailID"];
    switch ([[MEGAPurchase sharedInstance].pricing proLevelAtProductIndex:indexPath.row * 2]) {
        case MEGAAccountTypeLite:
            [productDetailVC setMegaAccountType:MEGAAccountTypeLite];
            
            break;
            
        case MEGAAccountTypeProI:
            [productDetailVC setMegaAccountType:MEGAAccountTypeProI];
            
            break;
            
        case MEGAAccountTypeProII:
            [productDetailVC setMegaAccountType:MEGAAccountTypeProII];
            
            break;
            
        case MEGAAccountTypeProIII:
            [productDetailVC setMegaAccountType:MEGAAccountTypeProIII];
            
            break;
            
        default:
            
            break;
    }
    
    [productDetailVC setStorageString:[NSByteCountFormatter stringFromByteCount:((long long)[[MEGAPurchase sharedInstance].pricing storageGBAtProductIndex:indexPath.row * 2] * TOBYTES) countStyle:NSByteCountFormatterCountStyleMemory]];
    [productDetailVC setBandwidthString:[NSByteCountFormatter stringFromByteCount:((long long)[[MEGAPurchase sharedInstance].pricing transferGBAtProductIndex:indexPath.row * 2] * TOBYTES) countStyle:NSByteCountFormatterCountStyleMemory]];
    [productDetailVC setPriceMonthString:[NSString stringWithFormat:@"%.2f %@", (float)[[MEGAPurchase sharedInstance].pricing amountAtProductIndex:indexPath.row * 2] / 100, [[MEGAPurchase sharedInstance].pricing currencyAtProductIndex:indexPath.row]]];
    [productDetailVC setPriceYearlyString:[NSString stringWithFormat:@"%.2f %@", (float)[[MEGAPurchase sharedInstance].pricing amountAtProductIndex:indexPath.row * 2 + 1] / 100, [[MEGAPurchase sharedInstance].pricing currencyAtProductIndex:indexPath.row]]];
    [productDetailVC setIOSIDMonthlyString:[[MEGAPurchase sharedInstance].pricing iOSIDAtProductIndex:indexPath.row * 2]];
    [productDetailVC setIOSIDYearlyString:[[MEGAPurchase sharedInstance].pricing iOSIDAtProductIndex:indexPath.row * 2 + 1]];
    [self.navigationController pushViewController:productDetailVC animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
