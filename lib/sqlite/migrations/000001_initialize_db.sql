CREATE TABLE videos(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  videoPath TEXT NOT NULL,
  funscriptPath TEXT NOT NULL,
  averageSpeed REAL NOT NULL,
  averageMin REAL NOT NULL,
  averageMax REAL NOT NULL,
  isFavorite INTEGER NOT NULL DEFAULT 0,
  isDislike INTEGER NOT NULL DEFAULT 0,
  dateFirstFound INTEGER NOT NULL,
  duration REAL,
  funscriptMetadataId INTEGER,
  FOREIGN KEY (funscriptMetadataId) REFERENCES funscript_metadata(id) ON DELETE SET NULL
);

CREATE TABLE funscript_metadata(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  creator TEXT,
  description TEXT,
  duration INTEGER,
  license TEXT,
  notes TEXT,
  scriptUrl TEXT,
  title TEXT,
  type TEXT,
  videoUrl TEXT,
  bookmarks TEXT,
  chapters TEXT,
  performers TEXT,
  tags TEXT
);

CREATE TABLE user_categories(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  description TEXT
);

CREATE TABLE video_user_category_links(
  videoId INTEGER NOT NULL,
  userCategoryId INTEGER NOT NULL,
  PRIMARY KEY (videoId, userCategoryId),
  FOREIGN KEY (videoId) REFERENCES videos(id) ON DELETE CASCADE,
  FOREIGN KEY (userCategoryId) REFERENCES user_categories(id) ON DELETE CASCADE
);

CREATE TABLE media_library_settings(
  id INTEGER PRIMARY KEY,
  sortOption TEXT NOT NULL,
  isSortAscending INTEGER NOT NULL,
  videosPerRow INTEGER NOT NULL,
  showVideoTitles INTEGER NOT NULL,
  showAverageSpeed INTEGER NOT NULL,
  showAverageMinMax INTEGER NOT NULL,
  showDuration INTEGER NOT NULL,
  separateFavorites INTEGER NOT NULL,
  visibilityFilters TEXT
);

CREATE TABLE settings(
  id INTEGER PRIMARY KEY,
  min INTEGER NOT NULL,
  max INTEGER NOT NULL,
  offsetMs INTEGER NOT NULL,
  mediaPaths TEXT,
  slewMaxRateOfChange REAL,
  rdpEpsilon REAL,
  remapFullRange INTEGER NOT NULL,
  skipToAction INTEGER NOT NULL,
  embeddedVideoPlayer INTEGER NOT NULL,
  autoSwitchToVideoPlayerTab INTEGER NOT NULL,
  autoPlay INTEGER NOT NULL,
  invert INTEGER NOT NULL
);
