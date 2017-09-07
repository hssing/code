// Timer: 跟实际游戏运行时间相关

class Timer implements events.EventHandle {

    private events = [];

    public dispose() {
        console.assert(this.events.length === 0);
    }

    public unbind(event: events.Event, data) {
        for (let i = 0; i < this.events.length; i++) {
            if (this.events[i].event === event) {
                this.events.splice(i, 1);
                return;
            }
        }
    }

    public cancel(target: {EventTracer: () => events.EventTracer}, name: string): void {
        target.EventTracer().cancel(name);
    }

    public process(): void {
        let clock = egret.getTimer();
        
        while (this.events[0] && (this.events[0].clock <= clock)) {
            let item = this.events[0];
            let delta = clock - item.lastClock;
            this.events.splice(0, 1);
            this.queue(item);
            
            if (item.times === 1 ) {
                item.event.unbind();
            }
            
            if (item.times !== 0) {
                item.times = item.times - 1;
            }
            
            item.event.fire(delta);
        }
    }

    public after(time: number, event: events.Event): events.Event {
        return this.repeat(time, event, 1);
    }

    public repeat(interval: number, event: events.Event, times: number = 0): events.Event {
        let item =
        {
            event	  : event,
            interval  : interval,
            times	  : times,
            clock     : 0,
            lastClock : 0,
        }
        
        event.bind(this);
        this.queue(item);
        return event;
    }

    private queue(item: {event, interval, times, clock, lastClock}): void {
        item.lastClock = egret.getTimer();
        item.clock = item.lastClock + item.interval;
        
        let index = 0;
        for (let i = 0; i < this.events.length; i++) {
            if (this.events[i].clock > item.clock) {
                break;
            }
            index = i + 1;
        }
        
        this.events.splice(index, 0, item);
    }

}
