namespace events {

    export interface EventHandle {
        unbind(event: Event, data: string): void;
    }

    // Event
    export class Event {

        private name: string;
        private tracer: EventTracer;
        private callback: Function;
        private eventSet: EventHandle;
        private data: string;
        
        public constructor(name: string, callback: Function, tracer: EventTracer) {
            this.name     = name;
            this.tracer   = tracer;
            this.callback = callback;
        }

        public dispose() {
            this.unbind();
        }

        public cancel(): void {
            this.unbind();
        }

        public bind(eventSet: EventHandle, data?: string): void {
            this.eventSet = eventSet;
            this.data     = data;
            this.tracer.bind(this);
        }

        public unbind(): void {
            this.tracer.unbind(this);

            if (this.eventSet) {
                this.eventSet.unbind(this, this.data);
            }
        }

        public fire(...args): boolean {
            return this.callback(...args) !== false;
        }
        
        public getName(): string {
            return this.name;
        }
    }

    // EventTracer
    export class EventTracer {
        
        private events: Map<Event, Event>;

        public constructor() {
            this.events = new Map();
        }

        public dispose() {
            this.events.forEach((v, k)=>k.dispose())
        }

        public bind(event: Event): void {
            this.events.set(event, event);
        }

        public unbind(event: Event): void {
            this.events.delete(event);
        }

        public clear(): void {
            this.events.forEach((v, k)=>k.unbind())
        }

        public exist(name: string): boolean {
            let iterator = this.events.keys()[Symbol.iterator](), step;
            while(!(step = iterator.next()).done){
                if (step.value.getName() === name) {
                    return true
                }
            }

            return false;
        }

        public cancel(name: string): void {
            let iterator = this.events.keys()[Symbol.iterator](), step;
            while(!(step = iterator.next()).done){
                if (step.value.getName() === name) {
                    return step.value.unbind();
                }
            }
        }
    }

    // EventSet
    export class EventSet implements EventHandle {

        private events: any;

        public constructor() {
            this.events = {};
        }

        public dispose() {
        }

        public bind(event: Event, data: string): void {
            let events = this.events[data];
            if (!events) {
                events = [];
                this.events[data] = events;
            }

            events.push(event);
            event.bind(this, data);
        }

        public unbind(event: Event, data: string) {
            if (!this.events[data]) {
                return;
            }

            let deleteIdx = this.events[data].indexOf(event);
            if (deleteIdx >= 0) {
                this.events[data].splice(deleteIdx, 1);
            }
        }

        public fire(data: string, ...args): boolean {
            if (!this.events[data]) {
                return false;
            }
            
            let ret = false;
            let arr = this.events[data].slice(0, this.events[data].length);
            for (let v of arr) {
                ret = v.fire(...args) || ret;
            }
            return ret;
        }
    }

    // Tracer
    export class Tracer {

        private eventTracer: EventTracer;

        public initTracer() {
            this.eventTracer = new EventTracer;
        }

        public disposeTracer() {
            this.eventTracer.dispose();
        }

        public Event(name: string, callback: string|Function): Event {
            callback = callback || name;
            if (name && this.eventTracer.exist(name)) {
                console.log(`!!!!!!!Warning: Dumplicate Event Name: ${name}`);
                this.eventTracer.cancel(name);
            }
            
            if (typeof(callback) === 'string') {
                let cbkName = callback;
                callback = (...args)=>this[cbkName].call(this, ...args);
            }else {
                let cbk: Function = callback;
                callback = (...args)=>cbk.call(this, ...args);
            }
            
            return new Event(name, callback, this.eventTracer);
        }

        public EventTracer(): EventTracer {
            return this.eventTracer;
        }
    }

    export class Base {

        private eventSet: EventSet;

        public constructor() {
            this.initTracer();
            this.eventSet = new EventSet();
        }

        public dispose() {
            this.eventSet.dispose();
            this.disposeTracer();
        }

        public on(type: string, event: Event): void {
            this.eventSet.bind(event, type);
        }

        public off(type: string, event: Event): void {
            this.eventSet.unbind(event, type);
        }
        
        public fireEvent(type: string, ...args): boolean {
            return this.eventSet.fire(type, ...args);
        }

        // Tracer
        eventTracer: EventTracer ;
        initTracer: () => void;
        disposeTracer: () => void;
        Event: (name: string, callback?: any) => Event;
        EventTracer: () => EventTracer;
    }

    eui.sys.mixin(Base, events.Tracer);

}
