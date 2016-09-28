% Hasil Preprocessing (Output : titik koordinat(x,y) , r , imagewithcircle
% , imagewithnoise
pathCitra1 = 'D:\zBAHANTA\CASIA-IrisV1\CASIA Iris Image Database (version 1.0)';
for i = 1 : 5
    if i<10
        fname = '00';
    elseif i<100
        fname = '0';
    else
        fname = '';
    end
    
for m = 1:2
    if m == 1
        for l = 1:3
            imageName = strcat(fname,num2str(i),'_',num2str(m),'_',num2str(l),'.bmp');
            eyeimage_filename = strcat(pathCitra1,'\',fname,num2str(i),...
                '\',num2str(m),'\',imageName);

            eyeimage = imread(eyeimage_filename);
            %figure,imshow(readCitra);
            
            [pathstr,name,ext] = fileparts(eyeimage_filename);
            
            savefile = [name,'-parameters.mat'];
            [stat,mess]=fileattrib(savefile);

            if stat == 1
            % if this file has been processed before
            % then load the circle parameters and
            % noise information for that file.
            load(savefile);
            else
            % if this file has not been processed before
            % then perform automatic segmentation and
            % save the results to a file
            [imagewithcircle imagewithnoise circleiris circlepupil] = zBatasCircleNoise(eyeimage);
            save(savefile,'circleiris','circlepupil','imagewithcircle','imagewithnoise');
            end


        end

    elseif m==2
        for l = 1:4
            imageName = strcat(fname,num2str(i),'_',num2str(m),'_',num2str(l),'.bmp');
            eyeimage_filename = strcat(pathCitra1,'\',fname,num2str(i),...
                '\',num2str(m),'\',imageName);

            eyeimage = imread(eyeimage_filename);
            %figure,imshow(readCitra);
            
            [pathstr,name,ext] = fileparts(eyeimage_filename);
            
            savefile = [name,'-parameters.mat'];
            [stat,mess]=fileattrib(savefile);

            if stat == 1
            % if this file has been processed before
            % then load the circle parameters and
            % noise information for that file.
            load(savefile);
            else
            % if this file has not been processed before
            % then perform automatic segmentation and
            % save the results to a file
            [imagewithcircle imagewithnoise circleiris circlepupil] = zBatasCircleNoise(eyeimage);
            save(savefile,'circleiris','circlepupil','imagewithcircle','imagewithnoise');
            end


        end
    end
end
% eyeimage_filename = 'D:\zBAHANTA\CASIA-IrisV1\CASIA Iris Image Database (version 1.0)\001\2\001_2_4.bmp';

display(strcat('Running... Kelas ',' ',num2str(i),'/108',' DONE...'));
end