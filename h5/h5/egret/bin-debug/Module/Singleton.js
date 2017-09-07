function Singleton(cls) {
    var args = [];
    for (var _i = 1; _i < arguments.length; _i++) {
        args[_i - 1] = arguments[_i];
    }
    if (cls["__singleton__"]) {
        return cls["__singleton__"];
    }
    cls["__singleton__"] = new (cls.bind.apply(cls, [void 0].concat(args)))();
    return cls["__singleton__"];
}
//# sourceMappingURL=Singleton.js.map