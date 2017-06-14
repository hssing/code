--
-- Author: Your Name
-- Date: 2015-10-30 16:10:57
--


local PraiseProxy = class("PraiseProxy", base.BaseProxy)

function PraiseProxy:init( )
	-- body
	--点赞返回
	self:add(123142,self.reqPraiseCallback)

end

---请求点赞
function PraiseProxy:reqPraise(  )
	self:send(12412412)
end


---请求点赞返回
function PraiseProxy:reqPraiseCallback( data )
	-- body
end








return PraiseProxy