--[[
    Author : manoraju@cisco.com
    Description: 
        This script provides solution for PCCE 12.0 Contact center requirement to allow outbound calls from finesse while block any calls made from jabber endpoint.

        Logic : 
         1) When call is made from finesse, the request first goes to CUCM via 
             CTIManger-Jtapi link and then to CUCM. 
         2) CUCM Converts it into SIP remote CC request requesting Jabber Client to 
             initiate Call on the specified Dialed Number. 
         3) This triggers a New SIP invite from Jabber to CUCM. The  Invite consist of 
            Call-Info header with "x-cisco-remotecc:callinfo".
         4) While a call made directly from jabber does not have remotecc value in it's SIP Invite
	 5) The script is applied on Inbound Invite received from jabber and looks for remotecc value or Call-Info header
            to determine if the call is received from finesse or  jabber and thereby allow or block it.
--]]


M = {}

local dnislist = '9'

local function process_inbound_request(msg)
	
	local callinfo= msg:getHeader("Call-Info")
	if not callinfo
	then
		local method, ruri, ver = msg:getRequestLine()
		local dnisstart = string.find(ruri, "sip:")
		local enddnis = string.find(ruri, "@", dnisstart+1)
		local userpart = string.sub(ruri, dnisstart, enddnis-1)
		if string.sub(userpart,5,5)== dnislist
		then 
			local newuri = string.gsub(ruri, userpart, "sip:JabberCall")
			msg:setRequestUri(newuri)
		end
	else      
		local callinf = string.match(callinfo, "remotecc")
		if not callinf
		then
			local method, ruri, ver = msg:getRequestLine()
			local dnisstart = string.find(ruri, "sip:")
			local enddnis = string.find(ruri, "@", dnisstart+1)
			local userpart = string.sub(ruri, dnisstart, enddnis-1)
			if string.sub(userpart,5,5)== dnislist
			then 
				local newuri = string.gsub(ruri, userpart, "sip:JabberCall")
				msg:setRequestUri(newuri)
			end
		end
	end
end	

M.inbound_INVITE  = function(msg)
    process_inbound_request(msg)
end


return M
