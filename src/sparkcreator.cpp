#include <QtCore/QDateTime>
#include <QtCore/QVariantMap>
#include <QtCore/QRandomGenerator>
#include <QtGui/QColor>
#include <QtGui/QImage>

#include "sparkcreator.h"

SparkCreator::SparkCreator(QObject *parent) :
    QObject       (parent),
    MinSparksCount(0),
    MaxSparksCount(0)
{
}

int SparkCreator::minSparksCount() const
{
    return MinSparksCount;
}

void SparkCreator::setMinSparksCount(int count)
{
    MinSparksCount = count;
}

int SparkCreator::maxSparksCount() const
{
    return MaxSparksCount;
}

void SparkCreator::setMaxSparksCount(int count)
{
    MaxSparksCount = count;
}

QString SparkCreator::imageFilePath() const
{
    return ImageFilePath;
}

void SparkCreator::setImageFilePath(const QString &file_path)
{
    ImageFilePath = file_path;

    SnowPixels.clear();

    if (!ImageFilePath.isEmpty()) {
        QImage image(ImageFilePath);

        if (!image.isNull()) {
            for (int x = 0; x < image.width(); x++) {
                for (int y = 0; y < image.height(); y++) {
                    QColor color = image.pixelColor(x, y);

                    if (color.alpha() > 200) {
                        QVariantMap pixel;

                        pixel.insert(QStringLiteral("x"), x);
                        pixel.insert(QStringLiteral("y"), y);

                        SnowPixels.append(pixel);
                    }
                }
            }
        } else {
            emit error(QStringLiteral("Cannot open image file %1").arg(ImageFilePath));
        }
    }
}

void SparkCreator::createRandomSparks()
{
    if (MinSparksCount >= 0 && MaxSparksCount > 0 && MinSparksCount < MaxSparksCount && SnowPixels.count() > 0) {
        QVariantList sparks;

        int sparks_count = QRandomGenerator::system()->bounded(MinSparksCount, MaxSparksCount);

        for (int i = 0; i < sparks_count; i++) {
            sparks.append(SnowPixels.at(QRandomGenerator::system()->bounded(SnowPixels.count())));
        }

        emit randomSparksCreated(sparks);
    } else {
        emit error(QStringLiteral("Cannot create random sparks"));
    }
}
