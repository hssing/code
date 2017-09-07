//copy from eui.sys.TouchScroll.ts

namespace world {
    /**
     * @private
     * 需要记录的历史速度的最大次数。
     */
    let MAX_VELOCITY_COUNT = 4;
    /**
     * @private
     * 记录的历史速度的权重列表。
     */
    let VELOCITY_WEIGHTS:number[] = [1, 1.33, 1.66, 2];
    /**
     * @private
     * 当前速度所占的权重。
     */
    let CURRENT_VELOCITY_WEIGHT = 2.33;
    /**
     * @private
     * 最小的改变速度，解决浮点数精度问题。
     */
    let MINIMUM_VELOCITY = 0.02;
    /**
     * @private
     * 当容器自动滚动时要应用的摩擦系数
     */
    let FRICTION = 0.998;
    /**
     * @private
     * 当容器自动滚动时并且滚动位置超出容器范围时要额外应用的摩擦系数
     */
    let EXTRA_FRICTION = 0.95;
    /**
     * @private
     * 摩擦系数的自然对数
     */
    let FRICTION_LOG = Math.log(FRICTION);

    /**
     * @private
     *
     * @param ratio
     * @returns
     */
    function easeOut(ratio:number):number {
        let invRatio:number = ratio - 1.0;
        return invRatio * invRatio * invRatio + 1;
    }

    /**
     * @private
     * 一个工具类,用于容器的滚屏拖动操作，计算在一段时间持续滚动后释放，应该继续滚动到的值和缓动时间。
     * 使用此工具类，您需要创建一个 ScrollThrown 实例,并在滚动发生时调用start()方法，然后在触摸移动过程中调用update()更新当前舞台坐标。
     * 内部将会启动一个计时器定时根据当前位置计算出速度值，并缓存下来最后4个值。当停止滚动时，再调用finish()方法，
     * 将立即停止记录位移，并将计算出的最终结果存储到 Thrown.scrollTo 和 Thrown.duration 属性上。
     */
    export class TouchScroll {

        /**
         * @private
         * 创建一个 TouchScroll 实例
         * @param updateFunction 滚动位置更新回调函数
         */
        public constructor(updateFunction:(scrollPos:number)=>void, endFunction:()=>void, target:egret.IEventDispatcher) {
            if (DEBUG && !updateFunction) {
                egret.$error(1003, "updateFunction");
            }
            this.updateFunction = updateFunction;
            this.endFunction = endFunction;
            this.target = target;
            this.animation = new eui.sys.Animation(this.onScrollingUpdate, this);
            this.animation.endFunction = this.finishScrolling;
            this.animation.easerFunction = easeOut;
        }

        /**
         * @private
         * 当前容器滚动外界可调节的系列
         */
        $scrollFactor = 1.0;

        /**
         * @private
         */
        private target:egret.IEventDispatcher;
        /**
         * @private
         */
        private updateFunction:(scrollPos:number)=>void;
        /**
         * @private
         */
        private endFunction:()=>void;

        /**
         * @private
         */
        private previousTime:number = 0;
        /**
         * @private
         */
        private velocity:number = 0;
        /**
         * @private
         */
        private previousVelocity:number[] = [];
        /**
         * @private
         */
        private currentPosition:number = 0;
        /**
         * @private
         */
        private previousPosition:number = 0;
        /**
         * @private
         */
        private currentScrollPos:number = 0;
        /**
         * @private
         */
        private maxScrollPos:number = 0;
        /**
         * @private
         * 触摸按下时的偏移量
         */
        private offsetPoint:number = 0;
        /**
         * @private
         * 停止触摸时继续滚动的动画实例
         */
        private animation:eui.sys.Animation;

        public $bounces:boolean = true;

        /**
         * @private
         * 正在播放缓动动画的标志。
         */
        public isPlaying():boolean {
            return this.animation.isPlaying;
        }

        /**
         * @private
         * 如果正在执行缓动滚屏，停止缓动。
         */
        public stop():void {
            this.animation.stop();
            egret.stopTick(this.onTick, this);
            this.started = false;
        }

        private started:boolean = true;

        /**
         * @private
         * true表示已经调用过start方法。
         */
        public isStarted():boolean {
            return this.started;
        }

        /**
         * @private
         * 开始记录位移变化。注意：当使用完毕后，必须调用 finish() 方法结束记录，否则该对象将无法被回收。
         * @param touchPoint 起始触摸位置，以像素为单位，通常是stageX或stageY。
         */
        public start(touchPoint:number):void {
            this.started = true;
            this.velocity = 0;
            this.previousVelocity.length = 0;
            this.previousTime = egret.getTimer();
            this.previousPosition = this.currentPosition = touchPoint;
            this.offsetPoint = touchPoint;
            egret.startTick(this.onTick, this);
        }

        /**
         * @private
         * 更新当前移动到的位置
         * @param touchPoint 当前触摸位置，以像素为单位，通常是stageX或stageY。
         */
        public update(touchPoint:number, maxScrollValue:number, scrollValue):void {
            maxScrollValue = Math.max(maxScrollValue, 0);
            this.currentPosition = touchPoint;
            this.maxScrollPos = maxScrollValue;
            let disMove = this.offsetPoint - touchPoint;
            let scrollPos = disMove + scrollValue;
            this.offsetPoint = touchPoint;

            scrollPos -= disMove * 0.5;
            this.currentScrollPos = scrollPos;
            this.updateFunction.call(this.target, scrollPos);
        }

        /**
         * @private
         * 停止记录位移变化，并计算出目标值和继续缓动的时间。
         * @param currentScrollPos 容器当前的滚动值。
         * @param maxScrollPos 容器可以滚动的最大值。当目标值不在 0~maxValue之间时，将会应用更大的摩擦力，从而影响缓动时间的长度。
         */
        public finish(currentScrollPos:number, maxScrollPos:number):void {
            egret.stopTick(this.onTick, this);
            this.started = false;
            let sum = this.velocity * CURRENT_VELOCITY_WEIGHT;
            let previousVelocityX = this.previousVelocity;
            let length = previousVelocityX.length;
            let totalWeight = CURRENT_VELOCITY_WEIGHT;
            for (let i = 0; i < length; i++) {
                let weight = VELOCITY_WEIGHTS[i];
                sum += previousVelocityX[0] * weight;
                totalWeight += weight;
            }

            let pixelsPerMS = sum / totalWeight;
            let absPixelsPerMS = Math.abs(pixelsPerMS);
            let duration = 0;
            let posTo = 0;
            if (absPixelsPerMS > MINIMUM_VELOCITY) {
                posTo = currentScrollPos + (pixelsPerMS - MINIMUM_VELOCITY) / FRICTION_LOG * 2 * this.$scrollFactor;
                duration = Math.log(MINIMUM_VELOCITY / absPixelsPerMS) / FRICTION_LOG;
            }
            else {
                posTo = currentScrollPos;
            }

            if (duration > 0) {
                this.throwTo(posTo, duration);
            }
            else {
                this.finishScrolling();
            }
        }

        /**
         * @private
         *
         * @param timeStamp
         * @returns
         */
        private onTick(timeStamp:number):boolean {
            let timeOffset = timeStamp - this.previousTime;
            if (timeOffset > 10) {
                let previousVelocity = this.previousVelocity;
                if (previousVelocity.length >= MAX_VELOCITY_COUNT) {
                    previousVelocity.shift();
                }
                this.velocity = (this.currentPosition - this.previousPosition) / timeOffset;
                previousVelocity.push(this.velocity);
                this.previousTime = timeStamp;
                this.previousPosition = this.currentPosition;
            }
            return true;
        }
        /**
         * @private
         *
         * @param animation
         */
        private finishScrolling(animation?:eui.sys.Animation):void {
            let hsp = this.currentScrollPos;
            let maxHsp = this.maxScrollPos;
            let hspTo = hsp;
            this.throwTo(hspTo, 300);
        }

        /**
         * @private
         * 缓动到水平滚动位置
         */
        private throwTo(hspTo:number, duration:number = 500):void {
            let hsp = this.currentScrollPos;
            if (hsp == hspTo) {
                this.endFunction.call(this.target);
                return;
            }
            let animation = this.animation;
            animation.duration = duration;
            animation.from = hsp;
            animation.to = hspTo;
            animation.play();
        }

        /**
         * @private
         * 更新水平滚动位置
         */
        private onScrollingUpdate(animation: eui.sys.Animation):void {
            this.currentScrollPos = animation.currentValue;
            this.updateFunction.call(this.target, animation.currentValue);
        }
    }
}