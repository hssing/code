
function Singleton<T>(cls: new (...args) => T, ...args): T {
    if (cls["__singleton__"]) {
        return cls["__singleton__"];
    }

    cls["__singleton__"] = new cls(...args);
    return cls["__singleton__"];
}
