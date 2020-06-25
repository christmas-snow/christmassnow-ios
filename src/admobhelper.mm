#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#include <QtCore/QtGlobal>
#include <QtCore/QtMath>
#include <QtCore/QDebug>

#include "admobhelper.h"

const QString AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID(QStringLiteral("ca-app-pub-2455088855015693/9661812425"));
const QString AdMobHelper::ADMOB_TEST_DEVICE_ID    (QStringLiteral(""));

namespace {

constexpr NSTimeInterval AD_RELOAD_ON_FAILURE_DELAY = 60.0;

}

@interface BannerViewDelegate : NSObject<GADBannerViewDelegate>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHelper:(AdMobHelper *)helper NS_DESIGNATED_INITIALIZER;
- (void)dealloc;
- (void)removeHelperAndAutorelease;
- (void)setPersonalization:(BOOL)personalized;
- (void)loadAd;

@end

@implementation BannerViewDelegate
{
    BOOL           ShowPersonalizedAds;
    GADBannerView *BannerView;
    AdMobHelper   *AdMobHelperInstance;
}

- (instancetype)initWithHelper:(AdMobHelper *)helper
{
    self = [super init];

    if (self != nil) {
        ShowPersonalizedAds = NO;
        AdMobHelperInstance = helper;

        UIViewController * __block root_view_controller = nil;

        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = window.rootViewController;

            *stop = (root_view_controller != nil);
        }];

        BannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];

        BannerView.adUnitID                                  = AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID.toNSString();
        BannerView.autoloadEnabled                           = YES;
        BannerView.translatesAutoresizingMaskIntoConstraints = NO;
        BannerView.rootViewController                        = root_view_controller;
        BannerView.delegate                                  = self;

        [root_view_controller.view addSubview:BannerView];

        UILayoutGuide *guide = root_view_controller.view.safeAreaLayoutGuide;

        [NSLayoutConstraint activateConstraints:@[
            [BannerView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
            [BannerView.topAnchor     constraintEqualToAnchor:guide.topAnchor]
        ]];

        CGSize  status_bar_size   = UIApplication.sharedApplication.statusBarFrame.size;
        CGFloat status_bar_height = qMin(status_bar_size.width, status_bar_size.height);

        if (AdMobHelperInstance != nullptr) {
            AdMobHelperInstance->SetBannerViewHeight(qFloor(BannerView.frame.size.height + root_view_controller.view.safeAreaInsets.top
                                                                                         - status_bar_height));
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

- (void)removeHelperAndAutorelease
{
    AdMobHelperInstance = nullptr;

    [self autorelease];
}

- (void)setPersonalization:(BOOL)personalized
{
    ShowPersonalizedAds = personalized;
}

- (void)loadAd
{
    GADRequest *request = [GADRequest request];

    if (AdMobHelper::ADMOB_TEST_DEVICE_ID != QStringLiteral("")) {
        request.testDevices = @[AdMobHelper::ADMOB_TEST_DEVICE_ID.toNSString()];
    }

    if (!ShowPersonalizedAds) {
        GADExtras *extras = [[[GADExtras alloc] init] autorelease];

        extras.additionalParameters = @{@"npa": @"1"};

        [request registerAdNetworkExtras:extras];
    }

    [BannerView loadRequest:request];
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    Q_UNUSED(adView)
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

    qWarning() << QString::fromNSString(error.localizedDescription);

    [self performSelector:@selector(loadAd) withObject:nil afterDelay:AD_RELOAD_ON_FAILURE_DELAY];
}

@end

AdMobHelper::AdMobHelper(QObject *parent) :
    QObject                   (parent),
    Initialized               (false),
    ShowPersonalizedAds       (false),
    BannerViewHeight          (0),
    BannerViewDelegateInstance(nil)
{
}

AdMobHelper::~AdMobHelper() noexcept
{
    [BannerViewDelegateInstance removeHelperAndAutorelease];
}

AdMobHelper &AdMobHelper::GetInstance()
{
    static AdMobHelper instance;

    return instance;
}

int AdMobHelper::bannerViewHeight() const
{
    return BannerViewHeight;
}

void AdMobHelper::initAds()
{
    if (!Initialized) {
        [GADMobileAds sharedInstance].requestConfiguration.maxAdContentRating = GADMaxAdContentRatingGeneral;

        [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];

        Initialized = true;
    }
}

void AdMobHelper::setPersonalization(bool personalized)
{
    ShowPersonalizedAds = personalized;

    if (Initialized) {
        [BannerViewDelegateInstance setPersonalization:ShowPersonalizedAds];
    }
}

void AdMobHelper::showBannerView()
{
    if (Initialized) {
        [BannerViewDelegateInstance removeHelperAndAutorelease];

        if (BannerViewHeight != 0) {
            BannerViewHeight = 0;

            emit bannerViewHeightChanged(BannerViewHeight);
        }

        BannerViewDelegateInstance = [[BannerViewDelegate alloc] initWithHelper:this];

        [BannerViewDelegateInstance setPersonalization:ShowPersonalizedAds];
        [BannerViewDelegateInstance loadAd];
    }
}

void AdMobHelper::hideBannerView()
{
    if (Initialized) {
        [BannerViewDelegateInstance removeHelperAndAutorelease];

        if (BannerViewHeight != 0) {
            BannerViewHeight = 0;

            emit bannerViewHeightChanged(BannerViewHeight);
        }

        BannerViewDelegateInstance = nil;
    }
}

void AdMobHelper::SetBannerViewHeight(int height)
{
    if (BannerViewHeight != height) {
        BannerViewHeight = height;

        emit bannerViewHeightChanged(BannerViewHeight);
    }
}
