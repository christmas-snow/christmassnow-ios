#ifndef ADMOBHELPER_H
#define ADMOBHELPER_H

#include <QtCore/QObject>
#include <QtCore/QString>

#ifdef __OBJC__
@class BannerViewDelegate;
#endif

class AdMobHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int bannerViewHeight READ bannerViewHeight NOTIFY bannerViewHeightChanged)

public:
    static const QString ADMOB_APP_ID,
                         ADMOB_BANNERVIEW_UNIT_ID,
                         ADMOB_TEST_DEVICE_ID;

    explicit AdMobHelper(QObject *parent = 0);
    virtual ~AdMobHelper();

    int  bannerViewHeight() const;

    Q_INVOKABLE void initialize();
    Q_INVOKABLE void showBannerView();
    Q_INVOKABLE void hideBannerView();

    static void setBannerViewHeight(const int &height);

signals:
    void bannerViewHeightChanged(int bannerViewHeight);

private:
    bool                Initialized;
    int                 BannerViewHeight;
    static AdMobHelper *Instance;
#ifdef __OBJC__
    BannerViewDelegate *BannerViewDelegateInstance;
#else
    void               *BannerViewDelegateInstance;
#endif
};

#endif // ADMOBHELPER_H
