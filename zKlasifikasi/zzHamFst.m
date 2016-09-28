function [ hasilKelas ] = zzHamFst( hasilEkstrak1,hasilEkstrak2 )

foo = load('param_hamming.mat');
TempTrainingData = foo.TemplateTrainGabor;   NoiseTrainingData = foo.NoiseTrainGabor;      

[templateTest] = hasilEkstrak1;
[ noiseTest] = hasilEkstrak2;

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


end

