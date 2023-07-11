local mgrCenter  = TWRequire("ManagerCenter")

function App_Update(dt)
	mgrCenter:update(dt)
	gMessageManager:update(dt)
	gRootManager:update(dt)
end

function App_Render()
	mgrCenter:render()
end

function App_Exit()
	mgrCenter:Exit()
end