im = imread("squirrel.jpeg");
pattern = imread("pattern2.jpeg");
im2 = imread("face.jpeg");
letterPics = {'A.jpeg', 'B.jpeg', 'C.jpeg', 'D.jpeg', 'E.jpeg', 'F.jpeg'...
    'G.jpeg', 'H.jpeg', 'I.jpeg', 'J.jpeg', 'K.jpeg', 'L.jpeg', 'M.jpeg'...
    'N.jpeg', 'O.jpeg', 'P.jpeg', 'Q.jpeg', 'R.jpeg', 'S.jpeg', 'T.jpeg'...
    'U.jpeg', 'V.jpeg', 'X.jpeg', 'Y.jpeg', 'Z.jpeg'};

word = {'J', 'A', 'D', 'E', 'N'};
s = 5;
temp = letterPics{1}
wordPattern = imread("wordPattern.jpeg");
figure(1); imshow(wordPattern);
wordDepthMap = makeWordDepthMap(letterPics,word,s);
figure(2); imshow(wordDepthMap);
wordFullPattern = patternCast(wordDepthMap,wordPattern);
wordGram = stereogram(wordDepthMap,wordFullPattern,10);
animate(wordFullPattern,wordGram,"wordGif.gif");


%figure; imshow(im2);
%newPattern = compress(im, im2, 10);

%figure(1); imshow(newPattern)
%fullPattern = patternCast(im, newPattern);

%figure(1); imshow(fullPattern)
%gram = stereogram(im,fullPattern,15);

%figure(2); imshow(gram)
%animate(fullPattern,gram);





function depthMap = makeWordDepthMap(letterPics, word,s) 
    alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
    indexArray = contains(alphabet,word{1});
    letterFilename = letterPics(indexArray)
    name = letterFilename{1}
    depthMap = imread(name);
    for i = 1:s-1
        letter = word{i};
        indexArray2 = contains(alphabet,letter);
        letterIm = imread(letterPics(indexArray2));
        %depthMap = imfuse(depthMap,letterIm,'montage');
        depthMap = cat(2,depthMap,letterIm);

    end
  
end

function index = findIndex(A,letter)
    index = 1;
    for i=1:size(A)
        if A(i) == letter
            index = i;
        end
    end
end

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
    threshold = prctile(magnitude,90,"all");

    edges = double(magnitude > threshold);
    depthMap = edges;
    
end
%function pattern = stretch(depthMap, pattern)
function pattern = compress(depthMap, im, numRepeats)
    width = size(depthMap,2);
    im_height = size(im,1);
    im_width = size(im,2);
    pattern_width = floor(width/numRepeats);
    pattern = zeros(im_height,pattern_width,3);
    compressAmt = floor(im_width/pattern_width);
    for i = 1:pattern_width
        pattern(:,i,:) = im(:,i*compressAmt,:);
    end
    pattern = pattern/256;
end

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
    fullPattern = imgaussfilt(fullPattern,5);

    %Might need to uncomment this in some cases for bad pictures
    %fullPattern = uint8(fullPattern);
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
    autoGram = imgaussfilt(autoGram,2);
end
%function animated = animate(fullPattern, autoGram)
function animate(fullPattern,autoGram,filename)
    [A1,map1] = rgb2ind(fullPattern,256);
    [A2,map2] = rgb2ind(autoGram,256);
    imwrite(A1,map1,filename,"gif","LoopCount",Inf,"DelayTime",0.1);
    imwrite(A2,map2,filename,"gif","WriteMode","append","DelayTime",0.1);

end
