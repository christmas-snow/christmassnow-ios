#import <GoogleMobileAds/GADMobileAds.h>
#import <GoogleMobileAds/GADRequest.h>
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADBannerViewDelegate.h>

#include <QtCore/QDebug>

#include "admobhelper.h"

const QString AdMobHelper::ADMOB_APP_ID              ("ca-app-pub-2455088855015693~4469017889");
const QString AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID  ("ca-app-pub-2455088855015693/9661812425");
const QString AdMobHelper::ADMOB_TEST_DEVICE_ID      ("");

AdMobHelper *AdMobHelper::Instance = NULL;

@interface BannerViewDelegate : NSObject<GADBannerViewDelegate>

- (id)init;
- (void)dealloc;
- (void)loadAd;

@property (nonatomic, retain) GADBannerView *BannerView;

@end

@implementation BannerViewDelegate

@synthesize BannerView;

- (id)init
{
    self = [super init];

    if (self) {
        UIViewController * __block root_view_controller = nil;

        [[[UIApplication sharedApplication] windows] enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = [window rootViewController];

            *stop = (root_view_controller != nil);
        }];

        BannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];

        BannerView.adUnitID                                  = AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID.toNSString();
        BannerView.autoloadEnabled                           = YES;
        BannerView.rootViewController                        = root_view_controller;
        BannerView.translatesAutoresizingMaskIntoConstraints = NO;
        BannerView.delegate                                  = self;

        [root_view_controller.view addSubview:BannerView];

        if (@available(iOS 11, *)) {
            UILayoutGuide *guide = root_view_controller.view.safeAreaLayoutGuide;

            [NSLayoutConstraint activateConstraints:@[
                [BannerView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
                [BannerView.topAnchor     constraintEqualToAnchor:guide.topAnchor]
            ]];
        } else {
            assert(0);
        }
    }

    return self;
}

- (void)dealloc
{
    [BannerView removeFromSuperview];
    [BannerView release];

    [super dealloc];
}

- (void)loadAd
{
    GADRequest *request = [GADRequest request];

    if (AdMobHelper::ADMOB_TEST_DEVICE_ID != "") {
        request.testDevices = @[ AdMobHelper::ADMOB_TEST_DEVICE_ID.toNSString() ];
    }

    [self.BannerView loadRequest:request];
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    Q_UNUSED(adView)

    CGSize status_bar_size   = [[UIApplication sharedApplication] statusBarFrame].size;
    int    status_bar_height = MIN(status_bar_size.width, status_bar_size.height);

    AdMobHelper::setBannerViewHeight(BannerView.frame.origin.y - status_bar_height + BannerView.frame.size.height);
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView
{
    Q_UNUSED(adView)
}

- (void)adViewWillDismissScreen:(GADBannerView *)adView
{
    Q_UNUSED(adView)
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    Q_UNUSED(adView)
}

- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error
{
    Q_UNUSED(adView)

    qWarning() << QString::fromNSString([error localizedDescription]);

    [self performSelector:@selector(loadAd) withObject:nil afterDelay:10.0];
}

@end

AdMobHelper::AdMobHelper(QObject *parent) : QObject(parent)
{
    Initialized                = false;
    BannerViewHeight           = 0;
    Instance                   = this;
    BannerViewDelegateInstance = NULL;
}

AdMobHelper::~AdMobHelper()
{
    if (Initialized) {
        if (BannerViewDelegateInstance != NULL && BannerViewDelegateInstance != nil) {
            [BannerViewDelegateInstance release];
        }
    }
}

int AdMobHelper::bannerViewHeight() const
{
    return BannerViewHeight;
}

void AdMobHelper::initialize()
{
    if (!Initialized) {
        [GADMobileAds configureWithApplicationID:ADMOB_APP_ID.toNSString()];

        Initialized = true;
    }
}

void AdMobHelper::showBannerView()
{
    if (Initialized) {
        if (BannerViewDelegateInstance != NULL && BannerViewDelegateInstance != nil) {
            [BannerViewDelegateInstance release];

            BannerViewHeight = 0;

            emit bannerViewHeightChanged(BannerViewHeight);

            BannerViewDelegateInstance = nil;
        }

        BannerViewDelegateInstance = [[BannerViewDelegate alloc] init];

        [BannerViewDelegateInstance loadAd];
    }
}

void AdMobHelper::hideBannerView()
{
    if (Initialized) {
        if (BannerViewDelegateInstance != NULL && BannerViewDelegateInstance != nil) {
            [BannerViewDelegateInstance release];

            BannerViewHeight = 0;

            emit bannerViewHeightChanged(BannerViewHeight);

            BannerViewDelegateInstance = nil;
        }
    }
}

void AdMobHelper::setBannerViewHeight(const int &height)
{
    Instance->BannerViewHeight = height;

    emit Instance->bannerViewHeightChanged(Instance->BannerViewHeight);
}
