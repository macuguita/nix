local M = {}

function M.align_to_char()
    -- Capture current visual selection BEFORE doing anything else
    local start_pos = vim.fn.getpos("v")  -- Start of current visual selection
    local end_pos = vim.fn.getpos(".")    -- End of current visual selection (cursor)

    -- Ask user for delimiter (this will automatically exit visual mode)
    local char = vim.fn.input("Align to char: ")
    if char == "" then return end

    -- Validate positions
    if not start_pos or not end_pos or start_pos[2] == 0 or end_pos[2] == 0 then
        print("Invalid selection")
        return
    end

    local ls = math.min(start_pos[2], end_pos[2])
    local le = math.max(start_pos[2], end_pos[2])

    -- Ensure proper line range
    if ls > le then
        ls, le = le, ls
    end

    local lines = vim.api.nvim_buf_get_lines(0, ls-1, le, false)

    -- Check if we have any lines to process
    if #lines == 0 then
        print("No lines selected")
        return
    end

    -- Process lines differently: keep full line content, find delimiter positions
    local line_data = {}
    local has_delimiter = false
    local max_pre_delimiter_width = 0

    for _, line in ipairs(lines) do
        local delimiter_pos = line:find(char, 1, true)

        if delimiter_pos then
            has_delimiter = true
            local before_delimiter = line:sub(1, delimiter_pos - 1)
            local after_delimiter = line:sub(delimiter_pos + #char)

            -- Trim trailing spaces from before_delimiter, but keep leading spaces
            before_delimiter = before_delimiter:gsub("%s+$", "")
            -- Trim leading spaces from after_delimiter
            after_delimiter = after_delimiter:gsub("^%s+", "")

            local display_width = vim.fn.strdisplaywidth(before_delimiter)
            max_pre_delimiter_width = math.max(max_pre_delimiter_width, display_width)

            table.insert(line_data, {
                before = before_delimiter,
                after = after_delimiter,
                has_delimiter = true
            })
        else
            -- Line without delimiter - keep as is
            table.insert(line_data, {
                full_line = line,
                has_delimiter = false
            })
        end
    end

    -- If no delimiter found, inform user
    if not has_delimiter then
        print("Delimiter '" .. char .. "' not found in selection")
        return
    end

    -- Rebuild aligned lines
    local new_lines = {}
    for _, data in ipairs(line_data) do
        if data.has_delimiter then
            local padding_needed = max_pre_delimiter_width - vim.fn.strdisplaywidth(data.before)
            local padding = string.rep(" ", math.max(0, padding_needed))
            local new_line = data.before .. padding .. " " .. char .. " " .. data.after
            table.insert(new_lines, new_line)
        else
            -- Line without delimiter stays unchanged
            table.insert(new_lines, data.full_line)
        end
    end

    -- Replace selection and restore cursor position
    local cursor_pos = vim.fn.getpos(".")
    vim.api.nvim_buf_set_lines(0, ls-1, le, false, new_lines)

    -- Try to restore a reasonable cursor position
    if cursor_pos[2] >= ls and cursor_pos[2] <= le then
        vim.fn.setpos(".", cursor_pos)
    end

    print("Aligned " .. #lines .. " lines to '" .. char .. "'")
end

-- Alternative function that works with range commands
function M.align_to_char_range(line1, line2, char)
    char = char or vim.fn.input("Align to char: ")
    if char == "" then return end

    local lines = vim.api.nvim_buf_get_lines(0, line1-1, line2, false)

    if #lines == 0 then
        print("No lines in range")
        return
    end

    -- Same processing logic as above
    local line_data = {}
    local has_delimiter = false
    local max_pre_delimiter_width = 0

    for _, line in ipairs(lines) do
        local delimiter_pos = line:find(char, 1, true)

        if delimiter_pos then
            has_delimiter = true
            local before_delimiter = line:sub(1, delimiter_pos - 1)
            local after_delimiter = line:sub(delimiter_pos + #char)

            -- Trim trailing spaces from before_delimiter, but keep leading spaces
            before_delimiter = before_delimiter:gsub("%s+$", "")
            -- Trim leading spaces from after_delimiter
            after_delimiter = after_delimiter:gsub("^%s+", "")

            local display_width = vim.fn.strdisplaywidth(before_delimiter)
            max_pre_delimiter_width = math.max(max_pre_delimiter_width, display_width)

            table.insert(line_data, {
                before = before_delimiter,
                after = after_delimiter,
                has_delimiter = true
            })
        else
            -- Line without delimiter - keep as is
            table.insert(line_data, {
                full_line = line,
                has_delimiter = false
            })
        end
    end

    if not has_delimiter then
        print("Delimiter '" .. char .. "' not found in range")
        return
    end

    local new_lines = {}
    for _, data in ipairs(line_data) do
        if data.has_delimiter then
            local padding_needed = max_pre_delimiter_width - vim.fn.strdisplaywidth(data.before)
            local padding = string.rep(" ", math.max(0, padding_needed))
            local new_line = data.before .. padding .. " " .. char .. " " .. data.after
            table.insert(new_lines, new_line)
        else
            -- Line without delimiter stays unchanged
            table.insert(new_lines, data.full_line)
        end
    end

    vim.api.nvim_buf_set_lines(0, line1-1, line2, false, new_lines)
    print("Aligned " .. #lines .. " lines to '" .. char .. "'")
end

-- Direct approach that captures selection immediately
function M.align_to_char_direct()
    -- Get the current visual selection bounds
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    -- Ask user for delimiter
    local char = vim.fn.input("Align to char: ")
    if char == "" then return end

    -- Use the range-based function
    M.align_to_char_range(start_line, end_line, char)
end

function M.pack_clean()
    local active_plugins = {}
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        active_plugins[plugin.spec.name] = plugin.active
    end

    for _, plugin in ipairs(vim.pack.get()) do
        if not active_plugins[plugin.spec.name] then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        print("No unused plugins.")
        return
    end

    local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
    end
end

function M.sort_by_dirs_custom(left, right)
    left = left.component.fs_t
    right = right.component.fs_t

    -- Check if both are directories or both are files
    local left_is_dir = left.filetype == "directory"
    local right_is_dir = right.filetype == "directory"

    -- If one is directory and the other isn't, directory comes first
    if left_is_dir and not right_is_dir then
        return true
    elseif not left_is_dir and right_is_dir then
        return false
    end

    -- If both are directories or both are files, sort alphabetically
    return left.filename:lower() < right.filename:lower()
end

return M

