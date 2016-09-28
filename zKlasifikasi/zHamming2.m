function [ hasilKelas,pred,predi,acc,C ] = zHamming2( eyeimage,flag)

addpath(genpath('C:\Users\TX300C\Documents\MATLAB\TA'));
hasilKelas=0;
if nargin == 1
    flag = 1;
end

foo = load('param-Hamm075.mat');% foo = load('param_hamming.mat');
TempTrainingData = foo.TemplateTrainGabor;   NoiseTrainingData = foo.NoiseTrainGabor;      
trainLabel = foo.GroupTrainGabor;

TempTestData = foo.TemplateTestGabor;         NoiseTestData = foo.NoiseTestGabor;            
testLabel = foo.GroupTestGabor;


if flag == 1
    [templateTest, noiseTest] = zEkstraksiGabor(eyeimage );
%     hasilKelas = eyeimage;
%     [templateTest] = TempTestData{3,1};
%     noiseTest = NoiseTestData{3,1};
    %# mendapatkan kelas
    avgDist = [];
    a = TempTrainingData;   b = NoiseTrainingData;
    
    for h =1:(length(a)/4) % 432/4=108
        distance1 = zHamming(templateTest,noiseTest , a{1,1},b{1,1} );
        distance2 = zHamming(templateTest,noiseTest , a{2,1},b{2,1} );
        distance3 = zHamming(templateTest,noiseTest , a{3,1},b{3,1} );
        distance4 = zHamming(templateTest,noiseTest , a{4,1},b{4,1} );

        a(1:4,:) = [];      b(1:4,:) = [];
        % avgDist = [avgDist ; [distance1 distance2 distance3 distance4]];
        avgDist = [avgDist , ((distance1+distance2+distance3+distance4)/4)]; 
    end
    
    [~,hasilKelas] = min(avgDist,[],2);

    if hasilKelas<10
        name = '00';
    elseif hasilKelas<100
        name = '0';
    else
        name = '';
    end
    hasilKelas = strcat('Kelas ke-',num2str(name),num2str(hasilKelas));

else
    pred = []; 
    a = TempTestData;   b = NoiseTestData;
    
    for g= 1:length(a) %324
    c = TempTrainingData;   d = NoiseTrainingData;
    avgDist = [];
    for h =1:(length(c)/4) %432/4=108
        distance1 = zHamming(a{g,1},b{g,1} , c{1,1},d{1,1} );
        distance2 = zHamming(a{g,1},b{g,1} , c{2,1},d{2,1} );
        distance3 = zHamming(a{g,1},b{g,1} , c{3,1},d{3,1} );
        distance4 = zHamming(a{g,1},b{g,1} , c{4,1},d{4,1} );

        c(1:4,:) = [];      d(1:4,:) = [];
        avgDist = [avgDist , ((distance1+distance2+distance3+distance4)/4)]; 
    end
    pred = [pred ; avgDist];
    display(strcat('Kelas-',num2str(g),'DONE'));
    end
    
    %# predict the class with the lowest distance
    [~,predi] = min(pred,[],2);
    acc = sum(predi == testLabel) ./ numel(testLabel);    %# accuracy
    C = confusionmat(testLabel, predi);    
         
end


end
