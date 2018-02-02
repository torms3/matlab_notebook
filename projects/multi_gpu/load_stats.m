function [stats] = load_stats( fname, phase, keys )

    assert(strcmp(phase,'train')||strcmp(phase,'test'));

    len = [];
    for i = 1:numel(keys)
        key = keys{i};
        val = hdf5read(fname,['/' phase '/' key]);
        stats.(key) = val(:);
        len(i) = numel(val);
    end

    n = min(len);
    fields = fieldnames(stats);
    for i = 1:numel(fields)
        stats.(fields{i})(1:end-n) = [];
    end

end
