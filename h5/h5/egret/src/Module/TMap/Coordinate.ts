namespace mo {

    export class Coordinate {

        private info: any;

        public constructor(info:any) {
            this.info = info;
        }

        public getInfo(): any {
            return this.info;
        }

        public cell2world(cx: number, cy: number): number[] {
            // cy = this.info.cols - cy;

            let x = this.info.ox + (cx - cy) * this.info.cw / 2;
            let y = this.info.oy + (cx + cy) * this.info.ch / 2;

            if (this.info.cols % 2 === 0) {
                x = x - this.info.cw / 2;
            }

            return [x, y];
        }

        public world2cell(x: number, y: number): number[] {
            if (this.info.cols % 2 === 0) {
                x = x + this.info.cw / 2;
            }

            x = x - this.info.ox;
            y = y - this.info.oy;

            let cx = Math.floor(y / this.info.ch + x / this.info.cw + 0.5);
            let cy = Math.floor(y / this.info.ch - x / this.info.cw + 0.5);

            // cy = this.info.cols - cy;

            return [cx, cy];
        }

        // begin from 0 ...
        public index2cell(id: number, cols?: number): number[] {
            let x = id % (cols || this.info.cols);
            let y = Math.floor(id / this.info.cols);
            return [x, y];
        }

        // begin from 0 ...
        public cell2index(cx: number, cy: number, cols?: number): number {
            return cy * (cols || this.info.cols) + cx;
        }
    }
}