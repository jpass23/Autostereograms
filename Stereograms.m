
pattern = uint8(imread("pattern.png"));
pattern2 = im2gray(imread("pattern.png"));
map = uint8(imread("Test.png"));

repeat = 256*repeatIm(pattern2,6);
gram = stereogram(map, pattern, 20); 
figure; imshow(repeat);
figure; imshow(gram);

%function depthMap = outline(im)
%function pattern = stretch(depthMap, pattern)
%function fullPattern = patternCast(depthMap, pattern)
%function autoGram = stereogram(depthMap, fullPattern)
%function animated = animate(fullPattern, autoGram)

function autoGram = stereogram(depthMap, pattern, shamt)
    depthMap = depthMap ./ max(depthMap(:)); %Normalize array
    height = size(pattern,1);
    width = size(pattern,2);
    
    autoGram = zeros(size(depthMap),'like',depthMap);
    for i = 1:size(autoGram,1)
        for j = 1:size(autoGram,2)  
            if j < width
                autoGram(i,j) = pattern(mod(i,height)+1,j);
            else
                shift = typecast(depthMap(i,j) * shamt, 'uint8') + 1;
                %disp(shift);
                autoGram(i,j) = pattern(mod(i,height)+1, mod(j,width)+shift);
            end
        end
    end
end

% function autoGram = stereogram(pattern,depthMap,shamt)
%     pattern = im2gray(pattern);
%     depthMap = depthMap ./ max(depthMap(:));
%     autoGram = repeatIm(pattern,6);
%     autoGram = 256*imtranslate(autoGram, [shamt, 0]);
%     %autoGram = 256*((shifted .* depthMap) + (autoGram .* (1-depthMap)));
% end
% 
function repeated = repeatIm(pattern,repVal)
    repeated = uint8(zeros(size(pattern,1),repVal*size(pattern,2),size(pattern,3)));
    for i = 1:repVal
        repeated(:,(i-1)*size(pattern,2)+1:i*size(pattern,2),:) = im2double(pattern);
    end
end
