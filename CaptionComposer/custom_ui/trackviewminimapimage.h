#ifndef TRACKVIEWMINIMAPIMAGE_H
#define TRACKVIEWMINIMAPIMAGE_H

#include "pacibase/property_macros.h"
#include "pacicore/track.h"

#include <QPainter>
#include <QQuickPaintedItem>

class TrackViewMinimapImage: public QQuickPaintedItem {
  Q_OBJECT
  PA_WRITABLE_PROPERTY(paci::Track*, currentTrack, CurrentTrack)
  PA_WRITABLE_PROPERTY(qreal, clipboxHeight, ClipboxHeight)
  PA_WRITABLE_PROPERTY(qreal, clipboxMinWidth, ClipboxMinWidth)
  PA_WRITABLE_PROPERTY(qreal, clipboxSpacing, ClipboxSpacing)
  PA_WRITABLE_PROPERTY(QColor, clipboxColor, ClipboxColor)

public:
  explicit TrackViewMinimapImage(QQuickItem* p = nullptr);
  void paint(QPainter* painter) override;

protected:
  Q_SLOT void recalc_height();
  Q_SLOT void full_refresh();
  QRectF clipboxRectOfIndex(int index) const;
  Q_SLOT void updateClipAtIndex(int index);
};

#endif // TRACKVIEWMINIMAPIMAGE_H
