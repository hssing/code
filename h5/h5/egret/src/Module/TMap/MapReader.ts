namespace mo {

    export class MapReader {

        private data = {};
        private hitPos;
        private length = 0;

        public constructor(file: any) {
            this.data = file;
        }

        public load(hitPos: number, length: number) {
            this.hitPos = hitPos;
            this.length = length;
        }

        public getData(key: number): any {
            return this.data[key];
        }
    }

}