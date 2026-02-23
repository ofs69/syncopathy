INSERT OR REPLACE INTO key_value_store (id, value)
SELECT 
    'MediaLibrarySettings' AS id,
    json_object(
        'sortOption', sortOption,
        'isSortAscending', CASE WHEN isSortAscending = 1 THEN json('true') ELSE json('false') END,
        'videosPerRow', videosPerRow,
        'showVideoTitles', CASE WHEN showVideoTitles = 1 THEN json('true') ELSE json('false') END,
        'showAverageSpeed', CASE WHEN showAverageSpeed = 1 THEN json('true') ELSE json('false') END,
        'showAverageMinMax', CASE WHEN showAverageMinMax = 1 THEN json('true') ELSE json('false') END,
        'showDuration', CASE WHEN showDuration = 1 THEN json('true') ELSE json('false') END,
        'showPlayCount', CASE WHEN showPlayCount = 1 THEN json('true') ELSE json('false') END,
        'separateFavorites', CASE WHEN separateFavorites = 1 THEN json('true') ELSE json('false') END,
        'visibilityFilters', json(IFNULL(visibilityFilters, '[]'))
    )
FROM media_library_settings
LIMIT 1;
DROP TABLE media_library_settings;