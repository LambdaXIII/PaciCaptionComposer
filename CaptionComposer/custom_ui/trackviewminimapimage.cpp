#include "trackviewminimapimage.h"

#include "warlock/numbertools.h"

TrackViewMinimapImage::TrackViewMinimapImage(QQuickItem* p)
  : QQuickPaintedItem(p)
  , m_currentTrack(nullptr)
  , m_clipboxHeight(4)
  , m_clipboxMinWidth(4)
  , m_clipboxSpacing(2)
  , m_clipboxColor(Qt::gray) {
  setImplicitWidth(25);
  setImplicitHeight(50);
  connect(
    this, &TrackViewMinimapImage::widthChanged, [&] { update(); });
  connect(this, &TrackViewMinimapImage::currentTrackChanged, this,
    &TrackViewMinimapImage::full_refresh);
  connect(this, &TrackViewMinimapImage::clipboxHeightChanged, this,
    &TrackViewMinimapImage::full_refresh);
  connect(this, &TrackViewMinimapImage::clipboxMinWidthChanged, this,
    &TrackViewMinimapImage::full_refresh);
  connect(this, &TrackViewMinimapImage::clipboxSpacingChanged, this,
    &TrackViewMinimapImage::full_refresh);
  connect(this, &TrackViewMinimapImage::clipboxColorChanged, this,
    &TrackViewMinimapImage::full_refresh);
}

void TrackViewMinimapImage::paint(QPainter* painter) {
  if (m_currentTrack != nullptr) {
    for (int index = 0; index < m_currentTrack->length(); ++index) {
      auto box = clipboxRectOfIndex(index);
      auto clip = m_currentTrack->at(index);
      painter->save();
      if (clip->isActivated()) {
        painter->setBrush(QBrush(m_clipboxColor));
      } else {
        painter->setPen(QPen(QBrush(m_clipboxColor), 1));
      }
      painter->drawRect(box);
      painter->restore();
    }
  }
}

void TrackViewMinimapImage::recalc_height() {
  if (m_currentTrack != nullptr) {
    auto count = m_currentTrack->length();
    qreal total_height =
      m_clipboxHeight * count + m_clipboxSpacing * (count - 1);
    setHeight(total_height);
  }
}

void TrackViewMinimapImage::full_refresh() {
  recalc_height();
  update();
}

QRectF TrackViewMinimapImage::clipboxRectOfIndex(int index) const {
  constexpr qreal word_pixel_ratio = 2; //字数像素比例
  auto width_gate = warlock::buildRangeGate(m_clipboxMinWidth, width());

  auto clip = m_currentTrack->at(index);
  auto ideal_width = clip->wordCount() * word_pixel_ratio;
  auto box_width = width_gate(ideal_width);

//  qreal box_x = width() - box_width;
  qreal box_x = 0;
  qreal box_y = index * m_clipboxHeight + index * m_clipboxSpacing;

  return { box_x, box_y, box_width, m_clipboxHeight };
}

void TrackViewMinimapImage::updateClipAtIndex(int index) {
  update(clipboxRectOfIndex(index).toRect());
}
