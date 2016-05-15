assert(_HOST or _CC_VERSION, "CC 1.74+ is required")
assert(http, "HTTP API is required")

local dirs = {}
dirs.root = ".bench"
dirs.repos = fs.combine(dirs.root, "repos.json")
dirs.config = fs.combine(dirs.root, "config.json")
dirs.packages = fs.combine(dirs.root, "packages")

-- json api
local json = load([[local a=20141223.14;local b="-[ JSON.lua package by Jeffrey Friedl (http://regex.info/blog/lua/json) version 20141223.14 ]-"local c={VERSION=a,AUTHOR_NOTE=b}local d="  "local e={pretty=true,align_keys=false,indent=d}local f={__tostring=function()return"JSON array"end}f.__index=f;local g={__tostring=function()return"JSON object"end}g.__index=g;function c:newArray(h)return setmetatable(h or{},f)end;function c:newObject(h)return setmetatable(h or{},g)end;local function i(j)if j<=127 then return string.char(j)elseif j<=2047 then local k=math.floor(j/0x40)local l=j-0x40*k;return string.char(0xC0+k,0x80+l)elseif j<=65535 then local k=math.floor(j/0x1000)local m=j-0x1000*k;local n=math.floor(m/0x40)local l=m-0x40*n;k=0xE0+k;n=0x80+n;l=0x80+l;if k==0xE0 and n<0xA0 or k==0xED and n>0x9F or k==0xF0 and n<0x90 or k==0xF4 and n>0x8F then return"?"else return string.char(k,n,l)end else local k=math.floor(j/0x40000)local m=j-0x40000*k;local o=math.floor(m/0x1000)m=m-0x1000*o;local p=math.floor(m/0x40)local l=m-0x40*p;return string.char(0xF0+k,0x80+o,0x80+p,0x80+l)end end;function c:onDecodeError(q,r,s,t)if r then if s then q=string.format("%s at char %d of: %s",q,s,r)else q=string.format("%s: %s",q,r)end end;if t~=nil then q=q.." ("..c:encode(t)..")"end;if self.assert then self.assert(false,q)else assert(false,q)end end;c.onDecodeOfNilError=c.onDecodeError;c.onDecodeOfHTMLError=c.onDecodeError;function c:onEncodeError(q,t)if t~=nil then q=q.." ("..c:encode(t)..")"end;if self.assert then self.assert(false,q)else assert(false,q)end end;local function u(self,r,v,t)local w=r:match('^-?[1-9]%d*',v)or r:match("^-?0",v)if not w then self:onDecodeError("expected number",r,v,t)end;local x=v+w:len()local y=r:match('^%.%d+',x)or""x=x+y:len()local z=r:match('^[eE][-+]?%d+',x)or""x=x+z:len()local A=w..y..z;local B=tonumber(A)if not B then self:onDecodeError("bad number",r,v,t)end;return B,x end;local function C(self,r,v,t)if r:sub(v,v)~='"'then self:onDecodeError("expected string's opening quote",r,v,t)end;local x=v+1;local D=r:len()local E=""while x<=D do local F=r:sub(x,x)if F=='"'then return E,x+1 end;if F~='\\'then E=E..F;x=x+1 elseif r:match('^\\b',x)then E=E.."\b"x=x+2 elseif r:match('^\\f',x)then E=E.."\f"x=x+2 elseif r:match('^\\n',x)then E=E.."\n"x=x+2 elseif r:match('^\\r',x)then E=E.."\r"x=x+2 elseif r:match('^\\t',x)then E=E.."\t"x=x+2 else local G=r:match('^\\u([0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])',x)if G then x=x+6;local j=tonumber(G,16)if j>=0xD800 and j<=0xDBFF then local H=r:match('^\\u([dD][cdefCDEF][0123456789aAbBcCdDeEfF][0123456789aAbBcCdDeEfF])',x)if H then x=x+6;j=0x2400+(j-0xD800)*0x400+tonumber(H,16)else end end;E=E..i(j)else E=E..r:match('^\\(.)',x)x=x+2 end end end;self:onDecodeError("unclosed string",r,v,t)end;local function I(r,v)local J,K=r:find("^[ \n\r\t]+",v)if K then return K+1 else return v end end;local L;local function M(self,r,v,t)if r:sub(v,v)~='{'then self:onDecodeError("expected '{'",r,v,t)end;local x=I(r,v+1)local E=self.strictTypes and self:newObject{}or{}if r:sub(x,x)=='}'then return E,x+1 end;local D=r:len()while x<=D do local N,O=C(self,r,x,t)x=I(r,O)if r:sub(x,x)~=':'then self:onDecodeError("expected colon",r,x,t)end;x=I(r,x+1)local P,O=L(self,r,x)E[N]=P;x=I(r,O)local F=r:sub(x,x)if F=='}'then return E,x+1 end;if r:sub(x,x)~=','then self:onDecodeError("expected comma or '}'",r,x,t)end;x=I(r,x+1)end;self:onDecodeError("unclosed '{'",r,v,t)end;local function Q(self,r,v,t)if r:sub(v,v)~='['then self:onDecodeError("expected '['",r,v,t)end;local x=I(r,v+1)local E=self.strictTypes and self:newArray{}or{}if r:sub(x,x)==']'then return E,x+1 end;local R=1;local D=r:len()while x<=D do local S,O=L(self,r,x)E[R]=S;R=R+1;x=I(r,O)local F=r:sub(x,x)if F==']'then return E,x+1 end;if r:sub(x,x)~=','then self:onDecodeError("expected comma or '['",r,x,t)end;x=I(r,x+1)end;self:onDecodeError("unclosed '['",r,v,t)end;L=function(self,r,v,t)v=I(r,v)if v>r:len()then self:onDecodeError("unexpected end of string",r,nil,t)end;if r:find('^"',v)then return C(self,r,v,t)elseif r:find('^[-0123456789 ]',v)then return u(self,r,v,t)elseif r:find('^%{',v)then return M(self,r,v,t)elseif r:find('^%[',v)then return Q(self,r,v,t)elseif r:find('^true',v)then return true,v+4 elseif r:find('^false',v)then return false,v+5 elseif r:find('^null',v)then return nil,v+4 else self:onDecodeError("can't parse JSON",r,v,t)end end;function c:decode(r,t)if type(self)~='table'or self.__index~=c then c:onDecodeError("JSON:decode must be called in method format",nil,nil,t)end;if r==nil then self:onDecodeOfNilError(string.format("nil passed to JSON:decode()"),nil,nil,t)elseif type(r)~='string'then self:onDecodeError(string.format("expected string argument to JSON:decode(), got %s",type(r)),nil,nil,t)end;if r:match('^%s*$')then return nil end;if r:match('^%s*<')then self:onDecodeOfHTMLError(string.format("html passed to JSON:decode()"),r,nil,t)end;if r:sub(1,1):byte()==0 or r:len()>=2 and r:sub(2,2):byte()==0 then self:onDecodeError("JSON package groks only UTF-8, sorry",r,nil,t)end;local T,U=pcall(L,self,r,1,t)if T then return U else if self.assert then self.assert(false,U)else assert(false,U)end;return nil,U end end;local function V(F)if F=="\n"then return"\\n"elseif F=="\r"then return"\\r"elseif F=="\t"then return"\\t"elseif F=="\b"then return"\\b"elseif F=="\f"then return"\\f"elseif F=='"'then return'\\"'elseif F=='\\'then return'\\\\'else return string.format("\\u%04x",F:byte())end end;local W='['..'"'..'%\\'..'%z'..'\001'..'-'..'\031'..']'local function X(U)local Y=U:gsub(W,V)return'"'..Y..'"'end;local function Z(self,_,t)local a0={}local a1={}local a2=false;local a3;for N in pairs(_)do if type(N)=='string'then table.insert(a0,N)elseif type(N)=='number'then table.insert(a1,N)if N<=0 or N>=math.huge then a2=true elseif not a3 or N>a3 then a3=N end else self:onEncodeError("can't encode table with a key of type "..type(N),t)end end;if#a0==0 and not a2 then if#a1>0 then return nil,a3 elseif tostring(_)=="JSON array"then return nil elseif tostring(_)=="JSON object"then return{}else return nil end end;table.sort(a0)local a4;if#a1>0 then if self.noKeyConversion then self:onEncodeError("a table with both numeric and string keys could be an object or array; aborting",t)end;a4={}for N,S in pairs(_)do a4[N]=S end;table.sort(a1)for J,a5 in ipairs(a1)do local a6=tostring(a5)if a4[a6]==nil then table.insert(a0,a6)a4[a6]=_[a5]else self:onEncodeError("conflict converting table with mixed-type keys into a JSON object: key "..a5 .." exists both as a string and a number.",t)end end end;return a0,nil,a4 end;local a7;function a7(self,U,a8,t,a9,aa)if U==nil then return'null'elseif type(U)=='string'then return X(U)elseif type(U)=='number'then if U~=U then return"null"elseif U>=math.huge then return"1e+9999"elseif U<=-math.huge then return"-1e+9999"else return tostring(U)end elseif type(U)=='boolean'then return tostring(U)elseif type(U)~='table'then self:onEncodeError("can't convert "..type(U).." to JSON",t)else local _=U;if type(a9)~='table'then a9={}end;if type(aa)~='string'then aa=""end;if a8[_]then self:onEncodeError("table "..tostring(_).." is a child of itself",t)else a8[_]=true end;local ab;local ac,a3,a4=Z(self,_,t)if a3 then local ad={}for x=1,a3 do table.insert(ad,a7(self,_[x],a8,t,a9,aa))end;if a9.pretty then ab="[ "..table.concat(ad,", ").." ]"else ab="["..table.concat(ad,",").."]"end elseif ac then local ae=a4 or _;if a9.pretty then local af={}local ag=0;for J,N in ipairs(ac)do local ah=a7(self,tostring(N),a8,t,a9,aa)if a9.align_keys then ag=math.max(ag,#ah)end;table.insert(af,ah)end;local ai=aa..tostring(a9.indent or"")local aj=ai..string.rep(" ",ag)..(a9.align_keys and"  "or"")local ak="%s%"..string.format("%d",ag).."s: %s"local al={}for x,N in ipairs(ac)do local am=a7(self,ae[N],a8,t,a9,aj)table.insert(al,string.format(ak,ai,af[x],am))end;ab="{\n"..table.concat(al,",\n").."\n"..aa.."}"else local an={}for J,N in ipairs(ac)do local am=a7(self,ae[N],a8,t,a9,aa)local ao=a7(self,tostring(N),a8,t,a9,aa)table.insert(an,string.format("%s:%s",ao,am))end;ab="{"..table.concat(an,",").."}"end else ab="[]"end;a8[_]=false;return ab end end;function c:encode(U,t,a9)if type(self)~='table'or self.__index~=c then c:onEncodeError("JSON:encode must be called in method format",t)end;return a7(self,U,{},t,a9 or nil)end;function c:encode_pretty(U,t,a9)if type(self)~='table'or self.__index~=c then c:onEncodeError("JSON:encode_pretty must be called in method format",t)end;return a7(self,U,{},t,a9 or e)end;function c.__tostring()return"JSON encode/decode package"end;c.__index=c;function c:new(ap)local aq={}if ap then for N,S in pairs(ap)do aq[N]=S end end;return setmetatable(aq,c)end;return c:new()]], "json.lua")()

local function expect(arg, typ, n, optional, level)
	if type(arg) ~= typ and not optional then
		return error(("expected %s, got %s for arg %i"):format(typ, type(arg), n), level or 2)
	elseif type(arg) ~= typ and arg ~= nil and optional then
		return error(("expected %s or nil, got %s for arg %i"):format(typ, type(arg), n), level or 2)
	end
	return arg
end

local function readConfig(name, default)
	expect(name, "string", 1)
	if fs.exists(dirs.config) then
		local f = fs.open(dirs.config, "r")
		local d = json:decode(f.readAll())
		f.close()
		if d[name] ~= nil then
			return d[name]
		else
			return default
		end
	else
		return default
	end
end

local function writeConfig(name, value)
	expect(name, "string", 1)
	local t = type(value)
	if t ~= "string" and t ~= "number" and t ~= "boolean" and t ~= "table" and value ~= nil then
		return error("invalid value")
	end
	local d = {}
	if fs.exists(dirs.config) then
		local f = fs.open(dirs.config, "r")
		local d = json:decode(f.readAll())
		f.close()
	end
	d[name] = value
	local f = fs.open(dirs.config, "w")
	f.write(json:encode_pretty(d))
	f.close()
end

local function writeFile(data, file)
	expect(data, "string", 1)
	expect(file, "string", 2)

	local f = fs.open(file, "w")
	if not f then return false, "failed to open file" end
	f.write(data)
	f.close()

	return true
end

local function readFile(file)
	expect(file, "string", 1)

	if not fs.exists(file) then return false, "file does not exist" end
	local f = fs.open(file, "r")
	if not f then return false, "failed to open file" end
	local data = f.readAll()
	f.close()
	return data
end

local phandlers = {}

do -- protocol handlers
	function phandlers.http(path)
		return http.get("http://" .. path)
	end
	
	function phandlers.https(path)
		return http.get("https://" .. path)
	end

	function phandlers.pastebin(path)
		return http.get("http://pastebin.com/raw/" .. path)
	end

	function phandlers.file(path)
		return fs.open(path, "r")
	end

	-- todo - gist, github, grin(?), gitlab(?)
end

local function handle(link)
	local protocol, path = link:match("^(%w+)://(%C+)$")
	if protocol and path then
		protocol = protocol:lower()
		if phandlers[protocol] then
			return phandlers[protocol](path)
		else
			return false, "no handler for protocol " .. protocol
		end
	else
		return false, "invalid uri"
	end
end

local function download(link, file)
	expect(link, "string", 1)
	expect(file, "string", 2, true)

	local h, err = handle(link)
	if not h then return false, err or "no handle received" end
	local d = h.readAll()
	h.close()
	if file then
		local ok, e = writeFile(d, file)
		if not ok then return false, e end
	end

	return true, d
end

local defaultRepos = {
	"https://raw.githubusercontent.com/apemanzilla-cc/bench/master/repos/main.json"
}

local function getRepos()
	return readConfig("repos", defaultRepos)
end

local function loadRepos()
	if fs.exists(dirs.repos) then
		local repos = json:decode(readFile(dirs.repos))
		for k, v in pairs(repos) do
			for i, pkg in ipairs(v.packages) do
				pkg.qname = v.name .. "/" .. pkg.name
			end
		end
		return repos
	else
		return {}
	end
end

local function loadRepo(name)
	expect(name, "string", 1)

	for link, repo in pairs(loadRepos()) do
		if repo.name == name then
			for i, v in ipairs(repo.packages) do
				v.qname = repo.name .. "/" .. v.name
			end
			return repo
		end
	end
end

local repoFormat = {
	name = "string",
	description = "string",
	packages = "table"
}

local packageFormat = {
	name = "string",
	description = "string",
	version = "number"
}

local packageOptional = {
	download = "table",
	depends = "table",
	launch = "string",
	install_location = "string",
	tags = "table"
}

local function validatePackage(data)
	expect(data, "table", 1)

	for k, v in pairs(packageFormat) do
		if type(data[k]) ~= v then
			return false, "invalid property '" .. k .. "' in package " .. (data.name or "<unknown>")
		end
	end

	for k, v in pairs(data) do
		if not (packageFormat[k] or packageOptional[k]) then
			return false, "unexpected property '" .. k .. "' in package " .. (data.name or "<unknown>")
		elseif packageOptional[k] then
			if type(v) ~= packageOptional[k] then
				return false, "invalid property '" .. k .. "' in package " .. (data.name or "<unknown>")
			end
		end
	end
	return true, ""
end

local function validateRepo(data)
	expect(data, "table", 1)

	for k, v in pairs(repoFormat) do
		if type(data[k]) ~= v then
			return false, "invalid property '" .. k .. "' in repo " .. (data.name or "<unknown>")
		end
	end
	for k, v in pairs(data.packages) do
		local ok, err = validatePackage(v)
		if not ok then return false, err end
	end
	return true, ""
end

local function resolvePackage(name)
	expect(name, "string", 1)

	local repo, pkg = name:match("([%w%d-_]+)/([%w%d-_]+)")
	if not repo then
		pkg = name
	end
	if repo then
		local data = loadRepo(repo)
		if not data then return false, "repo '" .. repo .. "' not present" end
		for i, v in ipairs(data.packages) do
			if v.name == pkg then
				return v, ""
			end
		end
		return false, "no matches for " .. name
	else
		local matches = {}
		local qnames = {}
		local repos = loadRepos()
		for k, repo in pairs(repos) do
			for i, pk in ipairs(repo.packages) do
				if pk.name == pkg then
					table.insert(matches, pk)
					table.insert(qnames, pk.qname)
				end
			end
		end
		if #matches == 0 then
			return false, "no matches for " .. name
		elseif #matches == 1 then
			return table.remove(matches, 1), ""
		else
			return false, "multiple matches: " .. table.concat(qnames, ", ")
		end
	end
end

local actions = {}

local action_mt = {}
action_mt.critical = false
action_mt.verbose = false

function actions.new(name)
	expect(name, "string", 1)
	return setmetatable({name=name}, {__index = action_mt})
end

function action_mt:assert(ok, msg)
	if not ok then
		if self.critical then
			error(msg, 0)
		else
			printError(msg)
			return false
		end
	end
	return true
end

function action_mt:log(msg)
	if self.verbose then
		print(msg)
	end
end

function action_mt:run() end

-- fetchs all repos
function actions.fetch(repos)
	expect(repos, "table", 1, true)
	local action = actions.new("fetch")
	action.repos = repos

	function action:run()
		local repos = self.repos or getRepos()
		local fetched = {}
		for i, link in ipairs(repos) do
			local ok, out = download(link)
			self:assert(ok, "failed to fetch repo from " .. link)
			local repo = json:decode(out)
			repo.link = link
			local valid, err = validateRepo(repo)
			self:assert(valid, "repo " .. (repo.name or ("at " .. link)) .. " is invalid: " .. err)
			if ok and valid then
				table.insert(fetched, repo)
				self:log("fetched repo " .. repo.name)
			end
		end

		if self:assert(writeFile(json:encode_pretty(fetched), dirs.repos)) then
			self:log("fetch complete")
		end
	end

	return action
end

function actions.addRepo(link)
	expect(link, "string", 1)

	local action = actions.new("addrepo")
	action.link = link

	function action:run()
		local repos = getRepos()

		for i, v in ipairs(repos) do
			if not self:assert(v ~= self.link, "repo already present") then
				return
			end
		end
		local ok, out = download(self.link)
		self:assert(ok, out)
		local repo = json:decode(out)
		local valid, err = validateRepo(repo)
		self:assert(valid, err)
		if not self:assert(not loadRepo(repo.name), "repo with name " .. repo.name .. " already present") then return end
		if valid and ok then
			table.insert(repos, self.link)
			local fetch = actions.fetch(repos)
			fetch.critical = self.critical
			fetch.verbose = false
			self:assert(pcall(fetch.run, fetch))
			self:log("added repo " .. repo.name)
			writeConfig("repos", repos)
		end
	end

	return action
end

function actions.removeRepo(name)
	expect(name, "string", 1)

	local action = actions.new("removerepo")
	action.name = name

	function action:run()
		local repos = loadRepos()
		local link
		for i, v in ipairs(repos) do
			if v.name == self.name then
				link = v.link
				break
			end
		end
		if self:assert(link, "repo " .. name .. " not present") then
			local links = getRepos()
			for i, v in ipairs(links) do
				if v == link then
					table.remove(links, i)
				end
			end
			writeConfig("repos", links)

			local fetch = actions.fetch()
			fetch.critical = self.critical
			fetch.verbose = false
			fetch:run()

			self:log("removed repo " .. self.name)
		end
	end

	return action
end

-- parse args
local args = {...}

if #args > 0 then
	local actionQueue = {}
	local subcmd = nil
	local arg = table.remove(args, 1)

	while arg do
		if arg:lower() == "fetch" then
			local fetch = actions.fetch()
			fetch.critical = true
			fetch.verbose = true
			table.insert(actionQueue, fetch)
		elseif arg:lower() == "addrepo" then
			subcmd = "addrepo"
		elseif arg:lower() == "removerepo" then
			subcmd = "removerepo"
		elseif subcmd then
			if subcmd == "addrepo" then
				local add = actions.addRepo(arg)
				add.critical = true
				add.verbose = true
				table.insert(actionQueue, add)
				subcmd = nil
			elseif subcmd == "removerepo" then
				local remove = actions.removeRepo(arg)
				remove.critical = true
				remove.verbose = true
				table.insert(actionQueue, remove)
				subcmd = nil
			end
		else
			error("expected subcommand, got '" .. arg .. "'", 0)
		end
		arg = table.remove(args, 1)
	end

	for i, v in ipairs(actionQueue) do
		v:run()
	end
else
	-- usage
	print("TODO put cli usage here")
end