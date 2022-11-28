im = imread("Test.png");
pattern = imread("pattern.png");
depthBruh = edgeDetect(im);

%function depthMap = outline(im)
function depthMap = edgeDetect(im)
    grayIm = im2gray(im);
    blurred = imfilter(grayIm,fspecial('gaussian',6,1));
    gradY = double(imfilter(blurred,fspecial('sobel')));
    gradX = double(imfilter(blurred,fspecial('sobel').'));

    magnitude = sqrt(gradY.^2 + gradX.^2);
    threshold = prctile(magnitude,90,"all");

    edges = double(magnitude > threshold)
    depthMap = edges;
    
end
%function pattern = stretch(depthMap, pattern)
%function fullPattern = patternCast(depthMap, pattern)
function fullPattern = patternCast(depthMap, pattern)
    height, width = size(depthMap);
    patH, patW = size(pattern);
    fullPattern = zeros(height,width);
    for i=1:height
        for j=1:width
            iMod = mod(i,patH) + 1;
            jMod = mod(j,patW) + 1;
            fullPattern(i,j) = pattern (iMod, jMod);
        end
    end    
end
%function autoGram = stereogram(depthMap, fullPattern)
function autoGram = stereogram(depthMap, fullPattern, shiftMult)
    depthNorm = depthMap ./ max(depthMap(:));
    height,width = size(depthMap);
    autoGram = fullPattern;
     for i=1:height
        for j=1:width
            iShift = i + (depthNorm(i,j) * shiftMult);
            autoGram(i,j) = fullPattern(iShift,j);
        end
    end    
end
%function animated = animate(fullPattern, autoGram)
function animated = animate(fullPattern,autoGram)
    filename = "testAnimated.gif"; % Specify the output file name
    [A1,map1] = rgb2ind(fullPattern,256);
    [A2,map2] = rgb2ind(autoGram,256);
    imwrite(A1,map1,filname,"gif","LoopCount",Inf,"DelayTime",0.1);
    imwrite(A2,map2,filename,"gif","WriteMode","append","DelayTime",0.1);
end

function repeated = repeatIm(pattern,repVal)
    repeated = uint8(zeros(size(pattern,1),repVal*size(pattern,2),size(pattern,3)));
    for i = 1:repVal
        repeated(:,(i-1)*size(pattern,2)+1:i*size(pattern,2),:) = im2double(pattern);
    end
end
