function zeroCrossings = zci(v)
% ZEROCROSSINGS finds the indecies where a vector crosses zero.
    zeroCrossings = find(v(:).*circshift(v(:), [-1 0]) <= 0); % Returns Zero-Crossing Indices Of Argument Vector
end
        