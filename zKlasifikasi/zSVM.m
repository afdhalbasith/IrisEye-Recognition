% proses Matching 1 citra mata dengan TrainingData (SVM,Haar)
function [ hasilKelas,pred,prob,acc,C ] = zSVM( eyeimage,flag )

addpath(genpath('C:\Users\TX300C\Documents\MATLAB\TA'));
hasilKelas = 0;
if nargin == 1
    flag = 1;
end

addpath('C:\Users\TX300C\Documents\MATLAB\TA\libsvm-3.21\matlab');
% hasilKelas = [];

% foo = load('param_svm.mat');
foo=load('param-Haar2.mat');
TrainingData = foo.TrainingSet;         TestData = foo.TestSet;
trainLabel = foo.GroupTrain;            testLabel = foo.GroupTest;

%# train models (one-against-all) 
model = cell(108,1);
for k=1:108
    model{k} = svmtrain(double(trainLabel==k), TrainingData, '-c 28.5 -t 1 -d 3 -b 1 -q');
end

if flag == 1
    hasilEkstrak = zEkstraksi(eyeimage);
    %# mendapatkan kelas
    probKelas = zeros(1,108);
    dummy = 999;
    for k=1:108
        [~,~,p] = svmpredict(dummy, hasilEkstrak, model{k}, '-b 1 -q');
        probKelas(:,k) = p(:,model{k}.Label==1);
    end

    [~,hasilKelas] = max(probKelas,[],2);

    if hasilKelas<10
        name = '00';
    elseif hasilKelas<100
        name = '0';
    else
        name = '';
    end
    hasilKelas = strcat('Kelas ke-',num2str(name),num2str(hasilKelas));
else
    prob = zeros(size(TestData,1),108);
    for k=1:108
        [~,~,p] = svmpredict(double(testLabel==k), TestData, model{k}, '-b 1 -q');
        prob(:,k) = p(:,model{k}.Label==1);
    end

    %# predict the class with the highest probability
    [~,pred] = max(prob,[],2);
    acc = sum(pred == testLabel) ./ numel(testLabel);    %# accuracy
    C = confusionmat(testLabel, pred);    
         
end
    
%# matching class(es) dgn setiap model
% hasilKelas = zeros(108,1);
% dummy = 999;
% for k=1:108
%     [prediksi,~,~] = svmpredict(dummy, hasilEkstrak, model{k}, '-b 1 -q');
%     hasilKelas(k,:) = prediksi;
% end
% 
% hasilKelas = find(hasilKelas);
% if hasilKelas<10
%     name = '00';
% elseif hasilKelas<100
%     name = '0';
% else
%     name = '';
% end
% 
% if isempty(hasilKelas)
%     hasilKelas = num2str('Gagal');
% elseif length(hasilKelas) == 1
%     hasilKelas = strcat('Kelas ke-',num2str(name),num2str(hasilKelas));
% else
%     hasilKelas = strcat('Kelas ke-',num2str(name),num2str(hasilKelas));
% end

end

% function FAR()
% 
% end
% 
% function FRR()
% 
% end

% Train & Classify ALL (stackoverflow style)
% load 'param_svm.mat';
% model = cell(108,1);
% for k=1:108
% model{k} = svmtrain(double(GroupTrain==k), TrainingSet, '-c 1 -b 1 -q');
% end
% %# get probability estimates of test instances using each model
% prob = zeros(324,108);
% for k=1:108
% [~,~,p] = svmpredict(double(GroupTest==k), TestSet, model{k}, '-b 1');
% prob(:,k) = p(:,model{k}.Label==1);    %# probability of class==k
% end
% %# predict the class with the highest probability
% [~,pred] = max(prob,[],2);
% acc = sum(pred == GroupTest) ./ numel(GroupTest)

% % (my style)
% % numInst = 756;numLabels = 108;
% % numTrain = 342; numTest = 1;
% % model = svmtrain(trainLabel,TrainingData,'-b 1 -q');
% % 
% % for i = 1:108
% % [predict,acc] = svmpredict(i,hasilEkstrak,model);
% % 
% % if acc == 1
% %     hasilKelas = [hasilKelas , i];
% % end
% % end

