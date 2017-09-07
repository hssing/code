var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var ui;
(function (ui) {
    var ServerList = (function (_super) {
        __extends(ServerList, _super);
        function ServerList(param) {
            return _super.call(this, ServerList.CUSTOM) || this;
        }
        ServerList.prototype.onEnter = function () {
            _super.prototype.onEnter.call(this);
            var serverListData = LogicMgr.get(logic.Login).getServerListInfo();
            this.serverList.addEventListener(eui.ItemTapEvent.ITEM_TAP, this.onItemTouch, this);
            var data = this.getData(serverListData);
            this.refresh(data);
        };
        ServerList.prototype.getData = function (serverListData) {
            var data = [];
            for (var i = 0; i < serverListData.length; i++) {
                var item = new logic.ServerInfo();
                item.name = serverListData[i].name;
                item.ip = serverListData[i].ip;
                item.port = serverListData[i].port;
                item.id = serverListData[i].id;
                data.push(item);
            }
            return data;
        };
        ServerList.prototype.refresh = function (data) {
            this.serverList.dataProvider = new eui.ArrayCollection(data);
        };
        ServerList.prototype.onItemTouch = function (e) {
            this.removeFromParent();
            LogicMgr.get(logic.Login).setCurServerInfo(this.serverList.selectedItem);
            LogicMgr.get(logic.Login).fireEvent(logic.Login.EVT.REFESH_SERVERINFO);
        };
        return ServerList;
    }(UIBase));
    ServerList.CUSTOM = {
        closeBg: { alpha: 0.5, disable: false },
        skinName: "resource/ui/ServerListUISkin.exml",
    };
    ui.ServerList = ServerList;
    __reflect(ServerList.prototype, "ui.ServerList");
})(ui || (ui = {}));
//# sourceMappingURL=ServerList.js.map