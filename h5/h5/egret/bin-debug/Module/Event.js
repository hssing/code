var __reflect = (this && this.__reflect) || function (p, c, t) {
    p.__class__ = c, t ? t.push(c) : t = [c], p.__types__ = p.__types__ ? t.concat(p.__types__) : t;
};
var events;
(function (events_1) {
    // Event
    var Event = (function () {
        function Event(name, callback, tracer) {
            this.name = name;
            this.tracer = tracer;
            this.callback = callback;
        }
        Event.prototype.dispose = function () {
            this.unbind();
        };
        Event.prototype.cancel = function () {
            this.unbind();
        };
        Event.prototype.bind = function (eventSet, data) {
            this.eventSet = eventSet;
            this.data = data;
            this.tracer.bind(this);
        };
        Event.prototype.unbind = function () {
            this.tracer.unbind(this);
            if (this.eventSet) {
                this.eventSet.unbind(this, this.data);
            }
        };
        Event.prototype.fire = function () {
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            return this.callback.apply(this, args) !== false;
        };
        Event.prototype.getName = function () {
            return this.name;
        };
        return Event;
    }());
    events_1.Event = Event;
    __reflect(Event.prototype, "events.Event");
    // EventTracer
    var EventTracer = (function () {
        function EventTracer() {
            this.events = new Map();
        }
        EventTracer.prototype.dispose = function () {
            this.events.forEach(function (v, k) { return k.dispose(); });
        };
        EventTracer.prototype.bind = function (event) {
            this.events.set(event, event);
        };
        EventTracer.prototype.unbind = function (event) {
            this.events.delete(event);
        };
        EventTracer.prototype.clear = function () {
            this.events.forEach(function (v, k) { return k.unbind(); });
        };
        EventTracer.prototype.exist = function (name) {
            var iterator = this.events.keys()[Symbol.iterator](), step;
            while (!(step = iterator.next()).done) {
                if (step.value.getName() === name) {
                    return true;
                }
            }
            return false;
        };
        EventTracer.prototype.cancel = function (name) {
            var iterator = this.events.keys()[Symbol.iterator](), step;
            while (!(step = iterator.next()).done) {
                if (step.value.getName() === name) {
                    return step.value.unbind();
                }
            }
        };
        return EventTracer;
    }());
    events_1.EventTracer = EventTracer;
    __reflect(EventTracer.prototype, "events.EventTracer");
    // EventSet
    var EventSet = (function () {
        function EventSet() {
            this.events = {};
        }
        EventSet.prototype.dispose = function () {
        };
        EventSet.prototype.bind = function (event, data) {
            var events = this.events[data];
            if (!events) {
                events = [];
                this.events[data] = events;
            }
            events.push(event);
            event.bind(this, data);
        };
        EventSet.prototype.unbind = function (event, data) {
            if (!this.events[data]) {
                return;
            }
            var deleteIdx = this.events[data].indexOf(event);
            if (deleteIdx >= 0) {
                this.events[data].splice(deleteIdx, 1);
            }
        };
        EventSet.prototype.fire = function (data) {
            var args = [];
            for (var _i = 1; _i < arguments.length; _i++) {
                args[_i - 1] = arguments[_i];
            }
            if (!this.events[data]) {
                return false;
            }
            var ret = false;
            var arr = this.events[data].slice(0, this.events[data].length);
            for (var _a = 0, arr_1 = arr; _a < arr_1.length; _a++) {
                var v = arr_1[_a];
                ret = v.fire.apply(v, args) || ret;
            }
            return ret;
        };
        return EventSet;
    }());
    events_1.EventSet = EventSet;
    __reflect(EventSet.prototype, "events.EventSet", ["events.EventHandle"]);
    // Tracer
    var Tracer = (function () {
        function Tracer() {
        }
        Tracer.prototype.initTracer = function () {
            this.eventTracer = new EventTracer;
        };
        Tracer.prototype.disposeTracer = function () {
            this.eventTracer.dispose();
        };
        Tracer.prototype.Event = function (name, callback) {
            var _this = this;
            callback = callback || name;
            if (name && this.eventTracer.exist(name)) {
                console.log("!!!!!!!Warning: Dumplicate Event Name: " + name);
                this.eventTracer.cancel(name);
            }
            if (typeof (callback) === 'string') {
                var cbkName_1 = callback;
                callback = function () {
                    var args = [];
                    for (var _i = 0; _i < arguments.length; _i++) {
                        args[_i] = arguments[_i];
                    }
                    return (_a = _this[cbkName_1]).call.apply(_a, [_this].concat(args));
                    var _a;
                };
            }
            else {
                var cbk_1 = callback;
                callback = function () {
                    var args = [];
                    for (var _i = 0; _i < arguments.length; _i++) {
                        args[_i] = arguments[_i];
                    }
                    return cbk_1.call.apply(cbk_1, [_this].concat(args));
                };
            }
            return new Event(name, callback, this.eventTracer);
        };
        Tracer.prototype.EventTracer = function () {
            return this.eventTracer;
        };
        return Tracer;
    }());
    events_1.Tracer = Tracer;
    __reflect(Tracer.prototype, "events.Tracer");
    var Base = (function () {
        function Base() {
            this.initTracer();
            this.eventSet = new EventSet();
        }
        Base.prototype.dispose = function () {
            this.eventSet.dispose();
            this.disposeTracer();
        };
        Base.prototype.on = function (type, event) {
            this.eventSet.bind(event, type);
        };
        Base.prototype.off = function (type, event) {
            this.eventSet.unbind(event, type);
        };
        Base.prototype.fireEvent = function (type) {
            var args = [];
            for (var _i = 1; _i < arguments.length; _i++) {
                args[_i - 1] = arguments[_i];
            }
            return (_a = this.eventSet).fire.apply(_a, [type].concat(args));
            var _a;
        };
        return Base;
    }());
    events_1.Base = Base;
    __reflect(Base.prototype, "events.Base");
    eui.sys.mixin(Base, events.Tracer);
})(events || (events = {}));
//# sourceMappingURL=Event.js.map