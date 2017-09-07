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
    var CampDetail = (function (_super) {
        __extends(CampDetail, _super);
        function CampDetail() {
            var _this = _super.call(this, CampDetail.CUSTOM) || this;
            _this.createGrideList();
            return _this;
        }
        CampDetail.prototype.createGrideList = function () {
            this.group = new eui.Group();
            this.mScroller.viewport = this.group;
            for (var i = 1; i <= 200; ++i) {
                var btn = new eui.Button();
                btn.label = "按钮" + (i < 10 ? "0" : "") + i;
                this.group.addChild(btn);
            }
            var tLayout = new eui.TileLayout();
            tLayout.paddingTop = 30;
            tLayout.paddingLeft = 30;
            tLayout.paddingRight = 30;
            tLayout.paddingBottom = 30;
            this.group.layout = tLayout;
            this._iAlignMode = AlignMode.GAP;
            tLayout.columnAlign = eui.ColumnAlign.JUSTIFY_USING_GAP;
            tLayout.rowAlign = eui.RowAlign.JUSTIFY_USING_GAP;
        };
        return CampDetail;
    }(UIBase));
    CampDetail.CUSTOM = {
        skinName: "resource/ui/CampUISkin.exml"
    };
    ui.CampDetail = CampDetail;
    __reflect(CampDetail.prototype, "ui.CampDetail");
    var AlignMode = (function () {
        function AlignMode() {
        }
        return AlignMode;
    }());
    AlignMode.GAP = 0;
    AlignMode.WH = 1;
    __reflect(AlignMode.prototype, "AlignMode");
})(ui || (ui = {}));
//# sourceMappingURL=CampDetail.js.map