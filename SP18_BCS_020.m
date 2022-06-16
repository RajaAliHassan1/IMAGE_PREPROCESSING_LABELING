function  SP18_BCS_020()



%%READING IMAGES FROM RESPECTIVE FOLDERS
ONE_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\1\*.jpg");

TWO_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\2\*.jpg");

FIVE_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\3\*.jpg");

TEN_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\4\*.jpg");

TWENTY_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\5\*.jpg");

FIFTY_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\6\*.jpg");

HUNDRED_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\7\*.jpg");

TWO_HUNDRED_CENT = imageDatastore("C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing\8\*.jpg");

%ADDING ONE EXTRA COLUME FOR LABELS
%AS DATA IS NEEDED FOR SUPERVISED LEARNING

A = FeatureExtraction(ONE_CENT);
%ADDING EXTRA COLUME FOR LABLE
%ONE CENT - 2 DOLLAR
%SCALE 'CENTS'. E.G 2DOLLAR = 200 CENT
A (:,9505) = 1; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append')
%TWO CENT
A = FeatureExtraction(TWO_CENT);
A (:,9505) = 2; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append')
% FIVE CENT
A = FeatureExtraction(FIVE_CENT);
A (:,9505) = 5; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append')
%10 CENT
A = FeatureExtraction(TEN_CENT);
A (:,9505) = 10; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append')
%20 CENT
A = FeatureExtraction(TWENTY_CENT);
A (:,9505) = 20; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append')
%50 CENT
A = FeatureExtraction(FIFTY_CENT);
A (:,9505) = 50; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append') 
%100 CENT
A = FeatureExtraction(HUNDRED_CENT);
A (:,9505) = 100; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append')
%200 CENT
A = FeatureExtraction(TWO_HUNDRED_CENT);
A (:,9505) = 200; 
writematrix(A,'C:\Users\Hp\PycharmProjects\DIPASSIGMENT3\testing.xlsx','WriteMode','append')


 %HOG FEATURE EXTRACTION 
    function featureVector = HOG(inputImage)

        %features = extractHOGFeatures(inputImage);
        [featureVector,hogVisualization] = extractHOGFeatures(inputImage);
        figure;
        imshow(inputImage); 
        hold on;
        plot(hogVisualization);
        
    end

 
%FEATURE EXTRACTION / PREPROCESSING   FUNCTION 
    function outputArray = FeatureExtraction(inputDS)
       
        j = 1;
        
        outputArray = zeros(1,9504);
        while hasdata(inputDS)
           
           temp = read(inputDS); %% DECREASING THE SIZE OF THE IMAGE FOR EASIER PROCESSING
           temp = rgb2gray(temp);    %% RBG TO GRAY SCALE CONVERSION
           temp = imresize(temp,[200,100]);
           temp = ContrastStreching(temp); %% CONTRAST STRECHING TO MAKE SURE IMAGE IS IN PROPER CONTRAST
           %%SHARPEN IMAGE
           vEdge  = VerticalEdge(temp); % GETTING VERTICAL EDGE % 1ST ORDER DERIVATIVE
           hEdge = HorizontalEdge(temp); % GETTING HORIZONTAL EDGE % 1ST ORDER DERIVATIVE
           temp = temp + (vEdge + hEdge);
           %%SHARPEN IMAGE
           temp = Binarization(temp); %% THRESHOLDING OF IMAGE
           temp = HOG(temp);
           outputArray(j,:) = temp;%SAVING THE EXTRACTED FEACTURES IN AN ARRAY OF IMAGES FOR FURTHER PROCESSING 
           j = j +1;
       end
    end




% SALT AND PEPER NOISE REMOVAL FUNCTION 
    function outputImage = SaltandPeper(inputImage)
        
        [R,C] = size(inputImage);
        outputImage = zeros(R,C);
        i = 2;
        j = 2;
    
        while i <= R -1
        while j <= C -1
        
        ou = inputImage(i-1:i+1,j-1:j+1);    
        array = reshape(ou,9,1);
        array = sort(array);
        outputImage(i,j) = array(5);
        disp(array);
        disp(outputImage(i,j));
        
        j = j+1;
        end
        i = i+1;
        j = 2;
        end
    
    
    end

% BINARIZATION FUCNTION 
% INPUT = IMAGE // OUTPUT = IMAGE
% BINARIZATION DONE WITH 128 THRESHOLD
function outputImage = Binarization (inputImage)

    [R,C] = size(inputImage);
    outputImage = zeros(R,C);
    disp(R)
    disp(C)
    i = 1;
    j = 1;
    while i <= R
    while j <= C
        
        if inputImage(i,j) > 128
            outputImage(i,j) = 1;
        else
            outputImage(i,j) = 0;
        end
        
        j = j+1;
    end
    i = i+1;
    j = 1;
    end 

end

% CONTRAST STRECHING FUNCTION  
% INPUT = IMAGE // OUTPUT = IMAGE
% STRECHING DONE FROM 0 - 255
function outputImage = ContrastStreching(inputImage)

    [R,C] = size(inputImage);
    minVal = min(inputImage(:));
    maxVal = max(inputImage(:));
    outputImage = zeros(R,C);
    i = 1;
    j = 1;
    while i <= R
    while j <= C
        
        a = (inputImage(i,j) - minVal);
        b = maxVal - minVal ;
        c = double(a)/ double(b);
        xx = double(c);
        outputImage(i,j) = uint8(xx*255);
        
        j = j+1;
    end
    i = i+1;
    j = 1;
    end  

end

end

%VERTICAL EDGE DETECTION FUNCTION  
% INPUT = IMAGE // OUTPUT = IMAGE
function outputImage = VerticalEdge(inputImage)
    
    
    [R,C] = size(inputImage);
    outputImage = zeros(R,C);
    disp(R)
    disp(C)
    i = 1;
    j = 1;
    k = 2;
    
    while i <= R
    while k <= C
        
        outputImage(i,j) = inputImage(i,j) - inputImage(i,k);    
        k = k+1;
        j = j+1;
    end
    i = i+1;
    j = 1;
    k = 2;
    end 
    
    
end

%HORIZONTAL EDGE DETECTION FUNCTION  
% INPUT = IMAGE // OUTPUT = IMAGE
function outputImage = HorizontalEdge(inputImage)
    
    
    [R,C] = size(inputImage);
    outputImage = zeros(R,C);
    disp(R)
    disp(C)
    i = 1;
    j = 1;
    k = 2;
    
    while i <= C
    while k <= R
        
        outputImage(j,i) = inputImage(j,i) - inputImage(k,i);    
        k = k+1;
        j = j+1;
    end
    i = i+1;
    j = 1;
    k = 2;
    end 
    
    
end


% CLIPLITION FILTER EDGE DETECTION 
%function outputImage = LiplitionFilter(inputImage)

%    [R,C] = size(inputImage);
%    outputImage = zeros(R,C);
%    disp(R)
%    disp(C)
%    i = 2;
%    j = 2;
%    LipFilter = fspecial('laplacian',[3,3]);
    
%    while i < R
%    while j < C
        
%        outputImage(i,j) = dot(double(inputImage(i-1:i+1,j-1:j+1)),LipFilter);    
%        j = j+1;
%    end
%    i = i+1;
%    j = 2;
%    end 
    
%end 





