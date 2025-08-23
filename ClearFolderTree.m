function ClearFolderTree(folder)

% Get everything except '.' and '..'
entries = dir(folder);
entries = entries(~ismember({entries.name}, {'.','..'}));

for k = 1:numel(entries)
    target = fullfile(folder, entries(k).name);
    if entries(k).isdir
        rmdir(target, 's');   % remove subfolder recursively
    else
        delete(target);       % remove file
    end
end

end