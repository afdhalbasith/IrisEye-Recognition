function [ hasilKelas ] = zzSVMFst( hasilEkstraks )

addpath(genpath('C:\Users\TX300C\Documents\MATLAB\TA'));

foo = load('param_svm.mat');
TrainingData = foo.TrainingSet;         %TestData = foo.TestSet;
trainLabel = foo.GroupTrain;            %testLabel = foo.GroupTest;

%# train models (one-against-all) 
model = cell(108,1);
for k=1:108
    model{k} = svmtrain(double(trainLabel==k), TrainingData, '-c 30 -b 1 -q');
end

hasilEkstrak = hasilEkstraks;
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

end

