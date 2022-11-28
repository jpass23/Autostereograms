im = imread("squirrel.jpeg");
pattern = imread("pattern2.jpeg");
depthBruh = edgeDetect(im2);
fullPattern = patternCast(im,pattern);
gram = stereogram(im,fullPattern,20);
figure(3);imshow(fullPattern)
figure(4);imshow(gram)
animate(fullPattern,gram);



%function depthMap = outline(im)
function depthMap = edgeDetect(im)
    grayIm = im2gray(im);
    blurred = imfilter(grayIm,fspecial('gaussian',20,10));
    gradY = double(imfilter(blurred,fspecial('sobel')));
    gradX = double(imfilter(blurred,fspecial('sobel').'));

    magnitude = sqrt(gradY.^2 + gradX.^2);
    threshold = prctile(magnitude,90,"all");

    edges = double(magnitude > threshold);
    depthMap = edges;
    
end
%function pattern = stretch(depthMap, pattern)
%function fullPattern = patternCast(depthMap, pattern)
function fullPattern = patternCast(depthMap, pattern)
    height = size(depthMap,1);
    width = size(depthMap,2);
    patH = size(pattern,1);
    patW = size(pattern,2);
    fullPattern = zeros(height,width,3);
    for i=1:height
        for j=1:width
            iMod = mod(i,patH) + 1;
            jMod = mod(j,patW) + 1;
            fullPattern(i,j,:) = pattern(iMod, jMod,:);
        end
    end
    fullPattern = imfilter(fullPattern,fspecial("gaussian",6,1));
    fullPattern = uint8(fullPattern);
end
%function autoGram = stereogram(depthMap, fullPattern)
function autoGram = stereogram(depthMap, fullPattern, shiftMult)
    depthNorm = double(im2gray(depthMap));
    depthNorm = depthNorm ./ max(depthNorm(:));
    height = size(depthMap,1);
    width = size(depthMap,2);
    autoGram = fullPattern;
     for i=1:height
        for j=1:width
            jShift = j + floor(depthNorm(i,j) * shiftMult);
            autoGram(i,j,:) = fullPattern(i,jShift,:);
        end
     end
    autoGram = imfilter(autoGram,fspecial("gaussian",3,1));
end
%function animated = animate(fullPattern, autoGram)
function animate(fullPattern,autoGram)
    filename = "testAnimated.gif"; % Specify the output file name
    [A1,map1] = rgb2ind(fullPattern,256);
    [A2,map2] = rgb2ind(autoGram,256);
    imwrite(A1,map1,filename,"gif","LoopCount",Inf,"DelayTime",0.1);
    imwrite(A2,map2,filename,"gif","WriteMode","append","DelayTime",0.1);

end
