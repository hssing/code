namespace RES {
    /**
     * @private
     */
    export class JszipAnalyzer extends BinAnalyzer {

        public constructor() {
            super();
            this._dataFormat = egret.HttpResponseType.ARRAY_BUFFER;
        }

        /**
         * 解析并缓存加载成功的数据
         */
        public analyzeData(resItem:ResourceItem, data:any):void {
            let name:string = resItem.name;
            if (this.fileDic[name] || !data) {
                return;
            }
            try {
                let zip = new JSZip(data);
                this.fileDic[name] = JSON.parse(zip.file("0.json").asText());
            }
            catch (e) {
                egret.$warn(1017, resItem.url, data);
            }
        }
    }
}