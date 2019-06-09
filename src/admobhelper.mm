#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#include <QtCore/QtGlobal>
#include <QtCore/QtMath>
#include <QtCore/QDebug>

#include "admobhelper.h"

const QString AdMobHelper::ADMOB_APP_ID              ("ca-app-pub-2455088855015693~4469017889");
const QString AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID  ("ca-app-pub-2455088855015693/9661812425");
const QString AdMobHelper::ADMOB_TEST_DEVICE_ID      ("");

@interface BannerViewDelegate : NSObject<GADBannerViewDelegate>

- (instancetype)initWithHelper:(AdMobHelper *)helper;
- (void)dealloc;
- (void)removeHelperAndAutorelease;
- (void)loadAd;

@end

@implementation BannerViewDelegate
{
    GADBannerView *BannerView;
    AdMobHelper   *AdMobHelperInstance;
}

- (instancetype)initWithHelper:(AdMobHelper *)helper
{
    self = [super init];

    if (self != nil) {
        AdMobHelperInstance = helper;

        UIViewController * __block root_view_controller = nil;

        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull window, NSUInteger, BOOL * _Nonnull stop) {
            root_view_controller = window.rootViewController;

            *stop = (root_view_controller != nil);
        }];

        BannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];

        BannerView.adUnitID           = AdMobHelper::ADMOB_BANNERVIEW_UNIT_ID.toNSString();
        BannerView.autoloadEnabled    = YES;
        BannerView.rootViewController = root_view_controller;
        BannerView.delegate           = self;

        if (@available(iOS 6, *)) {
            BannerView.translatesAutoresizingMaskIntoConstraints = NO;
        } else {
            assert(0);
        }

        [root_view_controller.view addSubview:BannerView];

        if (@available(iOS 11, *)) {
            UILayoutGuide *guide = root_view_controller.view.safeAreaLayoutGuide;

            [NSLayoutConstraint activateConstraints:@[
                [BannerView.centerXAnchor constraintEqualToAnchor:guide.centerXAnchor],
                [BannerView.topAnchor     constraintEqualToAnchor:guide.topAnchor]
            ]];

            CGSize  status_bar_size   = UIApplication.sharedApplication.statusBarFrame.size;
            CGFloat status_bar_height = qMin(status_bar_size.width, status_bar_size.height);

            if (AdMobHelperInstance != nullptr) {
                AdMobHelperInstance->setBannerViewHeight(qFloor(BannerView.frame.size.height + root_view_controller.view.safeAreaInsets.top
                                                                                             - status_bar_height));
            }
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

- (void)removeHelperAndAutorelease
{
    AdMobHelperInstance = nullptr;

    [self autorelease];
}

- (void)loadAd
{
    GADRequest *request = [GADRequest request];

    if (AdMobHelper::ADMOB_TEST_DEVICE_ID != "") {
        request.testDevices = @[ AdMobHelper::ADMOB_TEST_DEVICE_ID.toNSString() ];
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

    [self performSelector:@selector(loadAd) withObject:nil afterDelay:10.0];
}

@end

AdMobHelper::AdMobHelper(QObject *parent) : QObject(parent)
{
    [GADMobileAds configureWithApplicationID:ADMOB_APP_ID.toNSString()];

    BannerViewHeight           = 0;
    BannerViewDelegateInstance = nullptr;
}

AdMobHelper::~AdMobHelper() noexcept
{
    if (BannerViewDelegateInstance != nullptr && BannerViewDelegateInstance != nil) {
        [BannerViewDelegateInstance removeHelperAndAutorelease];
    }
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

void AdMobHelper::showBannerView()
{
    if (BannerViewDelegateInstance != nullptr && BannerViewDelegateInstance != nil) {
        [BannerViewDelegateInstance removeHelperAndAutorelease];

        BannerViewHeight = 0;

        emit bannerViewHeightChanged(BannerViewHeight);

        BannerViewDelegateInstance = nil;
    }

    BannerViewDelegateInstance = [[BannerViewDelegate alloc] initWithHelper:this];

    [BannerViewDelegateInstance loadAd];
}

void AdMobHelper::hideBannerView()
{
    if (BannerViewDelegateInstance != nullptr && BannerViewDelegateInstance != nil) {
        [BannerViewDelegateInstance removeHelperAndAutorelease];

        BannerViewHeight = 0;

        emit bannerViewHeightChanged(BannerViewHeight);

        BannerViewDelegateInstance = nil;
    }
}

void AdMobHelper::setBannerViewHeight(int height)
{
    BannerViewHeight = height;

    emit bannerViewHeightChanged(BannerViewHeight);
}
