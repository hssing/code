function applicationWillEnterForeground()
    local view = mgr.ViewMgr:get(_viewname.LOGIN)
    if view then
        view:xmlHttpRequest()
    end
end

applicationWillEnterForeground()