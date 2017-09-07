var config;
(function (config) {
    config.MAP_URLS = ["ditu_json"]; //, "caodi_json"];
    config.MAP_CONFIG = "dresource/Config/Map/";
    config.MAP_BORDER_OFFSET = 4; // 地图边界偏移量（单位：格子）
    config.MAP_UPDATE_COLS = 30; // 发送给后端的地图更新范围（列-宽）
    config.MAP_UPDATE_ROWS = 30; // 发送给后端的地图更新范围（行-高）
    config.MAP_BLOCKED_LAYER_NAME = "zudang";
})(config || (config = {}));
//# sourceMappingURL=Config.js.map