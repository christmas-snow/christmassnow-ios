#include <QtCore/QDateTime>
#include <QtGui/QColor>
#include <QtGui/QImage>

#include "sparkcreator.h"

SparkCreator::SparkCreator(QObject *parent) : QObject(parent)
{
    MinSparksCount = 0;
    MaxSparksCount = 0;
    ImageFilePath  = "";

    qsrand((uint)QDateTime::currentMSecsSinceEpoch());
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

void SparkCreator::setImageFilePath(QString file_path)
{
    ImageFilePath = file_path;

    if (!ImageFilePath.isEmpty())
    {
        QImage image(ImageFilePath);

        if (!image.isNull()) {
            snowPixels.clear();

            for (int x = 0; x < image.width(); x++) {
                for (int y = 0; y < image.height(); y++) {
                    QColor color = image.pixelColor(x, y);

                    if (color.alpha() > 200) {
                        QVariantMap pixel;

                        pixel.insert("x", x);
                        pixel.insert("y", y);

                        snowPixels.append(pixel);
                    }
                }
            }
        } else {
            emit error(QString("Cannot open image file %1").arg(ImageFilePath));
        }
    }
}

void SparkCreator::createRandomSparks()
{
    QVariantList sparks;

    for (int i = 0; i < MinSparksCount + qrand() * ((float)(MaxSparksCount - MinSparksCount) / RAND_MAX); i++) {
        sparks.append(snowPixels.at(qrand() * ((float)(snowPixels.count() - 1) / RAND_MAX)));
    }

    emit randomSparksCreated(sparks);
}
