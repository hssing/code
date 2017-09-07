namespace world {

    export class Radar extends ViewBase {

        public build(): egret.DisplayObjectContainer {
            return this.createView("leida_png");
        }
    }

}