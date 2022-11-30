im = imread("Test.png");
pattern = imread("pattern.png");
im2 = imread("Test2.jpeg");
depthBruh = edgeDetect(im2);
%imshow(depthBruh);
%figure; imshow(im2);
newPattern = compress(im, im2);
%figure; imshow(newPattern);
%stretch(im, im2);
letters = [0 1 1 0; 1 0 0 1 ; 1 1 1 1; 1 0 0 1; 1 0 0 1];
letters(:,:,2) = [1 1 1 0; 1 0 0 1; 1 1 1 0; 1 0 0 1; 1 1 1 0;]; %B
letters(:,:,3) = [0 1 1 1; 1 0 0 0; 1 0 0 0; 1 0 0 0; 0 1 1 1;]; %C
letters(:,:,4) = [1 1 1 0; 1 0 0 1; 1 0 0 1; 1 0 0 1; 1 1 1 0;]; %D
letters(:,:,5) = [1 1 1 1; 1 0 0 0; 1 1 1 1; 1 0 0 0; 1 1 1 1;]; %E
letters(:,:,6) = [1 1 1 1; 1 0 0 0; 1 1 1 1; 1 0 0 0; 1 0 0 0;]; %F
letters(:,:,7) = [0 1 1 1; 1 0 0 0; 1 0 1 1; 1 0 0 1; 0 1 1 1;]; %G
letters(:,:,8) = [1 0 0 1; 1 0 0 1; 1 1 1 1; 1 0 0 1; 1 0 0 1;]; %H
letters(:,:,9) = [1 1 1 1; 0 1 1 0; 0 1 1 0; 0 1 1 0; 1 1 1 1;]; %I
letters(:,:,10) = [1 1 1 1; 0 0 1 0; 0 0 1 0; 1 0 1 0; 0 1 0 0;]; %J
letters(:,:,11) = [1 0 0 1; 1 0 1 0; 1 1 0 0; 1 0 1 0; 1 0 0 1;]; %K
letters(:,:,12) = [1 0 0 0; 1 0 0 0; 1 0 0 0; 1 0 0 0; 1 1 1 0;]; %L
letters(:,:,13) = [1 0 0 1; 1 0 1 0; 1 1 0 0; 1 0 1 0; 1 0 0 1;]; %M ~
letters(:,:,14) = [1 0 0 1; 1 1 0 1; 1 0 1 1; 1 0 0 1; 1 0 0 1;]; %N
letters(:,:,15) = [0 1 1 0; 1 0 0 1; 1 0 0 1; 1 0 0 1; 0 1 1 0;]; %O
letters(:,:,16) = [1 1 1 0; 1 0 0 1; 1 1 1 0; 1 0 0 0; 1 0 0 0;]; %P
letters(:,:,17) = [1 1 1 1; 1 0 0 1; 1 1 1 1; 1 0 0 0; 1 0 0 0;]; %Q ~
letters(:,:,18) = [1 1 1 0; 1 0 0 1; 1 1 1 0; 1 0 1 0; 1 0 0 1;]; %R
letters(:,:,19) = [1 1 1 1; 1 0 0 0; 1 1 1 1; 0 0 0 1; 1 1 1 1;]; %S
letters(:,:,20) = [1 1 1 1; 0 1 1 0; 0 1 1 0; 0 1 1 0; 0 1 1 0;]; %T
letters(:,:,21) = [0 0 0 0; 1 0 0 1; 1 0 0 1; 1 0 0 1; 0 1 1 0;]; %U
letters(:,:,22) = [1 1 1 1; 1 0 0 1; 1 1 1 1; 1 0 0 0; 1 0 0 0;]; %V ~
letters(:,:,23) = [1 1 1 1; 1 0 0 1; 1 1 1 1; 1 0 0 0; 1 0 0 0;]; %W ~
letters(:,:,24) = [1 1 1 1; 1 0 0 1; 1 1 1 1; 1 0 0 0; 1 0 0 0;]; %X ~
letters(:,:,25) = [1 1 1 1; 1 0 0 1; 1 1 1 1; 1 0 0 0; 1 0 0 0;]; %Y ~
letters(:,:,26) = [1 1 1 1; 0 0 1 0; 0 1 0 0; 1 0 0 0; 1 1 1 1;]; %Z
letter = letters(:,:,7);
imshow(enlarge(letter,50))

function largeLetter = enlarge(letter, mult)
    largeLetter = zeros(mult*size(letter,1), mult*size(letter,2));
    for i = 1:size(letter,1)
        for j = 1:size(letter,2)
            largeLetter((i-1)*mult+1:i*mult,(j-1)*mult+1:j*mult) = letter(i,j);
        end
    end
    largeLetter = imfilter(largeLetter,fspecial('gaussian',10,10));
end
%function depthMap = outline(im)
function depthMap = edgeDetect(im)
    grayIm = im2gray(im);
    blurred = imfilter(grayIm,fspecial('gaussian',20,10));
    gradY = double(imfilter(blurred,fspecial('sobel')));
    gradX = double(imfilter(blurred,fspecial('sobel').'));

    magnitude = sqrt(gradY.^2 + gradX.^2);
    threshold = prctile(magnitude,97,"all");

    edges = double(magnitude > threshold);
    depthMap = edges;
    
end
%function pattern = stretch(depthMap, pattern)
function pattern = compress(depthMap, im)
    width = size(depthMap,2);
    im_height = size(im,1);
    im_width = size(im,2);
    pattern_width = floor(width/6);
    pattern = zeros(im_height,pattern_width,3);
    compressAmt = floor(im_width/pattern_width);
    for i = 1:pattern_width
        pattern(:,i,:) = im(:,i*compressAmt,:);
    end
    pattern = pattern/256;
end

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
