function [Gtotal,NPL,Gtotal_timetable]= NPL_Calculator(data)
    array_height = size(data,1); 
    Gtotal = zeros(array_height,1);
    time = ( data(:,4) / 1000 );
    duration = time(array_height) - time(1);
    NPL = 0; %normalized path length
    
    lpFilt = designfilt('lowpassiir','FilterOrder',4,'PassbandFrequency',cutt_off_freq,'PassbandRipple',0.2,'SampleRate',sampling_freq);
    data(:,1) = filter(lpFilt,data(:,1)); %x
    data(:,2) = filter(lpFilt,data(:,2)); %y
    data(:,3) = filter(lpFilt,data(:,3)); %z
    
    
    for x=1:array_height
      GX = data(x,1);
      GY = data(x,2);
      GZ = data(x,3);
      Gtotal (x,1)= sqrt(GX^2+GY^2+GZ^2); %accelration in total.
    end
    
    for x =1:array_height-1
       NPL  = NPL+ abs(Gtotal(x+1,1)-Gtoal(x,1));
    end
       NPL = (1/duration)*NPL;
       Gtotal_timetable = timetable(Gtotal(:,1), 'RowTimes', time);
    end 
     