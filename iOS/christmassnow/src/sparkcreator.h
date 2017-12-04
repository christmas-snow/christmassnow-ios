#ifndef SPARKCREATOR_H
#define SPARKCREATOR_H

#include <QObject>
#include <QVariant>

class SparkCreator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int     minSparksCount READ minSparksCount WRITE setMinSparksCount)
    Q_PROPERTY(int     maxSparksCount READ maxSparksCount WRITE setMaxSparksCount)
    Q_PROPERTY(QString imageFilePath  READ imageFilePath  WRITE setImageFilePath)

public:
    explicit SparkCreator(QObject *parent = nullptr);

    int minSparksCount() const;
    void setMinSparksCount(const int &count);

    int maxSparksCount() const;
    void setMaxSparksCount(const int &count);

    QString imageFilePath() const;
    void setImageFilePath(const QString &file_path);

    Q_INVOKABLE void createRandomSparks();

signals:
    void error(QString errorString);
    void randomSparksCreated(QVariantList sparks);

private:
    int          MinSparksCount, MaxSparksCount;
    QString      ImageFilePath;
    QVariantList snowPixels;
};

#endif // SPARKCREATOR_H
