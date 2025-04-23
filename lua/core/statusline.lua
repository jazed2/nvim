local slComponent = {} -- statusline components
local hi_pattern = "%%#%s#%s%%*"

function _G._statusline_component(name)
	return slComponent[name]()
end

function slComponent.diagnosticStatus()
	local diagnosis = " ✔ "
	local diagnosticSeverity = vim.diagnostic.severity

	local errors = #vim.diagnostic.get(0, { severity = diagnosticSeverity.ERROR })
	if errors > 0 then
		diagnosis = " E:" .. errors .. " "
	end

	local warnings = #vim.diagnostic.get(0, { severity = diagnosticSeverity.WARN })
	if warnings > 0 then
		diagnosis = " W:" .. warnings .. " "
	end

	return hi_pattern:format("Search", diagnosis)
end

function slComponent.position()
	return hi_pattern:format("Search", " %3l:%-2c [%L] ")
end

function slComponent.getLspServer()
	local bufnr = vim.api.nvim_get_current_buf()
	local lspClients = vim.lsp.get_clients({ bufnr })

	if next(lspClients) == nil then
		return ""
	end

	local names = {}
	for _, client in pairs(lspClients) do
		table.insert(names, client.name)
	end
	return "  [" .. table.concat(names, " | ") .. "]"
end

function slComponent.gitBranch()
	local printBranch

	local branch = vim.fn.system("git branch --show-current 2&> /dev/null")
	if branch ~= "" then
		printBranch = " " .. branch:gsub("%s+$", "")
	else
		printBranch = ""
	end

	return printBranch
end

function slComponent.vcsStatus()
	local git_info = vim.b.gitsigns_status_dict
	if not git_info or git_info.head == "" then
		return ""
	end
	local added = git_info.added and ("+" .. git_info.added .. " ") or ""
	local changed = git_info.changed and ("~" .. git_info.changed .. " ") or ""
	local removed = git_info.removed and ("-" .. git_info.removed .. " ") or ""
	if git_info.added == 0 then
		added = ""
	end
	if git_info.changed == 0 then
		changed = ""
	end
	if git_info.removed == 0 then
		removed = ""
	end

	return table.concat({
		added,
		changed,
		removed,
		" ",
		"%#Normal#",
	})
end

local statusline = {
	'%{%v:lua._statusline_component("diagnosticStatus")%} ',
	' %{%v:lua._statusline_component("gitBranch")%} ',
	' %{%v:lua._statusline_component("vcsStatus")%} ',
	"%=",
	"%F",
	"%r",
	"%m",
	"%=",
	' %{%v:lua._statusline_component("getLspServer")%} ',
	'%{%v:lua._statusline_component("position")%} ',
	" %2p%% ",
}

vim.o.statusline = table.concat(statusline, "")
