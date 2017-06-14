local common = {}

common.netEngine 	= import(".NetEngine").new()

--事件中心
common.events  = import(".Events").new()


return common