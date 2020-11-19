%Function to calculate CoP ml and ap direction.
%data will be the array containing the data, this will need changing when
%real hardware setup is performed.
%See
%https://www.scielo.br/scielo.php?script=sci_arttext&pid=S1980-00372011000500007&tlng=
%Link above has wrong calculation for CoP, see link below
%See: C:\Users\Magnu\Desktop\Smart Chair Summer Internship\David A. Winter-Biomechanics and Motor Control of Human Movement-Wiley (2009)
%for equation CoP - page 118. 
%[F1]=[i,1],[F2]=[i,2],[F3]=[i,3],[F4]=[i,4], timer = [i,5]
%Layout of force plate sensors.
%|   |      Arm rest     |   |
%|i,2|                   |i,3| 
%|   |          O        |   |
%|___|                   |___|
%______________FP____________
%|             |            |Positiv
%|  F2         |        F1  |^
%|             O            ||
%|  F3         |        F4  |X
%|_____________|____________|Neg
%        Neg   Y-> Pos
%           O = origo


%Might be more efficient to return same array.

function [standingUp_time, RMS_distance_ap, RMS_distance_ml, total_cop_path, mean_velocity,CoPapO_timeTable] = cop_calculator(data, smoothStart, saccadicStart)

    
    x_dim = 45.5;       %x dimension of balance board
    y_dim = 80;         %y dimension of balnce board
    %y_dim_armRest;      Not used - can be added when armrest is integrated
    array_height = size(data,1); %Number of rows in array
    CoP_placeHolder = zeros(array_height,4); %Create empty matrice for CoP calculations
    time = ( data(:,5) / 1000 );    %Convert tiemstamp from ms to seconds
    sampling_freq = 1 /(mean(diff(time))); %Calculate sampling frequency 
    cutt_off_freq = 4; %Define cut off frequency for LP filter
    time_var = seconds(data(:,5) / 1000); %Convert time to a duration matrice
    
    
    lpFilt = designfilt('lowpassiir','FilterOrder',4,'PassbandFrequency',cutt_off_freq,'PassbandRipple',0.2,'SampleRate',sampling_freq);
  
    %Filter raw data
    data(:,1) = filter(lpFilt,data(:,1));
    data(:,2) = filter(lpFilt,data(:,2));
    data(:,3) = filter(lpFilt,data(:,3));
    data(:,4) = filter(lpFilt,data(:,4));
    
    %another way of filtering, main diff is this does not give you options
    %to choose order
    %data(:,1) = lowpass(data(:,1), cutt_off_freq,sampling_freq);
    %data(:,2) = lowpass(data(:,2), cutt_off_freq,sampling_freq);
    %data(:,3) = lowpass(data(:,3), cutt_off_freq,sampling_freq);
    %data(:,4) = lowpass(data(:,4), cutt_off_freq,sampling_freq);
    
    for x=1:array_height
        
        F1 = data(x,1); F2 = data(x,2); F3 = data(x,3); F4 = data(x,4);
        
        %If weight is negative, set weight to zero.
        if F1 < 0, F1 = 0; end 
        if F2 < 0, F2 = 0; end 
        if F3 < 0, F3 = 0; end 
        if F4 < 0, F4 = 0; end
        
        
        Fz = F1+F2+F3+F4; %Total weight on force plate
        %F1_leftArmRest = data(); Not in use, can be used to calculate CoP
        %of arm rest
        %F2_rightArmRest = data();
        %Fz_armRest = F1_leftArmRest + F2_rightArmRest;
         
        CoP_placeHolder(x,1) = y_dim/2 *(((F1+F4)-(F3+F2))/Fz); %Calculate CoP ML
        
        CoP_placeHolder(x,2) = x_dim/2 *(((F1+F2)-(F4+F3))/Fz); %Calculate CoP AP
        
        CoP_placeHolder(x,3) = Fz; %Calculate total weight for each timestep
             
        
    end 
     
                
%________________FORCE PLATE CALCULATIONS__________________________________
        
           
        %Create time table with centre of pressure AP and ML
        CoPmlO_timeTable = timetable(CoP_placeHolder(:,1), 'RowTimes', time_var);
        CoPapO_timeTable = timetable(CoP_placeHolder(:,2), 'RowTimes', time_var);
        weight_timeTable = timetable(CoP_placeHolder(:,3), 'RowTimes', time_var);
        
        
        %plots ap and ml COP versus time
      % figure(10);
      % plot(CoPapO_timeTable.Var1);
        %hold on
        %plot(CoPmlO_timeTable.Var1);
        
        
        
        %plots ml cop vs ap cop
%         figure(12)
%         plot(CoPmlO_timeTable.Var1,CoPapO_timeTable.Var1);
%         title('CoP Path on balance board')
%         xlabel('Y (cm)')
%         ylabel('X (cm)')
        
        
        %Calculate mean of AP and ML not used
        %mean_CoPml = mean(CoP_placeHolder(:,1));
        %mean_CoPap = mean(CoP_placeHolder(:,2));

        %Detrend the CoPxxO data.
        CoPml = detrend(CoPmlO_timeTable.Var1,'constant');
        CoPap = detrend(CoPapO_timeTable.Var1,'constant');


        %plots AP versurs AP detrended
%         figure(10);
%         title('AP detrended vs AP')
%         plot(time_var,CoPapO_timeTable.Var1);
%         hold on
%         plot(time_var,CoPap);
%         xlabel('time')
%         ylabel('CoP AP')  
%         legend({'CoP AP','CoP AP detrended'},'Location','southwest')
%         hold off


        %plots ML versurs ML detrended
%         figure(11);
%         title('ML detrended vs ML')
%         plot(time_var,CoPmlO_timeTable.Var1);
%         hold on
%         plot(time_var,CoPml);
%         xlabel('time')
%         ylabel('CoP AP')  
%         legend({'CoP AP','CoP AP detrended'},'Location','southwest')
%         hold off

        %weight_settlingTime = settlingtime(weight_timeTable.Var1,5);
        weight_settlingTime = stepinfo(weight_timeTable.Var1);
        %Time from threshold is reached to subject is standing up      
        standingUp_time = weight_settlingTime.RiseTime;

        average_weight = mean(CoP_placeHolder(:,3));      

        %RD time series = vector distance from the mean CoP to each pair of
        %points in APo and MLo
        RD = (CoPml.^2 + CoPap.^2).^0.5;

        %The mean distance (RD) is the mean of the
        %RD time series, and represents the average distance from the mean
        %COP. Not used, see reasoning below
        %mean_distance = mean(RD);
       
        %Mean distance AP directionNot used as positive and negative
        %number canels each other out and gives faulty impression.
        %mean_distance_ap = mean(CoPap);

        %Mean distance ML direction - Not used as positive and negative
        %number canels each other out and gives faulty impression.
        %mean_distance_ml = mean(CoPml);

        %Root mean square distance total - Not used for feedback
        %RMS_distance = rms(RD);
        
        %Root mean square distance AP direction
        RMS_distance_ap = rms(CoPap);
        
        %Root mean square distance ML direction 
        RMS_distance_ml = rms(CoPml);
        
        %Total length of CoP path. Can be implmeneted for both AP and ML
      
        %Placeholder for datapoints from time series. 
        AP=[CoPap(1:array_height,1)];
        ML=[CoPml(1:array_height,1)];
        
        
        % total length of the COP path
        total_cop_path = 0;
        for x = 1:array_height-1
           
        total_cop_path = total_cop_path + ( (AP(x+1) - AP(x)).^2 + (ML(x+1) - ML(x)).^2 ).^0.5;   
                 
        end
        
        %Mean velocity = total distance / time - Can also be added for
        %both AP and ML direction
        mean_velocity = total_cop_path / (time(size(time)) - time(1));
            
end
