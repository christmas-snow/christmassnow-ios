#ifndef SPARKCREATOR_H
#define SPARKCREATOR_H

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtCore/QVariant>

class SparkCreator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int     minSparksCount READ minSparksCount WRITE setMinSparksCount)
    Q_PROPERTY(int     maxSparksCount READ maxSparksCount WRITE setMaxSparksCount)
    Q_PROPERTY(QString imageFilePath  READ imageFilePath  WRITE setImageFilePath)

public:
    explicit SparkCreator(QObject *parent = nullptr);
    ~SparkCreator() override = default;

    int minSparksCount() const;
    void setMinSparksCount(int count);

    int maxSparksCount() const;
    void setMaxSparksCount(int count);

    QString imageFilePath() const;
    void setImageFilePath(const QString &file_path);

    Q_INVOKABLE void createRandomSparks();

signals:
    void error(const QString &errorString);
    void randomSparksCreated(const QVariantList &sparks);

private:
    int          MinSparksCount, MaxSparksCount;
    QString      ImageFilePath;
    QVariantList snowPixels;
};

#endif // SPARKCREATOR_H
