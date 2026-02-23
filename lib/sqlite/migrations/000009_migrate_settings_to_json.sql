INSERT OR REPLACE INTO key_value_store (id, value)
SELECT 
    'MainAppSettings' AS id,
    json_object(
        'min', min,
        'max', max,
        'offsetMs', offsetMs,
        'mediaPaths', json(IFNULL(mediaPaths, '[]')),
        'slewMaxRateOfChange', slewMaxRateOfChange,
        'rdpEpsilon', rdpEpsilon,
        'remapFullRange', CASE WHEN remapFullRange = 1 THEN json('true') ELSE json('false') END,
        'skipToAction', CASE WHEN skipToAction = 1 THEN json('true') ELSE json('false') END,
        'embeddedVideoPlayer', CASE WHEN embeddedVideoPlayer = 1 THEN json('true') ELSE json('false') END,
        'autoSwitchToVideoPlayerTab', CASE WHEN autoSwitchToVideoPlayerTab = 1 THEN json('true') ELSE json('false') END,
        'invert', CASE WHEN invert = 1 THEN json('true') ELSE json('false') END,
        'playerBackendType', playerBackendType
    )
FROM settings
LIMIT 1;
DROP TABLE settings;