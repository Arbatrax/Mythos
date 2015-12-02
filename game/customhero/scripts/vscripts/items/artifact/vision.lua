function Vision(keys)
	local target = keys.target
	
	AddFOWViewer( 2, target:GetAbsOrigin(), 250, 0.2, false)
end