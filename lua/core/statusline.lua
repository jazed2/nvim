local M = {}

local SlComponent = {} -- statusline components

local hiPattern = "%%#%s#%s%%*" -- ergonomics
-- hiPatterns usage:
-- hiPattern:format("highlight-group", "text") or hiPattern.format(hiPattern,"highlight-group", "text")
-- example: hiPattern:format("Search", "text")
-- for highlight groups, see :h highlight-groups or :Telescope highlights

function _G._statusline_component(name)
	return SlComponent[name]()
end

function SlComponent.diagnosticStatus()
	local diagnosis = " ✔ "
	local diagnosticSeverity = vim.diagnostic.severity

	local errors = #vim.diagnostic.get(0, { severity = diagnosticSeverity.ERROR })
	if errors > 0 then
		diagnosis = "%%#Error#%E:" .. errors .. "%* "
	end

	local warnings = #vim.diagnostic.get(0, { severity = diagnosticSeverity.WARN })
	if warnings > 0 then
		diagnosis = " W:" .. warnings .. " "
	end

	return hiPattern:format("Search", diagnosis)
end

function SlComponent.vcsInfo()
	local branch = vim.fn.system("git branch --show-current 2&> /dev/null")
	local fileInfo = vim.b.gitsigns_status_dict

	if branch ~= "" then -- print branch name
		branch = " " .. branch:gsub("%s+$", "")
	else
		branch = ""
	end

	if not fileInfo or fileInfo.head == "" then
		return ""
	end

	local added = fileInfo.added and ("+" .. fileInfo.added .. " ") or ""
	local changed = fileInfo.changed and ("~" .. fileInfo.changed .. " ") or ""
	local removed = fileInfo.removed and ("-" .. fileInfo.removed .. " ") or ""

	if fileInfo.added == 0 then
		added = ""
	end
	if fileInfo.changed == 0 then
		changed = ""
	end
	if fileInfo.removed == 0 then
		removed = ""
	end

	return table.concat({
		branch,
		" ",
		added,
		changed,
		removed,
		" ",
	})
end

function SlComponent.lspNames()
	local bufnr = vim.api.nvim_get_current_buf()
	local lspClients = vim.lsp.get_clients({ bufnr })
	local lspNames = ""

	if not next(lspClients) then
		return ""
	end

	local names = {}
	for _, client in pairs(lspClients) do
		table.insert(names, client.name)
	end
	lspNames = table.concat(names, " | ")

	-- return hiPattern:format("SlComponent_lspName", lspNames)
	return lspNames
end

function SlComponent.position()
	return hiPattern:format("Search", " %3l:%-2c [%L] ")
end

local statusline = {
	'%{%v:lua._statusline_component("diagnosticStatus")%} ',
	' %{%v:lua._statusline_component("vcsInfo")%} ',
	"%=",
	"%F",
	"%r",
	"%m",
	"%=",
	' %{%v:lua._statusline_component("lspNames")%} ',
	'%{%v:lua._statusline_component("position")%} ',
	" %2p%% ",
}

vim.o.statusline = table.concat(statusline, "")

return M
