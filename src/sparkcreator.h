#ifndef SPARKCREATOR_H
#define SPARKCREATOR_H

#include <QtCore/QObject>
#include <QtCore/QString>
#include <QtCore/QVariantList>

class SparkCreator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int     minSparksCount READ minSparksCount WRITE setMinSparksCount)
    Q_PROPERTY(int     maxSparksCount READ maxSparksCount WRITE setMaxSparksCount)
    Q_PROPERTY(QString imageFilePath  READ imageFilePath  WRITE setImageFilePath)

public:
    explicit SparkCreator(QObject *parent = nullptr);

    SparkCreator(const SparkCreator&) = delete;
    SparkCreator(SparkCreator&&) noexcept = delete;

    SparkCreator &operator=(const SparkCreator&) = delete;
    SparkCreator &operator=(SparkCreator&&) noexcept = delete;

    ~SparkCreator() noexcept override = default;

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
    QVariantList SnowPixels;
};

#endif // SPARKCREATOR_H
